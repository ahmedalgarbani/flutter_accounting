/// journal_entry_line_model.dart
/// نموذج بند القيد اليومي (Domain Model)
library;

import 'package:meta/meta.dart';

import 'cost_allocation_model.dart';

@immutable
class JournalEntryLineModel {
  final int? id;
  final int? entryId;
  final int accountId;
  final String accountCode; // للعرض - يُملأ عند الجلب من DB
  final String accountName; // للعرض - يُملأ عند الجلب من DB
  final double debit;
  final double credit;
  final String? description;
  final int sortOrder;

  /// توزيع البند على مراكز التكلفة (اختياري). يمكن ربط البند بمركز من كل
  /// بُعد، أو توزيعه على عدة مراكز من نفس البعد. انظر [CostAllocationModel].
  final List<CostAllocationModel> allocations;

  /// عملة البند (يتطلب تعدد العملات). `null` = عملة الأساس، أو عملة الحساب
  /// إن كان للحساب عملة.
  final String? currencyCode;

  /// المبلغ بعملة البند. عند الحفظ يُحوَّل إلى عملة الأساس في [debit]/[credit]
  /// حسب [exchangeRate]. إن لم يُحدَّد وكان البند بعملة أجنبية، يُعتبر
  /// [debit]/[credit] المُدخل مبلغاً بعملة البند.
  final double? amountCurrency;

  /// سعر الصرف (وحدات عملة الأساس لكل وحدة من عملة البند). إن لم يُحدَّد
  /// يُؤخذ آخر سعر مسجل في تاريخ القيد أو قبله.
  final double? exchangeRate;

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
    this.allocations = const [],
    this.currencyCode,
    this.amountCurrency,
    this.exchangeRate,
  }) : assert(
          !(debit > 0 && credit > 0),
          'البند لا يمكن أن يكون مديناً ودائناً في نفس الوقت',
        );

  // ─────────────────────────────────────────────────────────────
  // Factory constructors مساعدة
  // ─────────────────────────────────────────────────────────────

  /// إنشاء بند مدين. مع [currencyCode] يكون [amount] بتلك العملة.
  factory JournalEntryLineModel.debitLine({
    int? id,
    int? entryId,
    required int accountId,
    String accountCode = '',
    String accountName = '',
    required double amount,
    String? description,
    int sortOrder = 0,
    List<CostAllocationModel> allocations = const [],
    String? currencyCode,
    double? exchangeRate,
  }) {
    return JournalEntryLineModel(
      id: id,
      entryId: entryId,
      accountId: accountId,
      accountCode: accountCode,
      accountName: accountName,
      debit: amount,
      credit: 0,
      description: description,
      sortOrder: sortOrder,
      allocations: allocations,
      currencyCode: currencyCode,
      amountCurrency: currencyCode == null ? null : amount,
      exchangeRate: exchangeRate,
    );
  }

  /// إنشاء بند دائن. مع [currencyCode] يكون [amount] بتلك العملة.
  factory JournalEntryLineModel.creditLine({
    int? id,
    int? entryId,
    required int accountId,
    String accountCode = '',
    String accountName = '',
    required double amount,
    String? description,
    int sortOrder = 0,
    List<CostAllocationModel> allocations = const [],
    String? currencyCode,
    double? exchangeRate,
  }) {
    return JournalEntryLineModel(
      id: id,
      entryId: entryId,
      accountId: accountId,
      accountCode: accountCode,
      accountName: accountName,
      debit: 0,
      credit: amount,
      description: description,
      sortOrder: sortOrder,
      allocations: allocations,
      currencyCode: currencyCode,
      amountCurrency: currencyCode == null ? null : amount,
      exchangeRate: exchangeRate,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  bool get isDebit => debit > 0;

  /// هل البند بعملة أجنبية (بعد الحفظ)؟
  bool get isForeignCurrency => currencyCode != null;
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
    List<CostAllocationModel>? allocations,
    String? currencyCode,
    double? amountCurrency,
    double? exchangeRate,
  }) {
    return JournalEntryLineModel(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      accountCode: accountCode ?? this.accountCode,
      accountName: accountName ?? this.accountName,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      allocations: allocations ?? this.allocations,
      currencyCode: currencyCode ?? this.currencyCode,
      amountCurrency: amountCurrency ?? this.amountCurrency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'entryId': entryId,
        'accountId': accountId,
        'accountCode': accountCode,
        'accountName': accountName,
        'debit': debit,
        'credit': credit,
        'description': description,
        'sortOrder': sortOrder,
        'allocations': allocations.map((a) => a.toMap()).toList(),
        'currencyCode': currencyCode,
        'amountCurrency': amountCurrency,
        'exchangeRate': exchangeRate,
      };

  factory JournalEntryLineModel.fromMap(Map<String, dynamic> map) =>
      JournalEntryLineModel(
        id: map['id'] as int?,
        entryId: map['entryId'] as int?,
        accountId: map['accountId'] as int,
        accountCode: (map['accountCode'] as String?) ?? '',
        accountName: (map['accountName'] as String?) ?? '',
        debit: ((map['debit'] as num?) ?? 0).toDouble(),
        credit: ((map['credit'] as num?) ?? 0).toDouble(),
        description: map['description'] as String?,
        sortOrder: (map['sortOrder'] as int?) ?? 0,
        allocations: ((map['allocations'] as List?) ?? const [])
            .map((a) => CostAllocationModel.fromMap(
                Map<String, dynamic>.from(a as Map)))
            .toList(),
        currencyCode: map['currencyCode'] as String?,
        amountCurrency: (map['amountCurrency'] as num?)?.toDouble(),
        exchangeRate: (map['exchangeRate'] as num?)?.toDouble(),
      );

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
