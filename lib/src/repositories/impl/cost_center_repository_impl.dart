/// cost_center_repository_impl.dart
/// تنفيذ Repository مراكز التكلفة مع قواعد العمل
library;

import '../../core/accounting_config.dart';
import '../../core/cost_allocation_calculator.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/cost_centers_dao.dart';
import '../../database/mappers/mappers.dart';
import '../../models/allocation_key_model.dart';
import '../../models/cost_allocation_model.dart';
import '../../models/cost_center_model.dart';
import '../../models/cost_dimension_model.dart';
import '../interfaces/interfaces.dart';
import 'dimension_policy_resolver.dart';

class CostCenterRepositoryImpl implements ICostCenterRepository {
  final CostCentersDao _dao;
  final AccountsDao _accountsDao;
  final AccountingConfig _config;

  CostCenterRepositoryImpl(
    this._dao,
    this._accountsDao, [
    this._config = const AccountingConfig(),
  ]);

  void _ensureEnabled() {
    if (!_config.enableCostCenters) throw const CostCentersDisabledException();
  }

  // ─────────────────────────────────────────────────────────────
  // الأبعاد
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<CostDimensionModel>> getDimensions(
          {bool activeOnly = false}) async =>
      (await _dao.getDimensions(activeOnly: activeOnly))
          .map(CostDimensionMapper.fromData)
          .toList();

  @override
  Future<CostDimensionModel?> getDimensionById(int id) async {
    final data = await _dao.getDimensionById(id);
    return data == null ? null : CostDimensionMapper.fromData(data);
  }

  @override
  Future<CostDimensionModel?> getDimensionByCode(String code) async {
    final data = await _dao.getDimensionByCode(code);
    return data == null ? null : CostDimensionMapper.fromData(data);
  }

  @override
  Future<CostDimensionModel> createDimension(
      CostDimensionModel dimension) async {
    _ensureEnabled();
    if (await _dao.dimensionCodeExists(dimension.code)) {
      throw DuplicateCostDimensionCodeException(dimension.code);
    }
    final now = DateTime.now();
    final toSave = dimension.copyWith(createdAt: now, updatedAt: now);
    final id =
        await _dao.insertDimension(CostDimensionMapper.toCompanion(toSave));
    return toSave.copyWith(id: id);
  }

  @override
  Future<CostDimensionModel> updateDimension(
      CostDimensionModel dimension) async {
    _ensureEnabled();
    final id = dimension.id;
    if (id == null || await _dao.getDimensionById(id) == null) {
      throw CostDimensionNotFoundException(id ?? dimension.code);
    }
    if (await _dao.dimensionCodeExists(dimension.code, excludeId: id)) {
      throw DuplicateCostDimensionCodeException(dimension.code);
    }
    final updated = dimension.copyWith(updatedAt: DateTime.now());
    await _dao.updateDimension(CostDimensionMapper.toCompanion(updated));
    return updated;
  }

  @override
  Future<CostDimensionModel> ensureDimension({
    required String code,
    required String name,
    String? nameAr,
    DimensionPolicy defaultPolicy = DimensionPolicy.optional,
    bool allowSplit = true,
  }) async {
    final existing = await getDimensionByCode(code);
    if (existing != null) return existing;
    final count = (await _dao.getDimensions()).length;
    return createDimension(CostDimensionModel(
      code: code,
      name: name,
      nameAr: nameAr,
      defaultPolicy: defaultPolicy,
      allowSplit: allowSplit,
      sortOrder: count,
    ));
  }

  @override
  Future<void> setDimensionActive(int id, {required bool isActive}) async {
    _ensureEnabled();
    await _requireDimension(id);
    await _dao.setDimensionActive(id, isActive);
  }

  @override
  Future<void> deleteDimension(int id) async {
    _ensureEnabled();
    await _requireDimension(id);
    if (await _dao.countCentersInDimension(id) > 0) {
      throw const CostDimensionHasCentersException();
    }
    await _dao.deleteDimension(id);
  }

  // ─────────────────────────────────────────────────────────────
  // المراكز
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<CostCenterModel>> getCostCenters(
          {int? dimensionId, bool activeOnly = false}) async =>
      CostCenterMapper.fromDataList(await _dao.getCenters(
          dimensionId: dimensionId, activeOnly: activeOnly));

  @override
  Future<CostCenterModel?> getCostCenterById(int id) async {
    final data = await _dao.getCenterById(id);
    return data == null ? null : CostCenterMapper.fromData(data);
  }

