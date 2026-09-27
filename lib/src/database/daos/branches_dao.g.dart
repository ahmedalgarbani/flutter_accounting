// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_dao.dart';

// ignore_for_file: type=lint
mixin _$BranchesDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CostDimensionsTable get costDimensions => attachedDatabase.costDimensions;
  $CostCentersTable get costCenters => attachedDatabase.costCenters;
  $BranchesTable get branches => attachedDatabase.branches;
  $AccountingPeriodsTable get accountingPeriods =>
      attachedDatabase.accountingPeriods;
  $BranchPeriodClosuresTable get branchPeriodClosures =>
      attachedDatabase.branchPeriodClosures;
  $AccountBranchesTable get accountBranches => attachedDatabase.accountBranches;
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  BranchesDaoManager get managers => BranchesDaoManager(this);
}

class BranchesDaoManager {
  final _$BranchesDaoMixin _db;
  BranchesDaoManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$CostDimensionsTableTableManager get costDimensions =>
      $$CostDimensionsTableTableManager(
          _db.attachedDatabase, _db.costDimensions);
  $$CostCentersTableTableManager get costCenters =>
      $$CostCentersTableTableManager(_db.attachedDatabase, _db.costCenters);
  $$BranchesTableTableManager get branches =>
      $$BranchesTableTableManager(_db.attachedDatabase, _db.branches);
  $$AccountingPeriodsTableTableManager get accountingPeriods =>
      $$AccountingPeriodsTableTableManager(
          _db.attachedDatabase, _db.accountingPeriods);
  $$BranchPeriodClosuresTableTableManager get branchPeriodClosures =>
      $$BranchPeriodClosuresTableTableManager(
          _db.attachedDatabase, _db.branchPeriodClosures);
  $$AccountBranchesTableTableManager get accountBranches =>
      $$AccountBranchesTableTableManager(
          _db.attachedDatabase, _db.accountBranches);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(
          _db.attachedDatabase, _db.journalEntries);
}
