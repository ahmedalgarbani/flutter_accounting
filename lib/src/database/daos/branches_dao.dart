/// branches_dao.dart
/// عمليات قاعدة البيانات للفروع وإقفال فتراتها وتقييد الحسابات
library;

import 'package:drift/drift.dart';
import '../../core/enums.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'branches_dao.g.dart';

@DriftAccessor(tables: [
  Branches,
  BranchPeriodClosures,
  AccountBranches,
  JournalEntries,
])
class BranchesDao extends DatabaseAccessor<AccountingDatabase>
    with _$BranchesDaoMixin {
  BranchesDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // الفروع
  // ─────────────────────────────────────────────────────────────

  Future<List<Branch>> getBranches({bool activeOnly = false}) {
    final query = select(branches)
      ..orderBy([(t) => OrderingTerm(expression: t.code)]);
    if (activeOnly) query.where((t) => t.isActive.equals(true));
    return query.get();
  }

  Future<Branch?> getBranchById(int id) =>
      (select(branches)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Branch?> getBranchByCode(String code) =>
      (select(branches)..where((t) => t.code.equals(code))).getSingleOrNull();

  Future<bool> codeExists(String code, {int? excludeId}) async {
    final query = select(branches)..where((t) => t.code.equals(code));
    if (excludeId != null) query.where((t) => t.id.equals(excludeId).not());
    return (await query.getSingleOrNull()) != null;
  }

  Future<int> insertBranch(BranchesCompanion entry) =>
      into(branches).insert(entry);

  Future<void> updateBranch(BranchesCompanion entry) =>
      (update(branches)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  Future<void> deleteBranch(int id) => transaction(() async {
        await (delete(accountBranches)..where((t) => t.branchId.equals(id)))
            .go();
        await (delete(branchPeriodClosures)
              ..where((t) => t.branchId.equals(id)))
            .go();
        await (delete(branches)..where((t) => t.id.equals(id))).go();
      });

  Future<bool> branchHasEntries(int id) async =>
      (await (select(journalEntries)
            ..where((t) => t.branchId.equals(id))
            ..limit(1))
          .getSingleOrNull()) !=
      null;

  /// عدد مسودات الفرع في نطاق زمني
  Future<int> countDrafts(int branchId, DateTime from, DateTime to) async {
    final count = journalEntries.id.count();
    final row = await (selectOnly(journalEntries)
          ..addColumns([count])
          ..where(journalEntries.branchId.equals(branchId) &
              journalEntries.status.equals(EntryStatus.draft.index) &
              journalEntries.date.isBetweenValues(from, to)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  // ─────────────────────────────────────────────────────────────
  // إقفال الفترات لكل فرع
  // ─────────────────────────────────────────────────────────────

  Future<bool> isPeriodClosed(int periodId, int branchId) async =>
      (await (select(branchPeriodClosures)
            ..where((t) =>
                t.periodId.equals(periodId) & t.branchId.equals(branchId)))
          .getSingleOrNull()) !=
      null;

  Future<void> closePeriod(int periodId, int branchId) =>
      into(branchPeriodClosures).insert(
        BranchPeriodClosuresCompanion.insert(
            periodId: periodId, branchId: branchId),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> reopenPeriod(int periodId, int branchId) =>
      (delete(branchPeriodClosures)
            ..where((t) =>
                t.periodId.equals(periodId) & t.branchId.equals(branchId)))
          .go();

  Future<List<int>> getClosedPeriodIds(int branchId) =>
      (selectOnly(branchPeriodClosures)
            ..addColumns([branchPeriodClosures.periodId])
            ..where(branchPeriodClosures.branchId.equals(branchId)))
          .map((r) => r.read(branchPeriodClosures.periodId)!)
          .get();

  // ─────────────────────────────────────────────────────────────
  // تقييد الحسابات بالفروع
  // ─────────────────────────────────────────────────────────────

  Future<List<int>> getAccountBranchIds(int accountId) =>
      (selectOnly(accountBranches)
            ..addColumns([accountBranches.branchId])
            ..where(accountBranches.accountId.equals(accountId)))
          .map((r) => r.read(accountBranches.branchId)!)
          .get();

  Future<void> setAccountBranches(int accountId, List<int> branchIds) =>
      transaction(() async {
        await (delete(accountBranches)
              ..where((t) => t.accountId.equals(accountId)))
            .go();
        for (final id in branchIds.toSet()) {
          await into(accountBranches).insert(AccountBranchesCompanion.insert(
              accountId: accountId, branchId: id));
        }
      });
}
