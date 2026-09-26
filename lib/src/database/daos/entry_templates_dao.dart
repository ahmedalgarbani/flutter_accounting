/// entry_templates_dao.dart
/// عمليات قاعدة البيانات الخاصة بالقوالب المخصصة
library;

import 'package:drift/drift.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'entry_templates_dao.g.dart';

@DriftAccessor(tables: [EntryTemplates])
class EntryTemplatesDao extends DatabaseAccessor<AccountingDatabase>
    with _$EntryTemplatesDaoMixin {
  EntryTemplatesDao(super.db);

  Future<List<EntryTemplate>> getAllTemplates() => (select(entryTemplates)
        ..orderBy([(t) => OrderingTerm(expression: t.name)]))
      .get();

  Future<EntryTemplate?> getTemplateById(int id) =>
      (select(entryTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTemplate(EntryTemplatesCompanion template) =>
      into(entryTemplates).insert(template);

  Future<void> updateTemplate(EntryTemplatesCompanion template) =>
      (update(entryTemplates)..where((t) => t.id.equals(template.id.value)))
          .write(template);

  Future<int> deleteTemplate(int id) =>
      (delete(entryTemplates)..where((t) => t.id.equals(id))).go();
}
