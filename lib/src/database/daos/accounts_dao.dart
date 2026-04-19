/// accounts_dao.dart
/// عمليات قاعدة البيانات الخاصة بالحسابات
library;

import 'package:drift/drift.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AccountingDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // القراءة
  // ─────────────────────────────────────────────────────────────

  /// جلب جميع الحسابات
  Future<List<Account>> getAllAccounts() =>
      (select(accounts)..orderBy([(t) => OrderingTerm(expression: t.code)])).get();

  /// جلب الحسابات النشطة فقط
  Future<List<Account>> getActiveAccounts() =>
      (select(accounts)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm(expression: t.code)]))
          .get();

  /// جلب حساب بالمعرّف
  Future<Account?> getAccountById(int id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// جلب حساب برمز الحساب
  Future<Account?> getAccountByCode(String code) =>
      (select(accounts)..where((t) => t.code.equals(code))).getSingleOrNull();

  /// جلب الحسابات حسب النوع
  Future<List<Account>> getAccountsByType(int typeIndex) =>
      (select(accounts)
            ..where((t) => t.type.equals(typeIndex))
            ..orderBy([(t) => OrderingTerm(expression: t.code)]))
          .get();

  /// جلب الحسابات الفرعية لحساب أب
  Future<List<Account>> getChildAccounts(int parentId) =>
      (select(accounts)
            ..where((t) => t.parentId.equals(parentId))
            ..orderBy([(t) => OrderingTerm(expression: t.code)]))
          .get();

  /// مشاهدة جميع الحسابات (Stream)
  Stream<List<Account>> watchAllAccounts() =>
      (select(accounts)..orderBy([(t) => OrderingTerm(expression: t.code)])).watch();

  /// هل رمز الحساب موجود مسبقاً؟
  Future<bool> codeExists(String code, {int? excludeId}) async {
    final query = select(accounts)..where((t) => t.code.equals(code));
    if (excludeId != null) {
      query.where((t) => t.id.equals(excludeId).not());
    }
    return (await query.getSingleOrNull()) != null;
  }

  /// هل الحساب لديه حسابات فرعية؟
  Future<bool> hasChildren(int accountId) async {
    final children = await getChildAccounts(accountId);
    return children.isNotEmpty;
  }

  // ─────────────────────────────────────────────────────────────
  // الكتابة
  // ─────────────────────────────────────────────────────────────

  /// إدراج حساب جديد - يُعيد المعرّف
  Future<int> insertAccount(AccountsCompanion entry) =>
      into(accounts).insert(entry);

  /// تحديث حساب
  Future<void> updateAccount(AccountsCompanion entry) =>
      (update(accounts)..where((t) => t.id.equals(entry.id.value))).write(entry);

  /// تفعيل/تعطيل حساب
  Future<void> setAccountActive(int id, bool isActive) =>
      (update(accounts)..where((t) => t.id.equals(id))).write(
        AccountsCompanion(
          isActive:  Value(isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// حذف حساب
  Future<int> deleteAccount(int id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────
  // إحصائيات
  // ─────────────────────────────────────────────────────────────

  /// عدد الحسابات الكلي
  Future<int> countAccounts() async {
    final count = countAll();
    final query  = selectOnly(accounts)..addColumns([count]);
    final row    = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