  @override
  Future<CostCenterModel?> getCostCenterByCode(String code) async {
    final data = await _dao.getCenterByCode(code);
    return data == null ? null : CostCenterMapper.fromData(data);
  }

  @override
  Future<List<CostCenterModel>> getChildCostCenters(int parentId) async =>
      CostCenterMapper.fromDataList(await _dao.getChildCenters(parentId));

  @override
  Stream<List<CostCenterModel>> watchCostCenters({int? dimensionId}) => _dao
      .watchCenters(dimensionId: dimensionId)
      .map(CostCenterMapper.fromDataList);

  @override
  Future<List<CostCenterModel>> getPostableCostCenters(
          {int? dimensionId}) async =>
      CostCenterMapper.fromDataList(
          await _dao.getPostableCenters(dimensionId: dimensionId));

  @override
  Future<List<CostCenterModel>> searchCostCenters(String query,
      {int? dimensionId}) async {
    if (query.trim().isEmpty) return getCostCenters(dimensionId: dimensionId);
    return CostCenterMapper.fromDataList(
        await _dao.searchCenters(query, dimensionId: dimensionId));
  }

  @override
  Future<CostCenterModel> createCostCenter(CostCenterModel costCenter) async {
    _ensureEnabled();
    await _requireDimension(costCenter.dimensionId);
    if (await _dao.centerCodeExists(costCenter.code)) {
      throw DuplicateCostCenterCodeException(costCenter.code);
    }

    var level = 1;
    final parentId = costCenter.parentId;
    if (parentId != null) {
      final parent = await _dao.getCenterById(parentId);
      if (parent == null) throw CostCenterNotFoundException(parentId);
      if (parent.dimensionId != costCenter.dimensionId) {
        throw const InvalidCostCenterHierarchyException(
            'المركز الأب يجب أن يكون من نفس البعد.');
      }
      // لا يتحول مركز عليه حركات إلى مركز أب (ستختفي حركاته من التوزيع)
      if (await _dao.centerHasAllocations(parentId) ||
          await _dao.centerIsReferenced(parentId)) {
        throw ParentCostCenterHasTransactionsException(parent.code);
      }
      level = parent.level + 1;
    }

    final now = DateTime.now();
    final toSave =
        costCenter.copyWith(level: level, createdAt: now, updatedAt: now);
    final id = await _dao.insertCenter(CostCenterMapper.toCompanion(toSave));
    return toSave.copyWith(id: id);
  }

