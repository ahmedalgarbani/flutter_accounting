/// accounting_config.dart
/// إعدادات سلوك المكتبة
library;

import 'package:meta/meta.dart';

@immutable
class AccountingConfig {
  /// هل يجب أن يقع تاريخ كل قيد داخل فترة محاسبية مفتوحة؟
  ///
  /// - `true` (الافتراضي): يُرفض القيد إذا لم توجد فترة تغطي تاريخه
  ///   ([DateOutsidePeriodException]) أو كانت مغلقة ([PeriodClosedException]).
  /// - `false`: لا يُشترط وجود فترة، لكن الفترات المغلقة تبقى محمية.
  ///   مناسب للأنظمة البسيطة التي لا تحتاج إدارة فترات.
  final bool requireOpenPeriod;

  /// بادئة الرقم التسلسلي للقيود (الافتراضي `JV` → `JV-2026-0001`)
  final String serialPrefix;

  /// عدد خانات الجزء الرقمي من الرقم التسلسلي (الافتراضي 4 → `0001`)
  final int serialPadding;

  /// تفعيل مراكز التكلفة (الأبعاد التحليلية: فرع، مشروع، قسم...).
  ///
  /// - `false` (الافتراضي): الميزة موقوفة؛ لا يمكن إنشاء أبعاد أو مراكز
  ///   أو توزيع البنود عليها ([CostCentersDisabledException])، ولا تُطبَّق
  ///   سياساتها. القراءة والتقارير تبقى متاحة للبيانات السابقة.
  /// - `true`: يمكن ربط بنود القيود بمراكز التكلفة وتوزيعها. كل شيء اختياري
  ///   إلا ما تجعله إلزامياً بنفسك عبر سياسات الأبعاد.
  final bool enableCostCenters;

  /// عدد المنازل العشرية لتقريب الحصص عند التوزيع بالنسب أو بمفاتيح التوزيع
  /// (الافتراضي 2؛ استخدم 3 لعملات مثل الدينار الكويتي). فرق التقريب يُحمَّل
  /// دائماً على آخر حصة كي يطابق المجموع مبلغ البند.
  final int allocationDecimals;

  const AccountingConfig({
    this.requireOpenPeriod = true,
    this.serialPrefix = 'JV',
    this.serialPadding = 4,
    this.enableCostCenters = false,
    this.allocationDecimals = 2,
  });

  AccountingConfig copyWith({
    bool? requireOpenPeriod,
    String? serialPrefix,
    int? serialPadding,
    bool? enableCostCenters,
    int? allocationDecimals,
  }) =>
      AccountingConfig(
        requireOpenPeriod: requireOpenPeriod ?? this.requireOpenPeriod,
        serialPrefix: serialPrefix ?? this.serialPrefix,
        serialPadding: serialPadding ?? this.serialPadding,
        enableCostCenters: enableCostCenters ?? this.enableCostCenters,
        allocationDecimals: allocationDecimals ?? this.allocationDecimals,
      );
}
