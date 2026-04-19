/// accounting_period_model.dart
/// نموذج الفترة المحاسبية (Domain Model)

import 'package:meta/meta.dart';

@immutable
class AccountingPeriodModel {
  final int? id;
  final String name;      // مثال: "يناير 2024"
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

  bool isDateInPeriod(DateTime date) {
    return date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
           date.isBefore(endDate.add(const Duration(seconds: 1)));
  }

  AccountingPeriodModel copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isClosed,
    DateTime? createdAt,
  }) {
    return AccountingPeriodModel(
      id:        id        ?? this.id,
      name:      name      ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate:   endDate   ?? this.endDate,
      isClosed:  isClosed  ?? this.isClosed,
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
}
