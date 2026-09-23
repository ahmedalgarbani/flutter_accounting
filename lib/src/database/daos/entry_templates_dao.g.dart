// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_templates_dao.dart';

// ignore_for_file: type=lint
mixin _$EntryTemplatesDaoMixin on DatabaseAccessor<AccountingDatabase> {
  $EntryTemplatesTable get entryTemplates => attachedDatabase.entryTemplates;
  EntryTemplatesDaoManager get managers => EntryTemplatesDaoManager(this);
}

class EntryTemplatesDaoManager {
  final _$EntryTemplatesDaoMixin _db;
  EntryTemplatesDaoManager(this._db);
  $$EntryTemplatesTableTableManager get entryTemplates =>
      $$EntryTemplatesTableTableManager(
          _db.attachedDatabase, _db.entryTemplates);
}
