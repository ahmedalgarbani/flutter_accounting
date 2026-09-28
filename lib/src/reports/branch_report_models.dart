/// branch_report_models.dart
/// نماذج تقارير الفروع
library;

import 'package:meta/meta.dart';
import '../core/enums.dart';

/// ترويسة فرع في التقارير. [branchId] = null يعني "بدون فرع".
@immutable
class BranchHeader {
  final int? branchId;
  final String code;
  final String name;
  final String? nameAr;

  const BranchHeader({
    required this.branchId,
    required this.code,
    required this.name,
    this.nameAr,
  });

  const BranchHeader.unassigned()
      : branchId = null,
        code = '',
        name = 'No branch',
        nameAr = 'بدون فرع';

  bool get isUnassigned => branchId == null;
  String get displayName => nameAr ?? name;
}

/// ملخص فرع: قائمة دخل الفترة ومركز مالي في نهايتها
@immutable
class BranchSummary {
  final BranchHeader branch;
  final double revenue;
  final double expenses;
  final double totalAssets;
  final double totalLiabilities;

  /// حقوق الملكية شاملة الأرباح المدورة للفرع
  final double totalEquity;

  const BranchSummary({
    required this.branch,
    required this.revenue,
    required this.expenses,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.totalEquity,
  });

  double get netIncome => revenue - expenses;

  /// أصول الفرع = خصومه + حقوق ملكيته
  bool get isBalanced =>
      (totalAssets - (totalLiabilities + totalEquity)).abs() < 0.01;
}

/// سطر حساب في مقارنة الفروع: رصيده (بالاتجاه الطبيعي) في كل فرع
@immutable
class BranchComparisonRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final AccountType accountType;
  final Map<int?, double> amounts;

  const BranchComparisonRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    this.accountNameAr,
    required this.accountType,
    required this.amounts,
  });

  String get displayName => accountNameAr ?? accountName;
  double amountFor(int? branchId) => amounts[branchId] ?? 0;
  double get total => amounts.values.fold(0.0, (s, v) => s + v);
}

/// مقارنة الفروع: ملخص لكل فرع + الإيرادات والمصروفات حسب الحساب
@immutable
class BranchComparisonReport {
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<BranchSummary> branches;
  final List<BranchComparisonRow> rows;

  const BranchComparisonReport({
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.branches,
    required this.rows,
  });

  double get totalNetIncome => branches.fold(0.0, (s, b) => s + b.netIncome);
}

/// مطابقة الحساب الجاري بين فرعين
@immutable
class InterBranchPair {
  final BranchHeader branchA;
  final BranchHeader branchB;

  /// رصيد حساب جاري الفرع B في دفاتر A (موجب = مدين: A يطلب B)
  final double balanceInA;

  /// رصيد حساب جاري الفرع A في دفاتر B (موجب = مدين: B يطلب A)
  final double balanceInB;

  const InterBranchPair({
    required this.branchA,
    required this.branchB,
    required this.balanceInA,
    required this.balanceInB,
  });

  /// يجب أن يساوي صفراً: ما يطلبه A من B = ما على B لـ A
  double get difference => balanceInA + balanceInB;
  bool get isReconciled => difference.abs() < 0.01;
}

@immutable
class InterBranchReconciliationReport {
  final DateTime asOf;
  final DateTime generatedAt;
  final List<InterBranchPair> pairs;

  const InterBranchReconciliationReport({
    required this.asOf,
    required this.generatedAt,
    required this.pairs,
  });

  bool get isReconciled => pairs.every((p) => p.isReconciled);
}
