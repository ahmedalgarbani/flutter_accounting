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

  /// تعدد العملات (اختياري). `null` (الافتراضي) = موقوف وكل المبالغ بعملة واحدة.
  /// مرّر [MultiCurrencyConfig] لتفعيله وتحديد عملة الأساس وحسابات الفروقات.
  final MultiCurrencyConfig? multiCurrency;

  const AccountingConfig({
    this.requireOpenPeriod = true,
    this.serialPrefix = 'JV',
    this.serialPadding = 4,
    this.enableCostCenters = false,
    this.allocationDecimals = 2,
    this.multiCurrency,
  });

  /// هل تعدد العملات مفعّل؟
  bool get isMultiCurrency => multiCurrency != null;

  AccountingConfig copyWith({
    bool? requireOpenPeriod,
    String? serialPrefix,
    int? serialPadding,
    bool? enableCostCenters,
    int? allocationDecimals,
    MultiCurrencyConfig? multiCurrency,
  }) =>
      AccountingConfig(
        requireOpenPeriod: requireOpenPeriod ?? this.requireOpenPeriod,
        serialPrefix: serialPrefix ?? this.serialPrefix,
        serialPadding: serialPadding ?? this.serialPadding,
        enableCostCenters: enableCostCenters ?? this.enableCostCenters,
        allocationDecimals: allocationDecimals ?? this.allocationDecimals,
        multiCurrency: multiCurrency ?? this.multiCurrency,
      );
}

/// إعدادات تعدد العملات.
///
/// ```dart
/// AccountingConfig(
///   multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR'),
/// )
/// ```
///
/// - كل القيود والتقارير المالية تبقى بعملة الأساس [baseCurrency]، والبند
///   بعملة أجنبية يحفظ أيضاً مبلغه الأصلي وسعر الصرف.
/// - عملة الأساس تُثبَّت في قاعدة البيانات عند أول تشغيل، ولا يمكن تغييرها
///   بعد تسجيل قيود.
@immutable
class MultiCurrencyConfig {
  /// رمز عملة الأساس (ISO 4217)، مثل `SAR`
  final String baseCurrency;

  /// حساب أرباح فروقات العملة المحققة (الافتراضي من الدليل الجاهز: `45`)
  final String realizedGainAccountCode;

  /// حساب خسائر فروقات العملة المحققة (الافتراضي من الدليل الجاهز: `50`)
  final String realizedLossAccountCode;

  /// حساب أرباح إعادة التقييم (غير المحققة). الافتراضي: حساب الأرباح المحققة
  final String? unrealizedGainAccountCode;

  /// حساب خسائر إعادة التقييم (غير المحققة). الافتراضي: حساب الخسائر المحققة
  final String? unrealizedLossAccountCode;

  /// حساب فروقات التقريب عند التحويل. الافتراضي: حساب الأرباح/الخسائر المحققة
  final String? roundingAccountCode;

  /// أقصى فرق تقريب (بعملة الأساس) يُسوّى تلقائياً في القيد متعدد العملات.
  /// أي فرق أكبر يُعتبر عدم توازن ([UnbalancedEntryException]).
  final double roundingTolerance;

  const MultiCurrencyConfig({
    required this.baseCurrency,
    this.realizedGainAccountCode = '45',
    this.realizedLossAccountCode = '50',
    this.unrealizedGainAccountCode,
    this.unrealizedLossAccountCode,
    this.roundingAccountCode,
    this.roundingTolerance = 0.05,
  });

  String get unrealizedGainCode =>
      unrealizedGainAccountCode ?? realizedGainAccountCode;
  String get unrealizedLossCode =>
      unrealizedLossAccountCode ?? realizedLossAccountCode;
}
