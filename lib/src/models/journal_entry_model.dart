/// journal_entry_model.dart
/// نموذج القيد اليومي (Domain Model)
library;

import 'package:meta/meta.dart';
import '../core/enums.dart';
import '../core/accounting_validator.dart';
import 'journal_entry_line_model.dart';

@immutable
class JournalEntryModel {
  final int? id;
  final String? serialNumber; // رقم القيد المتسلسل (Unique)
  final DateTime date;
  final String description;
  final String? reference; // رقم المرجع (فاتورة، سند، ...)
  final EntryStatus status;
  final List<JournalEntryLineModel> lines;
  final String? notes;

  // حقول التدقيق والرقابة (Audit Trail)
  final String? createdBy;
  final String? postedBy;
  final DateTime? postedAt;

  /// نوع العملية (مبيعات، سند قبض...) - اختياري
  final EntryType? entryType;

  /// ربط القيد بمستند في نظامك (مثال: sourceType: 'invoice', sourceId: '15')
  /// يسهّل البحث عن قيود المستند وعكسها عند إلغائه.
  final String? sourceType;
  final String? sourceId;

  /// إن كان القيد قيداً عكسياً: معرّف القيد الأصلي
  final int? reversalOfId;

  /// الفرع الذي ينتمي إليه القيد (يتطلب تفعيل الفروع)
  final int? branchId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JournalEntryModel({
    this.id,
    this.serialNumber,
    required this.date,
    required this.description,
    this.reference,
    this.status = EntryStatus.draft,
    this.lines = const [],
    this.notes,
    this.createdBy,
    this.postedBy,
    this.postedAt,
    this.entryType,
    this.sourceType,
    this.sourceId,
    this.reversalOfId,
    this.branchId,
    this.createdAt,
    this.updatedAt,
  });

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  double get totalDebits => lines.fold(0, (s, l) => s + l.debit);
  double get totalCredits => lines.fold(0, (s, l) => s + l.credit);
  bool get isBalanced => (totalDebits - totalCredits).abs() < 0.001;
  bool get isEditable => status.isEditable;
  bool get isPosted => status.isPosted;
  bool get isReversed => status == EntryStatus.reversed;

  /// هل هذا القيد قيد عكسي لقيد آخر؟
  bool get isReversal => reversalOfId != null;

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
    String? createdBy,
    String? postedBy,
    DateTime? postedAt,
    EntryType? entryType,
    String? sourceType,
    String? sourceId,
    int? reversalOfId,
    int? branchId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? serialNumber,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      date: date ?? this.date,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      lines: lines ?? this.lines,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      postedBy: postedBy ?? this.postedBy,
      postedAt: postedAt ?? this.postedAt,
      entryType: entryType ?? this.entryType,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      reversalOfId: reversalOfId ?? this.reversalOfId,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // تحويل إلى/من Map (للمزامنة مع الخادم أو التصدير)
  // ─────────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        'id': id,
        'serialNumber': serialNumber,
        'date': date.toIso8601String(),
        'description': description,
        'reference': reference,
        'status': status.name,
        'notes': notes,
        'createdBy': createdBy,
        'postedBy': postedBy,
        'postedAt': postedAt?.toIso8601String(),
        'entryType': entryType?.name,
        'sourceType': sourceType,
        'sourceId': sourceId,
        'reversalOfId': reversalOfId,
        'branchId': branchId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'lines': lines.map((l) => l.toMap()).toList(),
      };

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(Object? v) =>
        v == null ? null : DateTime.parse(v as String);
    return JournalEntryModel(
      id: map['id'] as int?,
      serialNumber: map['serialNumber'] as String?,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
      reference: map['reference'] as String?,
      status: map['status'] == null
          ? EntryStatus.draft
          : EntryStatus.values.byName(map['status'] as String),
      notes: map['notes'] as String?,
      createdBy: map['createdBy'] as String?,
      postedBy: map['postedBy'] as String?,
      postedAt: parseDate(map['postedAt']),
      entryType: map['entryType'] == null
          ? null
          : EntryType.values.byName(map['entryType'] as String),
      sourceType: map['sourceType'] as String?,
      sourceId: map['sourceId'] as String?,
      reversalOfId: map['reversalOfId'] as int?,
      branchId: map['branchId'] as int?,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      lines: ((map['lines'] as List?) ?? const [])
          .map((l) => JournalEntryLineModel.fromMap(
              Map<String, dynamic>.from(l as Map)))
          .toList(),
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
      'JournalEntry(id: $id, serial: $serialNumber, date: $date, desc: $description, status: ${status.name})';
}
