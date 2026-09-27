/// branch_model.dart
/// نموذج الفرع ومعاملات ما بين الفروع
library;

import 'package:meta/meta.dart';

import 'journal_entry_line_model.dart';

/// فرع كوحدة محاسبية: كل قيد ينتمي لفرع، فيكون لكل فرع ميزانيته.
@immutable
class BranchModel {
  final int? id;
  final String code;
  final String name;
  final String? nameAr;
  final String? description;
  final bool isActive;
  final bool isHeadOffice;

  /// حساب "جاري الفرع": تسجل عليه الفروع الأخرى ما لها أو عليها لهذا الفرع
  final int? interBranchAccountId;

  /// مركز التكلفة المرتبط (بُعد الفرع) - اختياري
  final int? costCenterId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BranchModel({
    this.id,
    required this.code,
    required this.name,
    this.nameAr,
    this.description,
    this.isActive = true,
    this.isHeadOffice = false,
    this.interBranchAccountId,
    this.costCenterId,
    this.createdAt,
    this.updatedAt,
  });

  String get displayName => nameAr ?? name;

  BranchModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameAr,
    String? description,
    bool? isActive,
    bool? isHeadOffice,
    int? interBranchAccountId,
    int? costCenterId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isHeadOffice: isHeadOffice ?? this.isHeadOffice,
      interBranchAccountId: interBranchAccountId ?? this.interBranchAccountId,
      costCenterId: costCenterId ?? this.costCenterId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'name': name,
        'nameAr': nameAr,
        'description': description,
        'isActive': isActive,
        'isHeadOffice': isHeadOffice,
        'interBranchAccountId': interBranchAccountId,
        'costCenterId': costCenterId,
      };

  factory BranchModel.fromMap(Map<String, dynamic> map) => BranchModel(
        id: map['id'] as int?,
        code: map['code'] as String,
        name: map['name'] as String,
        nameAr: map['nameAr'] as String?,
        description: map['description'] as String?,
        isActive: (map['isActive'] as bool?) ?? true,
        isHeadOffice: (map['isHeadOffice'] as bool?) ?? false,
        interBranchAccountId: map['interBranchAccountId'] as int?,
        costCenterId: map['costCenterId'] as int?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchModel && id == other.id && code == other.code;

  @override
  int get hashCode => Object.hash(id, code);

  @override
  String toString() => 'Branch(id: $id, code: $code)';
}

/// معاملة بين فرعين تُسجَّل كقيدين مرتبطين (قيد في دفاتر كل فرع).
///
/// مثال: المركز الرئيسي يدفع إيجار فرع جدة 1000 من بنكه:
/// ```dart
/// InterBranchTransaction(
///   fromBranchId: hq.id!, toBranchId: jeddah.id!,
///   description: 'إيجار فرع جدة',
///   fromLines: [JournalEntryLineModel.creditLine(accountId: bankId, amount: 1000)],
///   toLines:   [JournalEntryLineModel.debitLine(accountId: rentId, amount: 1000)],
/// )
/// ```
/// تكمل المكتبة كل قيد بحساب جاري الفرع الآخر: في دفاتر الرئيسي مدين
/// "جاري فرع جدة"، وفي دفاتر جدة دائن "جاري المركز الرئيسي".
@immutable
class InterBranchTransaction {
  final int fromBranchId;
  final int toBranchId;
  final DateTime? date;
  final String description;
  final String? reference;

  /// بنود الفرع المُرسِل (بدون حساب الجاري) - بعملة الأساس
  final List<JournalEntryLineModel> fromLines;

  /// بنود الفرع المستقبِل (بدون حساب الجاري) - بعملة الأساس
  final List<JournalEntryLineModel> toLines;

  const InterBranchTransaction({
    required this.fromBranchId,
    required this.toBranchId,
    required this.description,
    required this.fromLines,
    required this.toLines,
    this.date,
    this.reference,
  });
}
