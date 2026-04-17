/// accounting_test.dart
/// اختبارات شاملة للمكتبة المحاسبية
///
/// التشغيل:
/// ```bash
/// flutter test test/accounting_test.dart
/// ```

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

void main() {
  late FlutterAccounting fa;

  // ─────────────────────────────────────────────────────────────
  // إعداد: قاعدة بيانات في الذاكرة لكل اختبار
  // ─────────────────────────────────────────────────────────────
  setUp(() {
    fa = FlutterAccounting.forTesting();
  });

  tearDown(() async {
    await fa.dispose();
    FlutterAccounting.resetInstance();
  });

  // ═══════════════════════════════════════════════════════════════
  // اختبارات دليل الحسابات
  // ═══════════════════════════════════════════════════════════════
  group('AccountRepository', () {
    test('إنشاء حساب جديد بنجاح', () async {
      final account = await fa.accounts.createAccount(_cashAccount());

      expect(account.id,   isNotNull);
      expect(account.code, '111');
      expect(account.type, AccountType.asset);
      expect(account.normalBalance, NormalBalance.debit);
    });

    test('رفض رمز الحساب المكرر', () async {
      await fa.accounts.createAccount(_cashAccount());

      expect(
        () => fa.accounts.createAccount(_cashAccount()),
        throwsA(isA<DuplicateAccountCodeException>()),
      );
    });

    test('الرصيد الطبيعي صحيح لكل نوع حساب', () {
      expect(AccountType.asset.normalBalance,     NormalBalance.debit);
      expect(AccountType.expense.normalBalance,   NormalBalance.debit);
      expect(AccountType.liability.normalBalance, NormalBalance.credit);
      expect(AccountType.equity.normalBalance,    NormalBalance.credit);
      expect(AccountType.revenue.normalBalance,   NormalBalance.credit);
    });

    test('حذف حساب بدون قيود', () async {
      final account = await fa.accounts.createAccount(_cashAccount());
      await expectLater(fa.accounts.deleteAccount(account.id!), completes);
    });

    test('رفض حذف حساب يحتوي على قيود', () async {
      final cash    = await fa.accounts.createAccount(_cashAccount());
      final revenue = await fa.accounts.createAccount(_revenueAccount());

      // إنشاء قيد يستخدم حساب الصندوق
      await fa.journalEntries.createEntry(_saleEntry(cash.id!, revenue.id!));

      // محاولة الترحيل أولاً
      final allEntries = await fa.journalEntries.getAllEntries();
      await fa.journalEntries.postEntry(allEntries.first.id!);

      expect(
        () => fa.accounts.deleteAccount(cash.id!),
        throwsA(isA<AccountHasTransactionsException>()),
      );
    });

    test('تعطيل حساب وإعادة تفعيله', () async {
      final account = await fa.accounts.createAccount(_cashAccount());

      await fa.accounts.setAccountActive(account.id!, isActive: false);
      final disabled = await fa.accounts.getAccountById(account.id!);
      expect(disabled!.isActive, isFalse);

      await fa.accounts.setAccountActive(account.id!, isActive: true);
      final enabled = await fa.accounts.getAccountById(account.id!);
      expect(enabled!.isActive, isTrue);
    });

    test('جلب الحسابات حسب النوع', () async {
      await fa.accounts.createAccount(_cashAccount());
      await fa.accounts.createAccount(_revenueAccount());

      final assets = await fa.accounts.getAccountsByType(AccountType.asset);
      expect(assets.length, 1);
      expect(assets.first.code, '111');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // اختبارات محرك القيد المزدوج
  // ═══════════════════════════════════════════════════════════════
  group('AccountingValidator', () {
    test('قبول القيد المتوازن', () {
      final lines = [
        JournalEntryLineModel.debitLine(accountId: 1, amount: 1000),
        JournalEntryLineModel.creditLine(accountId: 2, amount: 1000),
      ];

      expect(
        () => AccountingValidator.validateEntryLines(lines),
        returnsNormally,
      );
    });

    test('رفض القيد غير المتوازن', () {
      final lines = [
        JournalEntryLineModel.debitLine(accountId: 1, amount: 1000),
        JournalEntryLineModel.creditLine(accountId: 2, amount: 900),
      ];

      expect(
        () => AccountingValidator.validateEntryLines(lines),
        throwsA(isA<UnbalancedEntryException>()),
      );
    });

    test('رفض القيد بدون بنود كافية', () {
      final lines = [
        JournalEntryLineModel.debitLine(accountId: 1, amount: 500),
      ];

      expect(
        () => AccountingValidator.validateEntryLines(lines),
        throwsA(isA<InsufficientLinesException>()),
      );
    });

    test('رفض البنود ذات المبلغ الصفري', () {
      final lines = [
        JournalEntryLineModel(accountId: 1, debit: 0, credit: 0),
        JournalEntryLineModel.creditLine(accountId: 2, amount: 500),
      ];

      expect(
        () => AccountingValidator.validateEntryLines(lines),
        throwsA(isA<ZeroAmountLineException>()),
      );
    });

    test('حساب إجمالي المدين والدائن', () {
      final lines = [
        JournalEntryLineModel.debitLine(accountId: 1, amount: 600),
        JournalEntryLineModel.debitLine(accountId: 2, amount: 400),
        JournalEntryLineModel.creditLine(accountId: 3, amount: 1000),
      ];

      expect(AccountingValidator.totalDebits(lines),  1000);
      expect(AccountingValidator.totalCredits(lines), 1000);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // اختبارات القيود اليومية
  // ═══════════════════════════════════════════════════════════════
  group('JournalEntryRepository', () {
    late int cashId;
    late int revenueId;

    setUp(() async {
      final cash    = await fa.accounts.createAccount(_cashAccount());
      final revenue = await fa.accounts.createAccount(_revenueAccount());
      cashId    = cash.id!;
      revenueId = revenue.id!;
    });

    test('إنشاء قيد مسودة بنجاح', () async {
      final entry = await fa.journalEntries.createEntry(
        _saleEntry(cashId, revenueId),
      );

      expect(entry.id,     isNotNull);
      expect(entry.status, EntryStatus.draft);
      expect(entry.lines,  hasLength(2));
      expect(entry.isBalanced, isTrue);
    });

    test('ترحيل القيد بنجاح', () async {
      final draft  = await fa.journalEntries.createEntry(_saleEntry(cashId, revenueId));
      final posted = await fa.journalEntries.postEntry(draft.id!);

      expect(posted.status,   EntryStatus.posted);
      expect(posted.isPosted, isTrue);
    });

    test('رفض تعديل القيد المرحّل', () async {
      final draft  = await fa.journalEntries.createEntry(_saleEntry(cashId, revenueId));
      final posted = await fa.journalEntries.postEntry(draft.id!);

      expect(
        () => fa.journalEntries.updateEntry(posted),
        throwsA(isA<CannotModifyPostedEntryException>()),
      );
    });

    test('رفض حذف القيد المرحّل', () async {
      final draft = await fa.journalEntries.createEntry(_saleEntry(cashId, revenueId));
      await fa.journalEntries.postEntry(draft.id!);

      expect(
        () => fa.journalEntries.deleteEntry(draft.id!),
        throwsA(isA<CannotModifyPostedEntryException>()),
      );
    });

    test('القيد العكسي يُنشئ قيداً جديداً ويعكس البنود', () async {
      final draft    = await fa.journalEntries.createEntry(_saleEntry(cashId, revenueId));
      final posted   = await fa.journalEntries.postEntry(draft.id!);
      final reversal = await fa.journalEntries.reverseEntry(posted.id!);

      // القيد العكسي يجب أن يكون متوازناً
      expect(reversal.isBalanced, isTrue);
      expect(reversal.status,     EntryStatus.posted);
      expect(reversal.description, contains('عكس'));

      // بنود القيد العكسي تكون معكوسة
      final origDebit  = posted.lines.firstWhere((l) => l.isDebit);
      final revCredit  = reversal.lines.firstWhere((l) => l.isCredit && l.accountId == origDebit.accountId);
      expect(revCredit.credit, origDebit.debit);

      // الحالة الأصلية تصبح "معكوس"
      final original = await fa.journalEntries.getEntryById(posted.id!);
      expect(original!.status, EntryStatus.reversed);
    });

    test('رفض الترحيل على حساب غير نشط', () async {
      await fa.accounts.setAccountActive(cashId, isActive: false);

      final draft = await fa.journalEntries.createEntry(_saleEntry(cashId, revenueId));

      expect(
        () => fa.journalEntries.postEntry(draft.id!),
        throwsA(isA<InactiveAccountException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // اختبارات التقارير المالية
  // ═══════════════════════════════════════════════════════════════
  group('ReportsRepository', () {
    setUp(() async {
      final cash     = await fa.accounts.createAccount(_cashAccount());
      final revenue  = await fa.accounts.createAccount(_revenueAccount());
      final expenses = await fa.accounts.createAccount(_expenseAccount());

      // قيد مبيعات: صندوق مدين / إيرادات دائن - 5000
      final saleEntry  = await fa.journalEntries.createEntry(_saleEntry(cash.id!, revenue.id!));
      await fa.journalEntries.postEntry(saleEntry.id!);

      // قيد مصاريف: مصاريف مدين / صندوق دائن - 2000
      final expEntry = await fa.journalEntries.createEntry(
        JournalEntryModel(
          date: DateTime.now(),
          description: 'دفع مصاريف إيجار',
          status: EntryStatus.draft,
          lines: [
            JournalEntryLineModel.debitLine(accountId: expenses.id!, amount: 2000),
            JournalEntryLineModel.creditLine(accountId: cash.id!, amount: 2000),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      await fa.journalEntries.postEntry(expEntry.id!);
    });

    test('ميزان المراجعة متوازن', () async {
      final report = await fa.reports.getTrialBalance();
      expect(report.isBalanced, isTrue);
    });

    test('قائمة الدخل: صافي الربح صحيح', () async {
      final report = await fa.reports.getIncomeStatement(
        from: DateTime(2000),
        to:   DateTime(2100),
      );

      expect(report.totalRevenue,  5000);
      expect(report.totalExpenses, 2000);
      expect(report.netIncome,     3000);
      expect(report.isProfitable,  isTrue);
    });

    test('الميزانية العمومية متوازنة', () async {
      final report = await fa.reports.getBalanceSheet(asOf: DateTime(2100));
      expect(report.isBalanced, isTrue);
    });
  });
}

// ─────────────────────────────────────────────────────────────
// بيانات الاختبار المساعدة
// ─────────────────────────────────────────────────────────────

AccountModel _cashAccount() => AccountModel(
  code: '111', name: 'Cash', nameAr: 'الصندوق',
  type: AccountType.asset,
  createdAt: DateTime.now(), updatedAt: DateTime.now(),
);

AccountModel _revenueAccount() => AccountModel(
  code: '41', name: 'Sales Revenue', nameAr: 'إيرادات المبيعات',
  type: AccountType.revenue,
  createdAt: DateTime.now(), updatedAt: DateTime.now(),
);

AccountModel _expenseAccount() => AccountModel(
  code: '53', name: 'Rent Expense', nameAr: 'مصاريف الإيجار',
  type: AccountType.expense,
  createdAt: DateTime.now(), updatedAt: DateTime.now(),
);

JournalEntryModel _saleEntry(int cashId, int revenueId) => JournalEntryModel(
  date:        DateTime.now(),
  description: 'قيد مبيعات نقدية',
  reference:   'INV-001',
  status:      EntryStatus.draft,
  lines: [
    JournalEntryLineModel.debitLine(accountId: cashId,    amount: 5000, description: 'استلام نقدي'),
    JournalEntryLineModel.creditLine(accountId: revenueId, amount: 5000, description: 'إيراد مبيعات'),
  ],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
