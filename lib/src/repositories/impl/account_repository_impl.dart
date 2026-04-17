/// account_repository_impl.dart
/// تنفيذ Repository الحسابات مع قواعد العمل الكاملة

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

  // ─────────────────────────────────────────────────────────────
  // الكتابة مع قواعد العمل
  // ─────────────────────────────────────────────────────────────

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    // التحقق من عدم تكرار الرمز
    if (await _accountsDao.codeExists(account.code)) {
      throw DuplicateAccountCodeException(account.code);
    }

    // تحديد مستوى الحساب تلقائياً
    int level = 1;
    if (account.parentId != null) {
      final parent = await _accountsDao.getAccountById(account.parentId!);
      if (parent == null) throw AccountNotFoundException(account.parentId);
      level = parent.level + 1;
    }

    final now       = DateTime.now();
    final withLevel = account.copyWith(level: level, createdAt: now, updatedAt: now);
    final companion = AccountMapper.toCompanion(withLevel);
    final id        = await _accountsDao.insertAccount(companion);

    return withLevel.copyWith(id: id);
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    if (account.id == null) throw AccountNotFoundException('null');

    // التحقق من عدم تكرار الرمز (باستثناء الحساب الحالي)
    if (await _accountsDao.codeExists(account.code, excludeId: account.id)) {
      throw DuplicateAccountCodeException(account.code);
    }

    final updated   = account.copyWith(updatedAt: DateTime.now());
    final companion = AccountMapper.toCompanion(updated);
    await _accountsDao.updateAccount(companion);

    return updated;
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
  Future<bool> hasTransactions(int accountId) async {
    // نتحقق من وجود بنود قيود ترتبط بهذا الحساب
    final balances = await _entriesDao.getAccountBalances();
    return balances.any((b) =>
        b.accountId == accountId &&
        (b.totalDebit > 0 || b.totalCredit > 0));
  }
}
