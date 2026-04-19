// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entries_dao.dart';

// ignore_for_file: type=lint
mixin _$JournalEntriesDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $JournalEntryLinesTable get journalEntryLines =>
      attachedDatabase.journalEntryLines;
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
}
