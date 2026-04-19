/// accounting_database.dart
/// قاعدة بيانات Drift الرئيسية

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_accounting/flutter_accounting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tables.dart';
import 'daos/accounts_dao.dart';
import 'daos/journal_entries_dao.dart';

part 'accounting_database.g.dart';

@DriftDatabase(
  tables: [Accounts, JournalEntries, JournalEntryLines, AccountingPeriods],
  daos: [AccountsDao, JournalEntriesDao],
)
class AccountingDatabase extends _$AccountingDatabase {
  AccountingDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // البيانات الأولية (اختياري): يمكن إضافة حسابات أساسية هنا
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // إضافة الترقيات المستقبلية هنا
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

  static Future<AccountingDatabase> create({
    String databaseName = 'flutter_accounting.db',
  }) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseName));
    return AccountingDatabase(NativeDatabase.createInBackground(file));
  }

  // ─────────────────────────────────────────────────────────────
  // Factory: قاعدة بيانات في الذاكرة (للاختبار)
  // ─────────────────────────────────────────────────────────────

  static AccountingDatabase inMemory() =>
      AccountingDatabase(NativeDatabase.memory());
}
