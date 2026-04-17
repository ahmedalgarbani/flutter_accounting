/// account_model.dart
/// نموذج الحساب (Domain Model)

import 'package:meta/meta.dart';
import '../core/enums.dart';

@immutable
class AccountModel {
  final int? id;
  final String code;
  final String name;
  final String? nameAr;
  final AccountType type;
  final int? parentId;
  final bool isActive;
  final String? description;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountModel({
    this.id,
    required this.code,
    required this.name,
    this.nameAr,
    required this.type,
    this.parentId,
    this.isActive = true,
    this.description,
    this.level = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  /// الرصيد الطبيعي للحساب مشتق من نوعه
  NormalBalance get normalBalance => type.normalBalance;

  /// الاسم المعروض (عربي إن وُجد، وإلا إنجليزي)
  String get displayName => nameAr ?? name;

  /// هل الحساب حساب أب (يحتوي على حسابات فرعية)؟ يُحدَّد خارجياً
  bool get isParent => parentId == null;

  // ─────────────────────────────────────────────────────────────
  // نسخ معدّلة
  // ─────────────────────────────────────────────────────────────
  AccountModel copyWith({
    int? id,
    String? code,
    String? name,
    String? nameAr,
    AccountType? type,
    int? parentId,
    bool? isActive,
    String? description,
    int? level,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id:          id          ?? this.id,
      code:        code        ?? this.code,
      name:        name        ?? this.name,
      nameAr:      nameAr      ?? this.nameAr,
      type:        type        ?? this.type,
      parentId:    parentId    ?? this.parentId,
      isActive:    isActive    ?? this.isActive,
      description: description ?? this.description,
      level:       level       ?? this.level,
      createdAt:   createdAt   ?? this.createdAt,
      updatedAt:   updatedAt   ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;

  @override
  String toString() => 'AccountModel(id: $id, code: $code, name: $name, type: ${type.name})';
}
