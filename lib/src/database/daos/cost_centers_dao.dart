/// cost_centers_dao.dart
/// عمليات قاعدة البيانات لمراكز التكلفة: الأبعاد، المراكز، القواعد،
/// مفاتيح التوزيع، واستعلامات تقارير المراكز
library;

import 'package:drift/drift.dart';
import '../../core/enums.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'cost_centers_dao.g.dart';

@DriftAccessor(tables: [
  CostDimensions,
  CostCenters,
  JournalLineAllocations,
  CostDimensionRules,
  AllocationKeys,
  AllocationKeyItems,
  JournalEntries,
  JournalEntryLines,
  Accounts,
])
class CostCentersDao extends DatabaseAccessor<AccountingDatabase>
    with _$CostCentersDaoMixin {
  CostCentersDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // الأبعاد - Dimensions
  // ─────────────────────────────────────────────────────────────

  Future<List<CostDimension>> getDimensions({bool activeOnly = false}) {
    final query = select(costDimensions)
      ..orderBy([
        (t) => OrderingTerm(expression: t.sortOrder),
        (t) => OrderingTerm(expression: t.code),
      ]);
    if (activeOnly) query.where((t) => t.isActive.equals(true));
    return query.get();
  }

  Future<CostDimension?> getDimensionById(int id) =>
      (select(costDimensions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<CostDimension?> getDimensionByCode(String code) =>
      (select(costDimensions)..where((t) => t.code.equals(code)))
          .getSingleOrNull();

  Future<bool> dimensionCodeExists(String code, {int? excludeId}) async {
    final query = select(costDimensions)..where((t) => t.code.equals(code));
    if (excludeId != null) query.where((t) => t.id.equals(excludeId).not());
    return (await query.getSingleOrNull()) != null;
  }

  Future<int> insertDimension(CostDimensionsCompanion entry) =>
      into(costDimensions).insert(entry);

  Future<void> updateDimension(CostDimensionsCompanion entry) =>
      (update(costDimensions)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> setDimensionActive(int id, bool isActive) =>
      (update(costDimensions)..where((t) => t.id.equals(id))).write(
        CostDimensionsCompanion(
          isActive: Value(isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// حذف بعد مع قواعده ومفاتيح توزيعه (يُفترض أنه بلا مراكز)
  Future<void> deleteDimension(int id) => transaction(() async {
        await (delete(costDimensionRules)
              ..where((t) => t.dimensionId.equals(id)))
            .go();
        final keyIds = await (selectOnly(allocationKeys)
              ..addColumns([allocationKeys.id])
              ..where(allocationKeys.dimensionId.equals(id)))
            .map((r) => r.read(allocationKeys.id)!)
            .get();
        for (final keyId in keyIds) {
          await deleteKey(keyId);
        }
        await (delete(costDimensions)..where((t) => t.id.equals(id))).go();
      });

  Future<int> countCentersInDimension(int dimensionId) async {
    final count = costCenters.id.count();
    final row = await (selectOnly(costCenters)
          ..addColumns([count])
          ..where(costCenters.dimensionId.equals(dimensionId)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  // ─────────────────────────────────────────────────────────────
  // المراكز - Cost Centers
  // ─────────────────────────────────────────────────────────────

  SimpleSelectStatement<$CostCentersTable, CostCenter> _centersQuery({
    int? dimensionId,
    bool activeOnly = false,
  }) {
    final query = select(costCenters)
      ..orderBy([(t) => OrderingTerm(expression: t.code)]);
    if (dimensionId != null) {
      query.where((t) => t.dimensionId.equals(dimensionId));
    }
    if (activeOnly) query.where((t) => t.isActive.equals(true));
    return query;
  }

  Future<List<CostCenter>> getCenters({
    int? dimensionId,
    bool activeOnly = false,
  }) =>
      _centersQuery(dimensionId: dimensionId, activeOnly: activeOnly).get();

  Stream<List<CostCenter>> watchCenters({int? dimensionId}) =>
      _centersQuery(dimensionId: dimensionId).watch();

  Future<CostCenter?> getCenterById(int id) =>
      (select(costCenters)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<CostCenter?> getCenterByCode(String code) =>
      (select(costCenters)..where((t) => t.code.equals(code)))
          .getSingleOrNull();

  Future<List<CostCenter>> getChildCenters(int parentId) => (select(costCenters)
        ..where((t) => t.parentId.equals(parentId))
        ..orderBy([(t) => OrderingTerm(expression: t.code)]))
      .get();

  /// المراكز النهائية (Leaf) النشطة في أبعاد نشطة - المسموح التوزيع عليها
  Future<List<CostCenter>> getPostableCenters({int? dimensionId}) {
    final query = select(costCenters).join([
      innerJoin(
          costDimensions, costDimensions.id.equalsExp(costCenters.dimensionId)),
    ])
      ..where(costCenters.isActive.equals(true) &
          costDimensions.isActive.equals(true) &
          notExistsQuery(
            select(alias(costCenters, 'c'))
              ..where((c) => c.parentId.equalsExp(costCenters.id)),
          ))
      ..orderBy([OrderingTerm(expression: costCenters.code)]);
    if (dimensionId != null) {
      query.where(costCenters.dimensionId.equals(dimensionId));
    }
    return query.map((row) => row.readTable(costCenters)).get();
  }

  Future<List<CostCenter>> searchCenters(String text, {int? dimensionId}) {
    final pattern = '%${text.trim()}%';
    final query = _centersQuery(dimensionId: dimensionId)
      ..where((t) =>
          t.code.like(pattern) | t.name.like(pattern) | t.nameAr.like(pattern));
    return query.get();
  }

  Future<bool> centerCodeExists(String code, {int? excludeId}) async {
    final query = select(costCenters)..where((t) => t.code.equals(code));
    if (excludeId != null) query.where((t) => t.id.equals(excludeId).not());
    return (await query.getSingleOrNull()) != null;
  }

  Future<bool> centerHasChildren(int id) async {
    final row = await (select(costCenters)
          ..where((t) => t.parentId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  /// معرّفات كل المراكز المتفرعة من مركز (بدون المركز نفسه)
  Future<List<int>> getDescendantIds(int centerId) async {
    final rows = await customSelect(
      '''
      WITH RECURSIVE tree(id) AS (
        SELECT id FROM cost_centers WHERE parent_id = ?
        UNION ALL
        SELECT c.id FROM cost_centers c INNER JOIN tree ON c.parent_id = tree.id
      )
      SELECT id FROM tree
      ''',
      variables: [Variable.withInt(centerId)],
      readsFrom: {costCenters},
    ).get();
    return rows.map((r) => r.read<int>('id')).toList();
  }

  /// هل للمركز حركات في أي قيد (بأي حالة)؟
  Future<bool> centerHasAllocations(int id) async {
    final row = await (select(journalLineAllocations)
          ..where((t) => t.costCenterId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  /// هل المركز مستخدم في مفتاح توزيع أو كمركز افتراضي في قاعدة؟
  Future<bool> centerIsReferenced(int id) async {
    final item = await (select(allocationKeyItems)
          ..where((t) => t.costCenterId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (item != null) return true;
    final rule = await (select(costDimensionRules)
          ..where((t) => t.defaultCostCenterId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    return rule != null;
  }

  Future<int> insertCenter(CostCentersCompanion entry) =>
      into(costCenters).insert(entry);

  Future<void> updateCenter(CostCentersCompanion entry) =>
      (update(costCenters)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> setCenterActive(int id, bool isActive) =>
      (update(costCenters)..where((t) => t.id.equals(id))).write(
        CostCentersCompanion(
          isActive: Value(isActive),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> setCenterLevel(int id, int level) =>
      (update(costCenters)..where((t) => t.id.equals(id)))
          .write(CostCentersCompanion(level: Value(level)));

  Future<int> deleteCenter(int id) =>
      (delete(costCenters)..where((t) => t.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────
  // القواعد - Dimension Rules
  // ─────────────────────────────────────────────────────────────

  Future<List<CostDimensionRule>> getRules({int? dimensionId}) {
    final query = select(costDimensionRules)
      ..orderBy([(t) => OrderingTerm(expression: t.id)]);
    if (dimensionId != null) {
      query.where((t) => t.dimensionId.equals(dimensionId));
    }
    return query.get();
  }

  Future<CostDimensionRule?> getRuleById(int id) =>
      (select(costDimensionRules)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// القاعدة الموجودة لنفس الهدف (حساب أو نوع حساب) في نفس البعد
  Future<CostDimensionRule?> findRule({
    required int dimensionId,
    int? accountId,
    AccountType? accountType,
  }) {
    final query = select(costDimensionRules)
      ..where((t) => t.dimensionId.equals(dimensionId))
      ..limit(1);
    if (accountId != null) {
      query.where((t) => t.accountId.equals(accountId));
    } else {
      query.where((t) =>
          t.accountId.isNull() & t.accountType.equals(accountType!.index));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertRule(CostDimensionRulesCompanion entry) =>
      into(costDimensionRules).insert(entry);

  Future<void> updateRule(CostDimensionRulesCompanion entry) =>
      (update(costDimensionRules)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<int> deleteRule(int id) =>
      (delete(costDimensionRules)..where((t) => t.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────
  // مفاتيح التوزيع - Allocation Keys
  // ─────────────────────────────────────────────────────────────

  Future<List<AllocationKey>> getKeys({int? dimensionId}) {
    final query = select(allocationKeys)
      ..orderBy([(t) => OrderingTerm(expression: t.code)]);
    if (dimensionId != null) {
      query.where((t) => t.dimensionId.equals(dimensionId));
    }
    return query.get();
  }

  Future<AllocationKey?> getKeyById(int id) =>
      (select(allocationKeys)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<AllocationKey?> getKeyByCode(String code) =>
      (select(allocationKeys)..where((t) => t.code.equals(code)))
          .getSingleOrNull();

  Future<bool> keyCodeExists(String code, {int? excludeId}) async {
    final query = select(allocationKeys)..where((t) => t.code.equals(code));
    if (excludeId != null) query.where((t) => t.id.equals(excludeId).not());
    return (await query.getSingleOrNull()) != null;
  }

  /// بنود عدة مفاتيح مع بيانات مراكزها (مجمّعة حسب معرّف المفتاح)
  Future<Map<int, List<(AllocationKeyItem, CostCenter)>>> getKeyItems(
      List<int> keyIds) async {
    final result = <int, List<(AllocationKeyItem, CostCenter)>>{};
    if (keyIds.isEmpty) return result;
    final query = select(allocationKeyItems).join([
      innerJoin(costCenters,
          costCenters.id.equalsExp(allocationKeyItems.costCenterId)),
    ])
      ..where(allocationKeyItems.keyId.isIn(keyIds))
      ..orderBy([
        OrderingTerm(expression: allocationKeyItems.keyId),
        OrderingTerm(expression: allocationKeyItems.id),
      ]);
    for (final row in await query.get()) {
      final item = row.readTable(allocationKeyItems);
      result
          .putIfAbsent(item.keyId, () => [])
          .add((item, row.readTable(costCenters)));
    }
    return result;
  }

  Future<int> insertKey(AllocationKeysCompanion entry) =>
      into(allocationKeys).insert(entry);

  Future<void> updateKey(AllocationKeysCompanion entry) =>
      (update(allocationKeys)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> replaceKeyItems(
    int keyId,
    List<AllocationKeyItemsCompanion> items,
  ) =>
      transaction(() async {
        await (delete(allocationKeyItems)..where((t) => t.keyId.equals(keyId)))
            .go();
        for (final item in items) {
          await into(allocationKeyItems)
              .insert(item.copyWith(keyId: Value(keyId)));
        }
      });

  Future<void> deleteKey(int id) => transaction(() async {
        await (delete(allocationKeyItems)..where((t) => t.keyId.equals(id)))
            .go();
        await (delete(allocationKeys)..where((t) => t.id.equals(id))).go();
      });

  // ─────────────────────────────────────────────────────────────
  // استعلامات التقارير
  //
  // كلها تحتسب القيود المؤثرة على الأرصدة فقط (المرحّلة والمعكوسة)،
  // و[from] شامل و[toExclusive] غير شامل. حصة المركز تأخذ جهة البند:
  // بند مدين → حصة مدينة، بند دائن → حصة دائنة.
  // ─────────────────────────────────────────────────────────────

  List<Variable> _statusAndDates(DateTime? from, DateTime? toExclusive) => [
        Variable.withInt(EntryStatus.posted.index),
        Variable.withInt(EntryStatus.reversed.index),
        Variable<DateTime>(from),
        Variable<DateTime>(from),
        Variable<DateTime>(toExclusive),
        Variable<DateTime>(toExclusive),
      ];

  static const _entryFilter = '''
        e.status IN (?, ?)
        AND (? IS NULL OR e.date >= ?)
        AND (? IS NULL OR e.date < ?)''';

  /// مجموع المدين والدائن لكل (مركز، حساب) في بُعد
  Future<List<CenterAccountTotalRow>> getCenterAccountTotals({
    required int dimensionId,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        a.cost_center_id AS cost_center_id,
        l.account_id     AS account_id,
        SUM(CASE WHEN l.debit  > 0 THEN a.amount ELSE 0.0 END) AS total_debit,
        SUM(CASE WHEN l.credit > 0 THEN a.amount ELSE 0.0 END) AS total_credit
      FROM journal_line_allocations a
      INNER JOIN journal_entry_lines l ON l.id = a.line_id
      INNER JOIN journal_entries e ON e.id = l.entry_id
      WHERE a.dimension_id = ?
        AND $_entryFilter
      GROUP BY a.cost_center_id, l.account_id
      ''',
      variables: [
        Variable.withInt(dimensionId),
        ..._statusAndDates(from, toExclusive),
      ],
      readsFrom: {journalLineAllocations, journalEntryLines, journalEntries},
    ).get();
    return rows.map(CenterAccountTotalRow.fromRow).toList();
  }

  /// الجزء غير الموزَّع على مراكز البعد لكل حساب
  /// (مبلغ البند ناقص مجموع حصصه في هذا البعد)
  Future<List<CenterAccountTotalRow>> getUnallocatedAccountTotals({
    required int dimensionId,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        NULL         AS cost_center_id,
        l.account_id AS account_id,
        SUM(CASE WHEN l.debit  > 0 THEN l.debit  - COALESCE(x.allocated, 0.0) ELSE 0.0 END) AS total_debit,
        SUM(CASE WHEN l.credit > 0 THEN l.credit - COALESCE(x.allocated, 0.0) ELSE 0.0 END) AS total_credit
      FROM journal_entry_lines l
      INNER JOIN journal_entries e ON e.id = l.entry_id
      LEFT JOIN (
        SELECT line_id, SUM(amount) AS allocated
        FROM journal_line_allocations
        WHERE dimension_id = ?
        GROUP BY line_id
      ) x ON x.line_id = l.id
      WHERE $_entryFilter
      GROUP BY l.account_id
      ''',
      variables: [
        Variable.withInt(dimensionId),
        ..._statusAndDates(from, toExclusive),
      ],
      readsFrom: {journalLineAllocations, journalEntryLines, journalEntries},
    ).get();
    return rows
        .map(CenterAccountTotalRow.fromRow)
        .where((r) => r.totalDebit.abs() > 1e-9 || r.totalCredit.abs() > 1e-9)
        .toList();
  }

  /// تفاصيل الحصص (سطر لكل حصة) مع بيانات القيد والبند، مرتبة زمنياً.
  /// [costCenterIds] و[dimensionIds] فلاتر اختيارية.
  Future<List<AllocationDetailRow>> getAllocationRows({
    List<int>? costCenterIds,
    List<int>? dimensionIds,
    List<int>? accountIds,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    String inClause(String column, List<int>? ids) => ids == null
        ? ''
        : ids.isEmpty
            ? 'AND 0'
            : 'AND $column IN (${List.filled(ids.length, '?').join(', ')})';

    final rows = await customSelect(
      '''
      SELECT
        e.id            AS entry_id,
        e.serial_number AS serial_number,
        e.date          AS date,
        e.description   AS entry_description,
        e.reference     AS reference,
        l.id            AS line_id,
        l.account_id    AS account_id,
        l.debit         AS line_debit,
        l.credit        AS line_credit,
        l.description   AS line_description,
        a.dimension_id  AS dimension_id,
        a.cost_center_id AS cost_center_id,
        a.amount        AS amount
      FROM journal_line_allocations a
      INNER JOIN journal_entry_lines l ON l.id = a.line_id
      INNER JOIN journal_entries e ON e.id = l.entry_id
      WHERE $_entryFilter
        ${inClause('a.cost_center_id', costCenterIds)}
        ${inClause('a.dimension_id', dimensionIds)}
        ${inClause('l.account_id', accountIds)}
      ORDER BY e.date, e.id, l.sort_order, l.id, a.id
      ''',
      variables: [
        ..._statusAndDates(from, toExclusive),
        for (final id in costCenterIds ?? const <int>[]) Variable.withInt(id),
        for (final id in dimensionIds ?? const <int>[]) Variable.withInt(id),
        for (final id in accountIds ?? const <int>[]) Variable.withInt(id),
      ],
      readsFrom: {journalLineAllocations, journalEntryLines, journalEntries},
    ).get();
    return rows.map(AllocationDetailRow.fromRow).toList();
  }

  /// البنود التي لم تُوزَّع (كلياً أو جزئياً) على مراكز البعد
  Future<List<UnallocatedLineRow>> getUnallocatedLines({
    required int dimensionId,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        e.id            AS entry_id,
        e.serial_number AS serial_number,
        e.date          AS date,
        e.description   AS entry_description,
        e.reference     AS reference,
        l.id            AS line_id,
        l.account_id    AS account_id,
        l.debit         AS line_debit,
        l.credit        AS line_credit,
        l.description   AS line_description,
        COALESCE(x.allocated, 0.0) AS allocated
      FROM journal_entry_lines l
      INNER JOIN journal_entries e ON e.id = l.entry_id
      LEFT JOIN (
        SELECT line_id, SUM(amount) AS allocated
        FROM journal_line_allocations
        WHERE dimension_id = ?
        GROUP BY line_id
      ) x ON x.line_id = l.id
      WHERE $_entryFilter
        AND (l.debit + l.credit) - COALESCE(x.allocated, 0.0) > 0.0005
      ORDER BY e.date, e.id, l.sort_order, l.id
      ''',
      variables: [
        Variable.withInt(dimensionId),
        ..._statusAndDates(from, toExclusive),
      ],
      readsFrom: {journalLineAllocations, journalEntryLines, journalEntries},
    ).get();
    return rows.map(UnallocatedLineRow.fromRow).toList();
  }
}

// ─────────────────────────────────────────────────────────────
// صفوف الاستعلامات (داخلية)
// ─────────────────────────────────────────────────────────────

/// مجموع حركة حساب على مركز (أو غير موزّع إن كان [costCenterId] = null)
class CenterAccountTotalRow {
  final int? costCenterId;
  final int accountId;
  final double totalDebit;
  final double totalCredit;

  CenterAccountTotalRow({
    required this.costCenterId,
    required this.accountId,
    required this.totalDebit,
    required this.totalCredit,
  });

  factory CenterAccountTotalRow.fromRow(QueryRow row) => CenterAccountTotalRow(
        costCenterId: row.read<int?>('cost_center_id'),
        accountId: row.read<int>('account_id'),
        totalDebit: row.read<double?>('total_debit') ?? 0,
        totalCredit: row.read<double?>('total_credit') ?? 0,
      );
}

/// حصة مركز من بند، مع بيانات القيد والبند
class AllocationDetailRow {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String entryDescription;
  final String? reference;
  final int lineId;
  final int accountId;
  final double lineDebit;
  final double lineCredit;
  final String? lineDescription;
  final int dimensionId;
  final int costCenterId;
  final double amount;

  AllocationDetailRow({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.entryDescription,
    required this.reference,
    required this.lineId,
    required this.accountId,
    required this.lineDebit,
    required this.lineCredit,
    required this.lineDescription,
    required this.dimensionId,
    required this.costCenterId,
    required this.amount,
  });

  bool get isDebit => lineDebit > 0;
  double get lineAmount => isDebit ? lineDebit : lineCredit;
  double get debit => isDebit ? amount : 0;
  double get credit => isDebit ? 0 : amount;

  factory AllocationDetailRow.fromRow(QueryRow row) => AllocationDetailRow(
        entryId: row.read<int>('entry_id'),
        serialNumber: row.read<String>('serial_number'),
        date: row.read<DateTime>('date'),
        entryDescription: row.read<String>('entry_description'),
        reference: row.read<String?>('reference'),
        lineId: row.read<int>('line_id'),
        accountId: row.read<int>('account_id'),
        lineDebit: row.read<double>('line_debit'),
        lineCredit: row.read<double>('line_credit'),
        lineDescription: row.read<String?>('line_description'),
        dimensionId: row.read<int>('dimension_id'),
        costCenterId: row.read<int>('cost_center_id'),
        amount: row.read<double>('amount'),
      );
}

/// بند لم يُوزَّع بالكامل على مراكز بُعد
class UnallocatedLineRow {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String entryDescription;
  final String? reference;
  final int lineId;
  final int accountId;
  final double lineDebit;
  final double lineCredit;
  final String? lineDescription;
  final double allocated;

  UnallocatedLineRow({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.entryDescription,
    required this.reference,
    required this.lineId,
    required this.accountId,
    required this.lineDebit,
    required this.lineCredit,
    required this.lineDescription,
    required this.allocated,
  });

  factory UnallocatedLineRow.fromRow(QueryRow row) => UnallocatedLineRow(
        entryId: row.read<int>('entry_id'),
        serialNumber: row.read<String>('serial_number'),
        date: row.read<DateTime>('date'),
        entryDescription: row.read<String>('entry_description'),
        reference: row.read<String?>('reference'),
        lineId: row.read<int>('line_id'),
        accountId: row.read<int>('account_id'),
        lineDebit: row.read<double>('line_debit'),
        lineCredit: row.read<double>('line_credit'),
        lineDescription: row.read<String?>('line_description'),
        allocated: row.read<double>('allocated'),
      );
}
