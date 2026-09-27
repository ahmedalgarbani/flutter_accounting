/// cost_center_report_models.dart
/// نماذج بيانات تقارير مراكز التكلفة
library;

import 'package:meta/meta.dart';
import '../core/enums.dart';

// ─────────────────────────────────────────────────────────────
// فلتر مراكز التكلفة
// ─────────────────────────────────────────────────────────────

/// فلتر يحدد المراكز التي تُحتسب حركاتها في تقرير.
///
/// - مراكز من نفس البعد تُجمع (فرع الرياض **أو** فرع جدة).
/// - مراكز من أبعاد مختلفة تتقاطع (فرع الرياض **و** مشروع X): تُحتسب حصة
///   البند التي تقع في كل البعدين معاً بالتناسب
///   (بند 1000: 60% للرياض و50% لمشروع X ← 300).
/// - [includeChildren] يضمّ المراكز الفرعية لكل مركز محدد.
@immutable
class CostCenterFilter {
  final List<int> costCenterIds;
  final bool includeChildren;

  const CostCenterFilter(this.costCenterIds, {this.includeChildren = true});

  /// فلتر بمركز واحد
  factory CostCenterFilter.single(int costCenterId,
          {bool includeChildren = true}) =>
      CostCenterFilter([costCenterId], includeChildren: includeChildren);
}

/// ترويسة مركز في تقارير المقارنة والمصفوفة.
/// [costCenterId] = null يعني "غير موزّع" (الحركات بلا مركز من هذا البعد).
@immutable
class CostCenterHeader {
  final int? costCenterId;
  final String code;
  final String name;
  final String? nameAr;

  const CostCenterHeader({
    required this.costCenterId,
    required this.code,
    required this.name,
    this.nameAr,
  });

  /// عمود/صف الحركات غير الموزعة
  const CostCenterHeader.unallocated()
      : costCenterId = null,
        code = '',
        name = 'Unallocated',
        nameAr = 'غير موزّع';

  bool get isUnallocated => costCenterId == null;
  String get displayName => nameAr ?? name;
}

// ─────────────────────────────────────────────────────────────
// ملخص أرباح المراكز - Cost Center Summary
// ─────────────────────────────────────────────────────────────

/// سطر مركز في الملخص. الأرقام **مجمّعة** (المركز الأب يشمل أبناءه).
@immutable
class CostCenterSummaryRow {
  final int costCenterId;
  final String code;
  final String name;
  final String? nameAr;
  final int? parentId;
  final int level;
  final bool isLeaf;
  final bool isActive;

  /// الإيرادات (دائن - مدين)
  final double revenue;

  /// المصروفات (مدين - دائن)
  final double expenses;

  const CostCenterSummaryRow({
    required this.costCenterId,
    required this.code,
    required this.name,
    this.nameAr,
    this.parentId,
    required this.level,
    required this.isLeaf,
    required this.isActive,
    required this.revenue,
    required this.expenses,
  });

  String get displayName => nameAr ?? name;

  /// صافي الربح (أو الخسارة إن كان سالباً)
  double get netIncome => revenue - expenses;
  bool get isProfitable => netIncome >= 0;
}

/// ملخص الإيرادات والمصروفات وصافي الربح لكل مراكز بُعد (شجرة).
@immutable
class CostCenterSummaryReport {
  final int dimensionId;
  final String dimensionCode;
  final String dimensionName;
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;

  /// كل المراكز بترتيب الشجرة (الأب ثم أبناؤه)
  final List<CostCenterSummaryRow> rows;

  /// الحركات التي لم تُوزَّع على أي مركز من هذا البعد
  final double unallocatedRevenue;
  final double unallocatedExpenses;

  const CostCenterSummaryReport({
    required this.dimensionId,
    required this.dimensionCode,
    required this.dimensionName,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.rows,
    required this.unallocatedRevenue,
    required this.unallocatedExpenses,
  });

  /// المراكز الجذرية فقط
  List<CostCenterSummaryRow> get rootRows =>
      rows.where((r) => r.parentId == null).toList();

