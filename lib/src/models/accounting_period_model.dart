/// accounting_period_model.dart
/// نموذج الفترة المحاسبية (Domain Model)
///
/// ملاحظة: عند الحفظ تُطبَّع الفترة لتبدأ من بداية يوم [startDate]
/// وتنتهي بنهاية يوم [endDate] (23:59:59)، لذا فإن
/// `endDate: DateTime(2026, 12, 31)` يشمل كامل يوم 31 ديسمبر.
library;

import 'package:meta/meta.dart';

@immutable
class AccountingPeriodModel {
  final int? id;
  final String name; // مثال: "يناير 2024"
  final DateTime startDate;
  final DateTime endDate;
  final bool isClosed;
  final DateTime? createdAt;

  const AccountingPeriodModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isClosed = false,
    this.createdAt,
  });

  /// هل الفترة مفتوحة للتسجيل؟
  bool get isOpen => !isClosed;

  /// هل يقع التاريخ ضمن الفترة؟ (المقارنة على مستوى اليوم: من بداية يوم
  /// البداية حتى نهاية يوم النهاية)
  bool isDateInPeriod(DateTime date) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final endExclusive = DateTime(endDate.year, endDate.month, endDate.day + 1);
    return !date.isBefore(start) && date.isBefore(endExclusive);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isClosed': isClosed,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory AccountingPeriodModel.fromMap(Map<String, dynamic> map) =>
      AccountingPeriodModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        startDate: DateTime.parse(map['startDate'] as String),
        endDate: DateTime.parse(map['endDate'] as String),
        isClosed: (map['isClosed'] as bool?) ?? false,
        createdAt: map['createdAt'] == null
            ? null
            : DateTime.parse(map['createdAt'] as String),
      );

  AccountingPeriodModel copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isClosed,
    DateTime? createdAt,
  }) {
    return AccountingPeriodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountingPeriodModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AccountingPeriod(id: $id, name: $name, $startDate → $endDate, closed: $isClosed)';
}
