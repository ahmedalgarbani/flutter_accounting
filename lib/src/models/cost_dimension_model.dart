/// cost_dimension_model.dart
/// نموذج البعد التحليلي (فرع، مشروع، قسم...) وقواعد ربطه بالحسابات
library;

import 'package:meta/meta.dart';
import '../core/enums.dart';

/// بُعد تحليلي تُصنَّف عليه الحركات، مثل: الفرع، المشروع، القسم.
///
/// كل بُعد له شجرة مراكز تكلفة خاصة به، ويمكن ربط بند القيد الواحد بمركز
/// من كل بُعد في نفس الوقت (فرع الرياض + مشروع X + قسم المبيعات).
@immutable
class CostDimensionModel {
  final int? id;

  /// رمز فريد، مثل `BRANCH`
  final String code;
  final String name;
  final String? nameAr;
  final String? description;

  /// السياسة الافتراضية لكل الحسابات (يمكن تخصيصها لكل حساب أو نوع حساب
  /// عبر [DimensionRuleModel]). الافتراضي: اختياري.
  final DimensionPolicy defaultPolicy;

  /// هل يُسمح بتوزيع البند الواحد على أكثر من مركز من هذا البعد؟
  /// (مثل: إيجار 60% فرع أ و 40% فرع ب)
  final bool allowSplit;

  /// البعد الموقوف لا يقبل توزيعات جديدة ولا تُطبَّق سياساته
  final bool isActive;

  /// ترتيب العرض في الواجهة
  final int sortOrder;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CostDimensionModel({
    this.id,
    required this.code,
    required this.name,
    this.nameAr,
    this.description,
    this.defaultPolicy = DimensionPolicy.optional,
    this.allowSplit = true,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  /// الاسم المعروض (عربي إن وُجد، وإلا إنجليزي)
  String get displayName => nameAr ?? name;

  CostDimensionModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameAr,
    String? description,
    DimensionPolicy? defaultPolicy,
    bool? allowSplit,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CostDimensionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      defaultPolicy: defaultPolicy ?? this.defaultPolicy,
      allowSplit: allowSplit ?? this.allowSplit,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
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
        'defaultPolicy': defaultPolicy.name,
        'allowSplit': allowSplit,
        'isActive': isActive,
        'sortOrder': sortOrder,
      };

  factory CostDimensionModel.fromMap(Map<String, dynamic> map) =>
      CostDimensionModel(
        id: map['id'] as int?,
        code: map['code'] as String,
        name: map['name'] as String,
        nameAr: map['nameAr'] as String?,
        description: map['description'] as String?,
        defaultPolicy: map['defaultPolicy'] == null
            ? DimensionPolicy.optional
            : DimensionPolicy.values.byName(map['defaultPolicy'] as String),
        allowSplit: (map['allowSplit'] as bool?) ?? true,
        isActive: (map['isActive'] as bool?) ?? true,
        sortOrder: (map['sortOrder'] as int?) ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostDimensionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => Object.hash(id, code);

  @override
  String toString() => 'CostDimension(id: $id, code: $code, name: $name)';
}

/// قاعدة تخصّص سياسة بُعد لحساب معيّن (وكل حساباته الفرعية) أو لنوع حساب.
///
/// ترتيب الأولوية عند تحديد السياسة لبند:
/// 1. قاعدة على الحساب نفسه، ثم على أقرب حساب أب له
/// 2. قاعدة على نوع الحساب (مثل: كل المصروفات)
/// 3. [CostDimensionModel.defaultPolicy]
///
/// ```dart
/// // كل المصروفات تتطلب تحديد القسم
/// await fa.costCenters.setRule(DimensionRuleModel.forType(
///   dimensionId: department.id!,
///   accountType: AccountType.expense,
///   policy: DimensionPolicy.required,
/// ));
/// ```
@immutable
class DimensionRuleModel {
  final int? id;
  final int dimensionId;

  /// الحساب المستهدف (يشمل حساباته الفرعية). يُحدَّد هذا أو [accountType].
  final int? accountId;

  /// نوع الحساب المستهدف. يُحدَّد هذا أو [accountId].
  final AccountType? accountType;

  final DimensionPolicy policy;

  /// مركز افتراضي يُطبَّق تلقائياً على البنود التي لا تحدد مركزاً من هذا البعد
  /// (مثل: حساب "إيجار فرع جدة" يذهب دائماً لمركز فرع جدة).
  final int? defaultCostCenterId;

  const DimensionRuleModel({
    this.id,
    required this.dimensionId,
    this.accountId,
    this.accountType,
    this.policy = DimensionPolicy.optional,
    this.defaultCostCenterId,
  });

  /// قاعدة على حساب (وحساباته الفرعية)
  factory DimensionRuleModel.forAccount({
    required int dimensionId,
    required int accountId,
    DimensionPolicy policy = DimensionPolicy.optional,
    int? defaultCostCenterId,
  }) =>
      DimensionRuleModel(
        dimensionId: dimensionId,
        accountId: accountId,
        policy: policy,
        defaultCostCenterId: defaultCostCenterId,
      );

  /// قاعدة على نوع حساب
  factory DimensionRuleModel.forType({
    required int dimensionId,
    required AccountType accountType,
    DimensionPolicy policy = DimensionPolicy.optional,
    int? defaultCostCenterId,
  }) =>
      DimensionRuleModel(
        dimensionId: dimensionId,
        accountType: accountType,
        policy: policy,
        defaultCostCenterId: defaultCostCenterId,
      );

  DimensionRuleModel copyWith({
    int? id,
    int? dimensionId,
    int? accountId,
    AccountType? accountType,
    DimensionPolicy? policy,
    int? defaultCostCenterId,
  }) {
    return DimensionRuleModel(
      id: id ?? this.id,
      dimensionId: dimensionId ?? this.dimensionId,
      accountId: accountId ?? this.accountId,
      accountType: accountType ?? this.accountType,
      policy: policy ?? this.policy,
      defaultCostCenterId: defaultCostCenterId ?? this.defaultCostCenterId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'dimensionId': dimensionId,
        'accountId': accountId,
        'accountType': accountType?.name,
        'policy': policy.name,
        'defaultCostCenterId': defaultCostCenterId,
      };

  factory DimensionRuleModel.fromMap(Map<String, dynamic> map) =>
      DimensionRuleModel(
        id: map['id'] as int?,
        dimensionId: map['dimensionId'] as int,
        accountId: map['accountId'] as int?,
        accountType: map['accountType'] == null
            ? null
            : AccountType.values.byName(map['accountType'] as String),
        policy: DimensionPolicy.values.byName(map['policy'] as String),
        defaultCostCenterId: map['defaultCostCenterId'] as int?,
      );

  @override
  String toString() => 'DimensionRule(dimension: $dimensionId, '
      'account: $accountId, type: ${accountType?.name}, policy: ${policy.name})';
}