  @override
  Future<CostCenterModel> updateCostCenter(CostCenterModel costCenter) async {
    _ensureEnabled();
    final id = costCenter.id;
    final existing = id == null ? null : await _dao.getCenterById(id);
    if (existing == null) {
      throw CostCenterNotFoundException(id ?? costCenter.code);
    }
    if (existing.dimensionId != costCenter.dimensionId) {
      throw const InvalidCostCenterHierarchyException(
          'لا يمكن نقل مركز التكلفة إلى بُعد آخر.');
    }
    if (await _dao.centerCodeExists(costCenter.code, excludeId: id)) {
      throw DuplicateCostCenterCodeException(costCenter.code);
    }

    var level = 1;
    final parentId = costCenter.parentId;
    if (parentId != null) {
      if (parentId == id) {
        throw const InvalidCostCenterHierarchyException(
            'لا يمكن أن يكون المركز أباً لنفسه.');
      }
      if ((await _dao.getDescendantIds(id!)).contains(parentId)) {
        throw const InvalidCostCenterHierarchyException(
            'لا يمكن نقل المركز تحت أحد مراكزه الفرعية.');
      }
      final parent = await _dao.getCenterById(parentId);
      if (parent == null) throw CostCenterNotFoundException(parentId);
      if (parent.dimensionId != costCenter.dimensionId) {
        throw const InvalidCostCenterHierarchyException(
            'المركز الأب يجب أن يكون من نفس البعد.');
      }
      if (parentId != existing.parentId &&
          (await _dao.centerHasAllocations(parentId) ||
              await _dao.centerIsReferenced(parentId))) {
        throw ParentCostCenterHasTransactionsException(parent.code);
      }
      level = parent.level + 1;
    }

    final updated = costCenter.copyWith(
      level: level,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    await _dao.transaction(() async {
      await _dao.updateCenter(CostCenterMapper.toCompanion(updated));
      if (level != existing.level) await _relevelChildren(id!, level);
    });
    return updated;
  }

  Future<void> _relevelChildren(int parentId, int parentLevel) async {
    for (final child in await _dao.getChildCenters(parentId)) {
      await _dao.setCenterLevel(child.id, parentLevel + 1);
      await _relevelChildren(child.id, parentLevel + 1);
    }
  }

  @override
  Future<CostCenterModel> ensureCostCenter({
    required String dimensionCode,
    required String code,
    required String name,
    String? nameAr,
    String? parentCode,
  }) async {
    final existing = await getCostCenterByCode(code);
    if (existing != null) return existing;

    final dimension = await _dao.getDimensionByCode(dimensionCode);
    if (dimension == null) throw CostDimensionNotFoundException(dimensionCode);

    int? parentId;
    if (parentCode != null) {
      final parent = await _dao.getCenterByCode(parentCode);
      if (parent == null) throw CostCenterNotFoundException(parentCode);
      parentId = parent.id;
    }
    return createCostCenter(CostCenterModel(
      dimensionId: dimension.id,
      code: code,
      name: name,
      nameAr: nameAr,
      parentId: parentId,
    ));
  }

  @override
  Future<void> setCostCenterActive(int id, {required bool isActive}) async {
    _ensureEnabled();
    if (await _dao.getCenterById(id) == null) {
      throw CostCenterNotFoundException(id);
    }
    await _dao.setCenterActive(id, isActive);
  }

  @override
  Future<void> deleteCostCenter(int id) async {
    _ensureEnabled();
    if (await _dao.getCenterById(id) == null) {
      throw CostCenterNotFoundException(id);
    }
    if (await _dao.centerHasChildren(id)) {
      throw const CostCenterHasChildrenException();
    }
    if (await _dao.centerHasAllocations(id) ||
        await _dao.centerIsReferenced(id)) {
      throw const CostCenterHasTransactionsException();
    }
    await _dao.deleteCenter(id);
  }

  @override
  Future<bool> hasTransactions(int costCenterId) =>
      _dao.centerHasAllocations(costCenterId);

  // ─────────────────────────────────────────────────────────────
  // القواعد
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<DimensionRuleModel>> getRules({int? dimensionId}) async =>
      (await _dao.getRules(dimensionId: dimensionId))
          .map(DimensionRuleMapper.fromData)
          .toList();

  @override
  Future<DimensionRuleModel> setRule(DimensionRuleModel rule) async {
    _ensureEnabled();
    await _requireDimension(rule.dimensionId);

    if ((rule.accountId == null) == (rule.accountType == null)) {
      throw ArgumentError(
          'القاعدة يجب أن تستهدف حساباً (accountId) أو نوع حساب (accountType) '
          'وليس كليهما. للسياسة العامة استخدم defaultPolicy في البعد.');
    }
    if (rule.accountId != null &&
        await _accountsDao.getAccountById(rule.accountId!) == null) {
      throw AccountNotFoundException(rule.accountId);
    }
    final defaultId = rule.defaultCostCenterId;
    if (defaultId != null) {
      if (rule.policy == DimensionPolicy.forbidden) {
        throw const InvalidCostAllocationException(
            'لا يمكن تحديد مركز افتراضي لقاعدة سياستها "ممنوع".');
      }
      await _requirePostableCenter(defaultId, dimensionId: rule.dimensionId);
    }

    final existing = await _dao.findRule(
      dimensionId: rule.dimensionId,
      accountId: rule.accountId,
      accountType: rule.accountType,
    );
    if (existing != null) {
      final updated = rule.copyWith(id: existing.id);
      await _dao.updateRule(DimensionRuleMapper.toCompanion(updated));
      return updated;
    }
    final id = await _dao.insertRule(DimensionRuleMapper.toCompanion(rule));
    return rule.copyWith(id: id);
  }

  @override
  Future<void> deleteRule(int id) async {
    _ensureEnabled();
    await _dao.deleteRule(id);
  }

  @override
  Future<DimensionPolicy> getEffectivePolicy({
    required int accountId,
    required int dimensionId,
  }) async {
    final resolver = await DimensionPolicyResolver.load(_dao, _accountsDao);
    return (await resolver.resolve(accountId, dimensionId)).policy;
  }

  // ─────────────────────────────────────────────────────────────
  // مفاتيح التوزيع
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<AllocationKeyModel>> getAllocationKeys({int? dimensionId}) async {
    final keys = await _dao.getKeys(dimensionId: dimensionId);
    final items = await _dao.getKeyItems(keys.map((k) => k.id).toList());
    return [
      for (final k in keys)
        AllocationKeyMapper.fromData(k, items[k.id] ?? const []),
    ];
  }

  @override
  Future<AllocationKeyModel?> getAllocationKeyById(int id) async {
    final key = await _dao.getKeyById(id);
    if (key == null) return null;
    final items = await _dao.getKeyItems([id]);
    return AllocationKeyMapper.fromData(key, items[id] ?? const []);
  }

  @override
  Future<AllocationKeyModel?> getAllocationKeyByCode(String code) async {
    final key = await _dao.getKeyByCode(code);
    return key == null ? null : getAllocationKeyById(key.id);
  }

  @override
  Future<AllocationKeyModel> saveAllocationKey(AllocationKeyModel key) async {
    _ensureEnabled();
    await _requireDimension(key.dimensionId);

    if (key.items.isEmpty) {
      throw const InvalidAllocationKeyException(
          'مفتاح التوزيع يجب أن يحتوي على مركز واحد على الأقل.');
    }
    if (key.items.any((i) => i.weight <= 0)) {
      throw const InvalidAllocationKeyException(
          'أوزان مفتاح التوزيع يجب أن تكون أكبر من صفر.');
    }
    final ids = key.items.map((i) => i.costCenterId).toList();
    if (ids.toSet().length != ids.length) {
      throw const InvalidAllocationKeyException(
          'لا يمكن تكرار نفس المركز في مفتاح التوزيع.');
    }
    for (final id in ids) {
      await _requirePostableCenter(id, dimensionId: key.dimensionId);
    }

    final keyId = key.id;
    if (await _dao.keyCodeExists(key.code, excludeId: keyId)) {
      throw DuplicateAllocationKeyCodeException(key.code);
    }

    final items = key.items.map(AllocationKeyMapper.itemToCompanion).toList();
    final savedId = await _dao.transaction(() async {
      if (keyId == null) {
        final id = await _dao.insertKey(AllocationKeyMapper.toCompanion(key));
        await _dao.replaceKeyItems(id, items);
        return id;
      }
      if (await _dao.getKeyById(keyId) == null) {
        throw AllocationKeyNotFoundException(keyId);
      }
      await _dao.updateKey(AllocationKeyMapper.toCompanion(key));
      await _dao.replaceKeyItems(keyId, items);
      return keyId;
    });
    return (await getAllocationKeyById(savedId))!;
  }

  @override
  Future<void> deleteAllocationKey(int id) async {
    _ensureEnabled();
    await _dao.deleteKey(id);
  }

  @override
  Future<List<CostAllocationModel>> splitByKey(
      int allocationKeyId, double amount) async {
    final key = await getAllocationKeyById(allocationKeyId);
    if (key == null) throw AllocationKeyNotFoundException(allocationKeyId);
    if (!key.isActive) {
      throw InvalidAllocationKeyException(
          'مفتاح التوزيع "${key.code}" غير نشط.');
    }
    if (amount <= 0) {
      throw const InvalidCostAllocationException(
          'المبلغ المراد توزيعه يجب أن يكون أكبر من صفر.');
    }
    final shares = CostAllocationCalculator.splitByWeights(
      amount,
      key.items.map((i) => i.weight).toList(),
      fractionDigits: _config.allocationDecimals,
    );
    return [
      for (var i = 0; i < key.items.length; i++)
        if (shares[i] > 0)
          CostAllocationModel(
            costCenterId: key.items[i].costCenterId,
            costCenterCode: key.items[i].costCenterCode,
            costCenterName: key.items[i].costCenterName,
            dimensionId: key.dimensionId,
            amount: shares[i],
            percentage:
                CostAllocationCalculator.round(shares[i] / amount * 100, 6),
          ),
    ];
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات
  // ─────────────────────────────────────────────────────────────

  Future<void> _requireDimension(int id) async {
    if (await _dao.getDimensionById(id) == null) {
      throw CostDimensionNotFoundException(id);
    }
  }

  /// مركز موجود، نشط، نهائي (Leaf)، ومن البعد المطلوب
  Future<void> _requirePostableCenter(int id,
      {required int dimensionId}) async {
    final center = await _dao.getCenterById(id);
    if (center == null) throw CostCenterNotFoundException(id);
    if (center.dimensionId != dimensionId) {
      throw InvalidCostAllocationException(
          'المركز "${center.code}" لا ينتمي للبعد المطلوب.');
    }
    if (!center.isActive) throw InactiveCostCenterException(center.code);
    if (await _dao.centerHasChildren(id)) {
      throw CostCenterIsParentException(center.code);
    }
  }
}
