/// account_repository_impl.dart
/// تنفيذ Repository الحسابات مع قواعد العمل الكاملة
library;

import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../models/account_model.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../interfaces/interfaces.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final AccountsDao _accountsDao;
  final JournalEntriesDao _entriesDao;

  AccountRepositoryImpl(this._accountsDao, this._entriesDao);

  // ─────────────────────────────────────────────────────────────
  // القراءة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<AccountModel>> getAllAccounts() async {
    final list = await _accountsDao.getAllAccounts();
    return AccountMapper.fromDataList(list);
  }

  @override
  Future<List<AccountModel>> getActiveAccounts() async {
    final list = await _accountsDao.getActiveAccounts();
    return AccountMapper.fromDataList(list);
  }

  @override
  Future<AccountModel?> getAccountById(int id) async {
    final data = await _accountsDao.getAccountById(id);
    return data != null ? AccountMapper.fromData(data) : null;
  }

  @override
  Future<AccountModel?> getAccountByCode(String code) async {
    final data = await _accountsDao.getAccountByCode(code);
    return data != null ? AccountMapper.fromData(data) : null;
  }

  @override
  Future<List<AccountModel>> getAccountsByType(AccountType type) async {
    final list = await _accountsDao.getAccountsByType(type.index);
    return AccountMapper.fromDataList(list);
  }

  @override
  Future<List<AccountModel>> getChildAccounts(int parentId) async {
    final list = await _accountsDao.getChildAccounts(parentId);
    return AccountMapper.fromDataList(list);
  }

  @override
  Stream<List<AccountModel>> watchAllAccounts() =>
      _accountsDao.watchAllAccounts().map(AccountMapper.fromDataList);

  @override
  Future<List<AccountModel>> getPostableAccounts({AccountType? type}) async {
    final list = await _accountsDao.getLeafAccounts(typeIndex: type?.index);
    return AccountMapper.fromDataList(list);
  }

  @override
  Future<List<AccountModel>> searchAccounts(String query) async {
    if (query.trim().isEmpty) return getAllAccounts();
    final list = await _accountsDao.searchAccounts(query);
    return AccountMapper.fromDataList(list);
  }

  @override
  Future<bool> hasChildren(int accountId) =>
      _accountsDao.hasChildren(accountId);

  // ─────────────────────────────────────────────────────────────
  // الكتابة مع قواعد العمل
  // ─────────────────────────────────────────────────────────────

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    // التحقق من عدم تكرار الرمز
    if (await _accountsDao.codeExists(account.code)) {
      throw DuplicateAccountCodeException(account.code);
    }

    // تحديد مستوى الحساب تلقائياً + قواعد الحساب الأب
    int level = 1;
    if (account.parentId != null) {
      final parent = await _accountsDao.getAccountById(account.parentId!);
      if (parent == null) throw AccountNotFoundException(account.parentId);

      // الحساب الفرعي يجب أن يكون من نفس نوع الأب
      if (parent.type != account.type) {
        throw AccountTypeMismatchException(account.code, parent.code);
      }
      // لا يمكن تحويل حساب عليه قيود إلى حساب أب (ستختفي أرصدته من الشجرة)
      if (await _entriesDao.accountHasLines(parent.id)) {
        throw ParentAccountHasTransactionsException(parent.code);
      }
      level = parent.level + 1;
    }

    final now = DateTime.now();
    final withLevel =
        account.copyWith(level: level, createdAt: now, updatedAt: now);
    final companion = AccountMapper.toCompanion(withLevel);
    final id = await _accountsDao.insertAccount(companion);

    return withLevel.copyWith(id: id);
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    if (account.id == null) throw const AccountNotFoundException('null');

    final existing = await _accountsDao.getAccountById(account.id!);
    if (existing == null) throw AccountNotFoundException(account.id);

    // التحقق من عدم تكرار الرمز (باستثناء الحساب الحالي)
    if (await _accountsDao.codeExists(account.code, excludeId: account.id)) {
      throw DuplicateAccountCodeException(account.code);
    }

    // لا يمكن تغيير النوع لحساب عليه قيود أو له أبناء
    if (existing.type != account.type &&
        (await _entriesDao.accountHasLines(account.id!) ||
            await _accountsDao.hasChildren(account.id!))) {
      throw CannotChangeAccountTypeException(existing.code);
    }

    // التحقق من الحساب الأب وإعادة حساب المستوى
    int level = 1;
    if (account.parentId != null) {
      if (account.parentId == account.id) {
        throw const InvalidAccountHierarchyException(
            'لا يمكن أن يكون الحساب أباً لنفسه.');
      }
      final descendants = await _accountsDao.getDescendantIds(account.id!);
      if (descendants.contains(account.parentId)) {
        throw const InvalidAccountHierarchyException(
          'لا يمكن نقل الحساب تحت أحد حساباته الفرعية.',
        );
      }
      final parent = await _accountsDao.getAccountById(account.parentId!);
      if (parent == null) throw AccountNotFoundException(account.parentId);
      if (parent.type != account.type) {
        throw AccountTypeMismatchException(account.code, parent.code);
      }
      if (account.parentId != existing.parentId &&
          await _entriesDao.accountHasLines(parent.id)) {
        throw ParentAccountHasTransactionsException(parent.code);
      }
      level = parent.level + 1;
    }

    final updated = account.copyWith(level: level, updatedAt: DateTime.now());
    final companion = AccountMapper.toCompanion(updated);

    await _accountsDao.transaction(() async {
      await _accountsDao.updateAccount(companion);
      if (level != existing.level) await _relevelChildren(account.id!, level);
    });

    return updated;
  }

  /// تحديث مستويات الحسابات الفرعية بعد نقل حساب في الشجرة
  Future<void> _relevelChildren(int parentId, int parentLevel) async {
    for (final child in await _accountsDao.getChildAccounts(parentId)) {
      await _accountsDao.setAccountLevel(child.id, parentLevel + 1);
      await _relevelChildren(child.id, parentLevel + 1);
    }
  }

  @override
  Future<AccountModel> ensureAccount({
    required String code,
    required String name,
    String? nameAr,
    required AccountType type,
    int? parentId,
    String? parentCode,
    String? description,
  }) async {
    final existing = await getAccountByCode(code);
    if (existing != null) return existing;

    int? resolvedParentId = parentId;
    if (resolvedParentId == null && parentCode != null) {
      final parent = await getAccountByCode(parentCode);
      if (parent == null) throw AccountNotFoundException(parentCode);
      resolvedParentId = parent.id;
    }

    return createAccount(AccountModel.create(
      code: code,
      name: name,
      nameAr: nameAr,
      type: type,
      parentId: resolvedParentId,
      description: description,
    ));
  }

  @override
  Future<void> setAccountActive(int id, {required bool isActive}) =>
      _accountsDao.setAccountActive(id, isActive);

  @override
  Future<void> deleteAccount(int id) async {
    // القاعدة 1: لا حذف إذا كان لديه أرصدة
    if (await hasTransactions(id)) {
      throw const AccountHasTransactionsException();
    }
    // القاعدة 2: لا حذف إذا كان لديه حسابات فرعية
    if (await _accountsDao.hasChildren(id)) {
      throw const AccountHasChildrenException();
    }

    await _accountsDao.deleteAccount(id);
  }

  // ─────────────────────────────────────────────────────────────
  // إحصائيات
  // ─────────────────────────────────────────────────────────────

  @override
  Future<int> countAccounts() => _accountsDao.countAccounts();

  @override
  Future<bool> hasTransactions(int accountId) =>
      // أي بند (حتى في مسودة) يمنع الحذف، وإلا فشل قيد المفتاح الأجنبي
      _entriesDao.accountHasLines(accountId);
}
