/// interfaces.dart
/// واجهات الـ Repository (Abstract Contracts)
/// تسمح بالاستبدال والاختبار بسهولة
library;

import '../../core/enums.dart';
import '../../models/account_model.dart';
import '../../models/accounting_period_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/entry_template_model.dart';
import '../../models/cost_dimension_model.dart';
import '../../models/cost_center_model.dart';
import '../../models/cost_allocation_model.dart';
import '../../models/allocation_key_model.dart';
import '../../models/cost_allocation_run_model.dart';
import '../../reports/report_models.dart';
import '../../reports/cost_center_report_models.dart';
import '../../models/currency_model.dart';
import '../../models/currency_operation_model.dart';
import '../../reports/currency_report_models.dart';

// ─────────────────────────────────────────────────────────────
// IAccountRepository - دليل الحسابات
// ─────────────────────────────────────────────────────────────

abstract class IAccountRepository {
  // القراءة
  Future<List<AccountModel>> getAllAccounts();
  Future<List<AccountModel>> getActiveAccounts();
  Future<AccountModel?> getAccountById(int id);
  Future<AccountModel?> getAccountByCode(String code);
  Future<List<AccountModel>> getAccountsByType(AccountType type);
  Future<List<AccountModel>> getChildAccounts(int parentId);
  Stream<List<AccountModel>> watchAllAccounts();

  /// الحسابات النهائية (Leaf) النشطة التي يُسمح بالتسجيل عليها.
  /// مثالية لقوائم اختيار الحساب في الواجهة.
  Future<List<AccountModel>> getPostableAccounts({AccountType? type});

  /// البحث بالرمز أو الاسم العربي/الإنجليزي
  Future<List<AccountModel>> searchAccounts(String query);

  /// هل للحساب حسابات فرعية؟
  Future<bool> hasChildren(int accountId);

  // الكتابة
  Future<AccountModel> createAccount(AccountModel account);
  Future<AccountModel> updateAccount(AccountModel account);
  Future<void> setAccountActive(int id, {required bool isActive});
  Future<void> deleteAccount(int id);

  /// يُعيد الحساب إن كان رمزه موجوداً، وإلا ينشئه.
  /// مفيد لتعريف حسابات نظامك عند بدء التطبيق دون تكرار.
  ///
  /// [parentCode] رمز الحساب الأب (بديل مريح عن parentId).
  Future<AccountModel> ensureAccount({
    required String code,
    required String name,
    String? nameAr,
    required AccountType type,
    int? parentId,
    String? parentCode,
    String? description,
  });

  // إحصائيات
  Future<int> countAccounts();

  /// هل توجد بنود قيود (بأي حالة) على الحساب؟
  Future<bool> hasTransactions(int accountId);
}

// ─────────────────────────────────────────────────────────────
// IJournalEntryRepository - القيود اليومية
// ─────────────────────────────────────────────────────────────

abstract class IJournalEntryRepository {
  // القراءة
  Future<List<JournalEntryModel>> getAllEntries();
  Future<JournalEntryModel?> getEntryById(int id);
  Future<JournalEntryModel?> getEntryBySerial(String serialNumber);
  Future<List<JournalEntryModel>> getEntriesByStatus(EntryStatus status);

  /// القيود بين تاريخين (شاملة لكامل يومَي البداية والنهاية)
  Future<List<JournalEntryModel>> getEntriesInDateRange(
      DateTime from, DateTime to);

  /// القيود التي تحمل رقم مرجع معيّن
  Future<List<JournalEntryModel>> getEntriesByReference(String reference);

  /// القيود المرتبطة بمستند في نظامك (مثال: 'invoice', '15')
  Future<List<JournalEntryModel>> getEntriesBySource(
      String sourceType, String sourceId);

  Stream<List<JournalEntryModel>> watchAllEntries();

  // الكتابة (مسودة)
  /// إنشاء قيد (مسودة افتراضياً). إذا مُرِّر بحالة `posted` يُرحَّل مباشرة.
  Future<JournalEntryModel> createEntry(JournalEntryModel entry);

  /// تعديل قيد مسودة (الحالة تبقى مسودة؛ للترحيل استخدم [postEntry])
  Future<JournalEntryModel> updateEntry(JournalEntryModel entry);
  Future<void> deleteEntry(int id);

