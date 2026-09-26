/// interfaces.dart
/// واجهات الـ Repository (Abstract Contracts)
/// تسمح بالاستبدال والاختبار بسهولة
library;

import '../../core/enums.dart';
import '../../models/account_model.dart';
import '../../models/accounting_period_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/entry_template_model.dart';
import '../../reports/report_models.dart';

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
