// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entries_dao.dart';

// ignore_for_file: type=lint
mixin _$JournalEntriesDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $JournalEntryLinesTable get journalEntryLines =>
      attachedDatabase.journalEntryLines;
  $AccountingPeriodsTable get accountingPeriods =>
      attachedDatabase.accountingPeriods;
  $EntryTemplatesTable get entryTemplates => attachedDatabase.entryTemplates;
  $CostDimensionsTable get costDimensions => attachedDatabase.costDimensions;
  $CostCentersTable get costCenters => attachedDatabase.costCenters;
  $JournalLineAllocationsTable get journalLineAllocations =>
      attachedDatabase.journalLineAllocations;
  JournalEntriesDaoManager get managers => JournalEntriesDaoManager(this);
}

class JournalEntriesDaoManager {
  final _$JournalEntriesDaoMixin _db;
  JournalEntriesDaoManager(this._db);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(
          _db.attachedDatabase, _db.journalEntries);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(
          _db.attachedDatabase, _db.journalEntryLines);
  $$AccountingPeriodsTableTableManager get accountingPeriods =>
      $$AccountingPeriodsTableTableManager(
          _db.attachedDatabase, _db.accountingPeriods);
  $$EntryTemplatesTableTableManager get entryTemplates =>
      $$EntryTemplatesTableTableManager(
          _db.attachedDatabase, _db.entryTemplates);
  $$CostDimensionsTableTableManager get costDimensions =>
      $$CostDimensionsTableTableManager(
          _db.attachedDatabase, _db.costDimensions);
  $$CostCentersTableTableManager get costCenters =>
      $$CostCentersTableTableManager(_db.attachedDatabase, _db.costCenters);
  $$JournalLineAllocationsTableTableManager get journalLineAllocations =>
      $$JournalLineAllocationsTableTableManager(
          _db.attachedDatabase, _db.journalLineAllocations);
}