  // ترحيل وعكس
  Future<JournalEntryModel> postEntry(int id, {String? postedBy});

  /// إنشاء القيد وترحيله في عملية ذرّية واحدة
  Future<JournalEntryModel> createAndPost(JournalEntryModel entry,
      {String? postedBy});

  /// إنشاء قيد عكسي مرحّل للقيد [id] وتعليم الأصلي كـ "معكوس" (عملية ذرّية)
  Future<JournalEntryModel> reverseEntry(
    int id, {
    DateTime? reversalDate,
    String? description,
    String? postedBy,
  });
}

// ─────────────────────────────────────────────────────────────
// IAccountingPeriodRepository - الفترات المحاسبية
// ─────────────────────────────────────────────────────────────

abstract class IAccountingPeriodRepository {
  Future<List<AccountingPeriodModel>> getAllPeriods();
  Future<AccountingPeriodModel?> getPeriodById(int id);
  Future<AccountingPeriodModel?> getPeriodForDate(DateTime date);

  /// إنشاء فترة (يُرفض التداخل مع فترة موجودة أو بداية بعد النهاية)
  Future<AccountingPeriodModel> createPeriod(AccountingPeriodModel period);
  Future<AccountingPeriodModel> updatePeriod(AccountingPeriodModel period);

  /// إغلاق الفترة (يُرفض إن كانت تحتوي على مسودات)
  Future<void> closePeriod(int id);

  /// إعادة فتح فترة مغلقة
  Future<void> reopenPeriod(int id);

  /// حذف فترة لا تحتوي على قيود
  Future<void> deletePeriod(int id);

  /// إنشاء سنة مالية كاملة كفترة واحدة، أو 12 فترة شهرية إن كان [monthly] = true.
  /// تُتجاهل الفترات الموجودة مسبقاً بنفس النطاق.
  Future<List<AccountingPeriodModel>> createFiscalYear(int year,
      {bool monthly = false});

  /// تُعيد الفترة المفتوحة التي تغطي [date]، وإن لم توجد فترة تُنشئ
  /// سنة مالية كاملة لسنة التاريخ.
  Future<AccountingPeriodModel> ensureOpenPeriodFor(DateTime date);
}

// ─────────────────────────────────────────────────────────────
// IReportsRepository - التقارير
// ─────────────────────────────────────────────────────────────

abstract class IReportsRepository {
  /// ميزان المراجعة. الافتراضي: من بداية السنة الحالية حتى اليوم.
  Future<TrialBalanceReport> getTrialBalance({DateTime? from, DateTime? to});
  Future<BalanceSheetReport> getBalanceSheet({required DateTime asOf});
  Future<IncomeStatementReport> getIncomeStatement(
      {required DateTime from, required DateTime to});

  /// رصيد حساب بالاتجاه الطبيعي (موجب = رصيد طبيعي).
  /// [includeChildren] يجمع أرصدة الحسابات الفرعية (مفيد للحسابات الرئيسية).
  Future<double> getAccountBalance(
    int accountId, {
    DateTime? asOf,
    bool includeChildren = true,
  });

  /// كشف حساب (دفتر الأستاذ) مع رصيد افتتاحي ورصيد تراكمي لكل حركة
  Future<AccountLedgerReport> getAccountLedger(
    int accountId, {
    DateTime? from,
    DateTime? to,
    bool includeChildren = true,
  });
}

// ─────────────────────────────────────────────────────────────
// IEntryTemplateRepository - قوالب العمليات
// ─────────────────────────────────────────────────────────────

abstract class IEntryTemplateRepository {
  /// جلب القوالب القياسية المدمجة
  List<EntryTemplateModel> getStandardTemplates();

  /// جلب القوالب المخصصة المحفوظة في قاعدة البيانات
  Future<List<EntryTemplateModel>> getCustomTemplates();

  /// حفظ قالب مخصص (إنشاء إن لم يكن له id، وإلا تحديث)
  Future<EntryTemplateModel> saveTemplate(EntryTemplateModel template);

  /// حذف قالب مخصص
  Future<void> deleteTemplate(int id);

