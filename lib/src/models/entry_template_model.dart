/// entry_template_model.dart
/// نموذج قالب القيد اليومي (Domain Model)

import 'package:meta/meta.dart';
import '../core/enums.dart';

@immutable
class EntryTemplateModel {
  final int? id;
  final String name;
  final String? description;
  final EntryType type;
  final List<EntryTemplateLineModel> lines;

  const EntryTemplateModel({
    this.id,
    required this.name,
    this.description,
    required this.type,
    this.lines = const [],
  });

  EntryTemplateModel copyWith({
    int? id,
    String? name,
    String? description,
    EntryType? type,
    List<EntryTemplateLineModel>? lines,
  }) {
    return EntryTemplateModel(
      id:          id          ?? this.id,
      name:        name        ?? this.name,
      description: description ?? this.description,
      type:        type        ?? this.type,
      lines:       lines       ?? this.lines,
    );
  }
}

@immutable
class EntryTemplateLineModel {
  final int? id;
  final int? accountId;      // حساب محدد مسبقاً (مثلاً حساب المبيعات دائماً ثابت)
  final AccountType? accountType; // نوع الحساب المطلوب (للفلترة في الواجهة)
  final bool isDebit;
  final String label;        // تسمية توضيحية (مثلاً "حساب الصندوق")
  final double defaultRatio; // نسبة افتراضية من المبلغ الإجمالي (1.0 = 100%)

  const EntryTemplateLineModel({
    this.id,
    this.accountId,
    this.accountType,
    required this.isDebit,
    required this.label,
    this.defaultRatio = 1.0,
  });

  EntryTemplateLineModel copyWith({
    int? id,
    int? accountId,
    AccountType? accountType,
    bool? isDebit,
    String? label,
    double? defaultRatio,
  }) {
    return EntryTemplateLineModel(
      id:           id           ?? this.id,
      accountId:    accountId    ?? this.accountId,
      accountType:  accountType  ?? this.accountType,
      isDebit:      isDebit      ?? this.isDebit,
      label:        label        ?? this.label,
      defaultRatio: defaultRatio ?? this.defaultRatio,
    );
  }
}
