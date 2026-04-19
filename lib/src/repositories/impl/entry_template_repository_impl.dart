/// entry_template_repository_impl.dart
/// تطبيق مستودع القوالب

import '../../core/standard_templates.dart';
import '../../models/entry_template_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../interfaces/interfaces.dart';

class EntryTemplateRepositoryImpl implements IEntryTemplateRepository {
  final IAccountRepository _accountRepo;

  EntryTemplateRepositoryImpl(this._accountRepo);

  @override
  List<EntryTemplateModel> getStandardTemplates() {
    return StandardTemplates.all;
  }

  @override
  Future<List<EntryTemplateModel>> getCustomTemplates() async {
    // TODO: إضافة جدول القوالب في قاعدة البيانات لاحقاً
    return [];
  }

  @override
  Future<EntryTemplateModel> saveTemplate(EntryTemplateModel template) async {
    // TODO: حفظ في قاعدة البيانات
    return template;
  }

  @override
  Future<void> deleteTemplate(int id) async {
    // TODO: حذف من قاعدة البيانات
  }

  @override
  Future<JournalEntryModel> applyTemplate({
    required EntryTemplateModel template,
    required Map<String, int> accountIdMap,
    required double totalAmount,
    DateTime? date,
    String? description,
    String? reference,
  }) async {
    final List<JournalEntryLineModel> lines = [];

    for (final tLine in template.lines) {
      final accountId = accountIdMap[tLine.label];
      if (accountId == null) {
        throw ArgumentError('Missing account ID for label: ${tLine.label}');
      }

      final account = await _accountRepo.getAccountById(accountId);
      if (account == null) {
        throw ArgumentError('Account with ID $accountId not found');
      }

      final amount = totalAmount * tLine.defaultRatio;

      lines.add(JournalEntryLineModel(
        accountId:   account.id!,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        debit:       tLine.isDebit ? amount : 0,
        credit:      tLine.isDebit ? 0 : amount,
        description: tLine.label,
      ));
    }

    return JournalEntryModel(
      date:        date ?? DateTime.now(),
      description: description ?? template.name,
      reference:   reference,
      lines:       lines,
    );
  }
}
