/// cost_allocation_run_model.dart
/// طلب ومعاينة توزيع تكاليف مركز على مراكز أخرى (توزيع دوري)
library;

import 'package:meta/meta.dart';

import 'cost_allocation_model.dart';

/// طلب توزيع أرصدة مركز تكلفة (عادةً مركز خدمي مثل "الإدارة العامة")
/// على مراكز أخرى حسب مفتاح توزيع، لفترة معينة.
///
/// ينتج قيد "توزيع تكاليف" لكل حساب له رصيد على المركز المصدر:
/// دائن للحساب على المركز المصدر، ومدين لنفس الحساب موزَّعاً على مراكز
/// المفتاح. أرصدة الحسابات لا تتغير؛ يتغير فقط توزيعها بين المراكز.
@immutable
class CostAllocationRequest {
  /// المركز المصدر (مركز فرعي Leaf)
  final int sourceCostCenterId;

  /// مفتاح التوزيع (يجب أن يكون من نفس بُعد المركز المصدر)
  final int allocationKeyId;

  /// الفترة التي تُحتسب أرصدتها
  final DateTime from;
  final DateTime to;

  /// تاريخ قيد التوزيع (الافتراضي: [to])
  final DateTime? date;

  /// الحسابات المشمولة (الافتراضي: كل حسابات المصروفات)
  final List<int>? accountIds;

  final String? description;
  final String? reference;

  const CostAllocationRequest({
    required this.sourceCostCenterId,
    required this.allocationKeyId,
    required this.from,
    required this.to,
    this.date,
    this.accountIds,
    this.description,
    this.reference,
  });
}

/// حساب واحد في معاينة التوزيع
@immutable
class CostAllocationPreviewLine {
  final int accountId;
  final String accountCode;
  final String accountName;

  /// رصيد الحساب على المركز المصدر (موجب = مدين)
  final double amount;

  /// حصص المراكز المستهدفة (مجموعها = |amount|)
  final List<CostAllocationModel> shares;

  const CostAllocationPreviewLine({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.amount,
    required this.shares,
  });
}

/// معاينة التوزيع قبل تنفيذه
@immutable
class CostAllocationPreview {
  final CostAllocationRequest request;
  final String sourceCostCenterCode;
  final String sourceCostCenterName;
  final String allocationKeyCode;
  final List<CostAllocationPreviewLine> lines;

  const CostAllocationPreview({
    required this.request,
    required this.sourceCostCenterCode,
    required this.sourceCostCenterName,
    required this.allocationKeyCode,
    required this.lines,
  });

  bool get isEmpty => lines.isEmpty;

  /// إجمالي المبلغ الموزَّع
  double get totalAmount => lines.fold(0.0, (s, l) => s + l.amount.abs());

  /// إجمالي حصة كل مركز مستهدف
  Map<int, double> get totalsByCostCenter {
    final totals = <int, double>{};
    for (final line in lines) {
      for (final share in line.shares) {
        totals.update(share.costCenterId!, (v) => v + share.amount!,
            ifAbsent: () => share.amount!);
      }
    }
    return totals;
  }
}
