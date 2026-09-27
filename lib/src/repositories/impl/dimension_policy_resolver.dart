/// dimension_policy_resolver.dart
/// تحديد السياسة الفعلية لبُعد على حساب (داخلي)
library;

import '../../core/enums.dart';
import '../../database/accounting_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/cost_centers_dao.dart';

/// السياسة الفعلية + المركز الافتراضي (إن وُجد) لبُعد على حساب
typedef EffectivePolicy = ({DimensionPolicy policy, int? defaultCostCenterId});

/// يحمّل الأبعاد والقواعد مرة واحدة ويحدد السياسة لكل (حساب، بُعد):
/// 1. قاعدة على الحساب، ثم على أقرب حساب أب
/// 2. قاعدة على نوع الحساب
/// 3. السياسة الافتراضية للبعد
class DimensionPolicyResolver {
  DimensionPolicyResolver._(this.dimensions, this._rules, this._accountsDao);

  /// كل الأبعاد (النشطة والموقوفة) حسب المعرّف
  final Map<int, CostDimension> dimensions;
  final List<CostDimensionRule> _rules;
  final AccountsDao _accountsDao;
  final Map<int, Account?> _accountCache = {};

  static Future<DimensionPolicyResolver> load(
    CostCentersDao costCentersDao,
    AccountsDao accountsDao,
  ) async {
    final dims = await costCentersDao.getDimensions();
    final rules = await costCentersDao.getRules();
    return DimensionPolicyResolver._(
      {for (final d in dims) d.id: d},
      rules,
      accountsDao,
    );
  }

  Iterable<CostDimension> get activeDimensions =>
      dimensions.values.where((d) => d.isActive);

  Future<Account?> _account(int id) async {
    if (_accountCache.containsKey(id)) return _accountCache[id];
    return _accountCache[id] = await _accountsDao.getAccountById(id);
  }

  Future<EffectivePolicy> resolve(int accountId, int dimensionId) async {
    final dimension = dimensions[dimensionId];
    final dimRules = _rules.where((r) => r.dimensionId == dimensionId).toList();

    EffectivePolicy of(CostDimensionRule r) =>
        (policy: r.policy, defaultCostCenterId: r.defaultCostCenterId);

    final account = await _account(accountId);
    if (account != null && dimRules.isNotEmpty) {
      // الحساب ثم آباؤه (الأقرب أولاً)
      Account? current = account;
      final visited = <int>{};
      while (current != null && visited.add(current.id)) {
        final id = current.id;
        for (final r in dimRules) {
          if (r.accountId == id) return of(r);
        }
        final parentId = current.parentId;
        current = parentId == null ? null : await _account(parentId);
      }
      for (final r in dimRules) {
        if (r.accountId == null && r.accountType == account.type) return of(r);
      }
    }
    return (
      policy: dimension?.defaultPolicy ?? DimensionPolicy.optional,
      defaultCostCenterId: null,
    );
  }
}
