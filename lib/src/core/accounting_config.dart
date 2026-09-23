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

  const AccountingConfig({
    this.requireOpenPeriod = true,
    this.serialPrefix = 'JV',
    this.serialPadding = 4,
  });

  AccountingConfig copyWith({
    bool? requireOpenPeriod,
    String? serialPrefix,
    int? serialPadding,
  }) =>
      AccountingConfig(
        requireOpenPeriod: requireOpenPeriod ?? this.requireOpenPeriod,
        serialPrefix:      serialPrefix      ?? this.serialPrefix,
        serialPadding:     serialPadding     ?? this.serialPadding,
      );
}
