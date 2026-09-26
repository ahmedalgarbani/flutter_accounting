/// journal_entry_builder.dart
/// باني القيود (Fluent API) - أسهل طريقة لإنشاء قيد يومية
library;

import '../models/journal_entry_line_model.dart';
import '../models/journal_entry_model.dart';
import '../repositories/interfaces/interfaces.dart';
import 'accounting_validator.dart';
import 'enums.dart';
import 'exceptions.dart';

/// يبني [JournalEntryModel] بسلاسة، ويمكن الإشارة للحسابات بالمعرّف أو بالرمز.
///
/// ```dart
/// final entry = JournalEntryBuilder(description: 'بيع نقدي - فاتورة 15')
///   .reference('INV-15')
///   .source('invoice', '15')
///   .debitCode('111', 1150)   // الصندوق
///   .creditCode('41', 1000)   // المبيعات
///   .creditCode('215', 150);  // ضريبة القيمة المضافة
///
/// // إنشاء وترحيل في خطوة واحدة (ذرّية):
/// await fa.record(entry);
/// ```
class JournalEntryBuilder {
  JournalEntryBuilder({
    required String description,
    DateTime? date,
  })  : _description = description,
        _date = date ?? DateTime.now();

  String _description;
  DateTime _date;
  String? _reference;
  String? _notes;
  String? _createdBy;
  String? _serialNumber;
  EntryType? _entryType;
  String? _sourceType;
  String? _sourceId;
  final List<_PendingLine> _lines = [];

  // ─────────────────────────────────────────────────────────────
  // بيانات القيد
  // ─────────────────────────────────────────────────────────────

  JournalEntryBuilder description(String value) {
    _description = value;
    return this;
  }

  JournalEntryBuilder date(DateTime value) {
    _date = value;
    return this;
  }

  JournalEntryBuilder reference(String? value) {
    _reference = value;
    return this;
  }

  JournalEntryBuilder notes(String? value) {
    _notes = value;
    return this;
  }

  JournalEntryBuilder createdBy(String? value) {
    _createdBy = value;
    return this;
  }

  JournalEntryBuilder type(EntryType? value) {
    _entryType = value;
    return this;
  }

  /// رقم تسلسلي يدوي (إن لم يُحدَّد يُولَّد تلقائياً)
  JournalEntryBuilder serialNumber(String? value) {
    _serialNumber = value;
    return this;
  }

  /// ربط القيد بمستند في نظامك، مثل `source('invoice', '15')`
  JournalEntryBuilder source(String type, Object id) {
    _sourceType = type;
    _sourceId = id.toString();
    return this;
  }

  // ─────────────────────────────────────────────────────────────
  // البنود
  // ─────────────────────────────────────────────────────────────

  /// بند مدين على حساب بالمعرّف
  JournalEntryBuilder debit(int accountId, double amount,
          {String? description}) =>
      _add(_PendingLine(
          accountId: accountId, debit: amount, description: description));

  /// بند دائن على حساب بالمعرّف
  JournalEntryBuilder credit(int accountId, double amount,
          {String? description}) =>
      _add(_PendingLine(
          accountId: accountId, credit: amount, description: description));

  /// بند مدين على حساب بالرمز (يُحلّ عند [resolve] أو `fa.record`)
  JournalEntryBuilder debitCode(String accountCode, double amount,
          {String? description}) =>
      _add(_PendingLine(
          accountCode: accountCode, debit: amount, description: description));

  /// بند دائن على حساب بالرمز (يُحلّ عند [resolve] أو `fa.record`)
  JournalEntryBuilder creditCode(String accountCode, double amount,
          {String? description}) =>
      _add(_PendingLine(
          accountCode: accountCode, credit: amount, description: description));

  /// إضافة بند جاهز
  JournalEntryBuilder line(JournalEntryLineModel line) => _add(_PendingLine(
        accountId: line.accountId,
        debit: line.debit,
        credit: line.credit,
        description: line.description,
      ));

  JournalEntryBuilder _add(_PendingLine line) {
    _lines.add(line);
    return this;
  }

  // ─────────────────────────────────────────────────────────────
  // معلومات مساعدة للواجهة
  // ─────────────────────────────────────────────────────────────

  double get totalDebits => _lines.fold(0.0, (s, l) => s + l.debit);
  double get totalCredits => _lines.fold(0.0, (s, l) => s + l.credit);
  bool get isBalanced =>
      AccountingValidator.isBalanced(totalDebits, totalCredits);

  /// الفرق بين المدين والدائن (موجب = المدين أكبر)
  double get difference => totalDebits - totalCredits;

  /// هل توجد بنود تشير لحسابات بالرمز وتحتاج إلى [resolve]؟
  bool get needsResolution => _lines.any((l) => l.accountId == null);

  // ─────────────────────────────────────────────────────────────
  // البناء
  // ─────────────────────────────────────────────────────────────

  /// يبني القيد مباشرة. جميع البنود يجب أن تستخدم معرّفات الحسابات
  /// (استخدم [resolve] إذا استعملت [debitCode] / [creditCode]).
  JournalEntryModel build() {
    if (needsResolution) {
      throw StateError(
        'بعض البنود تستخدم رموز حسابات. استخدم resolve() أو fa.record() بدلاً من build().',
      );
    }
    return _toModel({});
  }

  /// يحلّ رموز الحسابات إلى معرّفات ثم يبني القيد.
  /// يرمي [AccountNotFoundException] إذا لم يوجد رمز.
  Future<JournalEntryModel> resolve(IAccountRepository accounts) async {
    final ids = <String, int>{};
    for (final line in _lines) {
      final code = line.accountCode;
      if (line.accountId != null || code == null || ids.containsKey(code)) {
        continue;
      }
      final account = await accounts.getAccountByCode(code);
      if (account == null) throw AccountNotFoundException(code);
      ids[code] = account.id!;
    }
    return _toModel(ids);
  }

  JournalEntryModel _toModel(Map<String, int> codeIds) {
    final lines = <JournalEntryLineModel>[];
    for (var i = 0; i < _lines.length; i++) {
      final l = _lines[i];
      lines.add(JournalEntryLineModel(
        accountId: l.accountId ?? codeIds[l.accountCode]!,
        accountCode: l.accountCode ?? '',
        debit: l.debit,
        credit: l.credit,
        description: l.description,
        sortOrder: i,
      ));
    }
    return JournalEntryModel(
      serialNumber: _serialNumber,
      date: _date,
      description: _description,
      reference: _reference,
      notes: _notes,
      createdBy: _createdBy,
      entryType: _entryType,
      sourceType: _sourceType,
      sourceId: _sourceId,
      lines: lines,
    );
  }
}

class _PendingLine {
  final int? accountId;
  final String? accountCode;
  final double debit;
  final double credit;
  final String? description;

  _PendingLine({
    this.accountId,
    this.accountCode,
    this.debit = 0,
    this.credit = 0,
    this.description,
  });
}
