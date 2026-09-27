/// cost_allocation_calculator.dart
/// حسابات توزيع المبالغ على مراكز التكلفة (منطق نقي بدون قاعدة بيانات)
library;

import '../models/cost_allocation_model.dart';
import 'accounting_validator.dart';
import 'exceptions.dart';

class CostAllocationCalculator {
  CostAllocationCalculator._();

  /// تقريب إلى [fractionDigits] منزلة عشرية
  static double round(double value, [int fractionDigits = 2]) {
    final factor = _pow10(fractionDigits);
    return (value * factor).roundToDouble() / factor;
  }

  /// يوزّع [amount] حسب [weights] النسبية مع تقريب كل حصة إلى
  /// [fractionDigits] منزلة، ويحمّل فرق التقريب على آخر حصة كي يساوي
  /// المجموع [amount] تماماً.
  ///
  /// ```dart
  /// splitByWeights(100, [1, 1, 1]); // [33.33, 33.33, 33.34]
  /// ```
  static List<double> splitByWeights(
    double amount,
    List<double> weights, {
    int fractionDigits = 2,
  }) {
    if (weights.isEmpty) {
      throw const InvalidAllocationKeyException('لا توجد أوزان للتوزيع.');
    }
    if (weights.any((w) => w < 0)) {
      throw const InvalidAllocationKeyException(
          'أوزان التوزيع لا يمكن أن تكون سالبة.');
    }
    final total = weights.fold(0.0, (s, w) => s + w);
    if (total <= 0) {
      throw const InvalidAllocationKeyException(
          'مجموع أوزان التوزيع يجب أن يكون أكبر من صفر.');
    }

    final shares = <double>[];
    var allocated = 0.0;
    for (var i = 0; i < weights.length; i++) {
      final share = i == weights.length - 1
          ? round(amount - allocated, fractionDigits + 4)
          : round(amount * weights[i] / total, fractionDigits);
      shares.add(share);
      allocated += share;
    }
    return shares;
  }

  /// يحسب مبلغ كل حصة لبند مبلغه [lineAmount] ويتحقق من صحة التوزيع
  /// داخل بُعد واحد:
  ///
  /// - الحصة بالمبلغ تبقى كما هي، والحصة بالنسبة تُحوَّل لمبلغ مقرّب،
  ///   ومن دون مبلغ أو نسبة تعني 100%.
  /// - إن كانت الحصص كلها بالنسب ومجموعها 100% يُحمَّل فرق التقريب على
  ///   آخر حصة.
  /// - كل حصة يجب أن تكون موجبة، ومجموع الحصص يساوي [lineAmount].
  ///
  /// تُعيد الحصص مع `amount` و`percentage` محسوبين.
  static List<CostAllocationModel> resolveDimension(
    double lineAmount,
    List<CostAllocationModel> allocations, {
    int fractionDigits = 2,
    String dimensionLabel = '',
  }) {
    if (allocations.isEmpty) return const [];

    for (final a in allocations) {
      if ((a.amount != null && a.amount! <= 0) ||
          (a.percentage != null && a.percentage! <= 0)) {
        throw InvalidCostAllocationException(
            'حصة المركز "${a.displayName}" يجب أن تكون أكبر من صفر.');
      }
    }

    final amounts = [
      for (final a in allocations)
        a.amount ??
            round(lineAmount * (a.percentage ?? 100) / 100, fractionDigits),
    ];

    // تصحيح فرق التقريب عندما تكون كل الحصص نسباً مجموعها 100%
    final allPercent = allocations.every((a) => a.amount == null);
    final percentTotal =
        allocations.fold(0.0, (s, a) => s + (a.percentage ?? 100));
    if (allPercent && (percentTotal - 100).abs() < 1e-6) {
      final others =
          amounts.take(amounts.length - 1).fold(0.0, (s, v) => s + v);
      amounts[amounts.length - 1] =
          round(lineAmount - others, fractionDigits + 4);
    }

    final total = amounts.fold(0.0, (s, v) => s + v);
    if (!AccountingValidator.isBalanced(total, lineAmount)) {
      final label = dimensionLabel.isEmpty ? '' : ' للبعد "$dimensionLabel"';
      throw InvalidCostAllocationException(
          'مجموع توزيع البند$label ($total) لا يساوي مبلغ البند ($lineAmount).');
    }
    if (amounts.any((v) => v <= 0)) {
      throw const InvalidCostAllocationException(
          'كل حصة في التوزيع يجب أن تكون أكبر من صفر.');
    }

    return [
      for (var i = 0; i < allocations.length; i++)
        allocations[i].copyWith(
          amount: amounts[i],
          percentage: round(amounts[i] / lineAmount * 100, 6),
        ),
    ];
  }

  static double _pow10(int n) {
    var r = 1.0;
    for (var i = 0; i < n; i++) {
      r *= 10;
    }
    return r;
  }
}
