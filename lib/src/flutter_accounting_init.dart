/// flutter_accounting_init.dart
/// نقطة الدخول الرئيسية للمكتبة
///
/// الاستخدام:
/// ```dart
/// // في main.dart
/// final accounting = await FlutterAccounting.initialize(
///   seedDefaultAccounts: true,
///   config: const AccountingConfig(requireOpenPeriod: false),
/// );
///
/// // في أي مكان آخر
/// final fa = FlutterAccounting.instance;
/// await fa.record(
///   JournalEntryBuilder(description: 'بيع نقدي')
///     .debitCode('111', 500)
///     .creditCode('41', 500),
/// );
/// final report = await fa.reports.getTrialBalance();
/// ```
library;

import 'package:drift/drift.dart';

import 'core/accounting_config.dart';
import 'core/journal_entry_builder.dart';
import 'database/accounting_database.dart';
import 'models/journal_entry_model.dart';
import 'repositories/interfaces/interfaces.dart';
import 'repositories/impl/account_repository_impl.dart';
import 'repositories/impl/journal_entry_repository_impl.dart';
import 'repositories/impl/reports_repository_impl.dart';
import 'repositories/impl/entry_template_repository_impl.dart';
import 'repositories/impl/accounting_period_repository_impl.dart';
import 'repositories/impl/cost_allocation_repository_impl.dart';
import 'repositories/impl/cost_center_repository_impl.dart';
import 'repositories/impl/cost_reports_repository_impl.dart';
import 'repositories/impl/currency_repository_impl.dart';
import 'repositories/impl/exchange_difference_repository_impl.dart';
import 'repositories/impl/branch_repository_impl.dart';
import 'repositories/impl/branch_reports_repository_impl.dart';
import 'seed/accounting_seed_data.dart';
import 'seed/cost_center_seed_data.dart';
import 'seed/currency_seed_data.dart';

class FlutterAccounting {
  // ─────────────────────────────────────────────────────────────
  // الـ Repositories العامة
  // ─────────────────────────────────────────────────────────────

  /// دليل الحسابات
  final IAccountRepository accounts;

  /// القيود اليومية (إنشاء / ترحيل / عكس)
  final IJournalEntryRepository journalEntries;

  /// التقارير المالية وكشوف الحسابات
  final IReportsRepository reports;

  /// قوالب العمليات (بيع، شراء، سندات...)
  final IEntryTemplateRepository templates;

  /// الفترات المحاسبية
  final IAccountingPeriodRepository periods;

  /// مراكز التكلفة: الأبعاد (فرع/مشروع/قسم...)، المراكز، القواعد،
  /// ومفاتيح التوزيع. تتطلب `AccountingConfig(enableCostCenters: true)`.
  final ICostCenterRepository costCenters;

  /// التوزيع الدوري لتكاليف مركز على مراكز أخرى
  final ICostAllocationRepository costAllocations;

  /// تقارير مراكز التكلفة
  final ICostReportsRepository costReports;

  /// العملات وأسعار الصرف وأرصدة الحسابات بعملاتها.
  /// تتطلب `AccountingConfig(multiCurrency: MultiCurrencyConfig(...))`.
  final ICurrencyRepository currencies;

  /// فروقات العملة: إعادة التقييم والتسوية بالفرق المحقق
  final IExchangeDifferenceRepository exchangeDifferences;

  /// الفروع كوحدات محاسبية: الفروع، تقييد الحسابات، إقفال الفترات،
  /// والمعاملات بين الفروع. تتطلب `AccountingConfig(branches: BranchConfig())`.
  final IBranchRepository branches;

  /// تقارير الفروع: المقارنة، التقارير الموحّدة، ومطابقة الحسابات الجارية.
  /// (تقارير `reports` الحالية تقبل أيضاً `branchIds` لفرع أو أكثر)
  final IBranchReportsRepository branchReports;

  /// الإعدادات المستخدمة
  final AccountingConfig config;

  /// الوصول إلى قاعدة البيانات الخام (للاستخدام المتقدم)
  final AccountingDatabase database;

  FlutterAccounting._({
    required this.accounts,
    required this.journalEntries,
    required this.reports,
    required this.templates,
    required this.periods,
    required this.costCenters,
    required this.costAllocations,
    required this.costReports,
    required this.currencies,
    required this.exchangeDifferences,
    required this.branches,
    required this.branchReports,
    required this.config,
    required this.database,
  });

