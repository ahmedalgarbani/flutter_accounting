/// allocation_key_model.dart
/// مفتاح توزيع: أوزان ثابتة لتوزيع مبلغ على عدة مراكز تكلفة
library;

import 'package:meta/meta.dart';

/// مفتاح توزيع محفوظ، مثل "حسب المساحة": الرياض 300م² / جدة 200م².
///
/// الأوزان نسبية (لا يُشترط أن مجموعها 100)، وحصة كل مركز = وزنه ÷ مجموع
/// الأوزان. يُستخدم لتوزيع بند واحد وقت الإدخال، أو لتوزيع تكاليف مركز
/// خدمي على المراكز الأخرى دورياً.
@immutable
class AllocationKeyModel {
  final int? id;

  /// رمز فريد، مثل `AREA`
  final String code;
  final String name;
  final String? nameAr;

  /// كل مراكز المفتاح يجب أن تكون من هذا البعد
  final int dimensionId;
  final String? description;
  final bool isActive;
  final List<AllocationKeyItemModel> items;

  const AllocationKeyModel({
    this.id,
    required this.code,
    required this.name,
    this.nameAr,
    required this.dimensionId,
    this.description,
    this.isActive = true,
    this.items = const [],
  });

  String get displayName => nameAr ?? name;

  /// مجموع الأوزان
  double get totalWeight => items.fold(0.0, (s, i) => s + i.weight);

  /// النسبة المئوية لبند من المفتاح
  double percentageOf(AllocationKeyItemModel item) =>
      totalWeight == 0 ? 0 : item.weight / totalWeight * 100;

  AllocationKeyModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameAr,
    int? dimensionId,
    String? description,
    bool? isActive,
    List<AllocationKeyItemModel>? items,
  }) {
    return AllocationKeyModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      dimensionId: dimensionId ?? this.dimensionId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'name': name,
        'nameAr': nameAr,
        'dimensionId': dimensionId,
        'description': description,
        'isActive': isActive,
        'items': items.map((i) => i.toMap()).toList(),
      };

  factory AllocationKeyModel.fromMap(Map<String, dynamic> map) =>
      AllocationKeyModel(
        id: map['id'] as int?,
        code: map['code'] as String,
        name: map['name'] as String,
        nameAr: map['nameAr'] as String?,
        dimensionId: map['dimensionId'] as int,
        description: map['description'] as String?,
        isActive: (map['isActive'] as bool?) ?? true,
        items: ((map['items'] as List?) ?? const [])
            .map((i) => AllocationKeyItemModel.fromMap(
                Map<String, dynamic>.from(i as Map)))
            .toList(),
      );

  @override
  String toString() =>
      'AllocationKey(id: $id, code: $code, items: ${items.length})';
}

/// وزن مركز تكلفة داخل مفتاح توزيع
@immutable
class AllocationKeyItemModel {
  final int? id;
  final int costCenterId;

  /// وزن نسبي موجب (مساحة، عدد موظفين، نسبة...)
  final double weight;

  /// للعرض - يُملأ عند الجلب من قاعدة البيانات
  final String costCenterCode;
  final String costCenterName;

  const AllocationKeyItemModel({
    this.id,
    required this.costCenterId,
    required this.weight,
    this.costCenterCode = '',
    this.costCenterName = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'costCenterId': costCenterId,
        'weight': weight,
        'costCenterCode': costCenterCode,
        'costCenterName': costCenterName,
      };

  factory AllocationKeyItemModel.fromMap(Map<String, dynamic> map) =>
      AllocationKeyItemModel(
        id: map['id'] as int?,
        costCenterId: map['costCenterId'] as int,
        weight: (map['weight'] as num).toDouble(),
        costCenterCode: (map['costCenterCode'] as String?) ?? '',
        costCenterName: (map['costCenterName'] as String?) ?? '',
      );
}
