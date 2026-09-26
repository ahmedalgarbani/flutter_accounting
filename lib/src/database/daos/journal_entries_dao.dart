/// journal_entries_dao.dart
/// عمليات قاعدة البيانات للقيود اليومية وبنودها
library;

import 'package:drift/drift.dart';
import '../../core/enums.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'journal_entries_dao.g.dart';

// نموذج مدمج: قيد + بنده + اسم الحساب
class EntryLineWithAccount {
  final JournalEntryLine line;
  final Account account;

  EntryLineWithAccount({required this.line, required this.account});
}

@DriftAccessor(tables: [
  JournalEntries,
  JournalEntryLines,
  Accounts,
  AccountingPeriods,
  EntryTemplates,
])
class JournalEntriesDao extends DatabaseAccessor<AccountingDatabase>
    with _$JournalEntriesDaoMixin {
  JournalEntriesDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // الفترات المحاسبية - Accounting Periods
  // ─────────────────────────────────────────────────────────────

  Future<List<AccountingPeriod>> getAllPeriods() => (select(accountingPeriods)
        ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
      .get();

  Future<AccountingPeriod?> getPeriodById(int id) =>
      (select(accountingPeriods)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// الفترة التي يقع فيها التاريخ (إن وُجدت).
  /// لا يرمي استثناءً حتى لو وُجدت فترات متداخلة (بيانات قديمة)، ويُعيد أحدثها بدءاً.
  Future<AccountingPeriod?> getPeriodForDate(DateTime date) async {
    final rows = await (select(accountingPeriods)
          ..where((t) => t.startDate.isSmallerOrEqualValue(date))
          ..where((t) => t.endDate.isBiggerOrEqualValue(date))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  /// الفترات التي تتداخل مع النطاق [start, end]
  Future<List<AccountingPeriod>> getOverlappingPeriods(
    DateTime start,
    DateTime end, {
    int? excludeId,
  }) {
    final query = select(accountingPeriods)
      ..where((t) => t.startDate.isSmallerOrEqualValue(end))
      ..where((t) => t.endDate.isBiggerOrEqualValue(start));
    if (excludeId != null) {
      query.where((t) => t.id.equals(excludeId).not());
    }
    return query.get();
  }

  Future<int> insertPeriod(AccountingPeriodsCompanion period) =>
      into(accountingPeriods).insert(period);

  Future<void> updatePeriod(AccountingPeriodsCompanion period) =>
      (update(accountingPeriods)..where((t) => t.id.equals(period.id.value)))
          .write(period);

  Future<int> deletePeriod(int id) =>
      (delete(accountingPeriods)..where((t) => t.id.equals(id))).go();

  /// عدد القيود ضمن نطاق زمني (اختيارياً بحالة معينة)
  Future<int> countEntriesInRange(
    DateTime from,
    DateTime to, {
    EntryStatus? status,
  }) async {
    final count = journalEntries.id.count();
    final query = selectOnly(journalEntries)
      ..addColumns([count])
      ..where(journalEntries.date.isBetweenValues(from, to));
    if (status != null) {
      query.where(journalEntries.status.equals(status.index));
    }
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  // ─────────────────────────────────────────────────────────────
  // تسلسل القيود - Serial Numbers
  // ─────────────────────────────────────────────────────────────

  Future<bool> serialNumberExists(String serial) async {
    final query = select(journalEntries)
      ..where((t) => t.serialNumber.equals(serial));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// يولّد الرقم التالي بصيغة `PREFIX-YYYY-0001`.
  ///
  /// يعتمد على أكبر قيمة رقمية (وليس الترتيب النصي) كي لا ينكسر التسلسل
  /// بعد تجاوز `9999`.
  Future<String> generateNextSerialNumber(
    DateTime date, {
    String prefix = 'JV',
    int padding = 4,
  }) async {
    final yearPrefix = '$prefix-${date.year}-';

    final row = await customSelect(
      'SELECT MAX(CAST(SUBSTR(serial_number, ?) AS INTEGER)) AS max_no '
      'FROM journal_entries WHERE serial_number LIKE ?',
      variables: [
        Variable.withInt(yearPrefix.length + 1),
        Variable.withString('$yearPrefix%'),
      ],
      readsFrom: {journalEntries},
    ).getSingle();

    final nextNumber = (row.read<int?>('max_no') ?? 0) + 1;
    return '$yearPrefix${nextNumber.toString().padLeft(padding, '0')}';
  }

  // ─────────────────────────────────────────────────────────────
  // قراءة القيود
  // ─────────────────────────────────────────────────────────────

  Future<List<JournalEntry>> getAllEntries() =>
      (select(journalEntries)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<JournalEntry?> getEntryById(int id) =>
      (select(journalEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<JournalEntry?> getEntryBySerial(String serial) =>
      (select(journalEntries)..where((t) => t.serialNumber.equals(serial)))
          .getSingleOrNull();

  Future<List<JournalEntry>> getEntriesByReference(String reference) =>
      (select(journalEntries)
            ..where((t) => t.reference.equals(reference))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<JournalEntry>> getEntriesBySource(
    String sourceType,
    String sourceId,
  ) =>
      (select(journalEntries)
            ..where((t) => t.sourceType.equals(sourceType))
            ..where((t) => t.sourceId.equals(sourceId))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();

  /// القيد العكسي لقيد أصلي (إن وُجد)
  Future<JournalEntry?> getReversalOf(int originalId) => (select(journalEntries)
        ..where((t) => t.reversalOfId.equals(originalId))
        ..limit(1))
      .getSingleOrNull();

  Future<List<JournalEntry>> getEntriesByStatus(EntryStatus status) =>
      (select(journalEntries)
            ..where((t) => t.status.equals(status.index))
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
      (select(journalEntries)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  // ─────────────────────────────────────────────────────────────
  // قراءة بنود القيد (مع اسم الحساب)
  // ─────────────────────────────────────────────────────────────

  Future<List<EntryLineWithAccount>> getLinesForEntry(int entryId) async {
    final query = select(journalEntryLines).join([
      innerJoin(accounts, accounts.id.equalsExp(journalEntryLines.accountId)),
    ])
      ..where(journalEntryLines.entryId.equals(entryId))
      ..orderBy([
        OrderingTerm(expression: journalEntryLines.sortOrder),
        OrderingTerm(expression: journalEntryLines.id),
      ]);

    final rows = await query.get();
    return rows
        .map((row) => EntryLineWithAccount(
              line: row.readTable(journalEntryLines),
              account: row.readTable(accounts),
            ))
        .toList();
  }

  /// جلب بنود عدة قيود دفعة واحدة (تفادياً لمشكلة N+1)
  Future<Map<int, List<EntryLineWithAccount>>> getLinesForEntries(
    List<int> entryIds,
  ) async {
    final result = <int, List<EntryLineWithAccount>>{};
    if (entryIds.isEmpty) return result;

    const chunkSize = 500; // حد متغيرات SQLite
    for (var i = 0; i < entryIds.length; i += chunkSize) {
      final chunk = entryIds.sublist(
        i,
        i + chunkSize > entryIds.length ? entryIds.length : i + chunkSize,
      );
      final query = select(journalEntryLines).join([
        innerJoin(accounts, accounts.id.equalsExp(journalEntryLines.accountId)),
      ])
        ..where(journalEntryLines.entryId.isIn(chunk))
        ..orderBy([
          OrderingTerm(expression: journalEntryLines.entryId),
          OrderingTerm(expression: journalEntryLines.sortOrder),
          OrderingTerm(expression: journalEntryLines.id),
        ]);
      for (final row in await query.get()) {
        final line = row.readTable(journalEntryLines);
        result.putIfAbsent(line.entryId, () => []).add(
              EntryLineWithAccount(
                  line: line, account: row.readTable(accounts)),
            );
      }
    }
    return result;
  }

  /// هل يوجد أي بند (بأي حالة) مرتبط بالحساب؟
  Future<bool> accountHasLines(int accountId) async {
    final row = await (select(journalEntryLines)
          ..where((t) => t.accountId.equals(accountId))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  // ─────────────────────────────────────────────────────────────
  // كتابة القيود
  // ─────────────────────────────────────────────────────────────

  Future<int> insertEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<void> updateEntry(JournalEntriesCompanion entry) =>
      (update(journalEntries)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> updateEntryStatus(int entryId, EntryStatus status) =>
      (update(journalEntries)..where((t) => t.id.equals(entryId))).write(
        JournalEntriesCompanion(
          status: Value(status),
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
      (delete(journalEntryLines)..where((t) => t.entryId.equals(entryId))).go();

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

  /// يجلب مجموع المدين والدائن لكل حساب في نطاق زمني.
  ///
  /// - تُحتسب فقط القيود التي تؤثر على الأرصدة: المرحّلة والمعكوسة
  ///   (القيد المعكوس يبقى في الدفتر ويلغيه القيد العكسي المرحّل).
  /// - المسودات لا تدخل في الأرصدة.
  /// - [from] شامل، [toExclusive] غير شامل.
  Future<List<AccountBalanceRow>> getAccountBalances({
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final result = await customSelect(
      '''
      SELECT
        a.id          AS account_id,
        a.code        AS account_code,
        a.name        AS account_name,
        a.name_ar     AS account_name_ar,
        a.type        AS account_type,
        a.parent_id   AS parent_id,
        COALESCE(t.total_debit,  0.0) AS total_debit,
        COALESCE(t.total_credit, 0.0) AS total_credit
      FROM accounts a
      LEFT JOIN (
        SELECT
          l.account_id       AS account_id,
          SUM(l.debit)       AS total_debit,
          SUM(l.credit)      AS total_credit
        FROM journal_entry_lines l
        INNER JOIN journal_entries e ON e.id = l.entry_id
        WHERE e.status IN (?, ?)
          AND (? IS NULL OR e.date >= ?)
          AND (? IS NULL OR e.date < ?)
        GROUP BY l.account_id
      ) t ON t.account_id = a.id
      ORDER BY a.code
      ''',
      variables: [
        Variable.withInt(EntryStatus.posted.index),
        Variable.withInt(EntryStatus.reversed.index),
        Variable<DateTime>(from),
        Variable<DateTime>(from),
        Variable<DateTime>(toExclusive),
        Variable<DateTime>(toExclusive),
      ],
      readsFrom: {accounts, journalEntries, journalEntryLines},
    ).get();

    return result.map(AccountBalanceRow.fromRow).toList();
  }

  /// حركات حساب (أو مجموعة حسابات) من القيود المؤثرة على الأرصدة،
  /// مرتبة زمنياً — تُستخدم لكشف الحساب (دفتر الأستاذ).
  Future<List<LedgerLineRow>> getLedgerLines({
    required List<int> accountIds,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    if (accountIds.isEmpty) return [];
    final placeholders = List.filled(accountIds.length, '?').join(', ');
    final result = await customSelect(
      '''
      SELECT
        e.id            AS entry_id,
        e.serial_number AS serial_number,
        e.date          AS date,
        e.description   AS entry_description,
        e.reference     AS reference,
        l.id            AS line_id,
        l.account_id    AS account_id,
        l.debit         AS debit,
        l.credit        AS credit,
        l.description   AS line_description
      FROM journal_entry_lines l
      INNER JOIN journal_entries e ON e.id = l.entry_id
      WHERE l.account_id IN ($placeholders)
        AND e.status IN (?, ?)
        AND (? IS NULL OR e.date >= ?)
        AND (? IS NULL OR e.date < ?)
      ORDER BY e.date, e.id, l.sort_order, l.id
      ''',
      variables: [
        for (final id in accountIds) Variable.withInt(id),
        Variable.withInt(EntryStatus.posted.index),
        Variable.withInt(EntryStatus.reversed.index),
        Variable<DateTime>(from),
        Variable<DateTime>(from),
        Variable<DateTime>(toExclusive),
        Variable<DateTime>(toExclusive),
      ],
      readsFrom: {journalEntries, journalEntryLines},
    ).get();

    return result
        .map((row) => LedgerLineRow(
              entryId: row.read<int>('entry_id'),
              serialNumber: row.read<String>('serial_number'),
              date: row.read<DateTime>('date'),
              entryDescription: row.read<String>('entry_description'),
              reference: row.read<String?>('reference'),
              lineId: row.read<int>('line_id'),
              accountId: row.read<int>('account_id'),
              debit: row.read<double>('debit'),
              credit: row.read<double>('credit'),
              lineDescription: row.read<String?>('line_description'),
            ))
        .toList();
  }
}

// ─────────────────────────────────────────────────────────────
// نموذج صف رصيد الحساب (لتقديم البيانات للـ Repository)
// ─────────────────────────────────────────────────────────────
class AccountBalanceRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final int accountType;
  final int? parentId;
  final double totalDebit;
  final double totalCredit;

  AccountBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    this.accountNameAr,
    required this.accountType,
    this.parentId,
    required this.totalDebit,
    required this.totalCredit,
  });

  /// الاسم المعروض (عربي إن وُجد)
  String get displayName => accountNameAr ?? accountName;

  factory AccountBalanceRow.fromRow(QueryRow row) => AccountBalanceRow(
        accountId: row.read<int>('account_id'),
        accountCode: row.read<String>('account_code'),
        accountName: row.read<String>('account_name'),
        accountNameAr: row.read<String?>('account_name_ar'),
        accountType: row.read<int>('account_type'),
        parentId: row.read<int?>('parent_id'),
        totalDebit: row.read<double>('total_debit'),
        totalCredit: row.read<double>('total_credit'),
      );
}

// ─────────────────────────────────────────────────────────────
// صف حركة في دفتر الأستاذ (داخلي)
// ─────────────────────────────────────────────────────────────
class LedgerLineRow {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String entryDescription;
  final String? reference;
  final int lineId;
  final int accountId;
  final double debit;
  final double credit;
  final String? lineDescription;

  LedgerLineRow({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.entryDescription,
    required this.reference,
    required this.lineId,
    required this.accountId,
    required this.debit,
    required this.credit,
    required this.lineDescription,
  });
}
