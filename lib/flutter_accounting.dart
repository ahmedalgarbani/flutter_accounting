/// flutter_accounting.dart
/// الـ Public API للمكتبة - هذا الملف الوحيد الذي يستورده المستخدم
///
/// ```dart
/// import 'package:flutter_accounting/flutter_accounting.dart';
/// ```

library flutter_accounting;

// ── نقطة الدخول الرئيسية ──
export 'src/flutter_accounting_init.dart';

// ── النماذج ──
export 'src/models/account_model.dart';
export 'src/models/journal_entry_model.dart';
export 'src/models/journal_entry_line_model.dart';

// ── التعدادات ──
export 'src/core/enums.dart';

// ── الاستثناءات ──
export 'src/core/exceptions.dart';

// ── المحرك المحاسبي ──
export 'src/core/accounting_validator.dart';

// ── الواجهات (للـ DI والاختبار) ──
export 'src/repositories/interfaces/interfaces.dart';

// ── نماذج التقارير ──
export 'src/reports/report_models.dart';
