/// cost_allocation_model.dart
/// توزيع مبلغ بند القيد على مركز تكلفة
library;

import 'package:meta/meta.dart';

/// حصة مركز تكلفة من مبلغ بند قيد.
///
/// يمكن تحديد الحصة بالمبلغ [amount] أو بالنسبة [percentage] (من 100)،
/// وإن لم يُحدَّد أي منهما فالمركز يأخذ كامل مبلغ البند.
/// ويمكن الإشارة للمركز بالمعرّف [costCenterId] أو بالرمز [costCenterCode].
///
/// ```dart
/// JournalEntryBuilder(description: 'إيجار مشترك')
///   .debitCode('53', 10000, allocations: [
///     CostAllocationModel.percent('BR-RYD', 60),
///     CostAllocationModel.percent('BR-JED', 40),
///     CostAllocationModel.code('DEP-ADMIN'), // 100% من بُعد القسم
///   ])
///   .creditCode('111', 10000);
/// ```
///
/// عند الحفظ: مجموع حصص كل بُعد يجب أن يساوي مبلغ البند، وتُحسب المبالغ
/// من النسب مع تحميل فرق التقريب على آخر حصة.
@immutable
class CostAllocationModel {
  final int? id;
  final int? lineId;
  final int? costCenterId;

  /// رمز المركز (بديل مريح عن المعرّف، ويُملأ عند الجلب من قاعدة البيانات)
  final String? costCenterCode;

  /// اسم المركز للعرض - يُملأ عند الجلب من قاعدة البيانات
  final String costCenterName;

  /// البعد الذي ينتمي إليه المركز - يُملأ عند الحفظ أو الجلب
  final int? dimensionId;

  /// المبلغ المخصّص للمركز (دائماً موجب، وجهته مدين/دائن تتبع البند)
  final double? amount;

  /// النسبة من مبلغ البند (0-100)
  final double? percentage;

  const CostAllocationModel({
    this.id,
    this.lineId,
    this.costCenterId,
    this.costCenterCode,
    this.costCenterName = '',
    this.dimensionId,
    this.amount,
    this.percentage,
  }) : assert(costCenterId != null || costCenterCode != null,
            'يجب تحديد المركز بالمعرّف أو بالرمز');

  /// كامل مبلغ البند لمركز (بالمعرّف أو بالرمز)
  factory CostAllocationModel.full(Object costCenter) =>
      CostAllocationModel.percent(costCenter, 100);

  /// نسبة من مبلغ البند لمركز (بالمعرّف `int` أو بالرمز `String`)
  factory CostAllocationModel.percent(Object costCenter, double percentage) =>
      CostAllocationModel(
        costCenterId: costCenter is int ? costCenter : null,
        costCenterCode: costCenter is int ? null : costCenter.toString(),
        percentage: percentage,
      );

  /// مبلغ محدد لمركز (بالمعرّف `int` أو بالرمز `String`)
  factory CostAllocationModel.amount(Object costCenter, double amount) =>
      CostAllocationModel(
        costCenterId: costCenter is int ? costCenter : null,
        costCenterCode: costCenter is int ? null : costCenter.toString(),
        amount: amount,
      );

  /// مركز بالرمز، بمبلغ أو نسبة اختيارية (الافتراضي: كامل مبلغ البند)
  factory CostAllocationModel.code(String costCenterCode,
          {double? amount, double? percentage}) =>
      CostAllocationModel(
        costCenterCode: costCenterCode,
        amount: amount,
        percentage: percentage,
      );

  /// الاسم أو الرمز المعروض
  String get displayName => costCenterName.isNotEmpty
      ? costCenterName
      : (costCenterCode ?? '#$costCenterId');

  CostAllocationModel copyWith({
    int? id,
    int? lineId,
    int? costCenterId,
    String? costCenterCode,
    String? costCenterName,
    int? dimensionId,
    double? amount,
    double? percentage,
  }) {
    return CostAllocationModel(
      id: id ?? this.id,
      lineId: lineId ?? this.lineId,
      costCenterId: costCenterId ?? this.costCenterId,
      costCenterCode: costCenterCode ?? this.costCenterCode,
      costCenterName: costCenterName ?? this.costCenterName,
      dimensionId: dimensionId ?? this.dimensionId,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'lineId': lineId,
        'costCenterId': costCenterId,
        'costCenterCode': costCenterCode,
        'costCenterName': costCenterName,
        'dimensionId': dimensionId,
        'amount': amount,
        'percentage': percentage,
      };

  factory CostAllocationModel.fromMap(Map<String, dynamic> map) =>
      CostAllocationModel(
        id: map['id'] as int?,
        lineId: map['lineId'] as int?,
        costCenterId: map['costCenterId'] as int?,
        costCenterCode: map['costCenterCode'] as String?,
        costCenterName: (map['costCenterName'] as String?) ?? '',
        dimensionId: map['dimensionId'] as int?,
        amount: (map['amount'] as num?)?.toDouble(),
        percentage: (map['percentage'] as num?)?.toDouble(),
      );

  @override
  String toString() =>
      'CostAllocation(center: ${costCenterCode ?? costCenterId}, '
      'amount: $amount, percentage: $percentage)';
}
