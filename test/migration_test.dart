/// migration_test.dart
/// التحقق من ترقية قاعدة بيانات الإصدار 1 (0.3.0) إلى الإصدار الحالي دون فقد بيانات
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

// مخطط الإصدار 1 كما أنشأه الإصدار 0.3.0 من المكتبة
const _v1Schema = [
  '''CREATE TABLE "accounts" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "code" TEXT NOT NULL, "name" TEXT NOT NULL, "name_ar" TEXT NULL, "type" INTEGER NOT NULL, "parent_id" INTEGER NULL REFERENCES accounts (id), "is_active" INTEGER NOT NULL DEFAULT 1 CHECK ("is_active" IN (0, 1)), "description" TEXT NULL, "level" INTEGER NOT NULL DEFAULT 1, "created_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), "updated_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), UNIQUE ("code"))''',
  '''CREATE TABLE "journal_entries" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "serial_number" TEXT NOT NULL, "date" INTEGER NOT NULL, "description" TEXT NOT NULL, "reference" TEXT NULL, "status" INTEGER NOT NULL, "notes" TEXT NULL, "created_by" TEXT NULL, "posted_by" TEXT NULL, "posted_at" INTEGER NULL, "created_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), "updated_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)), UNIQUE ("serial_number"))''',
  '''CREATE TABLE "journal_entry_lines" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "entry_id" INTEGER NOT NULL REFERENCES journal_entries (id), "account_id" INTEGER NOT NULL REFERENCES accounts (id), "debit" REAL NOT NULL DEFAULT 0.0, "credit" REAL NOT NULL DEFAULT 0.0, "description" TEXT NULL, "sort_order" INTEGER NOT NULL DEFAULT 0)''',
  '''CREATE TABLE "accounting_periods" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "start_date" INTEGER NOT NULL, "end_date" INTEGER NOT NULL, "is_closed" INTEGER NOT NULL DEFAULT 0 CHECK ("is_closed" IN (0, 1)), "created_at" INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)))''',
];

int _epoch(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

void main() {
  test('ترقية قاعدة بيانات v1 إلى v3 مع الحفاظ على البيانات', () async {
    final executor = NativeDatabase.memory(setup: (raw) {
      final v = raw.userVersion;
      if (v != 0) return; // تُنفَّذ مرة واحدة فقط
      for (final sql in _v1Schema) {
        raw.execute(sql);
      }
      raw.execute(
          "INSERT INTO accounts (id, code, name, type) VALUES (1, '111', 'Cash', 0), (2, '41', 'Sales', 3)");
      raw.execute(
          'INSERT INTO accounting_periods (name, start_date, end_date) VALUES (?, ?, ?)',
          [
            '2024',
            _epoch(DateTime(2024)),
            _epoch(DateTime(2024, 12, 31, 23, 59, 59))
          ]);
      raw.execute(
          'INSERT INTO journal_entries (id, serial_number, date, description, status) VALUES (1, ?, ?, ?, 1)',
          ['JV-2024-0001', _epoch(DateTime(2024, 5, 1)), 'old sale']);
      raw.execute(
          'INSERT INTO journal_entry_lines (entry_id, account_id, debit, credit) VALUES (1, 1, 100, 0), (1, 2, 0, 100)');
      raw.userVersion = 1;
    });

    final fa = await FlutterAccounting.initialize(
      customExecutor: executor,
      config: const AccountingConfig(enableCostCenters: true),
    );
    addTearDown(fa.dispose);

    // البيانات القديمة سليمة
    final old = await fa.journalEntries.getEntryBySerial('JV-2024-0001');
    expect(old, isNotNull);
    expect(old!.lines, hasLength(2));
    expect(old.sourceType, isNull);
    expect(await fa.reports.getAccountBalance(1), 100);

    // الأعمدة والجداول الجديدة تعمل
    final e = await fa.record(
        JournalEntryBuilder(description: 'new', date: DateTime(2024, 6, 1))
            .source('invoice', 1)
            .debit(1, 5)
            .credit(2, 5));
    expect(e.serialNumber, 'JV-2024-0002');
    expect((await fa.journalEntries.getEntriesBySource('invoice', '1')),
        hasLength(1));

    await fa.templates.saveTemplate(StandardTemplates.cashSale);
    expect(await fa.templates.getCustomTemplates(), hasLength(1));

    // جداول مراكز التكلفة (v3) تعمل على البيانات القديمة
    final branch =
        await fa.costCenters.ensureDimension(code: 'BRANCH', name: 'Branch');
    final center = await fa.costCenters.createCostCenter(
        CostCenterModel(dimensionId: branch.id!, code: 'B1', name: 'Main'));
    await fa.record(JournalEntryBuilder(
            description: 'with center', date: DateTime(2024, 7, 1))
        .debit(1, 10,
            allocations: [CostAllocationModel.full(center.id!)]).credit(2, 10));
    final summary = await fa.costReports.getSummary(
        dimensionId: branch.id!,
        from: DateTime(2024),
        to: DateTime(2024, 12, 31));
    expect(summary.unallocatedRevenue, 115);
    expect(await fa.costCenters.hasTransactions(center.id!), isTrue);

    final version =
        await fa.database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 3);
  });
}
