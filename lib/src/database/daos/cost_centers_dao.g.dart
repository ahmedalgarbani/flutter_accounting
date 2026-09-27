// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_centers_dao.dart';

// ignore_for_file: type=lint
mixin _$CostCentersDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $CostDimensionsTable get costDimensions => attachedDatabase.costDimensions;
  $CostCentersTable get costCenters => attachedDatabase.costCenters;
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $JournalEntryLinesTable get journalEntryLines =>
      attachedDatabase.journalEntryLines;
  $JournalLineAllocationsTable get journalLineAllocations =>
      attachedDatabase.journalLineAllocations;
  $CostDimensionRulesTable get costDimensionRules =>
      attachedDatabase.costDimensionRules;
  $AllocationKeysTable get allocationKeys => attachedDatabase.allocationKeys;
  $AllocationKeyItemsTable get allocationKeyItems =>
      attachedDatabase.allocationKeyItems;
  CostCentersDaoManager get managers => CostCentersDaoManager(this);
}

class CostCentersDaoManager {
  final _$CostCentersDaoMixin _db;
  CostCentersDaoManager(this._db);
  $$CostDimensionsTableTableManager get costDimensions =>
      $$CostDimensionsTableTableManager(
          _db.attachedDatabase, _db.costDimensions);
  $$CostCentersTableTableManager get costCenters =>
      $$CostCentersTableTableManager(_db.attachedDatabase, _db.costCenters);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(
          _db.attachedDatabase, _db.journalEntries);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(
          _db.attachedDatabase, _db.journalEntryLines);
  $$JournalLineAllocationsTableTableManager get journalLineAllocations =>
      $$JournalLineAllocationsTableTableManager(
          _db.attachedDatabase, _db.journalLineAllocations);
  $$CostDimensionRulesTableTableManager get costDimensionRules =>
      $$CostDimensionRulesTableTableManager(
          _db.attachedDatabase, _db.costDimensionRules);
  $$AllocationKeysTableTableManager get allocationKeys =>
      $$AllocationKeysTableTableManager(
          _db.attachedDatabase, _db.allocationKeys);
  $$AllocationKeyItemsTableTableManager get allocationKeyItems =>
      $$AllocationKeyItemsTableTableManager(
          _db.attachedDatabase, _db.allocationKeyItems);
}
