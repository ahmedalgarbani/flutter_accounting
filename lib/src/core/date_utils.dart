/// date_utils.dart
/// مساعدات داخلية للتعامل مع حدود الأيام في التقارير والفترات
library;

/// بداية اليوم (00:00:00)
DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// بداية اليوم التالي - تُستخدم كحد أعلى غير شامل
DateTime startOfNextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

/// نهاية اليوم (23:59:59) - دقة الثواني تطابق طريقة تخزين Drift للتواريخ
DateTime endOfDay(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59);
