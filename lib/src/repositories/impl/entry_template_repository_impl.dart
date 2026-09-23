/// entry_template_repository_impl.dart
/// تطبيق مستودع القوالب
library;

import '../../core/exceptions.dart';
import '../../core/standard_templates.dart';
import '../../database/daos/entry_templates_dao.dart';
import '../../database/mappers/mappers.dart';
import '../../models/entry_template_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../interfaces/interfaces.dart';

class EntryTemplateRepositoryImpl implements IEntryTemplateRepository {
  final IAccountRepository _accountRepo;
  final EntryTemplatesDao? _templatesDao;

  EntryTemplateRepositoryImpl(this._accountRepo, [this._templatesDao]);

  EntryTemplatesDao get _dao {
    final dao = _templatesDao;
    if (dao == null) {
      throw StateError('EntryTemplatesDao غير متوفر لحفظ القوالب المخصصة.');
    }
    return dao;
  }

  @override
  List<EntryTemplateModel> getStandardTemplates() {
    return StandardTemplates.all;
  }

  @override
  Future<List<EntryTemplateModel>> getCustomTemplates() async {
    final list = await _dao.getAllTemplates();
    return list.map(EntryTemplateMapper.fromData).toList();
  }

  @override
  Future<EntryTemplateModel> saveTemplate(EntryTemplateModel template) async {
    _validateTemplate(template);
    final companion = EntryTemplateMapper.toCompanion(template);
    if (template.id == null) {
      final id = await _dao.insertTemplate(companion);
      return template.copyWith(id: id);
    }
    await _dao.updateTemplate(companion);
    return template;
  }

  @override
  Future<void> deleteTemplate(int id) async {
    await _dao.deleteTemplate(id);
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
    _validateTemplate(template);
    if (totalAmount <= 0) {
      throw const InvalidTemplateException('المبلغ الإجمالي يجب أن يكون أكبر من صفر.');
    }

    final List<JournalEntryLineModel> lines = [];

    for (var i = 0; i < template.lines.length; i++) {
      final tLine = template.lines[i];

      // الأولوية للحساب المختار في الخريطة، ثم الحساب الثابت في القالب
      final accountId = accountIdMap[tLine.label] ?? tLine.accountId;
      if (accountId == null) {
        throw InvalidTemplateException('لم يتم اختيار حساب للبند "${tLine.label}".');
      }

      final account = await _accountRepo.getAccountById(accountId);
      if (account == null) throw AccountNotFoundException(accountId);

      if (tLine.accountType != null && account.type != tLine.accountType) {
        throw InvalidTemplateException(
          'الحساب "${account.code}" لا يطابق النوع المطلوب للبند "${tLine.label}".',
        );
      }

      final amount = _round(totalAmount * tLine.defaultRatio);

      lines.add(JournalEntryLineModel(
        accountId:   account.id!,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        debit:       tLine.isDebit ? amount : 0,
        credit:      tLine.isDebit ? 0 : amount,
        description: tLine.label,
        sortOrder:   i,
      ));
    }

    return JournalEntryModel(
      date:        date ?? DateTime.now(),
      description: description ?? template.name,
      reference:   reference,
      entryType:   template.type,
      lines:       lines,
    );
  }

  void _validateTemplate(EntryTemplateModel template) {
    if (template.name.trim().isEmpty) {
      throw const InvalidTemplateException('اسم القالب مطلوب.');
    }
    if (!template.lines.any((l) => l.isDebit) ||
        !template.lines.any((l) => !l.isDebit)) {
      throw const InvalidTemplateException(
        'القالب يجب أن يحتوي على بند مدين وبند دائن على الأقل.',
      );
    }
    if (template.lines.any((l) => l.defaultRatio <= 0)) {
      throw const InvalidTemplateException('نسب البنود يجب أن تكون أكبر من صفر.');
    }
    if (!template.isBalanced) {
      throw const InvalidTemplateException(
        'القالب غير متوازن: مجموع نسب المدين يجب أن يساوي مجموع نسب الدائن.',
      );
    }
    final labels = template.lines.map((l) => l.label).toList();
    if (labels.toSet().length != labels.length) {
      throw const InvalidTemplateException('تسميات بنود القالب يجب أن تكون فريدة.');
    }
  }

  /// تقريب لـ 6 منازل لتفادي أخطاء الفاصلة العائمة في النسب
  static double _round(double v) => (v * 1e6).roundToDouble() / 1e6;
}
