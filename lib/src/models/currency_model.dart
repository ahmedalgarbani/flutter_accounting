/// currency_model.dart
/// نماذج العملات وأسعار الصرف
library;

import 'package:meta/meta.dart';

/// عملة (ISO 4217)
@immutable
class CurrencyModel {
  final int? id;

  /// رمز العملة، مثل `USD`
  final String code;
  final String name;
  final String? nameAr;

  /// الرمز المعروض، مثل `$` أو `ر.س`
  final String? symbol;

  /// عدد المنازل العشرية (الدينار الكويتي 3، الين 0)
  final int decimalPlaces;
  final bool isActive;

  const CurrencyModel({
    this.id,
    required this.code,
    required this.name,
    this.nameAr,
    this.symbol,
    this.decimalPlaces = 2,
    this.isActive = true,
  });

  String get displayName => nameAr ?? name;

  CurrencyModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameAr,
    String? symbol,
    int? decimalPlaces,
    bool? isActive,
  }) {
    return CurrencyModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      symbol: symbol ?? this.symbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'name': name,
        'nameAr': nameAr,
        'symbol': symbol,
        'decimalPlaces': decimalPlaces,
        'isActive': isActive,
      };

  factory CurrencyModel.fromMap(Map<String, dynamic> map) => CurrencyModel(
        id: map['id'] as int?,
        code: map['code'] as String,
        name: map['name'] as String,
        nameAr: map['nameAr'] as String?,
        symbol: map['symbol'] as String?,
        decimalPlaces: (map['decimalPlaces'] as int?) ?? 2,
        isActive: (map['isActive'] as bool?) ?? true,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CurrencyModel && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Currency($code)';
}

/// سعر صرف عملة مقابل عملة الأساس في تاريخ.
///
/// [rate] = كم وحدة من عملة الأساس تساوي وحدة واحدة من العملة
/// (مثال: USD مقابل SAR = 3.75). السعر يسري من تاريخه حتى السعر التالي.
@immutable
class ExchangeRateModel {
  final int? id;
  final String currencyCode;
  final DateTime date;
  final double rate;

  const ExchangeRateModel({
    this.id,
    required this.currencyCode,
    required this.date,
    required this.rate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'currencyCode': currencyCode,
        'date': date.toIso8601String(),
        'rate': rate,
      };

  factory ExchangeRateModel.fromMap(Map<String, dynamic> map) =>
      ExchangeRateModel(
        id: map['id'] as int?,
        currencyCode: map['currencyCode'] as String,
        date: DateTime.parse(map['date'] as String),
        rate: (map['rate'] as num).toDouble(),
      );

  @override
  String toString() => 'ExchangeRate($currencyCode @ $rate on $date)';
}
