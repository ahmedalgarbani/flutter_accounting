/// reports_repository_impl.dart
/// تنفيذ Repository التقارير المالية
library;

import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../reports/report_models.dart';
import '../interfaces/interfaces.dart';

/// ملاحظة حول حدود التواريخ في كل التقارير:
/// التقارير تعمل على مستوى اليوم؛ `from` يشمل كامل يومه من 00:00،
/// و`to` / `asOf` يشملان كامل يومهما حتى 23:59:59.
class ReportsRepositoryImpl implements IReportsRepository {
  final JournalEntriesDao _entriesDao;
  final AccountsDao? _accountsDao;

  ReportsRepositoryImpl(this._entriesDao, [this._accountsDao]);

  AccountsDao get _accounts =>
      _accountsDao ?? _entriesDao.attachedDatabase.accountsDao;

  // ─────────────────────────────────────────────────────────────
  // ميزان المراجعة - Trial Balance
  // ─────────────────────────────────────────────────────────────

  @override
  Future<TrialBalanceReport> getTrialBalance({
    DateTime? from,
    DateTime? to,
  }) async {
    final now      = DateTime.now();
    final fromDate = startOfDay(from ?? DateTime(now.year, 1, 1));
    final toDate   = to ?? now;

    final balances = await _entriesDao.getAccountBalances(
      from:        fromDate,
      toExclusive: startOfNextDay(toDate),
    );

    final rows = balances
        .where((b) => b.totalDebit != 0 || b.totalCredit != 0)
        .map((b) {
      final type       = AccountType.values[b.accountType];
      final netBalance = b.totalDebit - b.totalCredit;

      // الرصيد: موجب = مدين، سالب = دائن (بغض النظر عن نوع الحساب)
      return TrialBalanceRow(
        accountId:     b.accountId,
        accountCode:   b.accountCode,
        accountName:   b.accountName,
        accountNameAr: b.accountNameAr,
        accountType:   type,
        totalDebits:   b.totalDebit,
        totalCredits:  b.totalCredit,
        balance:       netBalance,
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
    final balances = await _entriesDao.getAccountBalances(
      toExclusive: startOfNextDay(asOf),
    );

    final assetRows     = <BalanceSheetRow>[];
    final liabilityRows = <BalanceSheetRow>[];
    final equityRows    = <BalanceSheetRow>[];

    // متغيرات قائمة الدخل (لحساب الأرباح المدورة)
    double totalRevenue  = 0;
    double totalExpenses = 0;

    for (final b in balances) {
      final type          = AccountType.values[b.accountType];
      final creditBalance = b.totalCredit - b.totalDebit;
      final debitBalance  = b.totalDebit - b.totalCredit;

      BalanceSheetRow row(double balance) => BalanceSheetRow(
            accountId:     b.accountId,
            accountCode:   b.accountCode,
            accountName:   b.accountName,
            accountNameAr: b.accountNameAr,
            type:          type,
            balance:       balance,
          );

      switch (type) {
        case AccountType.asset:
          if (debitBalance != 0) assetRows.add(row(debitBalance));
        case AccountType.liability:
          if (creditBalance != 0) liabilityRows.add(row(creditBalance));
        case AccountType.equity:
          if (creditBalance != 0) equityRows.add(row(creditBalance));
        case AccountType.revenue:
          totalRevenue += creditBalance;
        case AccountType.expense:
          totalExpenses += debitBalance;
      }
    }

    return BalanceSheetReport(
      asOf:             asOf,
      generatedAt:      now,
      assetRows:        assetRows,
      liabilityRows:    liabilityRows,
      equityRows:       equityRows,
      retainedEarnings: totalRevenue - totalExpenses,
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
    final balances = await _entriesDao.getAccountBalances(
      from:        startOfDay(from),
      toExclusive: startOfNextDay(to),
    );

    final revenueRows = <IncomeStatementRow>[];
    final expenseRows = <IncomeStatementRow>[];

    for (final b in balances) {
      final type = AccountType.values[b.accountType];

      IncomeStatementRow row(double balance) => IncomeStatementRow(
            accountId:     b.accountId,
            accountCode:   b.accountCode,
            accountName:   b.accountName,
            accountNameAr: b.accountNameAr,
            type:          type,
            balance:       balance,
          );

      if (type == AccountType.revenue) {
        final balance = b.totalCredit - b.totalDebit;
        if (balance != 0) revenueRows.add(row(balance));
      } else if (type == AccountType.expense) {
        final balance = b.totalDebit - b.totalCredit;
        if (balance != 0) expenseRows.add(row(balance));
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

  // ─────────────────────────────────────────────────────────────
  // رصيد حساب - Account Balance
  // ─────────────────────────────────────────────────────────────

  @override
  Future<double> getAccountBalance(
    int accountId, {
    DateTime? asOf,
    bool includeChildren = true,
  }) async {
    final account = await _accounts.getAccountById(accountId);
    if (account == null) throw AccountNotFoundException(accountId);

    final ids = {
      accountId,
      if (includeChildren) ...await _accounts.getDescendantIds(accountId),
    };
    final balances = await _entriesDao.getAccountBalances(
      toExclusive: asOf != null ? startOfNextDay(asOf) : null,
    );

    double debit = 0, credit = 0;
    for (final b in balances.where((b) => ids.contains(b.accountId))) {
      debit  += b.totalDebit;
      credit += b.totalCredit;
    }
    return _natural(account.type, debit, credit);
  }

  // ─────────────────────────────────────────────────────────────
  // كشف حساب - Account Ledger
  // ─────────────────────────────────────────────────────────────

  @override
  Future<AccountLedgerReport> getAccountLedger(
    int accountId, {
    DateTime? from,
    DateTime? to,
    bool includeChildren = true,
  }) async {
    final account = await _accounts.getAccountById(accountId);
    if (account == null) throw AccountNotFoundException(accountId);

    final now    = DateTime.now();
    final toDate = to ?? now;
    final ids = [
      accountId,
      if (includeChildren) ...await _accounts.getDescendantIds(accountId),
    ];

    // الرصيد الافتتاحي: كل الحركات قبل [from]
    double opening = 0;
    if (from != null) {
      final before = await _entriesDao.getAccountBalances(
        toExclusive: startOfDay(from),
      );
      double d = 0, c = 0;
      for (final b in before.where((b) => ids.contains(b.accountId))) {
        d += b.totalDebit;
        c += b.totalCredit;
      }
      opening = _natural(account.type, d, c);
    }

    final rows = await _entriesDao.getLedgerLines(
      accountIds:  ids,
      from:        from != null ? startOfDay(from) : null,
      toExclusive: startOfNextDay(toDate),
    );

    var running = opening;
    final lines = <LedgerEntryLine>[];
    for (final r in rows) {
      running += _natural(account.type, r.debit, r.credit);
      lines.add(LedgerEntryLine(
        entryId:        r.entryId,
        serialNumber:   r.serialNumber,
        date:           r.date,
        description:    r.lineDescription ?? r.entryDescription,
        reference:      r.reference,
        accountId:      r.accountId,
        debit:          r.debit,
        credit:         r.credit,
        runningBalance: running,
      ));
    }

    return AccountLedgerReport(
      accountId:        account.id,
      accountCode:      account.code,
      accountName:      account.name,
      accountNameAr:    account.nameAr,
      accountType:      account.type,
      includesChildren: includeChildren,
      from:             from,
      to:               toDate,
      generatedAt:      now,
      openingBalance:   opening,
      lines:            lines,
    );
  }

  /// الرصيد بالاتجاه الطبيعي لنوع الحساب
  static double _natural(AccountType type, double debit, double credit) =>
      type.normalBalance == NormalBalance.debit ? debit - credit : credit - debit;
}
