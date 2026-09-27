/// currency_report_models.dart
/// نماذج تقارير العملات وفروقاتها
library;

import 'package:meta/meta.dart';
import '../core/enums.dart';

/// رصيد حساب بعملة: بالعملة نفسها وبعملة الأساس (موجب = مدين)
@immutable
class CurrencyBalance {
  final String currencyCode;
  final double foreignBalance;
  final double baseBalance;

  const CurrencyBalance({
    required this.currencyCode,
    required this.foreignBalance,
    required this.baseBalance,
  });

  /// متوسط السعر الدفتري (رصيد الأساس ÷ رصيد العملة)
  double? get averageRate =>
      foreignBalance == 0 ? null : baseBalance / foreignBalance;
}

// ─────────────────────────────────────────────────────────────
// كشف حساب بالعملة
// ─────────────────────────────────────────────────────────────

@immutable
class CurrencyLedgerLine {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String description;
  final String? reference;

  /// عملة البند (null = عملة الأساس)
  final String? currencyCode;

  /// المبلغ بعملة البند (موجب = مدين)
  final double foreignAmount;
  final double? exchangeRate;

  /// المبلغ بعملة الأساس
  final double debit;
  final double credit;

  final double runningForeign;
  final double runningBase;

  const CurrencyLedgerLine({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.description,
    this.reference,
    required this.currencyCode,
    required this.foreignAmount,
    required this.exchangeRate,
    required this.debit,
    required this.credit,
    required this.runningForeign,
    required this.runningBase,
  });
}

/// كشف حساب بعملته وبعملة الأساس معاً (الأرصدة موجب = مدين)
@immutable
class CurrencyLedgerReport {
  final int accountId;
  final String accountCode;
  final String accountName;
  final String currencyCode;
  final DateTime? from;
  final DateTime to;
  final DateTime generatedAt;
  final double openingForeign;
  final double openingBase;
  final List<CurrencyLedgerLine> lines;

  const CurrencyLedgerReport({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.currencyCode,
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.openingForeign,
    required this.openingBase,
    required this.lines,
  });

  double get closingForeign =>
      lines.isEmpty ? openingForeign : lines.last.runningForeign;
  double get closingBase =>
      lines.isEmpty ? openingBase : lines.last.runningBase;
}

// ─────────────────────────────────────────────────────────────
// أرصدة العملات الأجنبية وإعادة التقييم
// ─────────────────────────────────────────────────────────────

/// رصيد (حساب، عملة) مع تقييمه بالسعر الحالي
@immutable
class ForeignCurrencyBalanceRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final AccountType accountType;
  final String currencyCode;

  /// الرصيد بالعملة (موجب = مدين)
  final double foreignBalance;

  /// الرصيد الدفتري بعملة الأساس
  final double bookBalance;

  /// سعر التقييم
  final double rate;

  /// الرصيد بعملة الأساس بسعر التقييم
  final double revaluedBalance;

  const ForeignCurrencyBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    required this.currencyCode,
    required this.foreignBalance,
    required this.bookBalance,
    required this.rate,
    required this.revaluedBalance,
  });

  /// الفرق (موجب = زيادة في الرصيد المدين: ربح للأصول، خسارة للخصوم)
  double get difference => revaluedBalance - bookBalance;

  /// هل رصيد العملة صفر (الفرق كله محقق)؟
  bool get isSettled => foreignBalance.abs() < 1e-9;
}

@immutable
class ForeignCurrencyBalancesReport {
  final DateTime asOf;
  final String baseCurrency;
  final DateTime generatedAt;
  final List<ForeignCurrencyBalanceRow> rows;

  const ForeignCurrencyBalancesReport({
    required this.asOf,
    required this.baseCurrency,
    required this.generatedAt,
    required this.rows,
  });

  /// صافي الفرق (موجب = ربح)
  double get totalDifference => rows.fold(0.0, (s, r) => s + r.difference);

  /// إجمالي كل عملة (الرصيد بالعملة)
  Map<String, double> get totalsByCurrency {
    final totals = <String, double>{};
    for (final r in rows) {
      totals.update(r.currencyCode, (v) => v + r.foreignBalance,
          ifAbsent: () => r.foreignBalance);
    }
    return totals;
  }
}

/// معاينة إعادة التقييم (الصفوف ذات الفرق فقط)
@immutable
class RevaluationPreview {
  final DateTime asOf;
  final List<ForeignCurrencyBalanceRow> rows;

  const RevaluationPreview({required this.asOf, required this.rows});

  bool get isEmpty => rows.isEmpty;

  /// صافي الفرق (موجب = ربح)
  double get netDifference => rows.fold(0.0, (s, r) => s + r.difference);
}
