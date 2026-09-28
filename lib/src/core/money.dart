/// money.dart
/// تقريب المبالغ حسب منازل العملة
library;

/// أدوات تقريب المبالغ.
///
/// المبالغ تُخزَّن كأرقام عشرية (`double`) مع تقريب صارم لمنازل كل عملة عند
/// كل تحويل، وهو نفس أسلوب أنظمة مثل Odoo وERPNext.
class Money {
  Money._();

  /// تقريب [value] إلى [decimals] منزلة (نصف لأعلى بعيداً عن الصفر)
  static double round(double value, [int decimals = 2]) {
    var factor = 1.0;
    for (var i = 0; i < decimals; i++) {
      factor *= 10;
    }
    // تصحيح بسيط لأخطاء التمثيل الثنائي (مثل 1.005 → 1.00499999)
    final shifted = value * factor;
    final nudged = shifted + (shifted >= 0 ? 1e-9 : -1e-9);
    return nudged.roundToDouble() / factor;
  }

  /// هل المبلغان متساويان ضمن نصف أصغر وحدة للعملة؟
  static bool equals(double a, double b, [int decimals = 2]) {
    var unit = 1.0;
    for (var i = 0; i < decimals; i++) {
      unit /= 10;
    }
    return (a - b).abs() < unit / 2;
  }
}