  /// تطبيق قالب لإنشاء مسودة قيد (لا تُحفظ - مرّرها إلى createEntry أو createAndPost)
  /// [accountIdMap] خريطة تربط Label الوارد في القالب بـ ID الحساب المختار.
  /// البنود التي لها `accountId` ثابت في القالب لا تحتاج إلى إدخال في الخريطة.
  Future<JournalEntryModel> applyTemplate({
    required EntryTemplateModel template,
    required Map<String, int> accountIdMap,
    required double totalAmount,
    DateTime? date,
    String? description,
    String? reference,
  });
}

// ─────────────────────────────────────────────────────────────
// ICostCenterRepository - مراكز التكلفة
// ─────────────────────────────────────────────────────────────

/// إدارة الأبعاد التحليلية ومراكز التكلفة وقواعدها ومفاتيح التوزيع.
///
/// عمليات الكتابة ترمي [CostCentersDisabledException] إن كانت الميزة غير
/// مفعّلة في `AccountingConfig.enableCostCenters`، والقراءة متاحة دائماً.
abstract class ICostCenterRepository {
  // ── الأبعاد ──
  Future<List<CostDimensionModel>> getDimensions({bool activeOnly = false});
  Future<CostDimensionModel?> getDimensionById(int id);
  Future<CostDimensionModel?> getDimensionByCode(String code);
  Future<CostDimensionModel> createDimension(CostDimensionModel dimension);
  Future<CostDimensionModel> updateDimension(CostDimensionModel dimension);

  /// يُعيد البعد إن كان رمزه موجوداً، وإلا ينشئه
  Future<CostDimensionModel> ensureDimension({
    required String code,
    required String name,
    String? nameAr,
    DimensionPolicy defaultPolicy = DimensionPolicy.optional,
    bool allowSplit = true,
  });

  /// إيقاف/تفعيل بُعد: البعد الموقوف لا يقبل توزيعات جديدة ولا تُطبَّق سياساته
  Future<void> setDimensionActive(int id, {required bool isActive});

  /// حذف بُعد لا يحتوي على مراكز (مع قواعده ومفاتيح توزيعه)
  Future<void> deleteDimension(int id);

  // ── المراكز ──
  Future<List<CostCenterModel>> getCostCenters(
      {int? dimensionId, bool activeOnly = false});
  Future<CostCenterModel?> getCostCenterById(int id);
  Future<CostCenterModel?> getCostCenterByCode(String code);
  Future<List<CostCenterModel>> getChildCostCenters(int parentId);
  Stream<List<CostCenterModel>> watchCostCenters({int? dimensionId});

  /// المراكز النهائية (Leaf) النشطة في أبعاد نشطة - لقوائم الاختيار
  Future<List<CostCenterModel>> getPostableCostCenters({int? dimensionId});

  /// البحث بالرمز أو الاسم العربي/الإنجليزي
  Future<List<CostCenterModel>> searchCostCenters(String query,
      {int? dimensionId});

  Future<CostCenterModel> createCostCenter(CostCenterModel costCenter);
  Future<CostCenterModel> updateCostCenter(CostCenterModel costCenter);

  /// يُعيد المركز إن كان رمزه موجوداً، وإلا ينشئه في البعد [dimensionCode]
  Future<CostCenterModel> ensureCostCenter({
    required String dimensionCode,
    required String code,
    required String name,
    String? nameAr,
    String? parentCode,
  });

  Future<void> setCostCenterActive(int id, {required bool isActive});

  /// حذف مركز بلا حركات أو أبناء أو ارتباطات
  Future<void> deleteCostCenter(int id);

  /// هل توجد حركات (بأي حالة) على المركز؟
  Future<bool> hasTransactions(int costCenterId);

  // ── قواعد الأبعاد ──
  Future<List<DimensionRuleModel>> getRules({int? dimensionId});

  /// إنشاء قاعدة أو تحديث القاعدة الموجودة لنفس الحساب/النوع في نفس البعد
  Future<DimensionRuleModel> setRule(DimensionRuleModel rule);
  Future<void> deleteRule(int id);

