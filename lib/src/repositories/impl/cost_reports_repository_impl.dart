/// cost_reports_repository_impl.dart
/// تنفيذ تقارير مراكز التكلفة
library;

import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../database/accounting_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/cost_centers_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../reports/cost_center_report_models.dart';
import '../../reports/report_models.dart';
import '../interfaces/interfaces.dart';

/// حدود التواريخ مثل التقارير المالية: `from` من بداية يومه،
/// و`to` حتى نهاية يومه. الافتراضي: من بداية السنة الحالية حتى اليوم.
class CostReportsRepositoryImpl implements ICostReportsRepository {
  final CostCentersDao _dao;
  final AccountsDao _accountsDao;
  final JournalEntriesDao _entriesDao;

  CostReportsRepositoryImpl(this._dao, this._accountsDao, this._entriesDao);

  // ─────────────────────────────────────────────────────────────
  // ملخص المراكز
  // ─────────────────────────────────────────────────────────────

  @override
  Future<CostCenterSummaryReport> getSummary({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
  }) async {
    final dimension = await _dimension(dimensionId);
    final range = _Range(from, to);
    final accounts = await _accounts();
    final tree = _CenterTree(await _dao.getCenters(dimensionId: dimensionId));

    // الإيرادات والمصروفات المباشرة لكل مركز
    final direct = <int, _Pnl>{};
    for (final t in await _dao.getCenterAccountTotals(
        dimensionId: dimensionId,
        from: range.from,
        toExclusive: range.toExclusive)) {
      direct
          .putIfAbsent(t.costCenterId!, _Pnl.new)
          .add(accounts[t.accountId]!.type, t.totalDebit, t.totalCredit);
    }
    final unallocated = _Pnl();
    for (final t in await _dao.getUnallocatedAccountTotals(
        dimensionId: dimensionId,
        from: range.from,
        toExclusive: range.toExclusive)) {
      unallocated.add(accounts[t.accountId]!.type, t.totalDebit, t.totalCredit);
    }

    final rows = <CostCenterSummaryRow>[];
    for (final c in tree.inTreeOrder()) {
      final total = _Pnl();
      for (final id in tree.subtree(c.id)) {
        final d = direct[id];
        if (d != null) total.merge(d);
      }
      rows.add(CostCenterSummaryRow(
        costCenterId: c.id,
        code: c.code,
        name: c.name,
        nameAr: c.nameAr,
        parentId: c.parentId,
        level: c.level,
        isLeaf: tree.isLeaf(c.id),
        isActive: c.isActive,
        revenue: total.revenue,
        expenses: total.expenses,
      ));
    }

    return CostCenterSummaryReport(
      dimensionId: dimension.id,
      dimensionCode: dimension.code,
      dimensionName: dimension.nameAr ?? dimension.name,
      from: range.from,
      to: range.to,
      generatedAt: DateTime.now(),
      rows: rows,
      unallocatedRevenue: unallocated.revenue,
      unallocatedExpenses: unallocated.expenses,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // مقارنة المراكز
  // ─────────────────────────────────────────────────────────────

  @override
  Future<CostCenterComparisonReport> getComparison({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
    List<int>? costCenterIds,
    bool includeUnallocated = true,
    bool incomeStatementOnly = true,
  }) async {
    final dimension = await _dimension(dimensionId);
    final range = _Range(from, to);
    final accounts = await _accounts();
    final tree = _CenterTree(await _dao.getCenters(dimensionId: dimensionId));
    final selected = tree.selectOrRoots(costCenterIds);

    // رصيد (مدين، دائن) لكل حساب لكل عمود
    final perColumn = <int?, Map<int, _DebitCredit>>{};
    final totals = await _dao.getCenterAccountTotals(
        dimensionId: dimensionId,
        from: range.from,
        toExclusive: range.toExclusive);
    for (final columnId in selected) {
      final members = tree.subtree(columnId).toSet();
      final byAccount = perColumn[columnId] = {};
      for (final t in totals.where((t) => members.contains(t.costCenterId))) {
        byAccount
            .putIfAbsent(t.accountId, _DebitCredit.new)
            .add(t.totalDebit, t.totalCredit);
      }
    }
    if (includeUnallocated) {
      final byAccount = perColumn[null] = {};
      for (final t in await _dao.getUnallocatedAccountTotals(
          dimensionId: dimensionId,
          from: range.from,
          toExclusive: range.toExclusive)) {
        byAccount
            .putIfAbsent(t.accountId, _DebitCredit.new)
            .add(t.totalDebit, t.totalCredit);
      }
    }

    // الصفوف: كل حساب له رصيد في أي عمود
    final accountIds = <int>{
      for (final m in perColumn.values) ...m.keys,
    }.where((id) =>
        !incomeStatementOnly || accounts[id]!.type.isIncomeStatementAccount);
    final rows = <CostCenterComparisonRow>[];
    for (final id in accountIds) {
      final account = accounts[id]!;
      final amounts = <int?, double>{
        for (final MapEntry(key: column, value: byAccount) in perColumn.entries)
          if (byAccount[id] != null)
            column: byAccount[id]!.natural(account.type),
      };
      if (amounts.values.every((v) => v.abs() < 1e-9)) continue;
      rows.add(CostCenterComparisonRow(
        accountId: id,
        accountCode: account.code,
        accountName: account.name,
        accountNameAr: account.nameAr,
        accountType: account.type,
        amounts: amounts,
      ));
    }
    rows.sort((a, b) => a.accountCode.compareTo(b.accountCode));

    CostCenterComparisonColumn column(int? id, CostCenterHeader header) {
      double revenue = 0, expenses = 0;
      for (final r in rows) {
        if (r.accountType == AccountType.revenue) revenue += r.amountFor(id);
        if (r.accountType == AccountType.expense) expenses += r.amountFor(id);
      }
      return CostCenterComparisonColumn(
          header: header, revenue: revenue, expenses: expenses);
    }

    return CostCenterComparisonReport(
      dimensionId: dimension.id,
      dimensionCode: dimension.code,
      dimensionName: dimension.nameAr ?? dimension.name,
      from: range.from,
      to: range.to,
      generatedAt: DateTime.now(),
      columns: [
        for (final id in selected) column(id, tree.header(id)),
        if (includeUnallocated)
          column(null, const CostCenterHeader.unallocated()),
      ],
      rows: rows,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // قائمة الدخل وميزان المراجعة لمجموعة مراكز
  // ─────────────────────────────────────────────────────────────

  @override
  Future<IncomeStatementReport> getIncomeStatement({
    required CostCenterFilter filter,
    required DateTime from,
    required DateTime to,
  }) async {
    final range = _Range(from, to);
    final accounts = await _accounts();
    final totals = await _filteredTotals(filter, range);

    final revenueRows = <IncomeStatementRow>[];
    final expenseRows = <IncomeStatementRow>[];
    for (final MapEntry(key: id, value: dc) in totals.entries) {
      final account = accounts[id]!;
      if (!account.type.isIncomeStatementAccount) continue;
      final balance = dc.natural(account.type);
      if (balance.abs() < 1e-9) continue;
      final row = IncomeStatementRow(
        accountId: id,
        accountCode: account.code,
        accountName: account.name,
        accountNameAr: account.nameAr,
        type: account.type,
        balance: balance,
      );
      (account.type == AccountType.revenue ? revenueRows : expenseRows)
          .add(row);
    }
    revenueRows.sort((a, b) => a.accountCode.compareTo(b.accountCode));
    expenseRows.sort((a, b) => a.accountCode.compareTo(b.accountCode));

    return IncomeStatementReport(
      from: from,
      to: to,
      generatedAt: DateTime.now(),
      revenueRows: revenueRows,
      expenseRows: expenseRows,
    );
  }

  @override
  Future<TrialBalanceReport> getTrialBalance({
    required CostCenterFilter filter,
    DateTime? from,
    DateTime? to,
  }) async {
    final range = _Range(from, to);
    final accounts = await _accounts();
    final totals = await _filteredTotals(filter, range);

    final rows = [
      for (final MapEntry(key: id, value: dc) in totals.entries)
        if (dc.debit.abs() > 1e-9 || dc.credit.abs() > 1e-9)
          TrialBalanceRow(
            accountId: id,
            accountCode: accounts[id]!.code,
            accountName: accounts[id]!.name,
            accountNameAr: accounts[id]!.nameAr,
            accountType: accounts[id]!.type,
            totalDebits: dc.debit,
            totalCredits: dc.credit,
            balance: dc.debit - dc.credit,
          ),
    ]..sort((a, b) => a.accountCode.compareTo(b.accountCode));

    return TrialBalanceReport(
      from: range.from,
      to: range.to,
      generatedAt: DateTime.now(),
      rows: rows,
    );
  }

  /// مجموع (مدين، دائن) لكل حساب ضمن الفلتر، مع تقاطع الأبعاد بالتناسب
  Future<Map<int, _DebitCredit>> _filteredTotals(
    CostCenterFilter filter,
    _Range range,
  ) async {
    final tree = _CenterTree(await _dao.getCenters());
    final byDimension = <int, Set<int>>{};
    for (final id in filter.costCenterIds) {
      final center = tree.centers[id];
      if (center == null) throw CostCenterNotFoundException(id);
      byDimension
          .putIfAbsent(center.dimensionId, () => {})
          .addAll(filter.includeChildren ? tree.subtree(id) : [id]);
    }
    final result = <int, _DebitCredit>{};
    if (byDimension.isEmpty) return result;

    final rows = await _dao.getAllocationRows(
      costCenterIds: [for (final s in byDimension.values) ...s],
      from: range.from,
      toExclusive: range.toExclusive,
    );

    // تجميع حسب البند: مجموع الحصص المختارة لكل بُعد
    final byLine = <int, (AllocationDetailRow, Map<int, double>)>{};
    for (final r in rows) {
      final entry = byLine.putIfAbsent(r.lineId, () => (r, {}));
      entry.$2
          .update(r.dimensionId, (v) => v + r.amount, ifAbsent: () => r.amount);
    }
    for (final (line, sums) in byLine.values) {
      if (sums.length != byDimension.length) continue; // لا يقع في كل الأبعاد
      var portion = line.lineAmount;
      for (final s in sums.values) {
        portion *= s / line.lineAmount;
      }
      result
          .putIfAbsent(line.accountId, _DebitCredit.new)
          .add(line.isDebit ? portion : 0, line.isDebit ? 0 : portion);
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────
  // كشف حساب مركز
  // ─────────────────────────────────────────────────────────────

  @override
  Future<CostCenterLedgerReport> getLedger(
    int costCenterId, {
    DateTime? from,
    DateTime? to,
    int? accountId,
    bool includeChildren = true,
  }) async {
    final center = await _dao.getCenterById(costCenterId);
    if (center == null) throw CostCenterNotFoundException(costCenterId);

    final centerIds = [
      costCenterId,
      if (includeChildren) ...await _dao.getDescendantIds(costCenterId),
    ];
    List<int>? accountIds;
    if (accountId != null) {
      if (await _accountsDao.getAccountById(accountId) == null) {
        throw AccountNotFoundException(accountId);
      }
      accountIds = [
        accountId,
        ...await _accountsDao.getDescendantIds(accountId),
      ];
    }
    final accounts = await _accounts();
    final centers = {
      for (final c in await _dao.getCenters(dimensionId: center.dimensionId))
        c.id: c,
    };

    final toDate = to ?? DateTime.now();
    double opening = 0;
    if (from != null) {
      for (final r in await _dao.getAllocationRows(
          costCenterIds: centerIds,
          accountIds: accountIds,
          toExclusive: startOfDay(from))) {
        opening += r.debit - r.credit;
      }
    }

    var running = opening;
    final lines = <CostCenterLedgerLine>[];
    for (final r in await _dao.getAllocationRows(
        costCenterIds: centerIds,
        accountIds: accountIds,
        from: from != null ? startOfDay(from) : null,
        toExclusive: startOfNextDay(toDate))) {
      running += r.debit - r.credit;
      final account = accounts[r.accountId]!;
      lines.add(CostCenterLedgerLine(
        entryId: r.entryId,
        serialNumber: r.serialNumber,
        date: r.date,
        description: r.lineDescription ?? r.entryDescription,
        reference: r.reference,
        accountId: r.accountId,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        costCenterId: r.costCenterId,
        costCenterCode: centers[r.costCenterId]?.code ?? '',
        debit: r.debit,
        credit: r.credit,
        runningBalance: running,
      ));
    }

    return CostCenterLedgerReport(
      costCenterId: center.id,
      costCenterCode: center.code,
      costCenterName: center.name,
      costCenterNameAr: center.nameAr,
      includesChildren: includeChildren,
      accountId: accountId,
      from: from,
      to: toDate,
      generatedAt: DateTime.now(),
      openingBalance: opening,
      lines: lines,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // مصفوفة بُعدين
  // ─────────────────────────────────────────────────────────────

  @override
  Future<CostCenterMatrixReport> getMatrix({
    required int rowDimensionId,
    required int columnDimensionId,
    DateTime? from,
    DateTime? to,
    List<int>? rowCostCenterIds,
    List<int>? columnCostCenterIds,
  }) async {
    if (rowDimensionId == columnDimensionId) {
      throw ArgumentError('المصفوفة تتطلب بُعدين مختلفين.');
    }
    await _dimension(rowDimensionId);
    await _dimension(columnDimensionId);
    final range = _Range(from, to);
    final accounts = await _accounts();
    final rowTree =
        _CenterTree(await _dao.getCenters(dimensionId: rowDimensionId));
    final colTree =
        _CenterTree(await _dao.getCenters(dimensionId: columnDimensionId));
    final rowSelected = rowTree.selectOrRoots(rowCostCenterIds);
    final colSelected = colTree.selectOrRoots(columnCostCenterIds);

    final incomeAccountIds = [
      for (final a in accounts.values)
        if (a.type.isIncomeStatementAccount) a.id,
    ];
    final rows = await _dao.getAllocationRows(
      dimensionIds: [rowDimensionId, columnDimensionId],
      accountIds: incomeAccountIds,
      from: range.from,
      toExclusive: range.toExclusive,
    );

    // حصص كل بند في كل من البعدين
    final byLine = <int,
        (AllocationDetailRow, List<(int, double)>, List<(int, double)>)>{};
    for (final r in rows) {
      final e = byLine.putIfAbsent(r.lineId, () => (r, [], []));
      (r.dimensionId == rowDimensionId ? e.$2 : e.$3)
          .add((r.costCenterId, r.amount));
    }

    const excluded = -1; // مركز خارج المراكز المختارة
    final cells = <(int?, int?), CostCenterMatrixCell>{};
    var touched = const CostCenterMatrixCell();
    for (final (line, rowShares, colShares) in byLine.values) {
      final type = accounts[line.accountId]!.type;
      final sign = (type == AccountType.revenue) == line.isDebit ? -1 : 1;
      CostCenterMatrixCell cellOf(double amount) => type == AccountType.revenue
          ? CostCenterMatrixCell(revenue: sign * amount)
          : CostCenterMatrixCell(expenses: sign * amount);

      final l = line.lineAmount;
      final rs = rowShares.isEmpty
          ? [(null, l)]
          : [
              for (final (id, a) in rowShares)
                (rowTree.bucket(id, rowSelected) ?? excluded, a)
            ];
      final cs = colShares.isEmpty
          ? [(null, l)]
          : [
              for (final (id, a) in colShares)
                (colTree.bucket(id, colSelected) ?? excluded, a)
            ];
      touched += cellOf(l);
      for (final (r, ra) in rs) {
        for (final (c, ca) in cs) {
          if (r == excluded || c == excluded) continue;
          cells.update((r, c), (v) => v + cellOf(ra * ca / l),
              ifAbsent: () => cellOf(ra * ca / l));
        }
      }
    }

    // البنود التي لا مركز لها في أي من البعدين
    final company = _Pnl();
    for (final b in await _entriesDao.getAccountBalances(
        from: range.from, toExclusive: range.toExclusive)) {
      company.add(
          AccountType.values[b.accountType], b.totalDebit, b.totalCredit);
    }
    final none = CostCenterMatrixCell(
      revenue: company.revenue - touched.revenue,
      expenses: company.expenses - touched.expenses,
    );
    if (none.revenue.abs() > 1e-9 || none.expenses.abs() > 1e-9) {
      cells.update((null, null), (v) => v + none, ifAbsent: () => none);
    }

    return CostCenterMatrixReport(
      rowDimensionId: rowDimensionId,
      columnDimensionId: columnDimensionId,
      from: range.from,
      to: range.to,
      generatedAt: DateTime.now(),
      rowHeaders: [
        for (final id in rowSelected) rowTree.header(id),
        const CostCenterHeader.unallocated(),
      ],
      columnHeaders: [
        for (final id in colSelected) colTree.header(id),
        const CostCenterHeader.unallocated(),
      ],
      cells: cells,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // البنود غير الموزعة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<UnallocatedLinesReport> getUnallocatedLines({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
    bool incomeStatementOnly = true,
  }) async {
    final dimension = await _dimension(dimensionId);
    final range = _Range(from, to);
    final accounts = await _accounts();

    final lines = <UnallocatedLine>[];
    for (final r in await _dao.getUnallocatedLines(
        dimensionId: dimensionId,
        from: range.from,
        toExclusive: range.toExclusive)) {
      final account = accounts[r.accountId]!;
      if (incomeStatementOnly && !account.type.isIncomeStatementAccount) {
        continue;
      }
      lines.add(UnallocatedLine(
        entryId: r.entryId,
        serialNumber: r.serialNumber,
        date: r.date,
        description: r.lineDescription ?? r.entryDescription,
        reference: r.reference,
        accountId: r.accountId,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        accountType: account.type,
        debit: r.lineDebit,
        credit: r.lineCredit,
        allocatedAmount: r.allocated,
      ));
    }

    return UnallocatedLinesReport(
      dimensionId: dimension.id,
      dimensionCode: dimension.code,
      dimensionName: dimension.nameAr ?? dimension.name,
      from: range.from,
      to: range.to,
      generatedAt: DateTime.now(),
      lines: lines,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات
  // ─────────────────────────────────────────────────────────────

  Future<CostDimension> _dimension(int id) async {
    final dimension = await _dao.getDimensionById(id);
    if (dimension == null) throw CostDimensionNotFoundException(id);
    return dimension;
  }

  Future<Map<int, Account>> _accounts() async =>
      {for (final a in await _accountsDao.getAllAccounts()) a.id: a};
}

/// نطاق تقرير بحدود الأيام
class _Range {
  final DateTime from;
  final DateTime to;
  final DateTime toExclusive;

  factory _Range(DateTime? from, DateTime? to) {
    final now = DateTime.now();
    final toDate = to ?? now;
    return _Range._(startOfDay(from ?? DateTime(now.year, 1, 1)), toDate,
        startOfNextDay(toDate));
  }

  _Range._(this.from, this.to, this.toExclusive);
}

class _DebitCredit {
  double debit = 0;
  double credit = 0;

  void add(double d, double c) {
    debit += d;
    credit += c;
  }

  /// الرصيد بالاتجاه الطبيعي لنوع الحساب
  double natural(AccountType type) => type.normalBalance == NormalBalance.debit
      ? debit - credit
      : credit - debit;
}

/// إيرادات ومصروفات متراكمة
class _Pnl {
  double revenue = 0;
  double expenses = 0;

  void add(AccountType type, double debit, double credit) {
    if (type == AccountType.revenue) revenue += credit - debit;
    if (type == AccountType.expense) expenses += debit - credit;
  }

  void merge(_Pnl other) {
    revenue += other.revenue;
    expenses += other.expenses;
  }
}

/// شجرة مراكز في الذاكرة
class _CenterTree {
  _CenterTree(List<CostCenter> list)
      : centers = {for (final c in list) c.id: c} {
    for (final c in list) {
      _children.putIfAbsent(c.parentId, () => []).add(c.id);
    }
  }

  final Map<int, CostCenter> centers;
  final Map<int?, List<int>> _children = {};

  bool isLeaf(int id) => (_children[id] ?? const []).isEmpty;

  /// المركز وكل أبنائه
  List<int> subtree(int id) => [
        id,
        for (final child in _children[id] ?? const <int>[]) ...subtree(child),
      ];

  /// كل المراكز بترتيب الشجرة (الأب ثم أبناؤه، مرتبين بالرمز)
  List<CostCenter> inTreeOrder() {
    final result = <CostCenter>[];
    void visit(int? parentId) {
      final ids = [...?_children[parentId]]
        ..sort((a, b) => centers[a]!.code.compareTo(centers[b]!.code));
      for (final id in ids) {
        result.add(centers[id]!);
        visit(id);
      }
    }

    visit(null);
    return result;
  }

  /// المراكز المحددة (بعد التحقق)، أو المراكز الجذرية
  List<int> selectOrRoots(List<int>? ids) {
    if (ids == null) {
      return [
        for (final c in inTreeOrder())
          if (c.parentId == null) c.id
      ];
    }
    for (final id in ids) {
      if (!centers.containsKey(id)) throw CostCenterNotFoundException(id);
    }
    return ids;
  }

  /// أول مركز من [selected] يحتوي [id] (هو نفسه أو أحد آبائه)
  int? bucket(int id, List<int> selected) {
    int? current = id;
    final visited = <int>{};
    while (current != null && visited.add(current)) {
      if (selected.contains(current)) return current;
      current = centers[current]?.parentId;
    }
    return null;
  }

  CostCenterHeader header(int id) {
    final c = centers[id]!;
    return CostCenterHeader(
        costCenterId: c.id, code: c.code, name: c.name, nameAr: c.nameAr);
  }
}
