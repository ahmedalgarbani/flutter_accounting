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

/// رموز مراكز التكلفة ومفاتيح التوزيع التي يستخدمها التطبيق.
abstract final class AppCostCenters {
  static const riyadh = 'BR-RYD'; // فرع الرياض
  static const jeddah = 'BR-JED'; // فرع جدة
  static const salesDept = 'DEP-SALES'; // قسم المبيعات
  static const adminDept = 'DEP-ADMIN'; // الإدارة
  static const byArea = 'AREA'; // مفتاح توزيع حسب مساحة الفروع
}

Future<FlutterAccounting> setupAccounting() async {
  final fa = await FlutterAccounting.initialize(
    databaseName: 'example_accounting.db',
    // مراكز التكلفة اختيارية: احذف هذا السطر إن لم تحتجها
    config: const AccountingConfig(enableCostCenters: true),
    // يزرع دليل الحسابات الافتراضي (40+ حساب) عند أول تشغيل فقط
    seedDefaultAccounts: true,
    // الأبعاد الجاهزة: الفرع، المشروع، القسم (أو عرّف أبعادك بنفسك)
    seedDefaultCostDimensions: true,
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

  await setupCostCenters(fa);
  return fa;
}

/// مراكز التكلفة الخاصة بالتطبيق (لا تتكرر مهما أعدت التشغيل)
Future<void> setupCostCenters(FlutterAccounting fa) async {
  final centers = fa.costCenters;
  final riyadh = await centers.ensureCostCenter(
      dimensionCode: CostCenterSeedData.branch,
      code: AppCostCenters.riyadh,
      name: 'Riyadh',
      nameAr: 'فرع الرياض');
  final jeddah = await centers.ensureCostCenter(
      dimensionCode: CostCenterSeedData.branch,
      code: AppCostCenters.jeddah,
      name: 'Jeddah',
      nameAr: 'فرع جدة');
  await centers.ensureCostCenter(
      dimensionCode: CostCenterSeedData.department,
      code: AppCostCenters.salesDept,
      name: 'Sales',
      nameAr: 'المبيعات');
  await centers.ensureCostCenter(
      dimensionCode: CostCenterSeedData.department,
      code: AppCostCenters.adminDept,
      name: 'Administration',
      nameAr: 'الإدارة');

  // مفتاح توزيع: الرياض 300م² وجدة 200م² (60% / 40%)
  if (await centers.getAllocationKeyByCode(AppCostCenters.byArea) == null) {
    await centers.saveAllocationKey(AllocationKeyModel(
      code: AppCostCenters.byArea,
      name: 'By area',
      nameAr: 'حسب المساحة',
      dimensionId: riyadh.dimensionId,
      items: [
        AllocationKeyItemModel(costCenterId: riyadh.id!, weight: 300),
        AllocationKeyItemModel(costCenterId: jeddah.id!, weight: 200),
      ],
    ));
  }

  // سياسة اختيارية: كل مصروف يجب أن يحدد القسم
  final department =
      await centers.getDimensionByCode(CostCenterSeedData.department);
  await centers.setRule(DimensionRuleModel.forType(
    dimensionId: department!.id!,
    accountType: AccountType.expense,
    policy: DimensionPolicy.required,
  ));
}
