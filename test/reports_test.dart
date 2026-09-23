/// reports_test.dart
/// اختبارات صحة الأرصدة والتقارير (بما فيها إصلاحات الإصدار 0.4.0)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import 'test_helpers.dart';

void main() {
  late FlutterAccounting fa;
  late int cashId;
  late int revenueId;
  late int expenseId;

  setUp(() async {
    fa = FlutterAccounting.forTesting();
    await fa.periods.createFiscalYear(2024);
    await fa.periods.createFiscalYear(2025);
    cashId    = (await fa.accounts.createAccount(cashAccount())).id!;
    revenueId = (await fa.accounts.createAccount(revenueAccount())).id!;
    expenseId = (await fa.accounts.createAccount(expenseAccount())).id!;
  });

  tearDown(() => fa.dispose());

  Future<JournalEntryModel> post(double amount, DateTime date) =>
      fa.journalEntries.createAndPost(saleEntry(cashId, revenueId, amount: amount, date: date));

  group('ReportsRepository - الأرصدة', () {
    test('المسودات لا تدخل في التقارير', () async {
      await fa.journalEntries.createEntry(
        saleEntry(cashId, revenueId, amount: 100, date: DateTime(2024, 3, 1)),
      );

      final tb = await fa.reports.getTrialBalance(from: DateTime(2024), to: DateTime(2024, 12, 31));
      expect(tb.rows, isEmpty);

      final income = await fa.reports.getIncomeStatement(
        from: DateTime(2024), to: DateTime(2024, 12, 31));
      expect(income.totalRevenue, 0);
    });

    test('فلترة التاريخ تعمل في التقارير', () async {
      await post(100, DateTime(2024, 3, 1));
      await post(40, DateTime(2025, 2, 1));

      final income2024 = await fa.reports.getIncomeStatement(
        from: DateTime(2024), to: DateTime(2024, 12, 31));
      expect(income2024.totalRevenue, 100);

      final income2025 = await fa.reports.getIncomeStatement(
        from: DateTime(2025), to: DateTime(2025, 12, 31));
      expect(income2025.totalRevenue, 40);

      final bs2024 = await fa.reports.getBalanceSheet(asOf: DateTime(2024, 12, 31));
      expect(bs2024.totalAssets, 100);
      expect(bs2024.isBalanced, isTrue);
    });

    test('تاريخ النهاية يشمل كامل اليوم', () async {
      await post(75, DateTime(2024, 6, 30, 18, 30));

      final income = await fa.reports.getIncomeStatement(
        from: DateTime(2024, 6, 1), to: DateTime(2024, 6, 30));
      expect(income.totalRevenue, 75);
    });

    test('القيد المعكوس وعكسه يلغيان بعضهما في الأرصدة', () async {
      final posted = await post(50, DateTime(2024, 5, 1));
      await fa.journalEntries.reverseEntry(posted.id!, reversalDate: DateTime(2024, 5, 2));

      final tb = await fa.reports.getTrialBalance(from: DateTime(2024), to: DateTime(2024, 12, 31));
      for (final row in tb.rows) {
        expect(row.balance, 0, reason: row.accountCode);
      }
      expect(await fa.reports.getAccountBalance(cashId), 0);
    });

    test('ميزان المراجعة: الرصيد الدائن يظهر في عمود الدائن', () async {
      await post(300, DateTime(2024, 1, 10));

      final tb = await fa.reports.getTrialBalance(from: DateTime(2024), to: DateTime(2024, 12, 31));
      final revenueRow = tb.rows.firstWhere((r) => r.accountId == revenueId);
      expect(revenueRow.isCreditBalance, isTrue);
      expect(revenueRow.creditBalance, 300);
      expect(tb.totalDebitBalances, 300);
      expect(tb.totalCreditBalances, 300);
      expect(tb.isBalanced, isTrue);
    });

    test('الأسماء العربية متاحة في صفوف التقارير', () async {
      await post(10, DateTime(2024, 1, 10));
      final tb = await fa.reports.getTrialBalance(from: DateTime(2024), to: DateTime(2024, 12, 31));
      final row = tb.rows.firstWhere((r) => r.accountId == cashId);
      expect(row.accountName, 'Cash');
      expect(row.displayName, 'الصندوق');
    });
  });

  group('ReportsRepository - رصيد وكشف الحساب', () {
    test('رصيد الحساب الأب يجمع أرصدة الأبناء', () async {
      final assets = await fa.accounts.createAccount(
        AccountModel.create(code: '1', name: 'Assets', type: AccountType.asset));
      final bank = await fa.accounts.createAccount(
        AccountModel.create(code: '112', name: 'Bank', type: AccountType.asset, parentId: assets.id));
      final petty = await fa.accounts.createAccount(
        AccountModel.create(code: '113', name: 'Petty', type: AccountType.asset, parentId: assets.id));

      await fa.record(JournalEntryBuilder(description: 'x', date: DateTime(2024, 2, 1))
          .debit(bank.id!, 70).debit(petty.id!, 30).credit(revenueId, 100));

      expect(await fa.reports.getAccountBalance(assets.id!), 100);
      expect(await fa.reports.getAccountBalance(assets.id!, includeChildren: false), 0);
      expect(await fa.reports.getAccountBalance(bank.id!), 70);
      expect(await fa.reports.getAccountBalance(revenueId), 100); // رصيد دائن طبيعي = موجب
    });

    test('رصيد الحساب حتى تاريخ معيّن', () async {
      await post(100, DateTime(2024, 1, 1));
      await post(50, DateTime(2024, 6, 1));
      expect(await fa.reports.getAccountBalance(cashId, asOf: DateTime(2024, 3, 1)), 100);
      expect(await fa.reports.getAccountBalance(cashId), 150);
    });

    test('كشف الحساب: رصيد افتتاحي ورصيد تراكمي', () async {
      await post(100, DateTime(2024, 1, 5));
      await post(200, DateTime(2024, 2, 5));
      await fa.journalEntries.createAndPost(JournalEntryModel(
        date: DateTime(2024, 2, 10),
        description: 'إيجار',
        lines: [
          JournalEntryLineModel.debitLine(accountId: expenseId, amount: 50),
          JournalEntryLineModel.creditLine(accountId: cashId, amount: 50),
        ],
      ));

      final ledger = await fa.reports.getAccountLedger(
        cashId, from: DateTime(2024, 2, 1), to: DateTime(2024, 2, 28));

      expect(ledger.openingBalance, 100);
      expect(ledger.lines, hasLength(2));
      expect(ledger.lines[0].runningBalance, 300);
      expect(ledger.lines[1].runningBalance, 250);
      expect(ledger.totalDebits, 200);
      expect(ledger.totalCredits, 50);
      expect(ledger.closingBalance, 250);
      expect(ledger.displayName, 'الصندوق');
    });
  });
}
