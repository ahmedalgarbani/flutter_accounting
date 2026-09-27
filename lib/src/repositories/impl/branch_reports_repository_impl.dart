/// branch_reports_repository_impl.dart
/// تنفيذ تقارير الفروع: المقارنة، التوحيد، ومطابقة الحسابات الجارية
library;

import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../database/accounting_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/branches_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../reports/branch_report_models.dart';
import '../../reports/report_models.dart';
import '../interfaces/interfaces.dart';

class BranchReportsRepositoryImpl implements IBranchReportsRepository {
  final BranchesDao _dao;
  final AccountsDao _accountsDao;
  final JournalEntriesDao _entriesDao;
  final IReportsRepository _reports;

  BranchReportsRepositoryImpl(
      this._dao, this._accountsDao, this._entriesDao, this._reports);

  // ─────────────────────────────────────────────────────────────
  // مقارنة الفروع
  // ─────────────────────────────────────────────────────────────

  @override
  Future<BranchComparisonReport> getComparison({
    DateTime? from,
    DateTime? to,
    List<int>? branchIds,
    bool includeUnassigned = true,
  }) async {
    final now = DateTime.now();
    final fromDate = startOfDay(from ?? DateTime(now.year, 1, 1));
    final toDate = to ?? now;
    final toExclusive = startOfNextDay(toDate);

    final branches = await _dao.getBranches();
    final selected = branchIds == null
        ? branches
        : branches.where((b) => branchIds.contains(b.id)).toList();

    final summaries = <BranchSummary>[];
    final amounts = <int, Map<int?, double>>{};
    final accountTypes = <int, AccountType>{};

    Future<void> add(BranchHeader header, List<int>? ids,
        {bool withoutBranch = false}) async {
      final period = await _entriesDao.getAccountBalances(
          from: fromDate,
          toExclusive: toExclusive,
          branchIds: ids,
          withoutBranch: withoutBranch);
      final position = await _entriesDao.getAccountBalances(
          toExclusive: toExclusive,
          branchIds: ids,
          withoutBranch: withoutBranch);

      double revenue = 0, expenses = 0;
      for (final b in period) {
        final type = AccountType.values[b.accountType];
        if (!type.isIncomeStatementAccount) continue;
        final value = type == AccountType.revenue
            ? b.totalCredit - b.totalDebit
            : b.totalDebit - b.totalCredit;
        if (value.abs() < 1e-9) continue;
        if (type == AccountType.revenue) {
          revenue += value;
        } else {
          expenses += value;
        }
        accountTypes[b.accountId] = type;
        amounts.putIfAbsent(b.accountId, () => {})[header.branchId] = value;
      }

      double assets = 0, liabilities = 0, equity = 0, retained = 0;
      for (final b in position) {
        final debit = b.totalDebit - b.totalCredit;
        switch (AccountType.values[b.accountType]) {
          case AccountType.asset:
            assets += debit;
          case AccountType.liability:
            liabilities -= debit;
          case AccountType.equity:
            equity -= debit;
          case AccountType.revenue:
          case AccountType.expense:
            retained -= debit;
        }
      }
      final hasActivity =
          period.any((b) => b.totalDebit != 0 || b.totalCredit != 0) ||
              position.any((b) => b.totalDebit != 0 || b.totalCredit != 0);
      if (withoutBranch && !hasActivity) return;
      summaries.add(BranchSummary(
        branch: header,
        revenue: revenue,
        expenses: expenses,
        totalAssets: assets,
        totalLiabilities: liabilities,
        totalEquity: equity + retained,
      ));
    }

    for (final b in selected) {
      await add(_header(b), [b.id]);
    }
    if (includeUnassigned) {
      await add(const BranchHeader.unassigned(), null, withoutBranch: true);
    }

    final accounts = {
      for (final a in await _accountsDao.getAllAccounts()) a.id: a,
    };
    final rows = [
      for (final MapEntry(key: id, value: byBranch) in amounts.entries)
        BranchComparisonRow(
          accountId: id,
          accountCode: accounts[id]!.code,
          accountName: accounts[id]!.name,
          accountNameAr: accounts[id]!.nameAr,
          accountType: accountTypes[id]!,
          amounts: byBranch,
        ),
    ]..sort((a, b) => a.accountCode.compareTo(b.accountCode));

    return BranchComparisonReport(
      from: fromDate,
      to: toDate,
      generatedAt: now,
      branches: summaries,
      rows: rows,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // التقارير الموحّدة (استبعاد حسابات جاري الفروع)
  // ─────────────────────────────────────────────────────────────

  Future<Set<int>> _interBranchAccountIds() async {
    final ids = <int>{};
    for (final b in await _dao.getBranches()) {
      final id = b.interBranchAccountId;
      if (id == null) continue;
      ids
        ..add(id)
        ..addAll(await _accountsDao.getDescendantIds(id));
    }
    return ids;
  }

  @override
  Future<TrialBalanceReport> getConsolidatedTrialBalance(
      {DateTime? from, DateTime? to}) async {
    final excluded = await _interBranchAccountIds();
    final tb = await _reports.getTrialBalance(from: from, to: to);
    return TrialBalanceReport(
      from: tb.from,
      to: tb.to,
      generatedAt: tb.generatedAt,
      rows: tb.rows.where((r) => !excluded.contains(r.accountId)).toList(),
    );
  }

  @override
  Future<BalanceSheetReport> getConsolidatedBalanceSheet(
      {required DateTime asOf}) async {
    final excluded = await _interBranchAccountIds();
    final bs = await _reports.getBalanceSheet(asOf: asOf);
    List<BalanceSheetRow> keep(List<BalanceSheetRow> rows) =>
        rows.where((r) => !excluded.contains(r.accountId)).toList();
    return BalanceSheetReport(
      asOf: bs.asOf,
      generatedAt: bs.generatedAt,
      assetRows: keep(bs.assetRows),
      liabilityRows: keep(bs.liabilityRows),
      equityRows: keep(bs.equityRows),
      retainedEarnings: bs.retainedEarnings,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // مطابقة الحسابات الجارية
  // ─────────────────────────────────────────────────────────────

  @override
  Future<InterBranchReconciliationReport> getInterBranchReconciliation(
      {DateTime? asOf}) async {
    final date = asOf ?? DateTime.now();
    final branches = [
      for (final b in await _dao.getBranches())
        if (b.interBranchAccountId != null) b,
    ];

    // رصيد كل حساب جاري في دفاتر كل فرع (موجب = مدين)
    final books = <int, Map<int, double>>{};
    for (final b in branches) {
      books[b.id] = {
        for (final row in await _entriesDao.getAccountBalances(
            toExclusive: startOfNextDay(date), branchIds: [b.id]))
          row.accountId: row.totalDebit - row.totalCredit,
      };
    }

    final pairs = <InterBranchPair>[];
    for (var i = 0; i < branches.length; i++) {
      for (var j = i + 1; j < branches.length; j++) {
        final a = branches[i], b = branches[j];
        final inA = books[a.id]![b.interBranchAccountId] ?? 0;
        final inB = books[b.id]![a.interBranchAccountId] ?? 0;
        if (inA.abs() < 1e-9 && inB.abs() < 1e-9) continue;
        pairs.add(InterBranchPair(
          branchA: _header(a),
          branchB: _header(b),
          balanceInA: inA,
          balanceInB: inB,
        ));
      }
    }

    return InterBranchReconciliationReport(
        asOf: date, generatedAt: DateTime.now(), pairs: pairs);
  }

  static BranchHeader _header(Branch b) => BranchHeader(
      branchId: b.id, code: b.code, name: b.name, nameAr: b.nameAr);
}