  /// السياسة الفعلية لبُعد على حساب بعد تطبيق القواعد والأولويات
  Future<DimensionPolicy> getEffectivePolicy({
    required int accountId,
    required int dimensionId,
  });

  // ── مفاتيح التوزيع ──
  Future<List<AllocationKeyModel>> getAllocationKeys({int? dimensionId});
  Future<AllocationKeyModel?> getAllocationKeyById(int id);
  Future<AllocationKeyModel?> getAllocationKeyByCode(String code);

  /// إنشاء مفتاح (بلا id) أو تحديثه مع بنوده
  Future<AllocationKeyModel> saveAllocationKey(AllocationKeyModel key);
  Future<void> deleteAllocationKey(int id);

  /// يقسم [amount] حسب أوزان المفتاح ويُعيد حصصاً جاهزة لبند قيد
  Future<List<CostAllocationModel>> splitByKey(
      int allocationKeyId, double amount);
}

// ─────────────────────────────────────────────────────────────
// ICostAllocationRepository - التوزيع الدوري للتكاليف
// ─────────────────────────────────────────────────────────────

abstract class ICostAllocationRepository {
  /// يحسب التوزيع دون حفظ شيء (لعرضه على المستخدم قبل التنفيذ)
  Future<CostAllocationPreview> previewAllocation(
      CostAllocationRequest request);

  /// ينشئ قيد توزيع التكاليف (مرحّلاً افتراضياً).
  /// القيد مرتبط بالمصدر `cost_allocation` ويمكن إلغاؤه بـ `reverseEntry`.
  /// يرمي [InvalidCostAllocationException] إن لم توجد أرصدة للتوزيع.
  Future<JournalEntryModel> runAllocation(
    CostAllocationRequest request, {
    bool post = true,
    String? postedBy,
  });
}

// ─────────────────────────────────────────────────────────────
// ICostReportsRepository - تقارير مراكز التكلفة
// ─────────────────────────────────────────────────────────────

/// تقارير مراكز التكلفة. التواريخ الافتراضية: من بداية السنة الحالية حتى
/// اليوم، وحدود التواريخ على مستوى اليوم مثل التقارير المالية.
abstract class ICostReportsRepository {
  /// ملخص الإيرادات والمصروفات وصافي الربح لكل مراكز بُعد (شجرة مجمّعة)
  Future<CostCenterSummaryReport> getSummary({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
  });

  /// مقارنة أرصدة الحسابات بين المراكز.
  /// [costCenterIds] المراكز المعروضة كأعمدة (كل منها يشمل أبناءه)،
  /// والافتراضي: المراكز الجذرية للبعد.
  /// [incomeStatementOnly] حسابات الإيرادات والمصروفات فقط (الافتراضي).
  Future<CostCenterComparisonReport> getComparison({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
    List<int>? costCenterIds,
    bool includeUnallocated = true,
    bool incomeStatementOnly = true,
  });

  /// قائمة الدخل لمركز أو مجموعة مراكز
  Future<IncomeStatementReport> getIncomeStatement({
    required CostCenterFilter filter,
    required DateTime from,
    required DateTime to,
  });

  /// ميزان المراجعة لمركز أو مجموعة مراكز
  Future<TrialBalanceReport> getTrialBalance({
    required CostCenterFilter filter,
    DateTime? from,
    DateTime? to,
  });

  /// كشف حساب مركز تكلفة (اختيارياً لحساب واحد وحساباته الفرعية)
  Future<CostCenterLedgerReport> getLedger(
    int costCenterId, {
    DateTime? from,
    DateTime? to,
    int? accountId,
    bool includeChildren = true,
  });

  /// تحليل متقاطع لبُعدين (مثل الفروع × المشاريع) للإيرادات والمصروفات.
  /// الصفوف/الأعمدة الافتراضية: المراكز الجذرية لكل بعد.
  Future<CostCenterMatrixReport> getMatrix({
    required int rowDimensionId,
    required int columnDimensionId,
    DateTime? from,
    DateTime? to,
    List<int>? rowCostCenterIds,
    List<int>? columnCostCenterIds,
  });

  /// البنود غير الموزعة على مراكز بُعد (لضبط جودة البيانات)
  Future<UnallocatedLinesReport> getUnallocatedLines({
    required int dimensionId,
    DateTime? from,
    DateTime? to,
    bool incomeStatementOnly = true,
  });
}

