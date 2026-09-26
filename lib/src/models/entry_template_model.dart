/// entry_template_model.dart
/// نموذج قالب القيد اليومي (Domain Model)
library;

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
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      lines: lines ?? this.lines,
    );
  }

  /// مجموع نسب البنود المدينة
  double get totalDebitRatio =>
      lines.where((l) => l.isDebit).fold(0.0, (s, l) => s + l.defaultRatio);

  /// مجموع نسب البنود الدائنة
  double get totalCreditRatio =>
      lines.where((l) => !l.isDebit).fold(0.0, (s, l) => s + l.defaultRatio);

  /// هل القالب متوازن (مجموع نسب المدين = مجموع نسب الدائن)؟
  bool get isBalanced => (totalDebitRatio - totalCreditRatio).abs() < 0.0001;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.name,
        'lines': lines.map((l) => l.toMap()).toList(),
      };

  factory EntryTemplateModel.fromMap(Map<String, dynamic> map) =>
      EntryTemplateModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        description: map['description'] as String?,
        type: EntryType.values.byName(map['type'] as String),
        lines: ((map['lines'] as List?) ?? const [])
            .map((l) => EntryTemplateLineModel.fromMap(
                Map<String, dynamic>.from(l as Map)))
            .toList(),
      );
}

@immutable
class EntryTemplateLineModel {
  final int? id;
  final int? accountId; // حساب محدد مسبقاً (مثلاً حساب المبيعات دائماً ثابت)
  final AccountType? accountType; // نوع الحساب المطلوب (للفلترة في الواجهة)
  final bool isDebit;
  final String label; // تسمية توضيحية (مثلاً "حساب الصندوق")
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
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      accountType: accountType ?? this.accountType,
      isDebit: isDebit ?? this.isDebit,
      label: label ?? this.label,
      defaultRatio: defaultRatio ?? this.defaultRatio,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'accountId': accountId,
        'accountType': accountType?.name,
        'isDebit': isDebit,
        'label': label,
        'defaultRatio': defaultRatio,
      };

  factory EntryTemplateLineModel.fromMap(Map<String, dynamic> map) =>
      EntryTemplateLineModel(
        id: map['id'] as int?,
        accountId: map['accountId'] as int?,
        accountType: map['accountType'] == null
            ? null
            : AccountType.values.byName(map['accountType'] as String),
        isDebit: map['isDebit'] as bool,
        label: map['label'] as String,
        defaultRatio: ((map['defaultRatio'] as num?) ?? 1.0).toDouble(),
      );
}
