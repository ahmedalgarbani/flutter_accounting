/// journal_entry_line_model.dart
/// نموذج بند القيد اليومي (Domain Model)

import 'package:meta/meta.dart';

@immutable
class JournalEntryLineModel {
  final int? id;
  final int? entryId;
  final int accountId;
  final String accountCode;   // للعرض - يُملأ عند الجلب من DB
  final String accountName;   // للعرض - يُملأ عند الجلب من DB
  final double debit;
  final double credit;
  final String? description;
  final int sortOrder;

  const JournalEntryLineModel({
    this.id,
    this.entryId,
    required this.accountId,
    this.accountCode = '',
    this.accountName = '',
    required this.debit,
    required this.credit,
    this.description,
    this.sortOrder = 0,
  }) : assert(
          !(debit > 0 && credit > 0),
          'البند لا يمكن أن يكون مديناً ودائناً في نفس الوقت',
        );

  // ─────────────────────────────────────────────────────────────
  // Factory constructors مساعدة
  // ─────────────────────────────────────────────────────────────

  /// إنشاء بند مدين
  factory JournalEntryLineModel.debitLine({
    int? id,
    int? entryId,
    required int accountId,
    String accountCode = '',
    String accountName = '',
    required double amount,
    String? description,
    int sortOrder = 0,
  }) {
    return JournalEntryLineModel(
      id:          id,
      entryId:     entryId,
      accountId:   accountId,
      accountCode: accountCode,
      accountName: accountName,
      debit:       amount,
      credit:      0,
      description: description,
      sortOrder:   sortOrder,
    );
  }

  /// إنشاء بند دائن
  factory JournalEntryLineModel.creditLine({
    int? id,
    int? entryId,
    required int accountId,
    String accountCode = '',
    String accountName = '',
    required double amount,
    String? description,
    int sortOrder = 0,
  }) {
    return JournalEntryLineModel(
      id:          id,
      entryId:     entryId,
      accountId:   accountId,
      accountCode: accountCode,
      accountName: accountName,
      debit:       0,
      credit:      amount,
      description: description,
      sortOrder:   sortOrder,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  bool get isDebit  => debit > 0;
  bool get isCredit => credit > 0;
  double get amount => isDebit ? debit : credit;

  JournalEntryLineModel copyWith({
    int? id,
    int? entryId,
    int? accountId,
    String? accountCode,
    String? accountName,
    double? debit,
    double? credit,
    String? description,
    int? sortOrder,
  }) {
    return JournalEntryLineModel(
      id:          id          ?? this.id,
      entryId:     entryId     ?? this.entryId,
      accountId:   accountId   ?? this.accountId,
      accountCode: accountCode ?? this.accountCode,
      accountName: accountName ?? this.accountName,
      debit:       debit       ?? this.debit,
      credit:      credit      ?? this.credit,
      description: description ?? this.description,
      sortOrder:   sortOrder   ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryLineModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Line(accountId: $accountId, debit: $debit, credit: $credit)';
}
