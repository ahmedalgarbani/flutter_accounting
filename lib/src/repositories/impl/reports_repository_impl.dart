/// reports_repository_impl.dart
/// تنفيذ Repository التقارير المالية الثلاثة

import '../../core/enums.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../reports/report_models.dart';
import '../interfaces/interfaces.dart';

class ReportsRepositoryImpl implements IReportsRepository {
  final JournalEntriesDao _entriesDao;

  ReportsRepositoryImpl(this._entriesDao);

  // ─────────────────────────────────────────────────────────────
  // ميزان المراجعة - Trial Balance
  // ─────────────────────────────────────────────────────────────

  @override
  Future<TrialBalanceReport> getTrialBalance({
    DateTime? from,
    DateTime? to,
  }) async {
    final now      = DateTime.now();
    final fromDate = from ?? DateTime(now.year, 1, 1);
    final toDate   = to   ?? now;

    final balances = await _entriesDao.getAccountBalances(
      from: fromDate,
      to:   toDate,
    );

    final rows = balances
        .where((b) => b.totalDebit > 0 || b.totalCredit > 0)
        .map((b) {
      final type          = AccountType.values[b.accountType];
      final netBalance    = b.totalDebit - b.totalCredit;

      // الرصيد: موجب = مدين، سالب = دائن
      final balance = type.normalBalance == NormalBalance.debit
          ? netBalance          // الأصول والمصاريف: الرصيد الطبيعي مدين
          : -netBalance;        // الخصوم والإيرادات وحقوق الملكية: الرصيد الطبيعي دائن

      return TrialBalanceRow(
        accountId:   b.accountId,
        accountCode: b.accountCode,
        accountName: b.accountName,
        accountType: type,
        totalDebits:  b.totalDebit,
        totalCredits: b.totalCredit,
        balance:      balance,
      );
    }).toList();

    return TrialBalanceReport(
      from:        fromDate,
      to:          toDate,
      generatedAt: now,
      rows:        rows,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // الميزانية العمومية - Balance Sheet
  // ─────────────────────────────────────────────────────────────

  @override
  Future<BalanceSheetReport> getBalanceSheet({required DateTime asOf}) async {
    final now      = DateTime.now();
    final balances = await _entriesDao.getAccountBalances(to: asOf);

    List<BalanceSheetRow> assetRows     = [];
    List<BalanceSheetRow> liabilityRows = [];
    List<BalanceSheetRow> equityRows    = [];

    // متغيرات قائمة الدخل (لحساب الأرباح المدورة)
    double totalRevenue  = 0;
    double totalExpenses = 0;

    for (final b in balances) {
      final type       = AccountType.values[b.accountType];
      final netBalance = b.totalCredit - b.totalDebit;

      switch (type) {
        case AccountType.asset:
          final balance = b.totalDebit - b.totalCredit; // الأصول رصيدها مدين
          if (balance != 0) {
            assetRows.add(BalanceSheetRow(
              accountId:   b.accountId,
              accountCode: b.accountCode,
              accountName: b.accountName,
              type:        type,
              balance:     balance,
            ));
          }
        case AccountType.liability:
          if (netBalance != 0) {
            liabilityRows.add(BalanceSheetRow(
              accountId:   b.accountId,
              accountCode: b.accountCode,
              accountName: b.accountName,
              type:        type,
              balance:     netBalance,
            ));
          }
        case AccountType.equity:
          if (netBalance != 0) {
            equityRows.add(BalanceSheetRow(
              accountId:   b.accountId,
              accountCode: b.accountCode,
              accountName: b.accountName,
              type:        type,
              balance:     netBalance,
            ));
          }
        case AccountType.revenue:
          totalRevenue += netBalance;
        case AccountType.expense:
          totalExpenses += (b.totalDebit - b.totalCredit);
      }
    }

    return BalanceSheetReport(
      asOf:              asOf,
      generatedAt:       now,
      assetRows:         assetRows,
      liabilityRows:     liabilityRows,
      equityRows:        equityRows,
      retainedEarnings:  totalRevenue - totalExpenses,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // قائمة الأرباح والخسائر - Income Statement
  // ─────────────────────────────────────────────────────────────

  @override
  Future<IncomeStatementReport> getIncomeStatement({
    required DateTime from,
    required DateTime to,
  }) async {
    final now      = DateTime.now();
    final balances = await _entriesDao.getAccountBalances(from: from, to: to);

    List<IncomeStatementRow> revenueRows = [];
    List<IncomeStatementRow> expenseRows = [];

    for (final b in balances) {
      final type = AccountType.values[b.accountType];

      if (type == AccountType.revenue) {
        final balance = b.totalCredit - b.totalDebit;
        if (balance != 0) {
          revenueRows.add(IncomeStatementRow(
            accountId:   b.accountId,
            accountCode: b.accountCode,
            accountName: b.accountName,
            type:        type,
            balance:     balance,
          ));
        }
      } else if (type == AccountType.expense) {
        final balance = b.totalDebit - b.totalCredit;
        if (balance != 0) {
          expenseRows.add(IncomeStatementRow(
            accountId:   b.accountId,
            accountCode: b.accountCode,
            accountName: b.accountName,
            type:        type,
            balance:     balance,
          ));
        }
      }
    }

    return IncomeStatementReport(
      from:        from,
      to:          to,
      generatedAt: now,
      revenueRows: revenueRows,
      expenseRows: expenseRows,
    );
  }
}