// ─────────────────────────────────────────────────────────────
// ICurrencyRepository - العملات وأسعار الصرف
// ─────────────────────────────────────────────────────────────

/// العملات وأسعار الصرف وأرصدة الحسابات بعملاتها.
/// الكتابة ترمي [MultiCurrencyDisabledException] إن لم يكن تعدد العملات مفعّلاً.
abstract class ICurrencyRepository {
  /// رمز عملة الأساس (null إن كان تعدد العملات غير مفعّل)
  String? get baseCurrencyCode;

  /// يتأكد من وجود عملة الأساس وتثبيتها في قاعدة البيانات.
  /// يرمي [BaseCurrencyMismatchException] إن تغيرت بعد تسجيل قيود.
  Future<CurrencyModel> ensureBaseCurrency();

  Future<List<CurrencyModel>> getCurrencies({bool activeOnly = false});
  Future<CurrencyModel?> getCurrency(String code);
  Future<CurrencyModel> createCurrency(CurrencyModel currency);
  Future<CurrencyModel> updateCurrency(CurrencyModel currency);

  /// يُعيد العملة إن كانت موجودة، وإلا ينشئها
  Future<CurrencyModel> ensureCurrency({
    required String code,
    required String name,
    String? nameAr,
    String? symbol,
    int decimalPlaces = 2,
  });

  Future<void> setCurrencyActive(String code, {required bool isActive});

  /// تسجيل سعر صرف [code] مقابل عملة الأساس في [date] (الافتراضي: اليوم).
  /// يستبدل سعر نفس اليوم إن وُجد.
  Future<ExchangeRateModel> setExchangeRate(String code, double rate,
      {DateTime? date});

  Future<List<ExchangeRateModel>> getExchangeRates(
      {String? code, DateTime? from, DateTime? to});
  Future<void> deleteExchangeRate(int id);

  /// آخر سعر مسجل في [date] أو قبله (عملة الأساس = 1).
  /// يرمي [ExchangeRateNotFoundException] إن لم يوجد.
  Future<double> getExchangeRate(String code, {DateTime? date});

  /// تحويل مبلغ بين عملتين عبر عملة الأساس، مقرّباً لمنازل [to]
  Future<double> convert(double amount,
      {required String from, required String to, DateTime? date});

  /// رصيد حساب بعملة (الافتراضي: عملة الحساب)
  Future<CurrencyBalance> getAccountCurrencyBalance(int accountId,
      {String? currencyCode, DateTime? asOf});

  /// كشف حساب بعملته وبعملة الأساس
  Future<CurrencyLedgerReport> getAccountCurrencyLedger(int accountId,
      {String? currencyCode, DateTime? from, DateTime? to});
}

// ─────────────────────────────────────────────────────────────
// IExchangeDifferenceRepository - فروقات العملة
// ─────────────────────────────────────────────────────────────

abstract class IExchangeDifferenceRepository {
  /// أرصدة الحسابات بالعملات الأجنبية مع تقييمها بسعر [asOf].
  /// الافتراضي: حسابات الأصول والخصوم؛ مرّر [accountIds] لحسابات محددة.
  Future<ForeignCurrencyBalancesReport> getForeignCurrencyBalances(
      {DateTime? asOf, List<int>? accountIds});

  /// معاينة إعادة التقييم دون حفظ
  Future<RevaluationPreview> previewRevaluation(RevaluationRequest request);

  /// ينشئ قيود إعادة التقييم (`EntryType.exchangeDifference`): قيد للفروقات
  /// المحققة، وقيد لغير المحققة يُعكس تلقائياً في `request.autoReverseOn`.
  /// يرمي [InvalidCurrencyOperationException] إن لم توجد فروقات.
  Future<RevaluationResult> runRevaluation(
    RevaluationRequest request, {
    bool post = true,
    String? postedBy,
  });

  /// تسوية مبلغ بعملة أجنبية مع قيد فرق العملة المحقق في نفس القيد
  Future<JournalEntryModel> settle(
    SettlementRequest request, {
    bool post = true,
    String? postedBy,
  });
}
