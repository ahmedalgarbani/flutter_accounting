/// cost_center_model.dart
/// نموذج مركز التكلفة (Domain Model)
library;

import 'package:meta/meta.dart';

/// مركز تكلفة (أو ربحية) ضمن بُعد تحليلي، مثل: "فرع الرياض" ضمن بُعد الفرع.
///
/// المراكز شجرة هرمية مثل دليل الحسابات: التوزيع يتم على المراكز الفرعية
/// (Leaf) فقط، والتقارير تجمع أرصدة الأبناء في الأب.
@immutable
class CostCenterModel {
  final int? id;

  /// البعد الذي ينتمي إليه المركز (لا يتغير بعد الإنشاء)
  final int dimensionId;

  /// رمز فريد على مستوى كل المراكز، مثل `BR-RYD`
  final String code;
  final String name;
  final String? nameAr;
  final int? parentId;

  /// مستوى المركز في الشجرة (1 = رئيسي)
  final int level;
  final bool isActive;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CostCenterModel({
    this.id,
    required this.dimensionId,
    required this.code,
    required this.name,
    this.nameAr,
    this.parentId,
    this.level = 1,
    this.isActive = true,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// الاسم المعروض (عربي إن وُجد، وإلا إنجليزي)
  String get displayName => nameAr ?? name;

  /// هل المركز جذري (بدون أب)؟
  bool get isRoot => parentId == null;

  CostCenterModel copyWith({
    int? id,
    int? dimensionId,
    String? code,
    String? name,
    String? nameAr,
    int? parentId,
    int? level,
    bool? isActive,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CostCenterModel(
      id: id ?? this.id,
      dimensionId: dimensionId ?? this.dimensionId,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// نسخة بدون أب (نقل المركز إلى المستوى الجذري)
  CostCenterModel withoutParent() => CostCenterModel(
        id: id,
        dimensionId: dimensionId,
        code: code,
        name: name,
        nameAr: nameAr,
        isActive: isActive,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'dimensionId': dimensionId,
        'code': code,
        'name': name,
        'nameAr': nameAr,
        'parentId': parentId,
        'level': level,
        'isActive': isActive,
        'description': description,
      };

  factory CostCenterModel.fromMap(Map<String, dynamic> map) => CostCenterModel(
        id: map['id'] as int?,
        dimensionId: map['dimensionId'] as int,
        code: map['code'] as String,
        name: map['name'] as String,
        nameAr: map['nameAr'] as String?,
        parentId: map['parentId'] as int?,
        level: (map['level'] as int?) ?? 1,
        isActive: (map['isActive'] as bool?) ?? true,
        description: map['description'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCenterModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => Object.hash(id, code);

  @override
  String toString() => 'CostCenter(id: $id, code: $code, name: $name)';
}