  /// يبني جميع المستودعات فوق قاعدة بيانات واحدة
  factory FlutterAccounting._fromDatabase(
    AccountingDatabase db,
    AccountingConfig config,
  ) {
    final accounts =
        AccountRepositoryImpl(db.accountsDao, db.journalEntriesDao, config);
    final currencies =
        CurrencyRepositoryImpl(db.currenciesDao, db.accountsDao, config);
    final journalEntries = JournalEntryRepositoryImpl(db.journalEntriesDao,
        db.accountsDao, config, db.costCentersDao, currencies);
    final costCenters =
        CostCenterRepositoryImpl(db.costCentersDao, db.accountsDao, config);
    final reports = ReportsRepositoryImpl(db.journalEntriesDao, db.accountsDao);
    return FlutterAccounting._(
      database: db,
      config: config,
      accounts: accounts,
      journalEntries: journalEntries,
      reports: reports,
      templates: EntryTemplateRepositoryImpl(accounts, db.entryTemplatesDao),
      periods: AccountingPeriodRepositoryImpl(db.journalEntriesDao),
      costCenters: costCenters,
      costAllocations: CostAllocationRepositoryImpl(db.costCentersDao,
          db.accountsDao, costCenters, journalEntries, config),
      costReports: CostReportsRepositoryImpl(
          db.costCentersDao, db.accountsDao, db.journalEntriesDao),
      currencies: currencies,
      exchangeDifferences: ExchangeDifferenceRepositoryImpl(
          db.currenciesDao, db.accountsDao, currencies, journalEntries, config),
      branches: BranchRepositoryImpl(db.branchesDao, db.accountsDao,
          db.journalEntriesDao, accounts, journalEntries, config),
      branchReports: BranchReportsRepositoryImpl(
          db.branchesDao, db.accountsDao, db.journalEntriesDao, reports),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Singleton
  // ─────────────────────────────────────────────────────────────

  static FlutterAccounting? _instance;

  /// الوصول إلى النسخة المهيأة.
  /// يجب استدعاء [initialize] أولاً وإلا يُرمى [StateError].
  static FlutterAccounting get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'FlutterAccounting لم يُهيَّأ بعد. استدعِ FlutterAccounting.initialize() أولاً.',
      );
    }
    return instance;
  }

  static bool get isInitialized => _instance != null;

  // ─────────────────────────────────────────────────────────────
  // التهيئة
  // ─────────────────────────────────────────────────────────────

  /// تهيئة المكتبة وإنشاء قاعدة البيانات.
  ///
  /// - [databaseName] اسم ملف قاعدة البيانات (الافتراضي: `flutter_accounting.db`)
  /// - [databaseDirectory] مجلد مخصص للملف (الافتراضي: مستندات التطبيق)
  /// - [customExecutor] تمرير executor مخصص (مفيد للاختبار أو التشفير)
  /// - [config] إعدادات السلوك، انظر [AccountingConfig]
  /// - [seedDefaultAccounts] زرع دليل الحسابات الافتراضي إن كانت القاعدة فارغة
  /// - [seedDefaultCostDimensions] إنشاء الأبعاد الجاهزة (الفرع، المشروع،
  ///   القسم) إن لم تكن موجودة. يتطلب `config.enableCostCenters = true`.
  ///   بدونها يمكنك تعريف أبعادك الخاصة عبر `fa.costCenters`.
  /// - [seedDefaultCurrencies] إضافة العملات الشائعة (يتطلب `config.multiCurrency`).
  ///   عملة الأساس تُضاف وتُثبَّت تلقائياً في كل الأحوال.
  ///
  /// استدعاء [initialize] مرة ثانية يغلق النسخة السابقة أولاً.
  static Future<FlutterAccounting> initialize({
    String databaseName = 'flutter_accounting.db',
    String? databaseDirectory,
    QueryExecutor? customExecutor,
    AccountingConfig config = const AccountingConfig(),
    bool seedDefaultAccounts = false,
    bool seedDefaultCostDimensions = false,
    bool seedDefaultCurrencies = false,
  }) async {
    if (seedDefaultCurrencies && !config.isMultiCurrency) {
      throw ArgumentError(
          'seedDefaultCurrencies يتطلب AccountingConfig(multiCurrency: ...).');
    }
    if (seedDefaultCostDimensions && !config.enableCostCenters) {
      throw ArgumentError(
          'seedDefaultCostDimensions يتطلب AccountingConfig(enableCostCenters: true).');
    }
    final previous = _instance;
    _instance = null;
    await previous?.database.close();

    final db = customExecutor != null
        ? AccountingDatabase(customExecutor)
        : await AccountingDatabase.create(
            databaseName: databaseName,
            directory: databaseDirectory,
          );

    final fa = FlutterAccounting._fromDatabase(db, config);
    if (seedDefaultAccounts) await AccountingSeedData.seed(fa.accounts);
    if (seedDefaultCostDimensions) {
      await CostCenterSeedData.seed(fa.costCenters);
    }
    if (config.isMultiCurrency) {
      // تثبيت عملة الأساس مبكراً (يرمي إن تغيّرت بعد تسجيل قيود)
      await fa.currencies.ensureBaseCurrency();
      if (seedDefaultCurrencies) await CurrencySeedData.seed(fa.currencies);
    }

    return _instance = fa;
  }

  /// إنشاء نسخة للاختبار (قاعدة بيانات في الذاكرة).
  /// لا تُسجَّل كـ [instance].
  static FlutterAccounting forTesting({
    AccountingConfig config = const AccountingConfig(),
  }) {
    return FlutterAccounting._fromDatabase(
        AccountingDatabase.inMemory(), config);
  }

  // ─────────────────────────────────────────────────────────────
  // واجهة مختصرة (Convenience API)
  // ─────────────────────────────────────────────────────────────

  /// ينشئ قيداً من [JournalEntryBuilder] (مع حل رموز الحسابات) ويرحّله
  /// في عملية ذرّية واحدة. مرّر `post: false` لحفظه كمسودة.
  ///
  /// ```dart
  /// await fa.record(
  ///   JournalEntryBuilder(description: 'فاتورة مبيعات 15')
  ///     .source('invoice', 15)
  ///     .debitCode('113', 1000)   // العملاء
  ///     .creditCode('41', 1000),  // المبيعات
  ///   postedBy: currentUser.name,
  /// );
  /// ```
  Future<JournalEntryModel> record(
    JournalEntryBuilder builder, {
    bool post = true,
    String? postedBy,
  }) async {
    final entry = await builder.resolve(accounts,
        costCenters: costCenters, branches: branches);
    return post
        ? journalEntries.createAndPost(entry, postedBy: postedBy)
        : journalEntries.createEntry(entry);
  }

  /// ينفّذ عدة عمليات محاسبية في transaction واحدة:
  /// إما أن تنجح كلها أو تُلغى كلها.
  ///
  /// ```dart
  /// await fa.transaction(() async {
  ///   await fa.record(saleEntry);
  ///   await fa.record(costOfGoodsEntry);
  /// });
  /// ```
  Future<T> transaction<T>(Future<T> Function() action) =>
      database.transaction(action);

  /// يعكس كل القيود المرحّلة المرتبطة بمستند في نظامك (مثلاً عند إلغاء فاتورة).
  /// يُعيد القيود العكسية المُنشأة.
  Future<List<JournalEntryModel>> reverseSource(
    String sourceType,
    Object sourceId, {
    DateTime? reversalDate,
    String? postedBy,
  }) {
    return transaction(() async {
      final entries = await journalEntries.getEntriesBySource(
          sourceType, sourceId.toString());
      final reversals = <JournalEntryModel>[];
      for (final e in entries.where((e) => e.isPosted && !e.isReversal)) {
        reversals.add(await journalEntries.reverseEntry(
          e.id!,
          reversalDate: reversalDate,
          postedBy: postedBy,
        ));
      }
      return reversals;
    });
  }

  // ─────────────────────────────────────────────────────────────
  // الإغلاق
  // ─────────────────────────────────────────────────────────────

  /// إغلاق قاعدة البيانات وتحرير الموارد
  Future<void> dispose() async {
    await database.close();
    if (identical(_instance, this)) _instance = null;
  }

  /// إعادة تهيئة النسخة (للاختبار)
  static void resetInstance() => _instance = null;
}
