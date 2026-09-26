/// accounting_setup.dart
/// تهيئة المحاسبة مرة واحدة عند بدء التطبيق.
///
/// هذا هو المكان الوحيد الذي يعرف فيه تطبيقك "رموز الحسابات" التي يستخدمها.
library;

import 'package:flutter_accounting/flutter_accounting.dart';

/// رموز الحسابات التي يستخدمها التطبيق (من دليل الحسابات الافتراضي).
/// ضعها في مكان واحد كي لا تنتشر الأرقام السحرية في الكود.
abstract final class AppAccounts {
  static const cash = '111'; // الصندوق
  static const bank = '112'; // البنك
  static const customers = '113'; // العملاء (مدينون)
  static const inventory = '115'; // المخزون
  static const suppliers = '211'; // الموردون (دائنون)
  static const vatPayable = '215'; // الضريبة المستحقة
  static const capital = '31'; // رأس المال
  static const sales = '41'; // المبيعات
  static const costOfGoodsSold = '51'; // تكلفة البضاعة المباعة
  static const rent = '53'; // الإيجار
}

Future<FlutterAccounting> setupAccounting() async {
  final fa = await FlutterAccounting.initialize(
    databaseName: 'example_accounting.db',
    // يزرع دليل الحسابات الافتراضي (40+ حساب) عند أول تشغيل فقط
    seedDefaultAccounts: true,
  );

  // تأكد من وجود سنة مالية مفتوحة للتاريخ الحالي (تُنشأ تلقائياً عند الحاجة)
  await fa.periods.ensureOpenPeriodFor(DateTime.now());

  // مثال: حساب إضافي خاص بتطبيقك - لا يُكرَّر مهما أعدت التشغيل
  await fa.accounts.ensureAccount(
    code: '1121',
    name: 'Wallet',
    nameAr: 'المحفظة الإلكترونية',
    type: AccountType.asset,
    parentCode: '11', // الأصول المتداولة
  );

  return fa;
}
