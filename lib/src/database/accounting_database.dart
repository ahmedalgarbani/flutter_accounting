/// accounting_database.dart
/// قاعدة بيانات Drift الرئيسية
library;

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_accounting/flutter_accounting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tables.dart';
import 'daos/accounts_dao.dart';
import 'daos/journal_entries_dao.dart';
import 'daos/entry_templates_dao.dart';
import 'daos/cost_centers_dao.dart';

part 'accounting_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    JournalEntries,
    JournalEntryLines,
    AccountingPeriods,
    EntryTemplates,
    CostDimensions,
    CostCenters,
    JournalLineAllocations,
    CostDimensionRules,
    AllocationKeys,
    AllocationKeyItems,
  ],
  daos: [AccountsDao, JournalEntriesDao, EntryTemplatesDao, CostCentersDao],
)
class AccountingDatabase extends _$AccountingDatabase {
  AccountingDatabase(super.e);

  @override

  /// سجل الإصدارات:
  /// - 1: الإصدار الأولي
  /// - 2: نوع القيد، ربط المصدر (sourceType/sourceId)، ربط القيد العكسي،
  ///      جدول القوالب المخصصة، وفهارس للأداء
  /// - 3: مراكز التكلفة: الأبعاد، المراكز، توزيع البنود، القواعد، مفاتيح التوزيع
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // البيانات الأولية (اختياري): يمكن إضافة حسابات أساسية هنا
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(journalEntries, journalEntries.entryType);
            await m.addColumn(journalEntries, journalEntries.sourceType);
            await m.addColumn(journalEntries, journalEntries.sourceId);
            await m.addColumn(journalEntries, journalEntries.reversalOfId);
            await m.createTable(entryTemplates);
            await m.createIndex(idxJournalEntriesDate);
            await m.createIndex(idxJournalEntriesSource);
            await m.createIndex(idxJournalEntryLinesEntry);
            await m.createIndex(idxJournalEntryLinesAccount);
          }
          if (from < 3) {
            await m.createTable(costDimensions);
            await m.createTable(costCenters);
            await m.createTable(journalLineAllocations);
            await m.createTable(costDimensionRules);
            await m.createTable(allocationKeys);
            await m.createTable(allocationKeyItems);
            await m.createIndex(idxCostCentersDimension);
            await m.createIndex(idxLineAllocationsLine);
            await m.createIndex(idxLineAllocationsCenter);
          }
        },
        beforeOpen: (details) async {
          // تفعيل Foreign Keys في SQLite
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );

  // ─────────────────────────────────────────────────────────────
  // Factory: إنشاء قاعدة بيانات حقيقية على الجهاز
  // ─────────────────────────────────────────────────────────────

  ///
  /// [directory] مجلد مخصص لحفظ الملف (الافتراضي: مجلد مستندات التطبيق).
  static Future<AccountingDatabase> create({
    String databaseName = 'flutter_accounting.db',
    String? directory,
  }) async {
    final dbFolder =
        directory ?? (await getApplicationDocumentsDirectory()).path;
    final file = File(p.join(dbFolder, databaseName));
    return AccountingDatabase(NativeDatabase.createInBackground(file));
  }

  // ─────────────────────────────────────────────────────────────
  // Factory: قاعدة بيانات في الذاكرة (للاختبار)
  // ─────────────────────────────────────────────────────────────

  static AccountingDatabase inMemory() =>
      AccountingDatabase(NativeDatabase.memory());
}
