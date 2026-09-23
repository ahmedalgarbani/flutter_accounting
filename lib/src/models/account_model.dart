/// account_model.dart
/// نموذج الحساب (Domain Model)
library;

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

  /// إنشاء نموذج حساب جديد بدون الحاجة لتمرير التواريخ.
  ///
  /// ```dart
  /// await fa.accounts.createAccount(
  ///   AccountModel.create(code: '1111', name: 'Main Cash', type: AccountType.asset, parentId: cashGroupId),
  /// );
  /// ```
  factory AccountModel.create({
    required String code,
    required String name,
    String? nameAr,
    required AccountType type,
    int? parentId,
    bool isActive = true,
    String? description,
  }) {
    final now = DateTime.now();
    return AccountModel(
      code:        code,
      name:        name,
      nameAr:      nameAr,
      type:        type,
      parentId:    parentId,
      isActive:    isActive,
      description: description,
      createdAt:   now,
      updatedAt:   now,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // خصائص مشتقة
  // ─────────────────────────────────────────────────────────────

  /// الرصيد الطبيعي للحساب مشتق من نوعه
  NormalBalance get normalBalance => type.normalBalance;

  /// الاسم المعروض (عربي إن وُجد، وإلا إنجليزي)
  String get displayName => nameAr ?? name;

  /// هل الحساب حساب جذري (بدون أب) في الشجرة؟
  bool get isRoot => parentId == null;

  /// ⚠️ الاسم مضلِّل: هذه الخاصية تعني فقط أن الحساب ليس له أب (جذري)،
  /// ولا تعني أن له حسابات فرعية.
  /// لمعرفة ذلك استخدم `accounts.hasChildren(id)`.
  @Deprecated('Use isRoot, or accounts.hasChildren(id) to check for sub-accounts.')
  bool get isParent => isRoot;

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

  Map<String, dynamic> toMap() => {
        'id':          id,
        'code':        code,
        'name':        name,
        'nameAr':      nameAr,
        'type':        type.name,
        'parentId':    parentId,
        'isActive':    isActive,
        'description': description,
        'level':       level,
        'createdAt':   createdAt.toIso8601String(),
        'updatedAt':   updatedAt.toIso8601String(),
      };

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    final now = DateTime.now();
    return AccountModel(
      id:          map['id'] as int?,
      code:        map['code'] as String,
      name:        map['name'] as String,
      nameAr:      map['nameAr'] as String?,
      type:        AccountType.values.byName(map['type'] as String),
      parentId:    map['parentId'] as int?,
      isActive:    (map['isActive'] as bool?) ?? true,
      description: map['description'] as String?,
      level:       (map['level'] as int?) ?? 1,
      createdAt:   map['createdAt'] == null ? now : DateTime.parse(map['createdAt'] as String),
      updatedAt:   map['updatedAt'] == null ? now : DateTime.parse(map['updatedAt'] as String),
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
