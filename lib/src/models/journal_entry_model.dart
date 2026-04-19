/// journal_entry_model.dart
/// نموذج القيد اليومي (Domain Model)

import 'package:meta/meta.dart';
import '../core/enums.dart';
import '../core/accounting_validator.dart';
import 'journal_entry_line_model.dart';

@immutable
class JournalEntryModel {
  final int? id;
  final DateTime date;
  final String description;
  final String? reference;     // رقم المرجع (فاتورة، سند، ...)
  final EntryStatus status;
  final List<JournalEntryLineModel> lines;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JournalEntryModel({
    this.id,
    required this.date,
    required this.description,
    this.reference,
    this.status = EntryStatus.draft,
    this.lines = const [],
    this.notes,
     this.createdAt,
     this.updatedAt,
  });

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  double get totalDebits  => lines.fold(0, (s, l) => s + l.debit);
  double get totalCredits => lines.fold(0, (s, l) => s + l.credit);
  bool   get isBalanced   => (totalDebits - totalCredits).abs() < 0.001;
  bool   get isEditable   => status.isEditable;
  bool   get isPosted     => status.isPosted;

  /// يتحقق من صحة القيد ويرفع استثناءً في حال وجود خطأ (Double-Entry rules)
  void validate() {
    AccountingValidator.validateEntryLines(lines);
  }

  // ─────────────────────────────────────────────────────────────
  // نسخ معدّلة
  // ─────────────────────────────────────────────────────────────
  JournalEntryModel copyWith({
    int? id,
    DateTime? date,
    String? description,
    String? reference,
    EntryStatus? status,
    List<JournalEntryLineModel>? lines,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntryModel(
      id:          id          ?? this.id,
      date:        date        ?? this.date,
      description: description ?? this.description,
      reference:   reference   ?? this.reference,
      status:      status      ?? this.status,
      lines:       lines       ?? this.lines,
      notes:       notes       ?? this.notes,
      createdAt:   createdAt   ?? this.createdAt,
      updatedAt:   updatedAt   ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'JournalEntry(id: $id, date: $date, desc: $description, status: ${status.name})';
}
