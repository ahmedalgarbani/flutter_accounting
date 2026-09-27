// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies_dao.dart';

// ignore_for_file: type=lint
mixin _$CurrenciesDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $CurrenciesTable get currencies => attachedDatabase.currencies;
  $ExchangeRatesTable get exchangeRates => attachedDatabase.exchangeRates;
  $AccountingSettingsTable get accountingSettings =>
      attachedDatabase.accountingSettings;
  $JournalEntriesTable get journalEntries => attachedDatabase.journalEntries;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $JournalEntryLinesTable get journalEntryLines =>
      attachedDatabase.journalEntryLines;
  CurrenciesDaoManager get managers => CurrenciesDaoManager(this);
}

class CurrenciesDaoManager {
  final _$CurrenciesDaoMixin _db;
  CurrenciesDaoManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db.attachedDatabase, _db.currencies);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db.attachedDatabase, _db.exchangeRates);
  $$AccountingSettingsTableTableManager get accountingSettings =>
      $$AccountingSettingsTableTableManager(
          _db.attachedDatabase, _db.accountingSettings);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(
          _db.attachedDatabase, _db.journalEntries);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(
          _db.attachedDatabase, _db.journalEntryLines);
}
