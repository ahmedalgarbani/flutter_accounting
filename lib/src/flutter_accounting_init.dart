/// flutter_accounting_init.dart
/// نقطة الدخول الرئيسية للمكتبة
///
/// الاستخدام:
/// ```dart
/// // في main.dart
/// final accounting = await FlutterAccounting.initialize();
///
/// // في أي مكان آخر
/// final fa = FlutterAccounting.instance;
/// await fa.accounts.createAccount(...);
/// await fa.journalEntries.postEntry(id);
/// final report = await fa.reports.getTrialBalance();
/// ```

import 'package:drift/drift.dart';

import 'database/accounting_database.dart';
import 'repositories/interfaces/interfaces.dart';
import 'repositories/impl/account_repository_impl.dart';
import 'repositories/impl/journal_entry_repository_impl.dart';
import 'repositories/impl/reports_repository_impl.dart';
import 'repositories/impl/entry_template_repository_impl.dart';

class FlutterAccounting {
  // ─────────────────────────────────────────────────────────────
  // الـ Repositories العامة
  // ─────────────────────────────────────────────────────────────

  final IAccountRepository      accounts;
  final IJournalEntryRepository journalEntries;
  final IReportsRepository      reports;
  final IEntryTemplateRepository templates;

  /// الوصول إلى قاعدة البيانات الخام (للاستخدام المتقدم)
  final AccountingDatabase database;

  FlutterAccounting._({
    required this.accounts,
    required this.journalEntries,
    required this.reports,
    required this.templates,
    required this.database,
  });

  // ─────────────────────────────────────────────────────────────
  // Singleton
  // ─────────────────────────────────────────────────────────────

  static FlutterAccounting? _instance;

  /// الوصول إلى النسخة المهيأة.
  /// يجب استدعاء [initialize] أولاً.
  static FlutterAccounting get instance {
    assert(
      _instance != null,
      'FlutterAccounting لم يُهيَّأ بعد. استدعِ initialize() أولاً.',
    );
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  // ─────────────────────────────────────────────────────────────
  // التهيئة
  // ─────────────────────────────────────────────────────────────

  /// تهيئة المكتبة وإنشاء قاعدة البيانات.
  ///
  /// [databaseName] اسم ملف قاعدة البيانات (الافتراضي: `flutter_accounting.db`)
  /// [customExecutor] تمرير executor مخصص (مفيد للاختبار)
  static Future<FlutterAccounting> initialize({
    String databaseName = 'flutter_accounting.db',
    QueryExecutor? customExecutor,
  }) async {
    final db = customExecutor != null
        ? AccountingDatabase(customExecutor)
        : await AccountingDatabase.create(databaseName: databaseName);

    _instance = FlutterAccounting._(
      database:      db,
      accounts:      AccountRepositoryImpl(db.accountsDao, db.journalEntriesDao),
      journalEntries: JournalEntryRepositoryImpl(db.journalEntriesDao, db.accountsDao),
      reports:       ReportsRepositoryImpl(db.journalEntriesDao),
      templates:     EntryTemplateRepositoryImpl(AccountRepositoryImpl(db.accountsDao, db.journalEntriesDao)),
    );

    return _instance!;
  }

  /// إنشاء نسخة للاختبار (قاعدة بيانات في الذاكرة)
  static FlutterAccounting forTesting() {
    final db = AccountingDatabase.inMemory();

    return FlutterAccounting._(
      database:       db,
      accounts:       AccountRepositoryImpl(db.accountsDao, db.journalEntriesDao),
      journalEntries: JournalEntryRepositoryImpl(db.journalEntriesDao, db.accountsDao),
      reports:        ReportsRepositoryImpl(db.journalEntriesDao),
      templates:      EntryTemplateRepositoryImpl(AccountRepositoryImpl(db.accountsDao, db.journalEntriesDao)),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // الإغلاق
  // ─────────────────────────────────────────────────────────────

  /// إغلاق قاعدة البيانات وتحرير الموارد
  Future<void> dispose() async {
    await database.close();
    _instance = null;
  }

  /// إعادة تهيئة النسخة (للاختبار)
  static void resetInstance() => _instance = null;
}