  /// الأبناء المباشرون لمركز
  List<CostCenterSummaryRow> childrenOf(int costCenterId) =>
      rows.where((r) => r.parentId == costCenterId).toList();

  double get unallocatedNetIncome => unallocatedRevenue - unallocatedExpenses;

  /// إجمالي إيرادات المنشأة في الفترة (الموزع + غير الموزع)
  double get totalRevenue =>
      rootRows.fold(0.0, (s, r) => s + r.revenue) + unallocatedRevenue;

  /// إجمالي مصروفات المنشأة في الفترة (الموزع + غير الموزع)
  double get totalExpenses =>
      rootRows.fold(0.0, (s, r) => s + r.expenses) + unallocatedExpenses;

  double get totalNetIncome => totalRevenue - totalExpenses;
}

// ─────────────────────────────────────────────────────────────
// مقارنة المراكز - Cost Center Comparison
// ─────────────────────────────────────────────────────────────

/// عمود مركز في تقرير المقارنة مع إجمالياته
@immutable
class CostCenterComparisonColumn {
  final CostCenterHeader header;
  final double revenue;
  final double expenses;

  const CostCenterComparisonColumn({
    required this.header,
    required this.revenue,
    required this.expenses,
  });

  double get netIncome => revenue - expenses;
}

/// سطر حساب في تقرير المقارنة: رصيده في كل مركز
@immutable
class CostCenterComparisonRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final AccountType accountType;

  /// الرصيد بالاتجاه الطبيعي للحساب لكل مركز (المفتاح null = غير موزّع)
  final Map<int?, double> amounts;

  const CostCenterComparisonRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    this.accountNameAr,
    required this.accountType,
    required this.amounts,
  });

  String get displayName => accountNameAr ?? accountName;

  double amountFor(int? costCenterId) => amounts[costCenterId] ?? 0;
  double get total => amounts.values.fold(0.0, (s, v) => s + v);
}

/// مقارنة أرصدة الحسابات بين مراكز بُعد (الحسابات صفوف والمراكز أعمدة).
@immutable
class CostCenterComparisonReport {
  final int dimensionId;
  final String dimensionCode;
  final String dimensionName;
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<CostCenterComparisonColumn> columns;
  final List<CostCenterComparisonRow> rows;

  const CostCenterComparisonReport({
    required this.dimensionId,
    required this.dimensionCode,
    required this.dimensionName,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.columns,
    required this.rows,
  });

  List<CostCenterComparisonRow> get revenueRows =>
      rows.where((r) => r.accountType == AccountType.revenue).toList();
  List<CostCenterComparisonRow> get expenseRows =>
      rows.where((r) => r.accountType == AccountType.expense).toList();
}

// ─────────────────────────────────────────────────────────────
// كشف حساب مركز تكلفة - Cost Center Ledger
// ─────────────────────────────────────────────────────────────

@immutable
class CostCenterLedgerLine {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String description;
  final String? reference;
  final int accountId;
  final String accountCode;
  final String accountName;

  /// المركز الذي سُجلت عليه الحصة (قد يكون فرعياً عند تضمين الأبناء)
  final int costCenterId;
  final String costCenterCode;

  /// حصة المركز من البند
  final double debit;
  final double credit;

  /// الرصيد التراكمي (موجب = مدين، سالب = دائن)
  final double runningBalance;

  const CostCenterLedgerLine({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.description,
    this.reference,
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.costCenterId,
    required this.costCenterCode,
    required this.debit,
    required this.credit,
    required this.runningBalance,
  });
}

/// كل الحركات المسجلة على مركز تكلفة (اختيارياً لحساب واحد).
@immutable
class CostCenterLedgerReport {
  final int costCenterId;
  final String costCenterCode;
  final String costCenterName;
  final String? costCenterNameAr;
  final bool includesChildren;

  /// الحساب المفلتر (null = كل الحسابات)
  final int? accountId;
  final DateTime? from;
  final DateTime to;
  final DateTime generatedAt;

