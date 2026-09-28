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
  static const usdCustomers = '1131'; // عملاء خارجيون (بالدولار)
}

/// رموز الفروع (وحدات محاسبية لكل منها ميزانيتها)
abstract final class AppBranches {
  static const headOffice = 'HQ'; // المركز الرئيسي
  static const riyadh = 'RYD'; // فرع الرياض
  static const jeddah = 'JED'; // فرع جدة
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
    // كل الميزات التالية اختيارية: احذف ما لا تحتاجه
    config: appConfig,
    // يزرع دليل الحسابات الافتراضي (40+ حساب) عند أول تشغيل فقط
    seedDefaultAccounts: true,
    // الأبعاد الجاهزة: الفرع، المشروع، القسم (أو عرّف أبعادك بنفسك)
    seedDefaultCostDimensions: true,
    // العملات الشائعة (عملة الأساس تُضاف دائماً)
    seedDefaultCurrencies: true,
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
  await setupBranches(fa);
  await setupCurrencies(fa);
  return fa;
}

/// إعدادات المحاسبة للتطبيق
const appConfig = AccountingConfig(
  // مراكز التكلفة (الفروع، الأقسام...) للتحليل
  enableCostCenters: true,
  // تعدد العملات: كل التقارير بالريال، والبنود الأجنبية تحفظ عملتها وسعرها
  multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR'),
  // الفروع كوحدات محاسبية (ميزانية لكل فرع)
  branches: BranchConfig(),
);

/// الفروع، مع ربط كل فرع بمركز تكلفته فتُنسب إليه قيوده تلقائياً
Future<void> setupBranches(FlutterAccounting fa) async {
  Future<int?> center(String code) async =>
      (await fa.costCenters.getCostCenterByCode(code))?.id;

  await fa.branches.ensureBranch(
      code: AppBranches.headOffice,
      name: 'Head Office',
      nameAr: 'المركز الرئيسي',
      isHeadOffice: true);
  await fa.branches.ensureBranch(
      code: AppBranches.riyadh,
      name: 'Riyadh',
      nameAr: 'فرع الرياض',
      costCenterId: await center(AppCostCenters.riyadh));
  await fa.branches.ensureBranch(
      code: AppBranches.jeddah,
      name: 'Jeddah',
      nameAr: 'فرع جدة',
      costCenterId: await center(AppCostCenters.jeddah));
}

/// سعر الدولار وحساب العملاء الخارجيين بالدولار
Future<void> setupCurrencies(FlutterAccounting fa) async {
  await fa.currencies.ensureCurrency(
      code: 'USD', name: 'US Dollar', nameAr: 'دولار أمريكي', symbol: r'$');
  final rates = await fa.currencies.getExchangeRates(code: 'USD');
  if (rates.isEmpty) {
    await fa.currencies
        .setExchangeRate('USD', 3.75, date: DateTime(DateTime.now().year));
  }
  if (await fa.accounts.getAccountByCode(AppAccounts.usdCustomers) == null) {
    await fa.accounts.createAccount(AccountModel.create(
      code: AppAccounts.usdCustomers,
      name: 'Foreign Customers (USD)',
      nameAr: 'عملاء خارجيون (دولار)',
      type: AccountType.asset,
      parentId: (await fa.accounts.getAccountByCode('11'))!.id,
      currencyCode: 'USD',
    ));
  }
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
