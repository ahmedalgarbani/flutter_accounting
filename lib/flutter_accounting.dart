/// flutter_accounting.dart
/// الـ Public API للمكتبة - هذا الملف الوحيد الذي يستورده المستخدم
///
/// ```dart
/// import 'package:flutter_accounting/flutter_accounting.dart';
/// ```

library;

// ── نقطة الدخول الرئيسية ──
export 'src/flutter_accounting_init.dart';

// ── النماذج ──
export 'src/models/account_model.dart';
export 'src/models/journal_entry_model.dart';
export 'src/models/journal_entry_line_model.dart';
export 'src/models/accounting_period_model.dart';
export 'src/models/entry_template_model.dart';

// ── التعدادات ──
export 'src/core/enums.dart';

// ── الاستثناءات ──
export 'src/core/exceptions.dart';

// ── المحرك المحاسبي ──
export 'src/core/accounting_validator.dart';
export 'src/core/accounting_config.dart';
export 'src/core/journal_entry_builder.dart';

// ── الواجهات (للـ DI والاختبار) ──
export 'src/repositories/interfaces/interfaces.dart';

// ── نماذج التقارير ──
export 'src/reports/report_models.dart';

// ── القوالب القياسية ودليل الحسابات الافتراضي ──
export 'src/core/standard_templates.dart';
export 'src/seed/accounting_seed_data.dart';
