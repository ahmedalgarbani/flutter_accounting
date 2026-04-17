/// journal_entries_dao.dart
/// عمليات قاعدة البيانات للقيود اليومية وبنودها

import 'package:drift/drift.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'journal_entries_dao.g.dart';

// نموذج مدمج: قيد + بنده + اسم الحساب
class EntryLineWithAccount {
  final JournalEntryLine line;
  final Account account;

  EntryLineWithAccount({required this.line, required this.account});
}

@DriftAccessor(tables: [JournalEntries, JournalEntryLines, Accounts])
class JournalEntriesDao extends DatabaseAccessor<AccountingDatabase>
    with _$JournalEntriesDaoMixin {
  JournalEntriesDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // قراءة القيود
  // ─────────────────────────────────────────────────────────────

  Future<List<JournalEntry>> getAllEntries() =>
      (select(journalEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<JournalEntry?> getEntryById(int id) =>
      (select(journalEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<JournalEntry>> getEntriesByStatus(int statusIndex) =>
      (select(journalEntries)
            ..where((t) => t.status.equals(statusIndex))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<JournalEntry>> getEntriesInDateRange(
    DateTime from,
    DateTime to,
  ) =>
      (select(journalEntries)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Stream<List<JournalEntry>> watchAllEntries() =>
      (select(journalEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  // ─────────────────────────────────────────────────────────────
  // قراءة بنود القيد (مع اسم الحساب)
  // ─────────────────────────────────────────────────────────────

  Future<List<EntryLineWithAccount>> getLinesForEntry(int entryId) async {
    final query = select(journalEntryLines).join([
      innerJoin(accounts, accounts.id.equalsExp(journalEntryLines.accountId)),
    ])
      ..where(journalEntryLines.entryId.equals(entryId))
      ..orderBy([OrderingTerm(expression: journalEntryLines.sortOrder)]);

    final rows = await query.get();
    return rows.map((row) => EntryLineWithAccount(
          line:    row.readTable(journalEntryLines),
          account: row.readTable(accounts),
        )).toList();
  }

  // ─────────────────────────────────────────────────────────────
  // كتابة القيود
  // ─────────────────────────────────────────────────────────────

  Future<int> insertEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<void> updateEntry(JournalEntriesCompanion entry) =>
      (update(journalEntries)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> updateEntryStatus(int entryId, int statusIndex) =>
      (update(journalEntries)..where((t) => t.id.equals(entryId))).write(
        JournalEntriesCompanion(
          status:    Value(statusIndex),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> deleteEntry(int entryId) =>
      (delete(journalEntries)..where((t) => t.id.equals(entryId))).go();

  // ─────────────────────────────────────────────────────────────
  // كتابة بنود القيد
  // ─────────────────────────────────────────────────────────────

  Future<int> insertLine(JournalEntryLinesCompanion line) =>
      into(journalEntryLines).insert(line);

  Future<void> deleteLinesForEntry(int entryId) =>
      (delete(journalEntryLines)
            ..where((t) => t.entryId.equals(entryId)))
          .go();

  // ─────────────────────────────────────────────────────────────
  // عمليات مجمّعة (Transaction-safe)
  // ─────────────────────────────────────────────────────────────

  /// إدراج قيد + بنوده في عملية واحدة (Atomic)
  Future<int> insertEntryWithLines({
    required JournalEntriesCompanion entry,
    required List<JournalEntryLinesCompanion> lines,
  }) async {
    return transaction(() async {
      final entryId = await insertEntry(entry);
      final linesWithEntryId = lines.map(
        (l) => l.copyWith(entryId: Value(entryId)),
      );
      for (final line in linesWithEntryId) {
        await insertLine(line);
      }
      return entryId;
    });
  }

  /// تحديث قيد + بنوده في عملية واحدة
  Future<void> updateEntryWithLines({
    required JournalEntriesCompanion entry,
    required List<JournalEntryLinesCompanion> lines,
  }) async {
    await transaction(() async {
      await updateEntry(entry);
      await deleteLinesForEntry(entry.id.value);
      final linesWithEntryId = lines.map(
        (l) => l.copyWith(entryId: Value(entry.id.value)),
      );
      for (final line in linesWithEntryId) {
        await insertLine(line);
      }
    });
  }

  /// حذف قيد + بنوده في عملية واحدة
  Future<void> deleteEntryWithLines(int entryId) async {
    await transaction(() async {
      await deleteLinesForEntry(entryId);
      await deleteEntry(entryId);
    });
  }

  // ─────────────────────────────────────────────────────────────
  // للتقارير: أرصدة الحسابات
  // ─────────────────────────────────────────────────────────────

  /// يجلب مجموع المدين والدائن لكل حساب في نطاق زمني
  Future<List<AccountBalanceRow>> getAccountBalances({
    DateTime? from,
    DateTime? to,
  }) async {
    // نستخدم استعلام خام لأن Drift لا يدعم GROUP BY بشكل كامل في API العادي
    final fromStr = (from ?? DateTime(1970)).toIso8601String();
    final toStr   = (to   ?? DateTime(2100)).toIso8601String();

    final result = await customSelect(
      '''
      SELECT
        a.id          AS account_id,
        a.code        AS account_code,
        a.name        AS account_name,
        a.type        AS account_type,
        COALESCE(SUM(l.debit),  0) AS total_debit,
        COALESCE(SUM(l.credit), 0) AS total_credit
      FROM accounts a
      LEFT JOIN journal_entry_lines l ON l.account_id = a.id
      LEFT JOIN journal_entries e     ON e.id = l.entry_id
        AND e.status = 1              -- posted فقط
        AND e.date >= ?
        AND e.date <= ?
      GROUP BY a.id
      ORDER BY a.code
      ''',
      variables: [Variable.withString(fromStr), Variable.withString(toStr)],
      readsFrom: {accounts, journalEntries, journalEntryLines},
    ).get();

    return result.map((row) => AccountBalanceRow.fromRow(row)).toList();
  }
}

// ─────────────────────────────────────────────────────────────
// نموذج صف رصيد الحساب (لتقديم البيانات للـ Repository)
// ─────────────────────────────────────────────────────────────
class AccountBalanceRow {
  final int    accountId;
  final String accountCode;
  final String accountName;
  final int    accountType;
  final double totalDebit;
  final double totalCredit;

  AccountBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    required this.totalDebit,
    required this.totalCredit,
  });

  factory AccountBalanceRow.fromRow(QueryRow row) => AccountBalanceRow(
        accountId:   row.read<int>('account_id'),
        accountCode: row.read<String>('account_code'),
        accountName: row.read<String>('account_name'),
        accountType: row.read<int>('account_type'),
        totalDebit:  row.read<double>('total_debit'),
        totalCredit: row.read<double>('total_credit'),
      );
}