  /// الرصيد الافتتاحي قبل [from] (موجب = مدين)
  final double openingBalance;
  final List<CostCenterLedgerLine> lines;

  const CostCenterLedgerReport({
    required this.costCenterId,
    required this.costCenterCode,
    required this.costCenterName,
    this.costCenterNameAr,
    required this.includesChildren,
    this.accountId,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.openingBalance,
    required this.lines,
  });

  String get displayName => costCenterNameAr ?? costCenterName;

  double get totalDebits => lines.fold(0.0, (s, l) => s + l.debit);
  double get totalCredits => lines.fold(0.0, (s, l) => s + l.credit);

  double get closingBalance =>
      lines.isEmpty ? openingBalance : lines.last.runningBalance;
}

// ─────────────────────────────────────────────────────────────
// مصفوفة بُعدين - Two-dimension Matrix
// ─────────────────────────────────────────────────────────────

@immutable
class CostCenterMatrixCell {
  final double revenue;
  final double expenses;

  const CostCenterMatrixCell({this.revenue = 0, this.expenses = 0});

  double get netIncome => revenue - expenses;

  CostCenterMatrixCell operator +(CostCenterMatrixCell other) =>
      CostCenterMatrixCell(
        revenue: revenue + other.revenue,
        expenses: expenses + other.expenses,
      );
}

/// تحليل متقاطع بين بُعدين (مثل: الفروع × المشاريع).
/// الصفوف مراكز البعد الأول والأعمدة مراكز الثاني، مع صف/عمود "غير موزّع".
@immutable
class CostCenterMatrixReport {
  final int rowDimensionId;
  final int columnDimensionId;
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<CostCenterHeader> rowHeaders;
  final List<CostCenterHeader> columnHeaders;
  final Map<(int?, int?), CostCenterMatrixCell> cells;

  const CostCenterMatrixReport({
    required this.rowDimensionId,
    required this.columnDimensionId,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.rowHeaders,
    required this.columnHeaders,
    required this.cells,
  });

  CostCenterMatrixCell cell(int? rowCostCenterId, int? columnCostCenterId) =>
      cells[(rowCostCenterId, columnCostCenterId)] ??
      const CostCenterMatrixCell();

  CostCenterMatrixCell rowTotal(int? rowCostCenterId) => columnHeaders.fold(
      const CostCenterMatrixCell(),
      (s, c) => s + cell(rowCostCenterId, c.costCenterId));

  CostCenterMatrixCell columnTotal(int? columnCostCenterId) => rowHeaders.fold(
      const CostCenterMatrixCell(),
      (s, r) => s + cell(r.costCenterId, columnCostCenterId));

  CostCenterMatrixCell get grandTotal =>
      cells.values.fold(const CostCenterMatrixCell(), (s, c) => s + c);
}

// ─────────────────────────────────────────────────────────────
// البنود غير الموزعة - Unallocated Lines
// ─────────────────────────────────────────────────────────────

@immutable
class UnallocatedLine {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String description;
  final String? reference;
  final int accountId;
  final String accountCode;
  final String accountName;
  final AccountType accountType;
  final double debit;
  final double credit;

  /// المبلغ الموزَّع على مراكز البعد
  final double allocatedAmount;

  const UnallocatedLine({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.description,
    this.reference,
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    required this.debit,
    required this.credit,
    required this.allocatedAmount,
  });

  double get lineAmount => debit > 0 ? debit : credit;
  double get unallocatedAmount => lineAmount - allocatedAmount;
}

/// البنود التي لم تُوزَّع (كلياً أو جزئياً) على مراكز بُعد - لضبط جودة البيانات.
@immutable
class UnallocatedLinesReport {
  final int dimensionId;
  final String dimensionCode;
  final String dimensionName;
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<UnallocatedLine> lines;

  const UnallocatedLinesReport({
    required this.dimensionId,
    required this.dimensionCode,
    required this.dimensionName,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.lines,
  });

  double get totalUnallocated =>
      lines.fold(0.0, (s, l) => s + l.unallocatedAmount);
}
