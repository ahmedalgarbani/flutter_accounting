/// currency_operation_model.dart
/// طلبات عمليات فروقات العملة: إعادة التقييم والتسوية
library;

import 'package:meta/meta.dart';

import 'journal_entry_model.dart';

/// طلب إعادة تقييم أرصدة العملات الأجنبية في تاريخ (عادةً نهاية الفترة).
///
/// لكل (حساب، عملة) له رصيد بعملة أجنبية: يُحسب رصيده بعملة الأساس بسعر
/// [asOf]، ويُسجَّل الفرق عن رصيده الدفتري كربح أو خسارة فروقات عملة.
/// الحساب الذي صار رصيده بالعملة صفراً يُسوّى فرقه كفرق **محقق**.
@immutable
class RevaluationRequest {
  /// تاريخ التقييم وسعر الصرف
  final DateTime asOf;

  /// الحسابات المشمولة (الافتراضي: كل حسابات الأصول والخصوم التي لها
  /// حركات بعملات أجنبية)
  final List<int>? accountIds;

  /// أسعار تتجاوز الأسعار المسجلة (رمز العملة ← السعر)
  final Map<String, double> rates;

  /// تاريخ عكس القيد تلقائياً (عادةً أول يوم في الفترة التالية). `null` = لا عكس
  final DateTime? autoReverseOn;

  final String? description;

  const RevaluationRequest({
    required this.asOf,
    this.accountIds,
    this.rates = const {},
    this.autoReverseOn,
    this.description,
  });
}

/// طلب تسوية مبلغ بعملة أجنبية على حساب (تحصيل من عميل أو سداد لمورد)
/// مع احتساب فرق العملة **المحقق** تلقائياً.
///
/// مثال: فاتورة 1000 USD سُجلت بسعر 3.75 (3750)، وحُصّلت بسعر 3.70 (3700):
/// يُقيَّد 50 خسارة فروقات عملة.
@immutable
class SettlementRequest {
  /// الحساب المُسوّى (عميل أو مورد)
  final int accountId;

  /// عملة التسوية (الافتراضي: عملة الحساب)
  final String? currencyCode;

  /// المبلغ المُسوّى بالعملة الأجنبية
  final double amount;

  /// الحساب المقابل (بنك أو صندوق). إن كان بنفس العملة يُسجل بها، وإلا
  /// بعملة الأساس.
  final int counterAccountId;

  /// سعر التسوية (الافتراضي: السعر المسجل في [date])
  final double? rate;

  /// السعر الدفتري المُسوّى به (الافتراضي: متوسط سعر رصيد الحساب بالعملة
  /// = رصيده بعملة الأساس ÷ رصيده بالعملة، في [date])
  final double? bookRate;

  final DateTime date;
  final String? description;
  final String? reference;
  final String? sourceType;
  final String? sourceId;

  const SettlementRequest({
    required this.accountId,
    required this.amount,
    required this.counterAccountId,
    required this.date,
    this.currencyCode,
    this.rate,
    this.bookRate,
    this.description,
    this.reference,
    this.sourceType,
    this.sourceId,
  });
}

/// نتيجة إعادة التقييم.
///
/// الفروقات المحققة (حسابات صار رصيدها بالعملة صفراً) تُسجل في قيد مستقل
/// لا يُعكس، والفروقات غير المحققة في قيد يُعكس تلقائياً إن طُلب ذلك.
@immutable
class RevaluationResult {
  /// قيد الفروقات المحققة (إن وُجدت)
  final JournalEntryModel? realizedEntry;

  /// قيد إعادة التقييم غير المحققة (إن وُجدت)
  final JournalEntryModel? unrealizedEntry;

  /// قيد العكس التلقائي لقيد إعادة التقييم (إن طُلب)
  final JournalEntryModel? reversalEntry;

  const RevaluationResult({
    this.realizedEntry,
    this.unrealizedEntry,
    this.reversalEntry,
  });

  List<JournalEntryModel> get entries => [
        if (realizedEntry != null) realizedEntry!,
        if (unrealizedEntry != null) unrealizedEntry!,
        if (reversalEntry != null) reversalEntry!,
      ];
}
