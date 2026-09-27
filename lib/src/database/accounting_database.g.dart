// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        nameAr,
        type,
        parentId,
        isActive,
        description,
        level,
        currencyCode,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code},
      ];
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      type: $AccountsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, int, int> $convertertype =
      const EnumIndexConverter<AccountType>(AccountType.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String code;
  final String name;
  final String? nameAr;
  final AccountType type;
  final int? parentId;
  final bool isActive;
  final String? description;

  /// مستوى الحساب في التسلسل الهرمي (1 = حساب رئيسي، 2 = فرعي، ...)
  final int level;

  /// عملة الحساب (Schema v4) - null = أي عملة
  final String? currencyCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Account(
      {required this.id,
      required this.code,
      required this.name,
      this.nameAr,
      required this.type,
      this.parentId,
      required this.isActive,
      this.description,
      required this.level,
      this.currencyCode,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    {
      map['type'] = Variable<int>($AccountsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      type: Value(type),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isActive: Value(isActive),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      level: Value(level),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      type: $AccountsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      parentId: serializer.fromJson<int?>(json['parentId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      description: serializer.fromJson<String?>(json['description']),
      level: serializer.fromJson<int>(json['level']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'type':
          serializer.toJson<int>($AccountsTable.$convertertype.toJson(type)),
      'parentId': serializer.toJson<int?>(parentId),
      'isActive': serializer.toJson<bool>(isActive),
      'description': serializer.toJson<String?>(description),
      'level': serializer.toJson<int>(level),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> nameAr = const Value.absent(),
          AccountType? type,
          Value<int?> parentId = const Value.absent(),
          bool? isActive,
          Value<String?> description = const Value.absent(),
          int? level,
          Value<String?> currencyCode = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Account(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        type: type ?? this.type,
        parentId: parentId.present ? parentId.value : this.parentId,
        isActive: isActive ?? this.isActive,
        description: description.present ? description.value : this.description,
        level: level ?? this.level,
        currencyCode:
            currencyCode.present ? currencyCode.value : this.currencyCode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      type: data.type.present ? data.type.value : this.type,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      description:
          data.description.present ? data.description.value : this.description,
      level: data.level.present ? data.level.value : this.level,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, nameAr, type, parentId,
      isActive, description, level, currencyCode, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.type == this.type &&
          other.parentId == this.parentId &&
          other.isActive == this.isActive &&
          other.description == this.description &&
          other.level == this.level &&
          other.currencyCode == this.currencyCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<AccountType> type;
  final Value<int?> parentId;
  final Value<bool> isActive;
  final Value<String?> description;
  final Value<int> level;
  final Value<String?> currencyCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.type = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.nameAr = const Value.absent(),
    required AccountType type,
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? type,
    Expression<int>? parentId,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<int>? level,
    Expression<String>? currencyCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (type != null) 'type': type,
      if (parentId != null) 'parent_id': parentId,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? nameAr,
      Value<AccountType>? type,
      Value<int?>? parentId,
      Value<bool>? isActive,
      Value<String?>? description,
      Value<int>? level,
      Value<String?>? currencyCode,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AccountsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      level: level ?? this.level,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serialNumberMeta =
      const VerificationMeta('serialNumber');
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
      'serial_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<EntryStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EntryStatus>($JournalEntriesTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postedByMeta =
      const VerificationMeta('postedBy');
  @override
  late final GeneratedColumn<String> postedBy = GeneratedColumn<String>(
      'posted_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postedAtMeta =
      const VerificationMeta('postedAt');
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
      'posted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<EntryType?, int> entryType =
      GeneratedColumn<int>('entry_type', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<EntryType?>($JournalEntriesTable.$converterentryTypen);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reversalOfIdMeta =
      const VerificationMeta('reversalOfId');
  @override
  late final GeneratedColumn<int> reversalOfId = GeneratedColumn<int>(
      'reversal_of_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serialNumber,
        date,
        description,
        reference,
        status,
        notes,
        createdBy,
        postedBy,
        postedAt,
        entryType,
        sourceType,
        sourceId,
        reversalOfId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serial_number')) {
      context.handle(
          _serialNumberMeta,
          serialNumber.isAcceptableOrUnknown(
              data['serial_number']!, _serialNumberMeta));
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('posted_by')) {
      context.handle(_postedByMeta,
          postedBy.isAcceptableOrUnknown(data['posted_by']!, _postedByMeta));
    }
    if (data.containsKey('posted_at')) {
      context.handle(_postedAtMeta,
          postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    }
    if (data.containsKey('reversal_of_id')) {
      context.handle(
          _reversalOfIdMeta,
          reversalOfId.isAcceptableOrUnknown(
              data['reversal_of_id']!, _reversalOfIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {serialNumber},
      ];
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      status: $JournalEntriesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      postedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}posted_by']),
      postedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}posted_at']),
      entryType: $JournalEntriesTable.$converterentryTypen.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}entry_type'])),
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type']),
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id']),
      reversalOfId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reversal_of_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntryStatus, int, int> $converterstatus =
      const EnumIndexConverter<EntryStatus>(EntryStatus.values);
  static JsonTypeConverter2<EntryType, int, int> $converterentryType =
      const EnumIndexConverter<EntryType>(EntryType.values);
  static JsonTypeConverter2<EntryType?, int?, int?> $converterentryTypen =
      JsonTypeConverter2.asNullable($converterentryType);
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;

  /// رقم القيد المتسلسل (Unique Serial Number)
  final String serialNumber;
  final DateTime date;
  final String description;

  /// رقم المرجع (فاتورة، سند، ...)
  final String? reference;
  final EntryStatus status;
  final String? notes;
  final String? createdBy;
  final String? postedBy;
  final DateTime? postedAt;

  /// نوع العملية (مبيعات، مشتريات، سند قبض...) - اختياري
  final EntryType? entryType;

  /// ربط القيد بمستند في النظام المضيف (مثال: 'invoice' / '15')
  final String? sourceType;
  final String? sourceId;

  /// إن كان هذا القيد قيداً عكسياً: معرّف القيد الأصلي
  final int? reversalOfId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntry(
      {required this.id,
      required this.serialNumber,
      required this.date,
      required this.description,
      this.reference,
      required this.status,
      this.notes,
      this.createdBy,
      this.postedBy,
      this.postedAt,
      this.entryType,
      this.sourceType,
      this.sourceId,
      this.reversalOfId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serial_number'] = Variable<String>(serialNumber);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    {
      map['status'] =
          Variable<int>($JournalEntriesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || postedBy != null) {
      map['posted_by'] = Variable<String>(postedBy);
    }
    if (!nullToAbsent || postedAt != null) {
      map['posted_at'] = Variable<DateTime>(postedAt);
    }
    if (!nullToAbsent || entryType != null) {
      map['entry_type'] = Variable<int>(
          $JournalEntriesTable.$converterentryTypen.toSql(entryType));
    }
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || reversalOfId != null) {
      map['reversal_of_id'] = Variable<int>(reversalOfId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      serialNumber: Value(serialNumber),
      date: Value(date),
      description: Value(description),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      postedBy: postedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(postedBy),
      postedAt: postedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(postedAt),
      entryType: entryType == null && nullToAbsent
          ? const Value.absent()
          : Value(entryType),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      reversalOfId: reversalOfId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalOfId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String>(json['description']),
      reference: serializer.fromJson<String?>(json['reference']),
      status: $JournalEntriesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      notes: serializer.fromJson<String?>(json['notes']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      postedBy: serializer.fromJson<String?>(json['postedBy']),
      postedAt: serializer.fromJson<DateTime?>(json['postedAt']),
      entryType: $JournalEntriesTable.$converterentryTypen
          .fromJson(serializer.fromJson<int?>(json['entryType'])),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      reversalOfId: serializer.fromJson<int?>(json['reversalOfId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String>(description),
      'reference': serializer.toJson<String?>(reference),
      'status': serializer
          .toJson<int>($JournalEntriesTable.$converterstatus.toJson(status)),
      'notes': serializer.toJson<String?>(notes),
      'createdBy': serializer.toJson<String?>(createdBy),
      'postedBy': serializer.toJson<String?>(postedBy),
      'postedAt': serializer.toJson<DateTime?>(postedAt),
      'entryType': serializer.toJson<int?>(
          $JournalEntriesTable.$converterentryTypen.toJson(entryType)),
      'sourceType': serializer.toJson<String?>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'reversalOfId': serializer.toJson<int?>(reversalOfId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntry copyWith(
          {int? id,
          String? serialNumber,
          DateTime? date,
          String? description,
          Value<String?> reference = const Value.absent(),
          EntryStatus? status,
          Value<String?> notes = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          Value<String?> postedBy = const Value.absent(),
          Value<DateTime?> postedAt = const Value.absent(),
          Value<EntryType?> entryType = const Value.absent(),
          Value<String?> sourceType = const Value.absent(),
          Value<String?> sourceId = const Value.absent(),
          Value<int?> reversalOfId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      JournalEntry(
        id: id ?? this.id,
        serialNumber: serialNumber ?? this.serialNumber,
        date: date ?? this.date,
        description: description ?? this.description,
        reference: reference.present ? reference.value : this.reference,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        postedBy: postedBy.present ? postedBy.value : this.postedBy,
        postedAt: postedAt.present ? postedAt.value : this.postedAt,
        entryType: entryType.present ? entryType.value : this.entryType,
        sourceType: sourceType.present ? sourceType.value : this.sourceType,
        sourceId: sourceId.present ? sourceId.value : this.sourceId,
        reversalOfId:
            reversalOfId.present ? reversalOfId.value : this.reversalOfId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      date: data.date.present ? data.date.value : this.date,
      description:
          data.description.present ? data.description.value : this.description,
      reference: data.reference.present ? data.reference.value : this.reference,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      postedBy: data.postedBy.present ? data.postedBy.value : this.postedBy,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      reversalOfId: data.reversalOfId.present
          ? data.reversalOfId.value
          : this.reversalOfId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('reference: $reference, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdBy: $createdBy, ')
          ..write('postedBy: $postedBy, ')
          ..write('postedAt: $postedAt, ')
          ..write('entryType: $entryType, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('reversalOfId: $reversalOfId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      serialNumber,
      date,
      description,
      reference,
      status,
      notes,
      createdBy,
      postedBy,
      postedAt,
      entryType,
      sourceType,
      sourceId,
      reversalOfId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.serialNumber == this.serialNumber &&
          other.date == this.date &&
          other.description == this.description &&
          other.reference == this.reference &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdBy == this.createdBy &&
          other.postedBy == this.postedBy &&
          other.postedAt == this.postedAt &&
          other.entryType == this.entryType &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.reversalOfId == this.reversalOfId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> serialNumber;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<String?> reference;
  final Value<EntryStatus> status;
  final Value<String?> notes;
  final Value<String?> createdBy;
  final Value<String?> postedBy;
  final Value<DateTime?> postedAt;
  final Value<EntryType?> entryType;
  final Value<String?> sourceType;
  final Value<String?> sourceId;
  final Value<int?> reversalOfId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.reference = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.postedBy = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.entryType = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.reversalOfId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String serialNumber,
    required DateTime date,
    required String description,
    this.reference = const Value.absent(),
    required EntryStatus status,
    this.notes = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.postedBy = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.entryType = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.reversalOfId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : serialNumber = Value(serialNumber),
        date = Value(date),
        description = Value(description),
        status = Value(status);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? serialNumber,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<String>? reference,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<String>? createdBy,
    Expression<String>? postedBy,
    Expression<DateTime>? postedAt,
    Expression<int>? entryType,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<int>? reversalOfId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (reference != null) 'reference': reference,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdBy != null) 'created_by': createdBy,
      if (postedBy != null) 'posted_by': postedBy,
      if (postedAt != null) 'posted_at': postedAt,
      if (entryType != null) 'entry_type': entryType,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (reversalOfId != null) 'reversal_of_id': reversalOfId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? serialNumber,
      Value<DateTime>? date,
      Value<String>? description,
      Value<String?>? reference,
      Value<EntryStatus>? status,
      Value<String?>? notes,
      Value<String?>? createdBy,
      Value<String?>? postedBy,
      Value<DateTime?>? postedAt,
      Value<EntryType?>? entryType,
      Value<String?>? sourceType,
      Value<String?>? sourceId,
      Value<int?>? reversalOfId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      date: date ?? this.date,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      postedBy: postedBy ?? this.postedBy,
      postedAt: postedAt ?? this.postedAt,
      entryType: entryType ?? this.entryType,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      reversalOfId: reversalOfId ?? this.reversalOfId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $JournalEntriesTable.$converterstatus.toSql(status.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (postedBy.present) {
      map['posted_by'] = Variable<String>(postedBy.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<int>(
          $JournalEntriesTable.$converterentryTypen.toSql(entryType.value));
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (reversalOfId.present) {
      map['reversal_of_id'] = Variable<int>(reversalOfId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('reference: $reference, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdBy: $createdBy, ')
          ..write('postedBy: $postedBy, ')
          ..write('postedAt: $postedAt, ')
          ..write('entryType: $entryType, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('reversalOfId: $reversalOfId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntryLinesTable extends JournalEntryLines
    with TableInfo<$JournalEntryLinesTable, JournalEntryLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entryIdMeta =
      const VerificationMeta('entryId');
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
      'entry_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES journal_entries (id)'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
      'debit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
      'credit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _amountCurrencyMeta =
      const VerificationMeta('amountCurrency');
  @override
  late final GeneratedColumn<double> amountCurrency = GeneratedColumn<double>(
      'amount_currency', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entryId,
        accountId,
        debit,
        credit,
        description,
        sortOrder,
        currencyCode,
        amountCurrency,
        exchangeRate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_lines';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntryLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(_entryIdMeta,
          entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta));
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    }
    if (data.containsKey('credit')) {
      context.handle(_creditMeta,
          credit.isAcceptableOrUnknown(data['credit']!, _creditMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('amount_currency')) {
      context.handle(
          _amountCurrencyMeta,
          amountCurrency.isAcceptableOrUnknown(
              data['amount_currency']!, _amountCurrencyMeta));
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entry_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debit'])!,
      credit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code']),
      amountCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_currency']),
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate']),
    );
  }

  @override
  $JournalEntryLinesTable createAlias(String alias) {
    return $JournalEntryLinesTable(attachedDatabase, alias);
  }
}

class JournalEntryLine extends DataClass
    implements Insertable<JournalEntryLine> {
  final int id;
  final int entryId;
  final int accountId;

  /// المبلغ المدين (0 إذا كان البند دائناً)
  final double debit;

  /// المبلغ الدائن (0 إذا كان البند مديناً)
  final double credit;
  final String? description;

  /// ترتيب البند داخل القيد
  final int sortOrder;
  final String? currencyCode;

  /// المبلغ بعملة البند (موجب، والجهة تتبع المدين/الدائن)
  final double? amountCurrency;
  final double? exchangeRate;
  const JournalEntryLine(
      {required this.id,
      required this.entryId,
      required this.accountId,
      required this.debit,
      required this.credit,
      this.description,
      required this.sortOrder,
      this.currencyCode,
      this.amountCurrency,
      this.exchangeRate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entry_id'] = Variable<int>(entryId);
    map['account_id'] = Variable<int>(accountId);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || amountCurrency != null) {
      map['amount_currency'] = Variable<double>(amountCurrency);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    return map;
  }

  JournalEntryLinesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryLinesCompanion(
      id: Value(id),
      entryId: Value(entryId),
      accountId: Value(accountId),
      debit: Value(debit),
      credit: Value(credit),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      amountCurrency: amountCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCurrency),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
    );
  }

  factory JournalEntryLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryLine(
      id: serializer.fromJson<int>(json['id']),
      entryId: serializer.fromJson<int>(json['entryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      amountCurrency: serializer.fromJson<double?>(json['amountCurrency']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entryId': serializer.toJson<int>(entryId),
      'accountId': serializer.toJson<int>(accountId),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'amountCurrency': serializer.toJson<double?>(amountCurrency),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
    };
  }

  JournalEntryLine copyWith(
          {int? id,
          int? entryId,
          int? accountId,
          double? debit,
          double? credit,
          Value<String?> description = const Value.absent(),
          int? sortOrder,
          Value<String?> currencyCode = const Value.absent(),
          Value<double?> amountCurrency = const Value.absent(),
          Value<double?> exchangeRate = const Value.absent()}) =>
      JournalEntryLine(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        accountId: accountId ?? this.accountId,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        description: description.present ? description.value : this.description,
        sortOrder: sortOrder ?? this.sortOrder,
        currencyCode:
            currencyCode.present ? currencyCode.value : this.currencyCode,
        amountCurrency:
            amountCurrency.present ? amountCurrency.value : this.amountCurrency,
        exchangeRate:
            exchangeRate.present ? exchangeRate.value : this.exchangeRate,
      );
  JournalEntryLine copyWithCompanion(JournalEntryLinesCompanion data) {
    return JournalEntryLine(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      description:
          data.description.present ? data.description.value : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      amountCurrency: data.amountCurrency.present
          ? data.amountCurrency.value
          : this.amountCurrency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryLine(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountCurrency: $amountCurrency, ')
          ..write('exchangeRate: $exchangeRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryId, accountId, debit, credit,
      description, sortOrder, currencyCode, amountCurrency, exchangeRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryLine &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.accountId == this.accountId &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.currencyCode == this.currencyCode &&
          other.amountCurrency == this.amountCurrency &&
          other.exchangeRate == this.exchangeRate);
}

class JournalEntryLinesCompanion extends UpdateCompanion<JournalEntryLine> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<int> accountId;
  final Value<double> debit;
  final Value<double> credit;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<String?> currencyCode;
  final Value<double?> amountCurrency;
  final Value<double?> exchangeRate;
  const JournalEntryLinesCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.amountCurrency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
  });
  JournalEntryLinesCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required int accountId,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.amountCurrency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
  })  : entryId = Value(entryId),
        accountId = Value(accountId);
  static Insertable<JournalEntryLine> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<int>? accountId,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<String>? currencyCode,
    Expression<double>? amountCurrency,
    Expression<double>? exchangeRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (accountId != null) 'account_id': accountId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amountCurrency != null) 'amount_currency': amountCurrency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
    });
  }

  JournalEntryLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? entryId,
      Value<int>? accountId,
      Value<double>? debit,
      Value<double>? credit,
      Value<String?>? description,
      Value<int>? sortOrder,
      Value<String?>? currencyCode,
      Value<double?>? amountCurrency,
      Value<double?>? exchangeRate}) {
    return JournalEntryLinesCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      currencyCode: currencyCode ?? this.currencyCode,
      amountCurrency: amountCurrency ?? this.amountCurrency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (amountCurrency.present) {
      map['amount_currency'] = Variable<double>(amountCurrency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryLinesCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountCurrency: $amountCurrency, ')
          ..write('exchangeRate: $exchangeRate')
          ..write(')'))
        .toString();
  }
}

class $AccountingPeriodsTable extends AccountingPeriods
    with TableInfo<$AccountingPeriodsTable, AccountingPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountingPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isClosedMeta =
      const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
      'is_closed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, startDate, endDate, isClosed, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounting_periods';
  @override
  VerificationContext validateIntegrity(Insertable<AccountingPeriod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(_isClosedMeta,
          isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountingPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountingPeriod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      isClosed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountingPeriodsTable createAlias(String alias) {
    return $AccountingPeriodsTable(attachedDatabase, alias);
  }
}

class AccountingPeriod extends DataClass
    implements Insertable<AccountingPeriod> {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isClosed;
  final DateTime createdAt;
  const AccountingPeriod(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.isClosed,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['is_closed'] = Variable<bool>(isClosed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountingPeriodsCompanion toCompanion(bool nullToAbsent) {
    return AccountingPeriodsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      isClosed: Value(isClosed),
      createdAt: Value(createdAt),
    );
  }

  factory AccountingPeriod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountingPeriod(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'isClosed': serializer.toJson<bool>(isClosed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountingPeriod copyWith(
          {int? id,
          String? name,
          DateTime? startDate,
          DateTime? endDate,
          bool? isClosed,
          DateTime? createdAt}) =>
      AccountingPeriod(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isClosed: isClosed ?? this.isClosed,
        createdAt: createdAt ?? this.createdAt,
      );
  AccountingPeriod copyWithCompanion(AccountingPeriodsCompanion data) {
    return AccountingPeriod(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountingPeriod(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, startDate, endDate, isClosed, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountingPeriod &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isClosed == this.isClosed &&
          other.createdAt == this.createdAt);
}

class AccountingPeriodsCompanion extends UpdateCompanion<AccountingPeriod> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> isClosed;
  final Value<DateTime> createdAt;
  const AccountingPeriodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountingPeriodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        startDate = Value(startDate),
        endDate = Value(endDate);
  static Insertable<AccountingPeriod> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isClosed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isClosed != null) 'is_closed': isClosed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountingPeriodsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<bool>? isClosed,
      Value<DateTime>? createdAt}) {
    return AccountingPeriodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountingPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EntryTemplatesTable extends EntryTemplates
    with TableInfo<$EntryTemplatesTable, EntryTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<EntryType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EntryType>($EntryTemplatesTable.$convertertype);
  static const VerificationMeta _linesJsonMeta =
      const VerificationMeta('linesJson');
  @override
  late final GeneratedColumn<String> linesJson = GeneratedColumn<String>(
      'lines_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, type, linesJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_templates';
  @override
  VerificationContext validateIntegrity(Insertable<EntryTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('lines_json')) {
      context.handle(_linesJsonMeta,
          linesJson.isAcceptableOrUnknown(data['lines_json']!, _linesJsonMeta));
    } else if (isInserting) {
      context.missing(_linesJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: $EntryTemplatesTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      linesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lines_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EntryTemplatesTable createAlias(String alias) {
    return $EntryTemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntryType, int, int> $convertertype =
      const EnumIndexConverter<EntryType>(EntryType.values);
}

class EntryTemplate extends DataClass implements Insertable<EntryTemplate> {
  final int id;
  final String name;
  final String? description;
  final EntryType type;

  /// بنود القالب مخزّنة كـ JSON
  final String linesJson;
  final DateTime createdAt;
  const EntryTemplate(
      {required this.id,
      required this.name,
      this.description,
      required this.type,
      required this.linesJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['type'] =
          Variable<int>($EntryTemplatesTable.$convertertype.toSql(type));
    }
    map['lines_json'] = Variable<String>(linesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntryTemplatesCompanion toCompanion(bool nullToAbsent) {
    return EntryTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      linesJson: Value(linesJson),
      createdAt: Value(createdAt),
    );
  }

  factory EntryTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      type: $EntryTemplatesTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      linesJson: serializer.fromJson<String>(json['linesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'type': serializer
          .toJson<int>($EntryTemplatesTable.$convertertype.toJson(type)),
      'linesJson': serializer.toJson<String>(linesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntryTemplate copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          EntryType? type,
          String? linesJson,
          DateTime? createdAt}) =>
      EntryTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        linesJson: linesJson ?? this.linesJson,
        createdAt: createdAt ?? this.createdAt,
      );
  EntryTemplate copyWithCompanion(EntryTemplatesCompanion data) {
    return EntryTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      linesJson: data.linesJson.present ? data.linesJson.value : this.linesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, type, linesJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.linesJson == this.linesJson &&
          other.createdAt == this.createdAt);
}

class EntryTemplatesCompanion extends UpdateCompanion<EntryTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<EntryType> type;
  final Value<String> linesJson;
  final Value<DateTime> createdAt;
  const EntryTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.linesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EntryTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required EntryType type,
    required String linesJson,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        linesJson = Value(linesJson);
  static Insertable<EntryTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? type,
    Expression<String>? linesJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (linesJson != null) 'lines_json': linesJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EntryTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<EntryType>? type,
      Value<String>? linesJson,
      Value<DateTime>? createdAt}) {
    return EntryTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      linesJson: linesJson ?? this.linesJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($EntryTemplatesTable.$convertertype.toSql(type.value));
    }
    if (linesJson.present) {
      map['lines_json'] = Variable<String>(linesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('linesJson: $linesJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CostDimensionsTable extends CostDimensions
    with TableInfo<$CostDimensionsTable, CostDimension> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostDimensionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<DimensionPolicy, int>
      defaultPolicy = GeneratedColumn<int>('default_policy', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(DimensionPolicy.optional.index))
          .withConverter<DimensionPolicy>(
              $CostDimensionsTable.$converterdefaultPolicy);
  static const VerificationMeta _allowSplitMeta =
      const VerificationMeta('allowSplit');
  @override
  late final GeneratedColumn<bool> allowSplit = GeneratedColumn<bool>(
      'allow_split', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("allow_split" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        nameAr,
        description,
        defaultPolicy,
        allowSplit,
        isActive,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_dimensions';
  @override
  VerificationContext validateIntegrity(Insertable<CostDimension> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('allow_split')) {
      context.handle(
          _allowSplitMeta,
          allowSplit.isAcceptableOrUnknown(
              data['allow_split']!, _allowSplitMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code},
      ];
  @override
  CostDimension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostDimension(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      defaultPolicy: $CostDimensionsTable.$converterdefaultPolicy.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}default_policy'])!),
      allowSplit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allow_split'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CostDimensionsTable createAlias(String alias) {
    return $CostDimensionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DimensionPolicy, int, int> $converterdefaultPolicy =
      const EnumIndexConverter<DimensionPolicy>(DimensionPolicy.values);
}

class CostDimension extends DataClass implements Insertable<CostDimension> {
  final int id;
  final String code;
  final String name;
  final String? nameAr;
  final String? description;

  /// السياسة الافتراضية لكل الحسابات
  final DimensionPolicy defaultPolicy;

  /// هل يُسمح بتوزيع البند على أكثر من مركز من هذا البعد؟
  final bool allowSplit;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CostDimension(
      {required this.id,
      required this.code,
      required this.name,
      this.nameAr,
      this.description,
      required this.defaultPolicy,
      required this.allowSplit,
      required this.isActive,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['default_policy'] = Variable<int>(
          $CostDimensionsTable.$converterdefaultPolicy.toSql(defaultPolicy));
    }
    map['allow_split'] = Variable<bool>(allowSplit);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CostDimensionsCompanion toCompanion(bool nullToAbsent) {
    return CostDimensionsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      defaultPolicy: Value(defaultPolicy),
      allowSplit: Value(allowSplit),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CostDimension.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostDimension(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      description: serializer.fromJson<String?>(json['description']),
      defaultPolicy: $CostDimensionsTable.$converterdefaultPolicy
          .fromJson(serializer.fromJson<int>(json['defaultPolicy'])),
      allowSplit: serializer.fromJson<bool>(json['allowSplit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'description': serializer.toJson<String?>(description),
      'defaultPolicy': serializer.toJson<int>(
          $CostDimensionsTable.$converterdefaultPolicy.toJson(defaultPolicy)),
      'allowSplit': serializer.toJson<bool>(allowSplit),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CostDimension copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> nameAr = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DimensionPolicy? defaultPolicy,
          bool? allowSplit,
          bool? isActive,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CostDimension(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        description: description.present ? description.value : this.description,
        defaultPolicy: defaultPolicy ?? this.defaultPolicy,
        allowSplit: allowSplit ?? this.allowSplit,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CostDimension copyWithCompanion(CostDimensionsCompanion data) {
    return CostDimension(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      description:
          data.description.present ? data.description.value : this.description,
      defaultPolicy: data.defaultPolicy.present
          ? data.defaultPolicy.value
          : this.defaultPolicy,
      allowSplit:
          data.allowSplit.present ? data.allowSplit.value : this.allowSplit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostDimension(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('defaultPolicy: $defaultPolicy, ')
          ..write('allowSplit: $allowSplit, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, nameAr, description,
      defaultPolicy, allowSplit, isActive, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostDimension &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.description == this.description &&
          other.defaultPolicy == this.defaultPolicy &&
          other.allowSplit == this.allowSplit &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CostDimensionsCompanion extends UpdateCompanion<CostDimension> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<String?> description;
  final Value<DimensionPolicy> defaultPolicy;
  final Value<bool> allowSplit;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CostDimensionsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.defaultPolicy = const Value.absent(),
    this.allowSplit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CostDimensionsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.defaultPolicy = const Value.absent(),
    this.allowSplit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name);
  static Insertable<CostDimension> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? description,
    Expression<int>? defaultPolicy,
    Expression<bool>? allowSplit,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (description != null) 'description': description,
      if (defaultPolicy != null) 'default_policy': defaultPolicy,
      if (allowSplit != null) 'allow_split': allowSplit,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CostDimensionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? nameAr,
      Value<String?>? description,
      Value<DimensionPolicy>? defaultPolicy,
      Value<bool>? allowSplit,
      Value<bool>? isActive,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CostDimensionsCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (defaultPolicy.present) {
      map['default_policy'] = Variable<int>($CostDimensionsTable
          .$converterdefaultPolicy
          .toSql(defaultPolicy.value));
    }
    if (allowSplit.present) {
      map['allow_split'] = Variable<bool>(allowSplit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostDimensionsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('defaultPolicy: $defaultPolicy, ')
          ..write('allowSplit: $allowSplit, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CostCentersTable extends CostCenters
    with TableInfo<$CostCentersTable, CostCenter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostCentersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dimensionIdMeta =
      const VerificationMeta('dimensionId');
  @override
  late final GeneratedColumn<int> dimensionId = GeneratedColumn<int>(
      'dimension_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cost_dimensions (id)'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cost_centers (id)'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dimensionId,
        code,
        name,
        nameAr,
        parentId,
        level,
        isActive,
        description,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_centers';
  @override
  VerificationContext validateIntegrity(Insertable<CostCenter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dimension_id')) {
      context.handle(
          _dimensionIdMeta,
          dimensionId.isAcceptableOrUnknown(
              data['dimension_id']!, _dimensionIdMeta));
    } else if (isInserting) {
      context.missing(_dimensionIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code},
      ];
  @override
  CostCenter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostCenter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dimensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dimension_id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CostCentersTable createAlias(String alias) {
    return $CostCentersTable(attachedDatabase, alias);
  }
}

class CostCenter extends DataClass implements Insertable<CostCenter> {
  final int id;
  final int dimensionId;
  final String code;
  final String name;
  final String? nameAr;
  final int? parentId;
  final int level;
  final bool isActive;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CostCenter(
      {required this.id,
      required this.dimensionId,
      required this.code,
      required this.name,
      this.nameAr,
      this.parentId,
      required this.level,
      required this.isActive,
      this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dimension_id'] = Variable<int>(dimensionId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['level'] = Variable<int>(level);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CostCentersCompanion toCompanion(bool nullToAbsent) {
    return CostCentersCompanion(
      id: Value(id),
      dimensionId: Value(dimensionId),
      code: Value(code),
      name: Value(name),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      level: Value(level),
      isActive: Value(isActive),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CostCenter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostCenter(
      id: serializer.fromJson<int>(json['id']),
      dimensionId: serializer.fromJson<int>(json['dimensionId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      level: serializer.fromJson<int>(json['level']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dimensionId': serializer.toJson<int>(dimensionId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'parentId': serializer.toJson<int?>(parentId),
      'level': serializer.toJson<int>(level),
      'isActive': serializer.toJson<bool>(isActive),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CostCenter copyWith(
          {int? id,
          int? dimensionId,
          String? code,
          String? name,
          Value<String?> nameAr = const Value.absent(),
          Value<int?> parentId = const Value.absent(),
          int? level,
          bool? isActive,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CostCenter(
        id: id ?? this.id,
        dimensionId: dimensionId ?? this.dimensionId,
        code: code ?? this.code,
        name: name ?? this.name,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        parentId: parentId.present ? parentId.value : this.parentId,
        level: level ?? this.level,
        isActive: isActive ?? this.isActive,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CostCenter copyWithCompanion(CostCentersCompanion data) {
    return CostCenter(
      id: data.id.present ? data.id.value : this.id,
      dimensionId:
          data.dimensionId.present ? data.dimensionId.value : this.dimensionId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      level: data.level.present ? data.level.value : this.level,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostCenter(')
          ..write('id: $id, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dimensionId, code, name, nameAr, parentId,
      level, isActive, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostCenter &&
          other.id == this.id &&
          other.dimensionId == this.dimensionId &&
          other.code == this.code &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.parentId == this.parentId &&
          other.level == this.level &&
          other.isActive == this.isActive &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CostCentersCompanion extends UpdateCompanion<CostCenter> {
  final Value<int> id;
  final Value<int> dimensionId;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<int?> parentId;
  final Value<int> level;
  final Value<bool> isActive;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CostCentersCompanion({
    this.id = const Value.absent(),
    this.dimensionId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CostCentersCompanion.insert({
    this.id = const Value.absent(),
    required int dimensionId,
    required String code,
    required String name,
    this.nameAr = const Value.absent(),
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : dimensionId = Value(dimensionId),
        code = Value(code),
        name = Value(name);
  static Insertable<CostCenter> custom({
    Expression<int>? id,
    Expression<int>? dimensionId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? parentId,
    Expression<int>? level,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dimensionId != null) 'dimension_id': dimensionId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (parentId != null) 'parent_id': parentId,
      if (level != null) 'level': level,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CostCentersCompanion copyWith(
      {Value<int>? id,
      Value<int>? dimensionId,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? nameAr,
      Value<int?>? parentId,
      Value<int>? level,
      Value<bool>? isActive,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CostCentersCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dimensionId.present) {
      map['dimension_id'] = Variable<int>(dimensionId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostCentersCompanion(')
          ..write('id: $id, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalLineAllocationsTable extends JournalLineAllocations
    with TableInfo<$JournalLineAllocationsTable, JournalLineAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalLineAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<int> lineId = GeneratedColumn<int>(
      'line_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES journal_entry_lines (id)'));
  static const VerificationMeta _costCenterIdMeta =
      const VerificationMeta('costCenterId');
  @override
  late final GeneratedColumn<int> costCenterId = GeneratedColumn<int>(
      'cost_center_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cost_centers (id)'));
  static const VerificationMeta _dimensionIdMeta =
      const VerificationMeta('dimensionId');
  @override
  late final GeneratedColumn<int> dimensionId = GeneratedColumn<int>(
      'dimension_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cost_dimensions (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
      'percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lineId, costCenterId, dimensionId, amount, percentage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_line_allocations';
  @override
  VerificationContext validateIntegrity(
      Insertable<JournalLineAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('line_id')) {
      context.handle(_lineIdMeta,
          lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta));
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('cost_center_id')) {
      context.handle(
          _costCenterIdMeta,
          costCenterId.isAcceptableOrUnknown(
              data['cost_center_id']!, _costCenterIdMeta));
    } else if (isInserting) {
      context.missing(_costCenterIdMeta);
    }
    if (data.containsKey('dimension_id')) {
      context.handle(
          _dimensionIdMeta,
          dimensionId.isAcceptableOrUnknown(
              data['dimension_id']!, _dimensionIdMeta));
    } else if (isInserting) {
      context.missing(_dimensionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalLineAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalLineAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_id'])!,
      costCenterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost_center_id'])!,
      dimensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dimension_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percentage'])!,
    );
  }

  @override
  $JournalLineAllocationsTable createAlias(String alias) {
    return $JournalLineAllocationsTable(attachedDatabase, alias);
  }
}

class JournalLineAllocation extends DataClass
    implements Insertable<JournalLineAllocation> {
  final int id;
  final int lineId;
  final int costCenterId;

  /// بُعد المركز (نسخة لتسريع التقارير)
  final int dimensionId;

  /// المبلغ المخصص (موجب دائماً، والجهة تتبع البند)
  final double amount;

  /// النسبة من مبلغ البند (0-100)
  final double percentage;
  const JournalLineAllocation(
      {required this.id,
      required this.lineId,
      required this.costCenterId,
      required this.dimensionId,
      required this.amount,
      required this.percentage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['line_id'] = Variable<int>(lineId);
    map['cost_center_id'] = Variable<int>(costCenterId);
    map['dimension_id'] = Variable<int>(dimensionId);
    map['amount'] = Variable<double>(amount);
    map['percentage'] = Variable<double>(percentage);
    return map;
  }

  JournalLineAllocationsCompanion toCompanion(bool nullToAbsent) {
    return JournalLineAllocationsCompanion(
      id: Value(id),
      lineId: Value(lineId),
      costCenterId: Value(costCenterId),
      dimensionId: Value(dimensionId),
      amount: Value(amount),
      percentage: Value(percentage),
    );
  }

  factory JournalLineAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalLineAllocation(
      id: serializer.fromJson<int>(json['id']),
      lineId: serializer.fromJson<int>(json['lineId']),
      costCenterId: serializer.fromJson<int>(json['costCenterId']),
      dimensionId: serializer.fromJson<int>(json['dimensionId']),
      amount: serializer.fromJson<double>(json['amount']),
      percentage: serializer.fromJson<double>(json['percentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lineId': serializer.toJson<int>(lineId),
      'costCenterId': serializer.toJson<int>(costCenterId),
      'dimensionId': serializer.toJson<int>(dimensionId),
      'amount': serializer.toJson<double>(amount),
      'percentage': serializer.toJson<double>(percentage),
    };
  }

  JournalLineAllocation copyWith(
          {int? id,
          int? lineId,
          int? costCenterId,
          int? dimensionId,
          double? amount,
          double? percentage}) =>
      JournalLineAllocation(
        id: id ?? this.id,
        lineId: lineId ?? this.lineId,
        costCenterId: costCenterId ?? this.costCenterId,
        dimensionId: dimensionId ?? this.dimensionId,
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
      );
  JournalLineAllocation copyWithCompanion(
      JournalLineAllocationsCompanion data) {
    return JournalLineAllocation(
      id: data.id.present ? data.id.value : this.id,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      dimensionId:
          data.dimensionId.present ? data.dimensionId.value : this.dimensionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      percentage:
          data.percentage.present ? data.percentage.value : this.percentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalLineAllocation(')
          ..write('id: $id, ')
          ..write('lineId: $lineId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('amount: $amount, ')
          ..write('percentage: $percentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lineId, costCenterId, dimensionId, amount, percentage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalLineAllocation &&
          other.id == this.id &&
          other.lineId == this.lineId &&
          other.costCenterId == this.costCenterId &&
          other.dimensionId == this.dimensionId &&
          other.amount == this.amount &&
          other.percentage == this.percentage);
}

class JournalLineAllocationsCompanion
    extends UpdateCompanion<JournalLineAllocation> {
  final Value<int> id;
  final Value<int> lineId;
  final Value<int> costCenterId;
  final Value<int> dimensionId;
  final Value<double> amount;
  final Value<double> percentage;
  const JournalLineAllocationsCompanion({
    this.id = const Value.absent(),
    this.lineId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.dimensionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.percentage = const Value.absent(),
  });
  JournalLineAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int lineId,
    required int costCenterId,
    required int dimensionId,
    required double amount,
    required double percentage,
  })  : lineId = Value(lineId),
        costCenterId = Value(costCenterId),
        dimensionId = Value(dimensionId),
        amount = Value(amount),
        percentage = Value(percentage);
  static Insertable<JournalLineAllocation> custom({
    Expression<int>? id,
    Expression<int>? lineId,
    Expression<int>? costCenterId,
    Expression<int>? dimensionId,
    Expression<double>? amount,
    Expression<double>? percentage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lineId != null) 'line_id': lineId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (dimensionId != null) 'dimension_id': dimensionId,
      if (amount != null) 'amount': amount,
      if (percentage != null) 'percentage': percentage,
    });
  }

  JournalLineAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? lineId,
      Value<int>? costCenterId,
      Value<int>? dimensionId,
      Value<double>? amount,
      Value<double>? percentage}) {
    return JournalLineAllocationsCompanion(
      id: id ?? this.id,
      lineId: lineId ?? this.lineId,
      costCenterId: costCenterId ?? this.costCenterId,
      dimensionId: dimensionId ?? this.dimensionId,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<int>(lineId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<int>(costCenterId.value);
    }
    if (dimensionId.present) {
      map['dimension_id'] = Variable<int>(dimensionId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalLineAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('lineId: $lineId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('amount: $amount, ')
          ..write('percentage: $percentage')
          ..write(')'))
        .toString();
  }
}

class $CostDimensionRulesTable extends CostDimensionRules
    with TableInfo<$CostDimensionRulesTable, CostDimensionRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostDimensionRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dimensionIdMeta =
      const VerificationMeta('dimensionId');
  @override
  late final GeneratedColumn<int> dimensionId = GeneratedColumn<int>(
      'dimension_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cost_dimensions (id)'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  @override
  late final GeneratedColumnWithTypeConverter<AccountType?, int> accountType =
      GeneratedColumn<int>('account_type', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<AccountType?>(
              $CostDimensionRulesTable.$converteraccountTypen);
  @override
  late final GeneratedColumnWithTypeConverter<DimensionPolicy, int> policy =
      GeneratedColumn<int>('policy', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<DimensionPolicy>(
              $CostDimensionRulesTable.$converterpolicy);
  static const VerificationMeta _defaultCostCenterIdMeta =
      const VerificationMeta('defaultCostCenterId');
  @override
  late final GeneratedColumn<int> defaultCostCenterId = GeneratedColumn<int>(
      'default_cost_center_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cost_centers (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, dimensionId, accountId, accountType, policy, defaultCostCenterId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_dimension_rules';
  @override
  VerificationContext validateIntegrity(Insertable<CostDimensionRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dimension_id')) {
      context.handle(
          _dimensionIdMeta,
          dimensionId.isAcceptableOrUnknown(
              data['dimension_id']!, _dimensionIdMeta));
    } else if (isInserting) {
      context.missing(_dimensionIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('default_cost_center_id')) {
      context.handle(
          _defaultCostCenterIdMeta,
          defaultCostCenterId.isAcceptableOrUnknown(
              data['default_cost_center_id']!, _defaultCostCenterIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostDimensionRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostDimensionRule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dimensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dimension_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id']),
      accountType: $CostDimensionRulesTable.$converteraccountTypen.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}account_type'])),
      policy: $CostDimensionRulesTable.$converterpolicy.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}policy'])!),
      defaultCostCenterId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_cost_center_id']),
    );
  }

  @override
  $CostDimensionRulesTable createAlias(String alias) {
    return $CostDimensionRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, int, int> $converteraccountType =
      const EnumIndexConverter<AccountType>(AccountType.values);
  static JsonTypeConverter2<AccountType?, int?, int?> $converteraccountTypen =
      JsonTypeConverter2.asNullable($converteraccountType);
  static JsonTypeConverter2<DimensionPolicy, int, int> $converterpolicy =
      const EnumIndexConverter<DimensionPolicy>(DimensionPolicy.values);
}

class CostDimensionRule extends DataClass
    implements Insertable<CostDimensionRule> {
  final int id;
  final int dimensionId;
  final int? accountId;
  final AccountType? accountType;
  final DimensionPolicy policy;
  final int? defaultCostCenterId;
  const CostDimensionRule(
      {required this.id,
      required this.dimensionId,
      this.accountId,
      this.accountType,
      required this.policy,
      this.defaultCostCenterId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dimension_id'] = Variable<int>(dimensionId);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || accountType != null) {
      map['account_type'] = Variable<int>(
          $CostDimensionRulesTable.$converteraccountTypen.toSql(accountType));
    }
    {
      map['policy'] = Variable<int>(
          $CostDimensionRulesTable.$converterpolicy.toSql(policy));
    }
    if (!nullToAbsent || defaultCostCenterId != null) {
      map['default_cost_center_id'] = Variable<int>(defaultCostCenterId);
    }
    return map;
  }

  CostDimensionRulesCompanion toCompanion(bool nullToAbsent) {
    return CostDimensionRulesCompanion(
      id: Value(id),
      dimensionId: Value(dimensionId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      accountType: accountType == null && nullToAbsent
          ? const Value.absent()
          : Value(accountType),
      policy: Value(policy),
      defaultCostCenterId: defaultCostCenterId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCostCenterId),
    );
  }

  factory CostDimensionRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostDimensionRule(
      id: serializer.fromJson<int>(json['id']),
      dimensionId: serializer.fromJson<int>(json['dimensionId']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      accountType: $CostDimensionRulesTable.$converteraccountTypen
          .fromJson(serializer.fromJson<int?>(json['accountType'])),
      policy: $CostDimensionRulesTable.$converterpolicy
          .fromJson(serializer.fromJson<int>(json['policy'])),
      defaultCostCenterId:
          serializer.fromJson<int?>(json['defaultCostCenterId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dimensionId': serializer.toJson<int>(dimensionId),
      'accountId': serializer.toJson<int?>(accountId),
      'accountType': serializer.toJson<int?>(
          $CostDimensionRulesTable.$converteraccountTypen.toJson(accountType)),
      'policy': serializer.toJson<int>(
          $CostDimensionRulesTable.$converterpolicy.toJson(policy)),
      'defaultCostCenterId': serializer.toJson<int?>(defaultCostCenterId),
    };
  }

  CostDimensionRule copyWith(
          {int? id,
          int? dimensionId,
          Value<int?> accountId = const Value.absent(),
          Value<AccountType?> accountType = const Value.absent(),
          DimensionPolicy? policy,
          Value<int?> defaultCostCenterId = const Value.absent()}) =>
      CostDimensionRule(
        id: id ?? this.id,
        dimensionId: dimensionId ?? this.dimensionId,
        accountId: accountId.present ? accountId.value : this.accountId,
        accountType: accountType.present ? accountType.value : this.accountType,
        policy: policy ?? this.policy,
        defaultCostCenterId: defaultCostCenterId.present
            ? defaultCostCenterId.value
            : this.defaultCostCenterId,
      );
  CostDimensionRule copyWithCompanion(CostDimensionRulesCompanion data) {
    return CostDimensionRule(
      id: data.id.present ? data.id.value : this.id,
      dimensionId:
          data.dimensionId.present ? data.dimensionId.value : this.dimensionId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      policy: data.policy.present ? data.policy.value : this.policy,
      defaultCostCenterId: data.defaultCostCenterId.present
          ? data.defaultCostCenterId.value
          : this.defaultCostCenterId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostDimensionRule(')
          ..write('id: $id, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('accountId: $accountId, ')
          ..write('accountType: $accountType, ')
          ..write('policy: $policy, ')
          ..write('defaultCostCenterId: $defaultCostCenterId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, dimensionId, accountId, accountType, policy, defaultCostCenterId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostDimensionRule &&
          other.id == this.id &&
          other.dimensionId == this.dimensionId &&
          other.accountId == this.accountId &&
          other.accountType == this.accountType &&
          other.policy == this.policy &&
          other.defaultCostCenterId == this.defaultCostCenterId);
}

class CostDimensionRulesCompanion extends UpdateCompanion<CostDimensionRule> {
  final Value<int> id;
  final Value<int> dimensionId;
  final Value<int?> accountId;
  final Value<AccountType?> accountType;
  final Value<DimensionPolicy> policy;
  final Value<int?> defaultCostCenterId;
  const CostDimensionRulesCompanion({
    this.id = const Value.absent(),
    this.dimensionId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountType = const Value.absent(),
    this.policy = const Value.absent(),
    this.defaultCostCenterId = const Value.absent(),
  });
  CostDimensionRulesCompanion.insert({
    this.id = const Value.absent(),
    required int dimensionId,
    this.accountId = const Value.absent(),
    this.accountType = const Value.absent(),
    required DimensionPolicy policy,
    this.defaultCostCenterId = const Value.absent(),
  })  : dimensionId = Value(dimensionId),
        policy = Value(policy);
  static Insertable<CostDimensionRule> custom({
    Expression<int>? id,
    Expression<int>? dimensionId,
    Expression<int>? accountId,
    Expression<int>? accountType,
    Expression<int>? policy,
    Expression<int>? defaultCostCenterId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dimensionId != null) 'dimension_id': dimensionId,
      if (accountId != null) 'account_id': accountId,
      if (accountType != null) 'account_type': accountType,
      if (policy != null) 'policy': policy,
      if (defaultCostCenterId != null)
        'default_cost_center_id': defaultCostCenterId,
    });
  }

  CostDimensionRulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? dimensionId,
      Value<int?>? accountId,
      Value<AccountType?>? accountType,
      Value<DimensionPolicy>? policy,
      Value<int?>? defaultCostCenterId}) {
    return CostDimensionRulesCompanion(
      id: id ?? this.id,
      dimensionId: dimensionId ?? this.dimensionId,
      accountId: accountId ?? this.accountId,
      accountType: accountType ?? this.accountType,
      policy: policy ?? this.policy,
      defaultCostCenterId: defaultCostCenterId ?? this.defaultCostCenterId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dimensionId.present) {
      map['dimension_id'] = Variable<int>(dimensionId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<int>($CostDimensionRulesTable
          .$converteraccountTypen
          .toSql(accountType.value));
    }
    if (policy.present) {
      map['policy'] = Variable<int>(
          $CostDimensionRulesTable.$converterpolicy.toSql(policy.value));
    }
    if (defaultCostCenterId.present) {
      map['default_cost_center_id'] = Variable<int>(defaultCostCenterId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostDimensionRulesCompanion(')
          ..write('id: $id, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('accountId: $accountId, ')
          ..write('accountType: $accountType, ')
          ..write('policy: $policy, ')
          ..write('defaultCostCenterId: $defaultCostCenterId')
          ..write(')'))
        .toString();
  }
}

class $AllocationKeysTable extends AllocationKeys
    with TableInfo<$AllocationKeysTable, AllocationKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _dimensionIdMeta =
      const VerificationMeta('dimensionId');
  @override
  late final GeneratedColumn<int> dimensionId = GeneratedColumn<int>(
      'dimension_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cost_dimensions (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        nameAr,
        dimensionId,
        description,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocation_keys';
  @override
  VerificationContext validateIntegrity(Insertable<AllocationKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('dimension_id')) {
      context.handle(
          _dimensionIdMeta,
          dimensionId.isAcceptableOrUnknown(
              data['dimension_id']!, _dimensionIdMeta));
    } else if (isInserting) {
      context.missing(_dimensionIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code},
      ];
  @override
  AllocationKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllocationKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      dimensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dimension_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AllocationKeysTable createAlias(String alias) {
    return $AllocationKeysTable(attachedDatabase, alias);
  }
}

class AllocationKey extends DataClass implements Insertable<AllocationKey> {
  final int id;
  final String code;
  final String name;
  final String? nameAr;
  final int dimensionId;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AllocationKey(
      {required this.id,
      required this.code,
      required this.name,
      this.nameAr,
      required this.dimensionId,
      this.description,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['dimension_id'] = Variable<int>(dimensionId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AllocationKeysCompanion toCompanion(bool nullToAbsent) {
    return AllocationKeysCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      dimensionId: Value(dimensionId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AllocationKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllocationKey(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      dimensionId: serializer.fromJson<int>(json['dimensionId']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'dimensionId': serializer.toJson<int>(dimensionId),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AllocationKey copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> nameAr = const Value.absent(),
          int? dimensionId,
          Value<String?> description = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AllocationKey(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        dimensionId: dimensionId ?? this.dimensionId,
        description: description.present ? description.value : this.description,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AllocationKey copyWithCompanion(AllocationKeysCompanion data) {
    return AllocationKey(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      dimensionId:
          data.dimensionId.present ? data.dimensionId.value : this.dimensionId,
      description:
          data.description.present ? data.description.value : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllocationKey(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, nameAr, dimensionId,
      description, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllocationKey &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.dimensionId == this.dimensionId &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AllocationKeysCompanion extends UpdateCompanion<AllocationKey> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<int> dimensionId;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AllocationKeysCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.dimensionId = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AllocationKeysCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.nameAr = const Value.absent(),
    required int dimensionId,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        dimensionId = Value(dimensionId);
  static Insertable<AllocationKey> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? dimensionId,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (dimensionId != null) 'dimension_id': dimensionId,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AllocationKeysCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? nameAr,
      Value<int>? dimensionId,
      Value<String?>? description,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AllocationKeysCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      dimensionId: dimensionId ?? this.dimensionId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (dimensionId.present) {
      map['dimension_id'] = Variable<int>(dimensionId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationKeysCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('dimensionId: $dimensionId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AllocationKeyItemsTable extends AllocationKeyItems
    with TableInfo<$AllocationKeyItemsTable, AllocationKeyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationKeyItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyIdMeta = const VerificationMeta('keyId');
  @override
  late final GeneratedColumn<int> keyId = GeneratedColumn<int>(
      'key_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES allocation_keys (id)'));
  static const VerificationMeta _costCenterIdMeta =
      const VerificationMeta('costCenterId');
  @override
  late final GeneratedColumn<int> costCenterId = GeneratedColumn<int>(
      'cost_center_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cost_centers (id)'));
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, keyId, costCenterId, weight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocation_key_items';
  @override
  VerificationContext validateIntegrity(Insertable<AllocationKeyItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key_id')) {
      context.handle(
          _keyIdMeta, keyId.isAcceptableOrUnknown(data['key_id']!, _keyIdMeta));
    } else if (isInserting) {
      context.missing(_keyIdMeta);
    }
    if (data.containsKey('cost_center_id')) {
      context.handle(
          _costCenterIdMeta,
          costCenterId.isAcceptableOrUnknown(
              data['cost_center_id']!, _costCenterIdMeta));
    } else if (isInserting) {
      context.missing(_costCenterIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllocationKeyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllocationKeyItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      keyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key_id'])!,
      costCenterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost_center_id'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
    );
  }

  @override
  $AllocationKeyItemsTable createAlias(String alias) {
    return $AllocationKeyItemsTable(attachedDatabase, alias);
  }
}

class AllocationKeyItem extends DataClass
    implements Insertable<AllocationKeyItem> {
  final int id;
  final int keyId;
  final int costCenterId;
  final double weight;
  const AllocationKeyItem(
      {required this.id,
      required this.keyId,
      required this.costCenterId,
      required this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key_id'] = Variable<int>(keyId);
    map['cost_center_id'] = Variable<int>(costCenterId);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  AllocationKeyItemsCompanion toCompanion(bool nullToAbsent) {
    return AllocationKeyItemsCompanion(
      id: Value(id),
      keyId: Value(keyId),
      costCenterId: Value(costCenterId),
      weight: Value(weight),
    );
  }

  factory AllocationKeyItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllocationKeyItem(
      id: serializer.fromJson<int>(json['id']),
      keyId: serializer.fromJson<int>(json['keyId']),
      costCenterId: serializer.fromJson<int>(json['costCenterId']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'keyId': serializer.toJson<int>(keyId),
      'costCenterId': serializer.toJson<int>(costCenterId),
      'weight': serializer.toJson<double>(weight),
    };
  }

  AllocationKeyItem copyWith(
          {int? id, int? keyId, int? costCenterId, double? weight}) =>
      AllocationKeyItem(
        id: id ?? this.id,
        keyId: keyId ?? this.keyId,
        costCenterId: costCenterId ?? this.costCenterId,
        weight: weight ?? this.weight,
      );
  AllocationKeyItem copyWithCompanion(AllocationKeyItemsCompanion data) {
    return AllocationKeyItem(
      id: data.id.present ? data.id.value : this.id,
      keyId: data.keyId.present ? data.keyId.value : this.keyId,
      costCenterId: data.costCenterId.present
          ? data.costCenterId.value
          : this.costCenterId,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllocationKeyItem(')
          ..write('id: $id, ')
          ..write('keyId: $keyId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, keyId, costCenterId, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllocationKeyItem &&
          other.id == this.id &&
          other.keyId == this.keyId &&
          other.costCenterId == this.costCenterId &&
          other.weight == this.weight);
}

class AllocationKeyItemsCompanion extends UpdateCompanion<AllocationKeyItem> {
  final Value<int> id;
  final Value<int> keyId;
  final Value<int> costCenterId;
  final Value<double> weight;
  const AllocationKeyItemsCompanion({
    this.id = const Value.absent(),
    this.keyId = const Value.absent(),
    this.costCenterId = const Value.absent(),
    this.weight = const Value.absent(),
  });
  AllocationKeyItemsCompanion.insert({
    this.id = const Value.absent(),
    required int keyId,
    required int costCenterId,
    required double weight,
  })  : keyId = Value(keyId),
        costCenterId = Value(costCenterId),
        weight = Value(weight);
  static Insertable<AllocationKeyItem> custom({
    Expression<int>? id,
    Expression<int>? keyId,
    Expression<int>? costCenterId,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (keyId != null) 'key_id': keyId,
      if (costCenterId != null) 'cost_center_id': costCenterId,
      if (weight != null) 'weight': weight,
    });
  }

  AllocationKeyItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? keyId,
      Value<int>? costCenterId,
      Value<double>? weight}) {
    return AllocationKeyItemsCompanion(
      id: id ?? this.id,
      keyId: keyId ?? this.keyId,
      costCenterId: costCenterId ?? this.costCenterId,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (keyId.present) {
      map['key_id'] = Variable<int>(keyId.value);
    }
    if (costCenterId.present) {
      map['cost_center_id'] = Variable<int>(costCenterId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationKeyItemsCompanion(')
          ..write('id: $id, ')
          ..write('keyId: $keyId, ')
          ..write('costCenterId: $costCenterId, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _decimalPlacesMeta =
      const VerificationMeta('decimalPlaces');
  @override
  late final GeneratedColumn<int> decimalPlaces = GeneratedColumn<int>(
      'decimal_places', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, name, nameAr, symbol, decimalPlaces, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    }
    if (data.containsKey('decimal_places')) {
      context.handle(
          _decimalPlacesMeta,
          decimalPlaces.isAcceptableOrUnknown(
              data['decimal_places']!, _decimalPlacesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code},
      ];
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol']),
      decimalPlaces: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}decimal_places'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final int id;
  final String code;
  final String name;
  final String? nameAr;
  final String? symbol;
  final int decimalPlaces;
  final bool isActive;
  const Currency(
      {required this.id,
      required this.code,
      required this.name,
      this.nameAr,
      this.symbol,
      required this.decimalPlaces,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    map['decimal_places'] = Variable<int>(decimalPlaces);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      decimalPlaces: Value(decimalPlaces),
      isActive: Value(isActive),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      symbol: serializer.fromJson<String?>(json['symbol']),
      decimalPlaces: serializer.fromJson<int>(json['decimalPlaces']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String?>(nameAr),
      'symbol': serializer.toJson<String?>(symbol),
      'decimalPlaces': serializer.toJson<int>(decimalPlaces),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Currency copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> nameAr = const Value.absent(),
          Value<String?> symbol = const Value.absent(),
          int? decimalPlaces,
          bool? isActive}) =>
      Currency(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        symbol: symbol.present ? symbol.value : this.symbol,
        decimalPlaces: decimalPlaces ?? this.decimalPlaces,
        isActive: isActive ?? this.isActive,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      decimalPlaces: data.decimalPlaces.present
          ? data.decimalPlaces.value
          : this.decimalPlaces,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('symbol: $symbol, ')
          ..write('decimalPlaces: $decimalPlaces, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, nameAr, symbol, decimalPlaces, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.symbol == this.symbol &&
          other.decimalPlaces == this.decimalPlaces &&
          other.isActive == this.isActive);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> nameAr;
  final Value<String?> symbol;
  final Value<int> decimalPlaces;
  final Value<bool> isActive;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.symbol = const Value.absent(),
    this.decimalPlaces = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.nameAr = const Value.absent(),
    this.symbol = const Value.absent(),
    this.decimalPlaces = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : code = Value(code),
        name = Value(name);
  static Insertable<Currency> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? symbol,
    Expression<int>? decimalPlaces,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (symbol != null) 'symbol': symbol,
      if (decimalPlaces != null) 'decimal_places': decimalPlaces,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? nameAr,
      Value<String?>? symbol,
      Value<int>? decimalPlaces,
      Value<bool>? isActive}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      symbol: symbol ?? this.symbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (decimalPlaces.present) {
      map['decimal_places'] = Variable<int>(decimalPlaces.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('symbol: $symbol, ')
          ..write('decimalPlaces: $decimalPlaces, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, currencyCode, date, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {currencyCode, date},
      ];
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final int id;
  final String currencyCode;
  final DateTime date;
  final double rate;
  const ExchangeRate(
      {required this.id,
      required this.currencyCode,
      required this.date,
      required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_code'] = Variable<String>(currencyCode);
    map['date'] = Variable<DateTime>(date);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      currencyCode: Value(currencyCode),
      date: Value(date),
      rate: Value(rate),
    );
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<int>(json['id']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      date: serializer.fromJson<DateTime>(json['date']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'date': serializer.toJson<DateTime>(date),
      'rate': serializer.toJson<double>(rate),
    };
  }

  ExchangeRate copyWith(
          {int? id, String? currencyCode, DateTime? date, double? rate}) =>
      ExchangeRate(
        id: id ?? this.id,
        currencyCode: currencyCode ?? this.currencyCode,
        date: date ?? this.date,
        rate: rate ?? this.rate,
      );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      date: data.date.present ? data.date.value : this.date,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('date: $date, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currencyCode, date, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.currencyCode == this.currencyCode &&
          other.date == this.date &&
          other.rate == this.rate);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<int> id;
  final Value<String> currencyCode;
  final Value<DateTime> date;
  final Value<double> rate;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.date = const Value.absent(),
    this.rate = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required String currencyCode,
    required DateTime date,
    required double rate,
  })  : currencyCode = Value(currencyCode),
        date = Value(date),
        rate = Value(rate);
  static Insertable<ExchangeRate> custom({
    Expression<int>? id,
    Expression<String>? currencyCode,
    Expression<DateTime>? date,
    Expression<double>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (date != null) 'date': date,
      if (rate != null) 'rate': rate,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? currencyCode,
      Value<DateTime>? date,
      Value<double>? rate}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      date: date ?? this.date,
      rate: rate ?? this.rate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('date: $date, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $AccountingSettingsTable extends AccountingSettings
    with TableInfo<$AccountingSettingsTable, AccountingSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountingSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounting_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AccountingSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AccountingSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountingSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AccountingSettingsTable createAlias(String alias) {
    return $AccountingSettingsTable(attachedDatabase, alias);
  }
}

class AccountingSetting extends DataClass
    implements Insertable<AccountingSetting> {
  final String key;
  final String value;
  const AccountingSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AccountingSettingsCompanion toCompanion(bool nullToAbsent) {
    return AccountingSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AccountingSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountingSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AccountingSetting copyWith({String? key, String? value}) => AccountingSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AccountingSetting copyWithCompanion(AccountingSettingsCompanion data) {
    return AccountingSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountingSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountingSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AccountingSettingsCompanion extends UpdateCompanion<AccountingSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AccountingSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountingSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AccountingSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountingSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AccountingSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountingSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AccountingDatabase extends GeneratedDatabase {
  _$AccountingDatabase(QueryExecutor e) : super(e);
  $AccountingDatabaseManager get managers => $AccountingDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalEntryLinesTable journalEntryLines =
      $JournalEntryLinesTable(this);
  late final $AccountingPeriodsTable accountingPeriods =
      $AccountingPeriodsTable(this);
  late final $EntryTemplatesTable entryTemplates = $EntryTemplatesTable(this);
  late final $CostDimensionsTable costDimensions = $CostDimensionsTable(this);
  late final $CostCentersTable costCenters = $CostCentersTable(this);
  late final $JournalLineAllocationsTable journalLineAllocations =
      $JournalLineAllocationsTable(this);
  late final $CostDimensionRulesTable costDimensionRules =
      $CostDimensionRulesTable(this);
  late final $AllocationKeysTable allocationKeys = $AllocationKeysTable(this);
  late final $AllocationKeyItemsTable allocationKeyItems =
      $AllocationKeyItemsTable(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $AccountingSettingsTable accountingSettings =
      $AccountingSettingsTable(this);
  late final Index idxJournalEntriesDate = Index('idx_journal_entries_date',
      'CREATE INDEX idx_journal_entries_date ON journal_entries (date)');
  late final Index idxJournalEntriesSource = Index('idx_journal_entries_source',
      'CREATE INDEX idx_journal_entries_source ON journal_entries (source_type, source_id)');
  late final Index idxJournalEntryLinesEntry = Index(
      'idx_journal_entry_lines_entry',
      'CREATE INDEX idx_journal_entry_lines_entry ON journal_entry_lines (entry_id)');
  late final Index idxJournalEntryLinesAccount = Index(
      'idx_journal_entry_lines_account',
      'CREATE INDEX idx_journal_entry_lines_account ON journal_entry_lines (account_id)');
  late final Index idxCostCentersDimension = Index('idx_cost_centers_dimension',
      'CREATE INDEX idx_cost_centers_dimension ON cost_centers (dimension_id)');
  late final Index idxLineAllocationsLine = Index('idx_line_allocations_line',
      'CREATE INDEX idx_line_allocations_line ON journal_line_allocations (line_id)');
  late final Index idxLineAllocationsCenter = Index(
      'idx_line_allocations_center',
      'CREATE INDEX idx_line_allocations_center ON journal_line_allocations (cost_center_id)');
  late final Index idxExchangeRatesLookup = Index('idx_exchange_rates_lookup',
      'CREATE INDEX idx_exchange_rates_lookup ON exchange_rates (currency_code, date)');
  late final AccountsDao accountsDao = AccountsDao(this as AccountingDatabase);
  late final JournalEntriesDao journalEntriesDao =
      JournalEntriesDao(this as AccountingDatabase);
  late final EntryTemplatesDao entryTemplatesDao =
      EntryTemplatesDao(this as AccountingDatabase);
  late final CostCentersDao costCentersDao =
      CostCentersDao(this as AccountingDatabase);
  late final CurrenciesDao currenciesDao =
      CurrenciesDao(this as AccountingDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        journalEntries,
        journalEntryLines,
        accountingPeriods,
        entryTemplates,
        costDimensions,
        costCenters,
        journalLineAllocations,
        costDimensionRules,
        allocationKeys,
        allocationKeyItems,
        currencies,
        exchangeRates,
        accountingSettings,
        idxJournalEntriesDate,
        idxJournalEntriesSource,
        idxJournalEntryLinesEntry,
        idxJournalEntryLinesAccount,
        idxCostCentersDimension,
        idxLineAllocationsLine,
        idxLineAllocationsCenter,
        idxExchangeRatesLookup
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> nameAr,
  required AccountType type,
  Value<int?> parentId,
  Value<bool> isActive,
  Value<String?> description,
  Value<int> level,
  Value<String?> currencyCode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> nameAr,
  Value<AccountType> type,
  Value<int?> parentId,
  Value<bool> isActive,
  Value<String?> description,
  Value<int> level,
  Value<String?> currencyCode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AccountingDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _parentIdTable(_$AccountingDatabase db) =>
      db.accounts.createAlias('accounts__parent_id__accounts__id');

  $$AccountsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$JournalEntryLinesTable, List<JournalEntryLine>>
      _journalEntryLinesRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.journalEntryLines,
              aliasName: 'accounts__id__journal_entry_lines__account_id');

  $$JournalEntryLinesTableProcessedTableManager get journalEntryLinesRefs {
    final manager =
        $$JournalEntryLinesTableTableManager($_db, $_db.journalEntryLines)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalEntryLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CostDimensionRulesTable, List<CostDimensionRule>>
      _costDimensionRulesRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.costDimensionRules,
              aliasName: 'accounts__id__cost_dimension_rules__account_id');

  $$CostDimensionRulesTableProcessedTableManager get costDimensionRulesRefs {
    final manager =
        $$CostDimensionRulesTableTableManager($_db, $_db.costDimensionRules)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_costDimensionRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AccountingDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType, AccountType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get parentId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> journalEntryLinesRefs(
      Expression<bool> Function($$JournalEntryLinesTableFilterComposer f) f) {
    final $$JournalEntryLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.journalEntryLines,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntryLinesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntryLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> costDimensionRulesRefs(
      Expression<bool> Function($$CostDimensionRulesTableFilterComposer f) f) {
    final $$CostDimensionRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costDimensionRules,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionRulesTableFilterComposer(
              $db: $db,
              $table: $db.costDimensionRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get parentId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get parentId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> journalEntryLinesRefs<T extends Object>(
      Expression<T> Function($$JournalEntryLinesTableAnnotationComposer a) f) {
    final $$JournalEntryLinesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalEntryLines,
            getReferencedColumn: (t) => t.accountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalEntryLinesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalEntryLines,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> costDimensionRulesRefs<T extends Object>(
      Expression<T> Function($$CostDimensionRulesTableAnnotationComposer a) f) {
    final $$CostDimensionRulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.costDimensionRules,
            getReferencedColumn: (t) => t.accountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CostDimensionRulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.costDimensionRules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool parentId,
        bool journalEntryLinesRefs,
        bool costDimensionRulesRefs})> {
  $$AccountsTableTableManager(_$AccountingDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<AccountType> type = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            type: type,
            parentId: parentId,
            isActive: isActive,
            description: description,
            level: level,
            currencyCode: currencyCode,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> nameAr = const Value.absent(),
            required AccountType type,
            Value<int?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            type: type,
            parentId: parentId,
            isActive: isActive,
            description: description,
            level: level,
            currencyCode: currencyCode,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountsTable, Account>(table),
                    $$AccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {parentId = false,
              journalEntryLinesRefs = false,
              costDimensionRulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntryLinesRefs) db.journalEntryLines,
                if (costDimensionRulesRefs) db.costDimensionRules
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$AccountsTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$AccountsTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntryLinesRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            JournalEntryLine>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._journalEntryLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .journalEntryLinesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (costDimensionRulesRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            CostDimensionRule>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._costDimensionRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .costDimensionRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool parentId,
        bool journalEntryLinesRefs,
        bool costDimensionRulesRefs})>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  required String serialNumber,
  required DateTime date,
  required String description,
  Value<String?> reference,
  required EntryStatus status,
  Value<String?> notes,
  Value<String?> createdBy,
  Value<String?> postedBy,
  Value<DateTime?> postedAt,
  Value<EntryType?> entryType,
  Value<String?> sourceType,
  Value<String?> sourceId,
  Value<int?> reversalOfId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String> serialNumber,
  Value<DateTime> date,
  Value<String> description,
  Value<String?> reference,
  Value<EntryStatus> status,
  Value<String?> notes,
  Value<String?> createdBy,
  Value<String?> postedBy,
  Value<DateTime?> postedAt,
  Value<EntryType?> entryType,
  Value<String?> sourceType,
  Value<String?> sourceId,
  Value<int?> reversalOfId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$JournalEntriesTableReferences extends BaseReferences<
    _$AccountingDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalEntryLinesTable, List<JournalEntryLine>>
      _journalEntryLinesRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.journalEntryLines,
              aliasName: 'journal_entries__id__journal_entry_lines__entry_id');

  $$JournalEntryLinesTableProcessedTableManager get journalEntryLinesRefs {
    final manager =
        $$JournalEntryLinesTableTableManager($_db, $_db.journalEntryLines)
            .filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalEntryLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AccountingDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EntryStatus, EntryStatus, int> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postedBy => $composableBuilder(
      column: $table.postedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get postedAt => $composableBuilder(
      column: $table.postedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EntryType?, EntryType, int> get entryType =>
      $composableBuilder(
          column: $table.entryType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> journalEntryLinesRefs(
      Expression<bool> Function($$JournalEntryLinesTableFilterComposer f) f) {
    final $$JournalEntryLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.journalEntryLines,
        getReferencedColumn: (t) => t.entryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntryLinesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntryLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postedBy => $composableBuilder(
      column: $table.postedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get postedAt => $composableBuilder(
      column: $table.postedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entryType => $composableBuilder(
      column: $table.entryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get postedBy =>
      $composableBuilder(column: $table.postedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryType?, int> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> journalEntryLinesRefs<T extends Object>(
      Expression<T> Function($$JournalEntryLinesTableAnnotationComposer a) f) {
    final $$JournalEntryLinesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalEntryLines,
            getReferencedColumn: (t) => t.entryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalEntryLinesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalEntryLines,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntry, $$JournalEntriesTableReferences),
    JournalEntry,
    PrefetchHooks Function({bool journalEntryLinesRefs})> {
  $$JournalEntriesTableTableManager(
      _$AccountingDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serialNumber = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<EntryStatus> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> postedBy = const Value.absent(),
            Value<DateTime?> postedAt = const Value.absent(),
            Value<EntryType?> entryType = const Value.absent(),
            Value<String?> sourceType = const Value.absent(),
            Value<String?> sourceId = const Value.absent(),
            Value<int?> reversalOfId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            serialNumber: serialNumber,
            date: date,
            description: description,
            reference: reference,
            status: status,
            notes: notes,
            createdBy: createdBy,
            postedBy: postedBy,
            postedAt: postedAt,
            entryType: entryType,
            sourceType: sourceType,
            sourceId: sourceId,
            reversalOfId: reversalOfId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serialNumber,
            required DateTime date,
            required String description,
            Value<String?> reference = const Value.absent(),
            required EntryStatus status,
            Value<String?> notes = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> postedBy = const Value.absent(),
            Value<DateTime?> postedAt = const Value.absent(),
            Value<EntryType?> entryType = const Value.absent(),
            Value<String?> sourceType = const Value.absent(),
            Value<String?> sourceId = const Value.absent(),
            Value<int?> reversalOfId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            serialNumber: serialNumber,
            date: date,
            description: description,
            reference: reference,
            status: status,
            notes: notes,
            createdBy: createdBy,
            postedBy: postedBy,
            postedAt: postedAt,
            entryType: entryType,
            sourceType: sourceType,
            sourceId: sourceId,
            reversalOfId: reversalOfId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$JournalEntriesTable, JournalEntry>(table),
                    $$JournalEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({journalEntryLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntryLinesRefs) db.journalEntryLines
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntryLinesRefs)
                    await $_getPrefetchedData<JournalEntry,
                            $JournalEntriesTable, JournalEntryLine>(
                        currentTable: table,
                        referencedTable: $$JournalEntriesTableReferences
                            ._journalEntryLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$JournalEntriesTableReferences(db, table, p0)
                                .journalEntryLinesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntry, $$JournalEntriesTableReferences),
    JournalEntry,
    PrefetchHooks Function({bool journalEntryLinesRefs})>;
typedef $$JournalEntryLinesTableCreateCompanionBuilder
    = JournalEntryLinesCompanion Function({
  Value<int> id,
  required int entryId,
  required int accountId,
  Value<double> debit,
  Value<double> credit,
  Value<String?> description,
  Value<int> sortOrder,
  Value<String?> currencyCode,
  Value<double?> amountCurrency,
  Value<double?> exchangeRate,
});
typedef $$JournalEntryLinesTableUpdateCompanionBuilder
    = JournalEntryLinesCompanion Function({
  Value<int> id,
  Value<int> entryId,
  Value<int> accountId,
  Value<double> debit,
  Value<double> credit,
  Value<String?> description,
  Value<int> sortOrder,
  Value<String?> currencyCode,
  Value<double?> amountCurrency,
  Value<double?> exchangeRate,
});

final class $$JournalEntryLinesTableReferences extends BaseReferences<
    _$AccountingDatabase, $JournalEntryLinesTable, JournalEntryLine> {
  $$JournalEntryLinesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JournalEntriesTable _entryIdTable(_$AccountingDatabase db) =>
      db.journalEntries
          .createAlias('journal_entry_lines__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager($_db, $_db.journalEntries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _accountIdTable(_$AccountingDatabase db) =>
      db.accounts.createAlias('journal_entry_lines__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$JournalLineAllocationsTable,
      List<JournalLineAllocation>> _journalLineAllocationsRefsTable(
          _$AccountingDatabase db) =>
      MultiTypedResultKey.fromTable(db.journalLineAllocations,
          aliasName:
              'journal_entry_lines__id__journal_line_allocations__line_id');

  $$JournalLineAllocationsTableProcessedTableManager
      get journalLineAllocationsRefs {
    final manager = $$JournalLineAllocationsTableTableManager(
            $_db, $_db.journalLineAllocations)
        .filter((f) => f.lineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalLineAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$JournalEntryLinesTableFilterComposer
    extends Composer<_$AccountingDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> journalLineAllocationsRefs(
      Expression<bool> Function($$JournalLineAllocationsTableFilterComposer f)
          f) {
    final $$JournalLineAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.lineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$JournalEntryLinesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntryLinesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<double> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entryId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> journalLineAllocationsRefs<T extends Object>(
      Expression<T> Function($$JournalLineAllocationsTableAnnotationComposer a)
          f) {
    final $$JournalLineAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.lineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$JournalEntryLinesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $JournalEntryLinesTable,
    JournalEntryLine,
    $$JournalEntryLinesTableFilterComposer,
    $$JournalEntryLinesTableOrderingComposer,
    $$JournalEntryLinesTableAnnotationComposer,
    $$JournalEntryLinesTableCreateCompanionBuilder,
    $$JournalEntryLinesTableUpdateCompanionBuilder,
    (JournalEntryLine, $$JournalEntryLinesTableReferences),
    JournalEntryLine,
    PrefetchHooks Function(
        {bool entryId, bool accountId, bool journalLineAllocationsRefs})> {
  $$JournalEntryLinesTableTableManager(
      _$AccountingDatabase db, $JournalEntryLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntryLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntryLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntryLinesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> entryId = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<double?> amountCurrency = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
          }) =>
              JournalEntryLinesCompanion(
            id: id,
            entryId: entryId,
            accountId: accountId,
            debit: debit,
            credit: credit,
            description: description,
            sortOrder: sortOrder,
            currencyCode: currencyCode,
            amountCurrency: amountCurrency,
            exchangeRate: exchangeRate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int entryId,
            required int accountId,
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<double?> amountCurrency = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
          }) =>
              JournalEntryLinesCompanion.insert(
            id: id,
            entryId: entryId,
            accountId: accountId,
            debit: debit,
            credit: credit,
            description: description,
            sortOrder: sortOrder,
            currencyCode: currencyCode,
            amountCurrency: amountCurrency,
            exchangeRate: exchangeRate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$JournalEntryLinesTable, JournalEntryLine>(
                        table),
                    $$JournalEntryLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {entryId = false,
              accountId = false,
              journalLineAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalLineAllocationsRefs) db.journalLineAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (entryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entryId,
                    referencedTable:
                        $$JournalEntryLinesTableReferences._entryIdTable(db),
                    referencedColumn:
                        $$JournalEntryLinesTableReferences._entryIdTable(db).id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$JournalEntryLinesTableReferences._accountIdTable(db),
                    referencedColumn: $$JournalEntryLinesTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalLineAllocationsRefs)
                    await $_getPrefetchedData<JournalEntryLine,
                            $JournalEntryLinesTable, JournalLineAllocation>(
                        currentTable: table,
                        referencedTable: $$JournalEntryLinesTableReferences
                            ._journalLineAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$JournalEntryLinesTableReferences(db, table, p0)
                                .journalLineAllocationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.lineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$JournalEntryLinesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $JournalEntryLinesTable,
    JournalEntryLine,
    $$JournalEntryLinesTableFilterComposer,
    $$JournalEntryLinesTableOrderingComposer,
    $$JournalEntryLinesTableAnnotationComposer,
    $$JournalEntryLinesTableCreateCompanionBuilder,
    $$JournalEntryLinesTableUpdateCompanionBuilder,
    (JournalEntryLine, $$JournalEntryLinesTableReferences),
    JournalEntryLine,
    PrefetchHooks Function(
        {bool entryId, bool accountId, bool journalLineAllocationsRefs})>;
typedef $$AccountingPeriodsTableCreateCompanionBuilder
    = AccountingPeriodsCompanion Function({
  Value<int> id,
  required String name,
  required DateTime startDate,
  required DateTime endDate,
  Value<bool> isClosed,
  Value<DateTime> createdAt,
});
typedef $$AccountingPeriodsTableUpdateCompanionBuilder
    = AccountingPeriodsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<bool> isClosed,
  Value<DateTime> createdAt,
});

class $$AccountingPeriodsTableFilterComposer
    extends Composer<_$AccountingDatabase, $AccountingPeriodsTable> {
  $$AccountingPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AccountingPeriodsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $AccountingPeriodsTable> {
  $$AccountingPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountingPeriodsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $AccountingPeriodsTable> {
  $$AccountingPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountingPeriodsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $AccountingPeriodsTable,
    AccountingPeriod,
    $$AccountingPeriodsTableFilterComposer,
    $$AccountingPeriodsTableOrderingComposer,
    $$AccountingPeriodsTableAnnotationComposer,
    $$AccountingPeriodsTableCreateCompanionBuilder,
    $$AccountingPeriodsTableUpdateCompanionBuilder,
    (
      AccountingPeriod,
      BaseReferences<_$AccountingDatabase, $AccountingPeriodsTable,
          AccountingPeriod>
    ),
    AccountingPeriod,
    PrefetchHooks Function()> {
  $$AccountingPeriodsTableTableManager(
      _$AccountingDatabase db, $AccountingPeriodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountingPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountingPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountingPeriodsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<bool> isClosed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AccountingPeriodsCompanion(
            id: id,
            name: name,
            startDate: startDate,
            endDate: endDate,
            isClosed: isClosed,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime startDate,
            required DateTime endDate,
            Value<bool> isClosed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AccountingPeriodsCompanion.insert(
            id: id,
            name: name,
            startDate: startDate,
            endDate: endDate,
            isClosed: isClosed,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountingPeriodsTable, AccountingPeriod>(
                        table),
                    BaseReferences<_$AccountingDatabase,
                        $AccountingPeriodsTable, AccountingPeriod>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountingPeriodsTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $AccountingPeriodsTable,
    AccountingPeriod,
    $$AccountingPeriodsTableFilterComposer,
    $$AccountingPeriodsTableOrderingComposer,
    $$AccountingPeriodsTableAnnotationComposer,
    $$AccountingPeriodsTableCreateCompanionBuilder,
    $$AccountingPeriodsTableUpdateCompanionBuilder,
    (
      AccountingPeriod,
      BaseReferences<_$AccountingDatabase, $AccountingPeriodsTable,
          AccountingPeriod>
    ),
    AccountingPeriod,
    PrefetchHooks Function()>;
typedef $$EntryTemplatesTableCreateCompanionBuilder = EntryTemplatesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required EntryType type,
  required String linesJson,
  Value<DateTime> createdAt,
});
typedef $$EntryTemplatesTableUpdateCompanionBuilder = EntryTemplatesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<EntryType> type,
  Value<String> linesJson,
  Value<DateTime> createdAt,
});

class $$EntryTemplatesTableFilterComposer
    extends Composer<_$AccountingDatabase, $EntryTemplatesTable> {
  $$EntryTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EntryType, EntryType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get linesJson => $composableBuilder(
      column: $table.linesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EntryTemplatesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $EntryTemplatesTable> {
  $$EntryTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linesJson => $composableBuilder(
      column: $table.linesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EntryTemplatesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $EntryTemplatesTable> {
  $$EntryTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get linesJson =>
      $composableBuilder(column: $table.linesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EntryTemplatesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $EntryTemplatesTable,
    EntryTemplate,
    $$EntryTemplatesTableFilterComposer,
    $$EntryTemplatesTableOrderingComposer,
    $$EntryTemplatesTableAnnotationComposer,
    $$EntryTemplatesTableCreateCompanionBuilder,
    $$EntryTemplatesTableUpdateCompanionBuilder,
    (
      EntryTemplate,
      BaseReferences<_$AccountingDatabase, $EntryTemplatesTable, EntryTemplate>
    ),
    EntryTemplate,
    PrefetchHooks Function()> {
  $$EntryTemplatesTableTableManager(
      _$AccountingDatabase db, $EntryTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntryTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<EntryType> type = const Value.absent(),
            Value<String> linesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EntryTemplatesCompanion(
            id: id,
            name: name,
            description: description,
            type: type,
            linesJson: linesJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required EntryType type,
            required String linesJson,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EntryTemplatesCompanion.insert(
            id: id,
            name: name,
            description: description,
            type: type,
            linesJson: linesJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EntryTemplatesTable, EntryTemplate>(table),
                    BaseReferences<_$AccountingDatabase, $EntryTemplatesTable,
                        EntryTemplate>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntryTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $EntryTemplatesTable,
    EntryTemplate,
    $$EntryTemplatesTableFilterComposer,
    $$EntryTemplatesTableOrderingComposer,
    $$EntryTemplatesTableAnnotationComposer,
    $$EntryTemplatesTableCreateCompanionBuilder,
    $$EntryTemplatesTableUpdateCompanionBuilder,
    (
      EntryTemplate,
      BaseReferences<_$AccountingDatabase, $EntryTemplatesTable, EntryTemplate>
    ),
    EntryTemplate,
    PrefetchHooks Function()>;
typedef $$CostDimensionsTableCreateCompanionBuilder = CostDimensionsCompanion
    Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> nameAr,
  Value<String?> description,
  Value<DimensionPolicy> defaultPolicy,
  Value<bool> allowSplit,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CostDimensionsTableUpdateCompanionBuilder = CostDimensionsCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> nameAr,
  Value<String?> description,
  Value<DimensionPolicy> defaultPolicy,
  Value<bool> allowSplit,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CostDimensionsTableReferences extends BaseReferences<
    _$AccountingDatabase, $CostDimensionsTable, CostDimension> {
  $$CostDimensionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CostCentersTable, List<CostCenter>>
      _costCentersRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.costCenters,
              aliasName: 'cost_dimensions__id__cost_centers__dimension_id');

  $$CostCentersTableProcessedTableManager get costCentersRefs {
    final manager = $$CostCentersTableTableManager($_db, $_db.costCenters)
        .filter((f) => f.dimensionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_costCentersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$JournalLineAllocationsTable,
      List<JournalLineAllocation>> _journalLineAllocationsRefsTable(
          _$AccountingDatabase db) =>
      MultiTypedResultKey.fromTable(db.journalLineAllocations,
          aliasName:
              'cost_dimensions__id__journal_line_allocations__dimension_id');

  $$JournalLineAllocationsTableProcessedTableManager
      get journalLineAllocationsRefs {
    final manager = $$JournalLineAllocationsTableTableManager(
            $_db, $_db.journalLineAllocations)
        .filter((f) => f.dimensionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalLineAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CostDimensionRulesTable, List<CostDimensionRule>>
      _costDimensionRulesRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.costDimensionRules,
              aliasName:
                  'cost_dimensions__id__cost_dimension_rules__dimension_id');

  $$CostDimensionRulesTableProcessedTableManager get costDimensionRulesRefs {
    final manager = $$CostDimensionRulesTableTableManager(
            $_db, $_db.costDimensionRules)
        .filter((f) => f.dimensionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_costDimensionRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AllocationKeysTable, List<AllocationKey>>
      _allocationKeysRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.allocationKeys,
              aliasName: 'cost_dimensions__id__allocation_keys__dimension_id');

  $$AllocationKeysTableProcessedTableManager get allocationKeysRefs {
    final manager = $$AllocationKeysTableTableManager($_db, $_db.allocationKeys)
        .filter((f) => f.dimensionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_allocationKeysRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CostDimensionsTableFilterComposer
    extends Composer<_$AccountingDatabase, $CostDimensionsTable> {
  $$CostDimensionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DimensionPolicy, DimensionPolicy, int>
      get defaultPolicy => $composableBuilder(
          column: $table.defaultPolicy,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get allowSplit => $composableBuilder(
      column: $table.allowSplit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> costCentersRefs(
      Expression<bool> Function($$CostCentersTableFilterComposer f) f) {
    final $$CostCentersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.dimensionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableFilterComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> journalLineAllocationsRefs(
      Expression<bool> Function($$JournalLineAllocationsTableFilterComposer f)
          f) {
    final $$JournalLineAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.dimensionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> costDimensionRulesRefs(
      Expression<bool> Function($$CostDimensionRulesTableFilterComposer f) f) {
    final $$CostDimensionRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costDimensionRules,
        getReferencedColumn: (t) => t.dimensionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionRulesTableFilterComposer(
              $db: $db,
              $table: $db.costDimensionRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> allocationKeysRefs(
      Expression<bool> Function($$AllocationKeysTableFilterComposer f) f) {
    final $$AllocationKeysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.allocationKeys,
        getReferencedColumn: (t) => t.dimensionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeysTableFilterComposer(
              $db: $db,
              $table: $db.allocationKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CostDimensionsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $CostDimensionsTable> {
  $$CostDimensionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultPolicy => $composableBuilder(
      column: $table.defaultPolicy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowSplit => $composableBuilder(
      column: $table.allowSplit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CostDimensionsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $CostDimensionsTable> {
  $$CostDimensionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DimensionPolicy, int> get defaultPolicy =>
      $composableBuilder(
          column: $table.defaultPolicy, builder: (column) => column);

  GeneratedColumn<bool> get allowSplit => $composableBuilder(
      column: $table.allowSplit, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> costCentersRefs<T extends Object>(
      Expression<T> Function($$CostCentersTableAnnotationComposer a) f) {
    final $$CostCentersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.dimensionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableAnnotationComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> journalLineAllocationsRefs<T extends Object>(
      Expression<T> Function($$JournalLineAllocationsTableAnnotationComposer a)
          f) {
    final $$JournalLineAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.dimensionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> costDimensionRulesRefs<T extends Object>(
      Expression<T> Function($$CostDimensionRulesTableAnnotationComposer a) f) {
    final $$CostDimensionRulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.costDimensionRules,
            getReferencedColumn: (t) => t.dimensionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CostDimensionRulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.costDimensionRules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> allocationKeysRefs<T extends Object>(
      Expression<T> Function($$AllocationKeysTableAnnotationComposer a) f) {
    final $$AllocationKeysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.allocationKeys,
        getReferencedColumn: (t) => t.dimensionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeysTableAnnotationComposer(
              $db: $db,
              $table: $db.allocationKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CostDimensionsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $CostDimensionsTable,
    CostDimension,
    $$CostDimensionsTableFilterComposer,
    $$CostDimensionsTableOrderingComposer,
    $$CostDimensionsTableAnnotationComposer,
    $$CostDimensionsTableCreateCompanionBuilder,
    $$CostDimensionsTableUpdateCompanionBuilder,
    (CostDimension, $$CostDimensionsTableReferences),
    CostDimension,
    PrefetchHooks Function(
        {bool costCentersRefs,
        bool journalLineAllocationsRefs,
        bool costDimensionRulesRefs,
        bool allocationKeysRefs})> {
  $$CostDimensionsTableTableManager(
      _$AccountingDatabase db, $CostDimensionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostDimensionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostDimensionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostDimensionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DimensionPolicy> defaultPolicy = const Value.absent(),
            Value<bool> allowSplit = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CostDimensionsCompanion(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            description: description,
            defaultPolicy: defaultPolicy,
            allowSplit: allowSplit,
            isActive: isActive,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> nameAr = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DimensionPolicy> defaultPolicy = const Value.absent(),
            Value<bool> allowSplit = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CostDimensionsCompanion.insert(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            description: description,
            defaultPolicy: defaultPolicy,
            allowSplit: allowSplit,
            isActive: isActive,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CostDimensionsTable, CostDimension>(table),
                    $$CostDimensionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {costCentersRefs = false,
              journalLineAllocationsRefs = false,
              costDimensionRulesRefs = false,
              allocationKeysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (costCentersRefs) db.costCenters,
                if (journalLineAllocationsRefs) db.journalLineAllocations,
                if (costDimensionRulesRefs) db.costDimensionRules,
                if (allocationKeysRefs) db.allocationKeys
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (costCentersRefs)
                    await $_getPrefetchedData<CostDimension,
                            $CostDimensionsTable, CostCenter>(
                        currentTable: table,
                        referencedTable: $$CostDimensionsTableReferences
                            ._costCentersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostDimensionsTableReferences(db, table, p0)
                                .costCentersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dimensionId == item.id),
                        typedResults: items),
                  if (journalLineAllocationsRefs)
                    await $_getPrefetchedData<CostDimension,
                            $CostDimensionsTable, JournalLineAllocation>(
                        currentTable: table,
                        referencedTable: $$CostDimensionsTableReferences
                            ._journalLineAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostDimensionsTableReferences(db, table, p0)
                                .journalLineAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dimensionId == item.id),
                        typedResults: items),
                  if (costDimensionRulesRefs)
                    await $_getPrefetchedData<CostDimension,
                            $CostDimensionsTable, CostDimensionRule>(
                        currentTable: table,
                        referencedTable: $$CostDimensionsTableReferences
                            ._costDimensionRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostDimensionsTableReferences(db, table, p0)
                                .costDimensionRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dimensionId == item.id),
                        typedResults: items),
                  if (allocationKeysRefs)
                    await $_getPrefetchedData<CostDimension,
                            $CostDimensionsTable, AllocationKey>(
                        currentTable: table,
                        referencedTable: $$CostDimensionsTableReferences
                            ._allocationKeysRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostDimensionsTableReferences(db, table, p0)
                                .allocationKeysRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dimensionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CostDimensionsTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $CostDimensionsTable,
    CostDimension,
    $$CostDimensionsTableFilterComposer,
    $$CostDimensionsTableOrderingComposer,
    $$CostDimensionsTableAnnotationComposer,
    $$CostDimensionsTableCreateCompanionBuilder,
    $$CostDimensionsTableUpdateCompanionBuilder,
    (CostDimension, $$CostDimensionsTableReferences),
    CostDimension,
    PrefetchHooks Function(
        {bool costCentersRefs,
        bool journalLineAllocationsRefs,
        bool costDimensionRulesRefs,
        bool allocationKeysRefs})>;
typedef $$CostCentersTableCreateCompanionBuilder = CostCentersCompanion
    Function({
  Value<int> id,
  required int dimensionId,
  required String code,
  required String name,
  Value<String?> nameAr,
  Value<int?> parentId,
  Value<int> level,
  Value<bool> isActive,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CostCentersTableUpdateCompanionBuilder = CostCentersCompanion
    Function({
  Value<int> id,
  Value<int> dimensionId,
  Value<String> code,
  Value<String> name,
  Value<String?> nameAr,
  Value<int?> parentId,
  Value<int> level,
  Value<bool> isActive,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CostCentersTableReferences extends BaseReferences<
    _$AccountingDatabase, $CostCentersTable, CostCenter> {
  $$CostCentersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CostDimensionsTable _dimensionIdTable(_$AccountingDatabase db) =>
      db.costDimensions
          .createAlias('cost_centers__dimension_id__cost_dimensions__id');

  $$CostDimensionsTableProcessedTableManager get dimensionId {
    final $_column = $_itemColumn<int>('dimension_id')!;

    final manager = $$CostDimensionsTableTableManager($_db, $_db.costDimensions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dimensionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CostCentersTable _parentIdTable(_$AccountingDatabase db) =>
      db.costCenters.createAlias('cost_centers__parent_id__cost_centers__id');

  $$CostCentersTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CostCentersTableTableManager($_db, $_db.costCenters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$JournalLineAllocationsTable,
      List<JournalLineAllocation>> _journalLineAllocationsRefsTable(
          _$AccountingDatabase db) =>
      MultiTypedResultKey.fromTable(db.journalLineAllocations,
          aliasName:
              'cost_centers__id__journal_line_allocations__cost_center_id');

  $$JournalLineAllocationsTableProcessedTableManager
      get journalLineAllocationsRefs {
    final manager = $$JournalLineAllocationsTableTableManager(
            $_db, $_db.journalLineAllocations)
        .filter((f) => f.costCenterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalLineAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CostDimensionRulesTable,
      List<CostDimensionRule>> _costDimensionRulesRefsTable(
          _$AccountingDatabase db) =>
      MultiTypedResultKey.fromTable(db.costDimensionRules,
          aliasName:
              'cost_centers__id__cost_dimension_rules__default_cost_center_id');

  $$CostDimensionRulesTableProcessedTableManager get costDimensionRulesRefs {
    final manager =
        $$CostDimensionRulesTableTableManager($_db, $_db.costDimensionRules)
            .filter((f) =>
                f.defaultCostCenterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_costDimensionRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AllocationKeyItemsTable, List<AllocationKeyItem>>
      _allocationKeyItemsRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.allocationKeyItems,
              aliasName:
                  'cost_centers__id__allocation_key_items__cost_center_id');

  $$AllocationKeyItemsTableProcessedTableManager get allocationKeyItemsRefs {
    final manager = $$AllocationKeyItemsTableTableManager(
            $_db, $_db.allocationKeyItems)
        .filter((f) => f.costCenterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_allocationKeyItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CostCentersTableFilterComposer
    extends Composer<_$AccountingDatabase, $CostCentersTable> {
  $$CostCentersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CostDimensionsTableFilterComposer get dimensionId {
    final $$CostDimensionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableFilterComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableFilterComposer get parentId {
    final $$CostCentersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableFilterComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> journalLineAllocationsRefs(
      Expression<bool> Function($$JournalLineAllocationsTableFilterComposer f)
          f) {
    final $$JournalLineAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.costCenterId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> costDimensionRulesRefs(
      Expression<bool> Function($$CostDimensionRulesTableFilterComposer f) f) {
    final $$CostDimensionRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costDimensionRules,
        getReferencedColumn: (t) => t.defaultCostCenterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionRulesTableFilterComposer(
              $db: $db,
              $table: $db.costDimensionRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> allocationKeyItemsRefs(
      Expression<bool> Function($$AllocationKeyItemsTableFilterComposer f) f) {
    final $$AllocationKeyItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.allocationKeyItems,
        getReferencedColumn: (t) => t.costCenterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeyItemsTableFilterComposer(
              $db: $db,
              $table: $db.allocationKeyItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CostCentersTableOrderingComposer
    extends Composer<_$AccountingDatabase, $CostCentersTable> {
  $$CostCentersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CostDimensionsTableOrderingComposer get dimensionId {
    final $$CostDimensionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableOrderingComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableOrderingComposer get parentId {
    final $$CostCentersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableOrderingComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostCentersTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $CostCentersTable> {
  $$CostCentersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CostDimensionsTableAnnotationComposer get dimensionId {
    final $$CostDimensionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableAnnotationComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableAnnotationComposer get parentId {
    final $$CostCentersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableAnnotationComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> journalLineAllocationsRefs<T extends Object>(
      Expression<T> Function($$JournalLineAllocationsTableAnnotationComposer a)
          f) {
    final $$JournalLineAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalLineAllocations,
            getReferencedColumn: (t) => t.costCenterId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalLineAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalLineAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> costDimensionRulesRefs<T extends Object>(
      Expression<T> Function($$CostDimensionRulesTableAnnotationComposer a) f) {
    final $$CostDimensionRulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.costDimensionRules,
            getReferencedColumn: (t) => t.defaultCostCenterId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CostDimensionRulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.costDimensionRules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> allocationKeyItemsRefs<T extends Object>(
      Expression<T> Function($$AllocationKeyItemsTableAnnotationComposer a) f) {
    final $$AllocationKeyItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.allocationKeyItems,
            getReferencedColumn: (t) => t.costCenterId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AllocationKeyItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.allocationKeyItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CostCentersTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $CostCentersTable,
    CostCenter,
    $$CostCentersTableFilterComposer,
    $$CostCentersTableOrderingComposer,
    $$CostCentersTableAnnotationComposer,
    $$CostCentersTableCreateCompanionBuilder,
    $$CostCentersTableUpdateCompanionBuilder,
    (CostCenter, $$CostCentersTableReferences),
    CostCenter,
    PrefetchHooks Function(
        {bool dimensionId,
        bool parentId,
        bool journalLineAllocationsRefs,
        bool costDimensionRulesRefs,
        bool allocationKeyItemsRefs})> {
  $$CostCentersTableTableManager(
      _$AccountingDatabase db, $CostCentersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostCentersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostCentersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostCentersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dimensionId = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CostCentersCompanion(
            id: id,
            dimensionId: dimensionId,
            code: code,
            name: name,
            nameAr: nameAr,
            parentId: parentId,
            level: level,
            isActive: isActive,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dimensionId,
            required String code,
            required String name,
            Value<String?> nameAr = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CostCentersCompanion.insert(
            id: id,
            dimensionId: dimensionId,
            code: code,
            name: name,
            nameAr: nameAr,
            parentId: parentId,
            level: level,
            isActive: isActive,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CostCentersTable, CostCenter>(table),
                    $$CostCentersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dimensionId = false,
              parentId = false,
              journalLineAllocationsRefs = false,
              costDimensionRulesRefs = false,
              allocationKeyItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalLineAllocationsRefs) db.journalLineAllocations,
                if (costDimensionRulesRefs) db.costDimensionRules,
                if (allocationKeyItemsRefs) db.allocationKeyItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dimensionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dimensionId,
                    referencedTable:
                        $$CostCentersTableReferences._dimensionIdTable(db),
                    referencedColumn:
                        $$CostCentersTableReferences._dimensionIdTable(db).id,
                  ) as T;
                }
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$CostCentersTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$CostCentersTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalLineAllocationsRefs)
                    await $_getPrefetchedData<CostCenter, $CostCentersTable,
                            JournalLineAllocation>(
                        currentTable: table,
                        referencedTable: $$CostCentersTableReferences
                            ._journalLineAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostCentersTableReferences(db, table, p0)
                                .journalLineAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.costCenterId == item.id),
                        typedResults: items),
                  if (costDimensionRulesRefs)
                    await $_getPrefetchedData<CostCenter, $CostCentersTable,
                            CostDimensionRule>(
                        currentTable: table,
                        referencedTable: $$CostCentersTableReferences
                            ._costDimensionRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostCentersTableReferences(db, table, p0)
                                .costDimensionRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.defaultCostCenterId == item.id),
                        typedResults: items),
                  if (allocationKeyItemsRefs)
                    await $_getPrefetchedData<CostCenter, $CostCentersTable,
                            AllocationKeyItem>(
                        currentTable: table,
                        referencedTable: $$CostCentersTableReferences
                            ._allocationKeyItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CostCentersTableReferences(db, table, p0)
                                .allocationKeyItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.costCenterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CostCentersTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $CostCentersTable,
    CostCenter,
    $$CostCentersTableFilterComposer,
    $$CostCentersTableOrderingComposer,
    $$CostCentersTableAnnotationComposer,
    $$CostCentersTableCreateCompanionBuilder,
    $$CostCentersTableUpdateCompanionBuilder,
    (CostCenter, $$CostCentersTableReferences),
    CostCenter,
    PrefetchHooks Function(
        {bool dimensionId,
        bool parentId,
        bool journalLineAllocationsRefs,
        bool costDimensionRulesRefs,
        bool allocationKeyItemsRefs})>;
typedef $$JournalLineAllocationsTableCreateCompanionBuilder
    = JournalLineAllocationsCompanion Function({
  Value<int> id,
  required int lineId,
  required int costCenterId,
  required int dimensionId,
  required double amount,
  required double percentage,
});
typedef $$JournalLineAllocationsTableUpdateCompanionBuilder
    = JournalLineAllocationsCompanion Function({
  Value<int> id,
  Value<int> lineId,
  Value<int> costCenterId,
  Value<int> dimensionId,
  Value<double> amount,
  Value<double> percentage,
});

final class $$JournalLineAllocationsTableReferences extends BaseReferences<
    _$AccountingDatabase, $JournalLineAllocationsTable, JournalLineAllocation> {
  $$JournalLineAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JournalEntryLinesTable _lineIdTable(_$AccountingDatabase db) =>
      db.journalEntryLines.createAlias(
          'journal_line_allocations__line_id__journal_entry_lines__id');

  $$JournalEntryLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<int>('line_id')!;

    final manager =
        $$JournalEntryLinesTableTableManager($_db, $_db.journalEntryLines)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CostCentersTable _costCenterIdTable(_$AccountingDatabase db) =>
      db.costCenters.createAlias(
          'journal_line_allocations__cost_center_id__cost_centers__id');

  $$CostCentersTableProcessedTableManager get costCenterId {
    final $_column = $_itemColumn<int>('cost_center_id')!;

    final manager = $$CostCentersTableTableManager($_db, $_db.costCenters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_costCenterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CostDimensionsTable _dimensionIdTable(_$AccountingDatabase db) =>
      db.costDimensions.createAlias(
          'journal_line_allocations__dimension_id__cost_dimensions__id');

  $$CostDimensionsTableProcessedTableManager get dimensionId {
    final $_column = $_itemColumn<int>('dimension_id')!;

    final manager = $$CostDimensionsTableTableManager($_db, $_db.costDimensions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dimensionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$JournalLineAllocationsTableFilterComposer
    extends Composer<_$AccountingDatabase, $JournalLineAllocationsTable> {
  $$JournalLineAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnFilters(column));

  $$JournalEntryLinesTableFilterComposer get lineId {
    final $$JournalEntryLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.journalEntryLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntryLinesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntryLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableFilterComposer get costCenterId {
    final $$CostCentersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableFilterComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostDimensionsTableFilterComposer get dimensionId {
    final $$CostDimensionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableFilterComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalLineAllocationsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $JournalLineAllocationsTable> {
  $$JournalLineAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnOrderings(column));

  $$JournalEntryLinesTableOrderingComposer get lineId {
    final $$JournalEntryLinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.journalEntryLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntryLinesTableOrderingComposer(
              $db: $db,
              $table: $db.journalEntryLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableOrderingComposer get costCenterId {
    final $$CostCentersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableOrderingComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostDimensionsTableOrderingComposer get dimensionId {
    final $$CostDimensionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableOrderingComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalLineAllocationsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $JournalLineAllocationsTable> {
  $$JournalLineAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => column);

  $$JournalEntryLinesTableAnnotationComposer get lineId {
    final $$JournalEntryLinesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.lineId,
            referencedTable: $db.journalEntryLines,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalEntryLinesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalEntryLines,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$CostCentersTableAnnotationComposer get costCenterId {
    final $$CostCentersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableAnnotationComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostDimensionsTableAnnotationComposer get dimensionId {
    final $$CostDimensionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableAnnotationComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalLineAllocationsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $JournalLineAllocationsTable,
    JournalLineAllocation,
    $$JournalLineAllocationsTableFilterComposer,
    $$JournalLineAllocationsTableOrderingComposer,
    $$JournalLineAllocationsTableAnnotationComposer,
    $$JournalLineAllocationsTableCreateCompanionBuilder,
    $$JournalLineAllocationsTableUpdateCompanionBuilder,
    (JournalLineAllocation, $$JournalLineAllocationsTableReferences),
    JournalLineAllocation,
    PrefetchHooks Function(
        {bool lineId, bool costCenterId, bool dimensionId})> {
  $$JournalLineAllocationsTableTableManager(
      _$AccountingDatabase db, $JournalLineAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalLineAllocationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalLineAllocationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalLineAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> lineId = const Value.absent(),
            Value<int> costCenterId = const Value.absent(),
            Value<int> dimensionId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> percentage = const Value.absent(),
          }) =>
              JournalLineAllocationsCompanion(
            id: id,
            lineId: lineId,
            costCenterId: costCenterId,
            dimensionId: dimensionId,
            amount: amount,
            percentage: percentage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int lineId,
            required int costCenterId,
            required int dimensionId,
            required double amount,
            required double percentage,
          }) =>
              JournalLineAllocationsCompanion.insert(
            id: id,
            lineId: lineId,
            costCenterId: costCenterId,
            dimensionId: dimensionId,
            amount: amount,
            percentage: percentage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$JournalLineAllocationsTable,
                        JournalLineAllocation>(table),
                    $$JournalLineAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {lineId = false, costCenterId = false, dimensionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lineId,
                    referencedTable: $$JournalLineAllocationsTableReferences
                        ._lineIdTable(db),
                    referencedColumn: $$JournalLineAllocationsTableReferences
                        ._lineIdTable(db)
                        .id,
                  ) as T;
                }
                if (costCenterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.costCenterId,
                    referencedTable: $$JournalLineAllocationsTableReferences
                        ._costCenterIdTable(db),
                    referencedColumn: $$JournalLineAllocationsTableReferences
                        ._costCenterIdTable(db)
                        .id,
                  ) as T;
                }
                if (dimensionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dimensionId,
                    referencedTable: $$JournalLineAllocationsTableReferences
                        ._dimensionIdTable(db),
                    referencedColumn: $$JournalLineAllocationsTableReferences
                        ._dimensionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$JournalLineAllocationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AccountingDatabase,
        $JournalLineAllocationsTable,
        JournalLineAllocation,
        $$JournalLineAllocationsTableFilterComposer,
        $$JournalLineAllocationsTableOrderingComposer,
        $$JournalLineAllocationsTableAnnotationComposer,
        $$JournalLineAllocationsTableCreateCompanionBuilder,
        $$JournalLineAllocationsTableUpdateCompanionBuilder,
        (JournalLineAllocation, $$JournalLineAllocationsTableReferences),
        JournalLineAllocation,
        PrefetchHooks Function(
            {bool lineId, bool costCenterId, bool dimensionId})>;
typedef $$CostDimensionRulesTableCreateCompanionBuilder
    = CostDimensionRulesCompanion Function({
  Value<int> id,
  required int dimensionId,
  Value<int?> accountId,
  Value<AccountType?> accountType,
  required DimensionPolicy policy,
  Value<int?> defaultCostCenterId,
});
typedef $$CostDimensionRulesTableUpdateCompanionBuilder
    = CostDimensionRulesCompanion Function({
  Value<int> id,
  Value<int> dimensionId,
  Value<int?> accountId,
  Value<AccountType?> accountType,
  Value<DimensionPolicy> policy,
  Value<int?> defaultCostCenterId,
});

final class $$CostDimensionRulesTableReferences extends BaseReferences<
    _$AccountingDatabase, $CostDimensionRulesTable, CostDimensionRule> {
  $$CostDimensionRulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CostDimensionsTable _dimensionIdTable(_$AccountingDatabase db) => db
      .costDimensions
      .createAlias('cost_dimension_rules__dimension_id__cost_dimensions__id');

  $$CostDimensionsTableProcessedTableManager get dimensionId {
    final $_column = $_itemColumn<int>('dimension_id')!;

    final manager = $$CostDimensionsTableTableManager($_db, $_db.costDimensions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dimensionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _accountIdTable(_$AccountingDatabase db) =>
      db.accounts.createAlias('cost_dimension_rules__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CostCentersTable _defaultCostCenterIdTable(_$AccountingDatabase db) =>
      db.costCenters.createAlias(
          'cost_dimension_rules__default_cost_center_id__cost_centers__id');

  $$CostCentersTableProcessedTableManager? get defaultCostCenterId {
    final $_column = $_itemColumn<int>('default_cost_center_id');
    if ($_column == null) return null;
    final manager = $$CostCentersTableTableManager($_db, $_db.costCenters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultCostCenterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CostDimensionRulesTableFilterComposer
    extends Composer<_$AccountingDatabase, $CostDimensionRulesTable> {
  $$CostDimensionRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType?, AccountType, int>
      get accountType => $composableBuilder(
          column: $table.accountType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DimensionPolicy, DimensionPolicy, int>
      get policy => $composableBuilder(
          column: $table.policy,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CostDimensionsTableFilterComposer get dimensionId {
    final $$CostDimensionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableFilterComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableFilterComposer get defaultCostCenterId {
    final $$CostCentersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultCostCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableFilterComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostDimensionRulesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $CostDimensionRulesTable> {
  $$CostDimensionRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get policy => $composableBuilder(
      column: $table.policy, builder: (column) => ColumnOrderings(column));

  $$CostDimensionsTableOrderingComposer get dimensionId {
    final $$CostDimensionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableOrderingComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableOrderingComposer get defaultCostCenterId {
    final $$CostCentersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultCostCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableOrderingComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostDimensionRulesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $CostDimensionRulesTable> {
  $$CostDimensionRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType?, int> get accountType =>
      $composableBuilder(
          column: $table.accountType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DimensionPolicy, int> get policy =>
      $composableBuilder(column: $table.policy, builder: (column) => column);

  $$CostDimensionsTableAnnotationComposer get dimensionId {
    final $$CostDimensionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableAnnotationComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableAnnotationComposer get defaultCostCenterId {
    final $$CostCentersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultCostCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableAnnotationComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostDimensionRulesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $CostDimensionRulesTable,
    CostDimensionRule,
    $$CostDimensionRulesTableFilterComposer,
    $$CostDimensionRulesTableOrderingComposer,
    $$CostDimensionRulesTableAnnotationComposer,
    $$CostDimensionRulesTableCreateCompanionBuilder,
    $$CostDimensionRulesTableUpdateCompanionBuilder,
    (CostDimensionRule, $$CostDimensionRulesTableReferences),
    CostDimensionRule,
    PrefetchHooks Function(
        {bool dimensionId, bool accountId, bool defaultCostCenterId})> {
  $$CostDimensionRulesTableTableManager(
      _$AccountingDatabase db, $CostDimensionRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostDimensionRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostDimensionRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostDimensionRulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dimensionId = const Value.absent(),
            Value<int?> accountId = const Value.absent(),
            Value<AccountType?> accountType = const Value.absent(),
            Value<DimensionPolicy> policy = const Value.absent(),
            Value<int?> defaultCostCenterId = const Value.absent(),
          }) =>
              CostDimensionRulesCompanion(
            id: id,
            dimensionId: dimensionId,
            accountId: accountId,
            accountType: accountType,
            policy: policy,
            defaultCostCenterId: defaultCostCenterId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dimensionId,
            Value<int?> accountId = const Value.absent(),
            Value<AccountType?> accountType = const Value.absent(),
            required DimensionPolicy policy,
            Value<int?> defaultCostCenterId = const Value.absent(),
          }) =>
              CostDimensionRulesCompanion.insert(
            id: id,
            dimensionId: dimensionId,
            accountId: accountId,
            accountType: accountType,
            policy: policy,
            defaultCostCenterId: defaultCostCenterId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CostDimensionRulesTable, CostDimensionRule>(
                        table),
                    $$CostDimensionRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dimensionId = false,
              accountId = false,
              defaultCostCenterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dimensionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dimensionId,
                    referencedTable: $$CostDimensionRulesTableReferences
                        ._dimensionIdTable(db),
                    referencedColumn: $$CostDimensionRulesTableReferences
                        ._dimensionIdTable(db)
                        .id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$CostDimensionRulesTableReferences._accountIdTable(db),
                    referencedColumn: $$CostDimensionRulesTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }
                if (defaultCostCenterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.defaultCostCenterId,
                    referencedTable: $$CostDimensionRulesTableReferences
                        ._defaultCostCenterIdTable(db),
                    referencedColumn: $$CostDimensionRulesTableReferences
                        ._defaultCostCenterIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CostDimensionRulesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $CostDimensionRulesTable,
    CostDimensionRule,
    $$CostDimensionRulesTableFilterComposer,
    $$CostDimensionRulesTableOrderingComposer,
    $$CostDimensionRulesTableAnnotationComposer,
    $$CostDimensionRulesTableCreateCompanionBuilder,
    $$CostDimensionRulesTableUpdateCompanionBuilder,
    (CostDimensionRule, $$CostDimensionRulesTableReferences),
    CostDimensionRule,
    PrefetchHooks Function(
        {bool dimensionId, bool accountId, bool defaultCostCenterId})>;
typedef $$AllocationKeysTableCreateCompanionBuilder = AllocationKeysCompanion
    Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> nameAr,
  required int dimensionId,
  Value<String?> description,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AllocationKeysTableUpdateCompanionBuilder = AllocationKeysCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> nameAr,
  Value<int> dimensionId,
  Value<String?> description,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$AllocationKeysTableReferences extends BaseReferences<
    _$AccountingDatabase, $AllocationKeysTable, AllocationKey> {
  $$AllocationKeysTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CostDimensionsTable _dimensionIdTable(_$AccountingDatabase db) =>
      db.costDimensions
          .createAlias('allocation_keys__dimension_id__cost_dimensions__id');

  $$CostDimensionsTableProcessedTableManager get dimensionId {
    final $_column = $_itemColumn<int>('dimension_id')!;

    final manager = $$CostDimensionsTableTableManager($_db, $_db.costDimensions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dimensionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AllocationKeyItemsTable, List<AllocationKeyItem>>
      _allocationKeyItemsRefsTable(_$AccountingDatabase db) =>
          MultiTypedResultKey.fromTable(db.allocationKeyItems,
              aliasName: 'allocation_keys__id__allocation_key_items__key_id');

  $$AllocationKeyItemsTableProcessedTableManager get allocationKeyItemsRefs {
    final manager =
        $$AllocationKeyItemsTableTableManager($_db, $_db.allocationKeyItems)
            .filter((f) => f.keyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_allocationKeyItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AllocationKeysTableFilterComposer
    extends Composer<_$AccountingDatabase, $AllocationKeysTable> {
  $$AllocationKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CostDimensionsTableFilterComposer get dimensionId {
    final $$CostDimensionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableFilterComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> allocationKeyItemsRefs(
      Expression<bool> Function($$AllocationKeyItemsTableFilterComposer f) f) {
    final $$AllocationKeyItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.allocationKeyItems,
        getReferencedColumn: (t) => t.keyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeyItemsTableFilterComposer(
              $db: $db,
              $table: $db.allocationKeyItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AllocationKeysTableOrderingComposer
    extends Composer<_$AccountingDatabase, $AllocationKeysTable> {
  $$AllocationKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CostDimensionsTableOrderingComposer get dimensionId {
    final $$CostDimensionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableOrderingComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AllocationKeysTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $AllocationKeysTable> {
  $$AllocationKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CostDimensionsTableAnnotationComposer get dimensionId {
    final $$CostDimensionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dimensionId,
        referencedTable: $db.costDimensions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostDimensionsTableAnnotationComposer(
              $db: $db,
              $table: $db.costDimensions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> allocationKeyItemsRefs<T extends Object>(
      Expression<T> Function($$AllocationKeyItemsTableAnnotationComposer a) f) {
    final $$AllocationKeyItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.allocationKeyItems,
            getReferencedColumn: (t) => t.keyId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AllocationKeyItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.allocationKeyItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AllocationKeysTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $AllocationKeysTable,
    AllocationKey,
    $$AllocationKeysTableFilterComposer,
    $$AllocationKeysTableOrderingComposer,
    $$AllocationKeysTableAnnotationComposer,
    $$AllocationKeysTableCreateCompanionBuilder,
    $$AllocationKeysTableUpdateCompanionBuilder,
    (AllocationKey, $$AllocationKeysTableReferences),
    AllocationKey,
    PrefetchHooks Function({bool dimensionId, bool allocationKeyItemsRefs})> {
  $$AllocationKeysTableTableManager(
      _$AccountingDatabase db, $AllocationKeysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllocationKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<int> dimensionId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AllocationKeysCompanion(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            dimensionId: dimensionId,
            description: description,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> nameAr = const Value.absent(),
            required int dimensionId,
            Value<String?> description = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AllocationKeysCompanion.insert(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            dimensionId: dimensionId,
            description: description,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AllocationKeysTable, AllocationKey>(table),
                    $$AllocationKeysTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dimensionId = false, allocationKeyItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (allocationKeyItemsRefs) db.allocationKeyItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dimensionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dimensionId,
                    referencedTable:
                        $$AllocationKeysTableReferences._dimensionIdTable(db),
                    referencedColumn: $$AllocationKeysTableReferences
                        ._dimensionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (allocationKeyItemsRefs)
                    await $_getPrefetchedData<AllocationKey,
                            $AllocationKeysTable, AllocationKeyItem>(
                        currentTable: table,
                        referencedTable: $$AllocationKeysTableReferences
                            ._allocationKeyItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AllocationKeysTableReferences(db, table, p0)
                                .allocationKeyItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.keyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AllocationKeysTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $AllocationKeysTable,
    AllocationKey,
    $$AllocationKeysTableFilterComposer,
    $$AllocationKeysTableOrderingComposer,
    $$AllocationKeysTableAnnotationComposer,
    $$AllocationKeysTableCreateCompanionBuilder,
    $$AllocationKeysTableUpdateCompanionBuilder,
    (AllocationKey, $$AllocationKeysTableReferences),
    AllocationKey,
    PrefetchHooks Function({bool dimensionId, bool allocationKeyItemsRefs})>;
typedef $$AllocationKeyItemsTableCreateCompanionBuilder
    = AllocationKeyItemsCompanion Function({
  Value<int> id,
  required int keyId,
  required int costCenterId,
  required double weight,
});
typedef $$AllocationKeyItemsTableUpdateCompanionBuilder
    = AllocationKeyItemsCompanion Function({
  Value<int> id,
  Value<int> keyId,
  Value<int> costCenterId,
  Value<double> weight,
});

final class $$AllocationKeyItemsTableReferences extends BaseReferences<
    _$AccountingDatabase, $AllocationKeyItemsTable, AllocationKeyItem> {
  $$AllocationKeyItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AllocationKeysTable _keyIdTable(_$AccountingDatabase db) =>
      db.allocationKeys
          .createAlias('allocation_key_items__key_id__allocation_keys__id');

  $$AllocationKeysTableProcessedTableManager get keyId {
    final $_column = $_itemColumn<int>('key_id')!;

    final manager = $$AllocationKeysTableTableManager($_db, $_db.allocationKeys)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_keyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CostCentersTable _costCenterIdTable(_$AccountingDatabase db) => db
      .costCenters
      .createAlias('allocation_key_items__cost_center_id__cost_centers__id');

  $$CostCentersTableProcessedTableManager get costCenterId {
    final $_column = $_itemColumn<int>('cost_center_id')!;

    final manager = $$CostCentersTableTableManager($_db, $_db.costCenters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_costCenterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AllocationKeyItemsTableFilterComposer
    extends Composer<_$AccountingDatabase, $AllocationKeyItemsTable> {
  $$AllocationKeyItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  $$AllocationKeysTableFilterComposer get keyId {
    final $$AllocationKeysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.keyId,
        referencedTable: $db.allocationKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeysTableFilterComposer(
              $db: $db,
              $table: $db.allocationKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableFilterComposer get costCenterId {
    final $$CostCentersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableFilterComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AllocationKeyItemsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $AllocationKeyItemsTable> {
  $$AllocationKeyItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  $$AllocationKeysTableOrderingComposer get keyId {
    final $$AllocationKeysTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.keyId,
        referencedTable: $db.allocationKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeysTableOrderingComposer(
              $db: $db,
              $table: $db.allocationKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableOrderingComposer get costCenterId {
    final $$CostCentersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableOrderingComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AllocationKeyItemsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $AllocationKeyItemsTable> {
  $$AllocationKeyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  $$AllocationKeysTableAnnotationComposer get keyId {
    final $$AllocationKeysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.keyId,
        referencedTable: $db.allocationKeys,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AllocationKeysTableAnnotationComposer(
              $db: $db,
              $table: $db.allocationKeys,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CostCentersTableAnnotationComposer get costCenterId {
    final $$CostCentersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.costCenterId,
        referencedTable: $db.costCenters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCentersTableAnnotationComposer(
              $db: $db,
              $table: $db.costCenters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AllocationKeyItemsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $AllocationKeyItemsTable,
    AllocationKeyItem,
    $$AllocationKeyItemsTableFilterComposer,
    $$AllocationKeyItemsTableOrderingComposer,
    $$AllocationKeyItemsTableAnnotationComposer,
    $$AllocationKeyItemsTableCreateCompanionBuilder,
    $$AllocationKeyItemsTableUpdateCompanionBuilder,
    (AllocationKeyItem, $$AllocationKeyItemsTableReferences),
    AllocationKeyItem,
    PrefetchHooks Function({bool keyId, bool costCenterId})> {
  $$AllocationKeyItemsTableTableManager(
      _$AccountingDatabase db, $AllocationKeyItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationKeyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationKeyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllocationKeyItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> keyId = const Value.absent(),
            Value<int> costCenterId = const Value.absent(),
            Value<double> weight = const Value.absent(),
          }) =>
              AllocationKeyItemsCompanion(
            id: id,
            keyId: keyId,
            costCenterId: costCenterId,
            weight: weight,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int keyId,
            required int costCenterId,
            required double weight,
          }) =>
              AllocationKeyItemsCompanion.insert(
            id: id,
            keyId: keyId,
            costCenterId: costCenterId,
            weight: weight,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AllocationKeyItemsTable, AllocationKeyItem>(
                        table),
                    $$AllocationKeyItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({keyId = false, costCenterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (keyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.keyId,
                    referencedTable:
                        $$AllocationKeyItemsTableReferences._keyIdTable(db),
                    referencedColumn:
                        $$AllocationKeyItemsTableReferences._keyIdTable(db).id,
                  ) as T;
                }
                if (costCenterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.costCenterId,
                    referencedTable: $$AllocationKeyItemsTableReferences
                        ._costCenterIdTable(db),
                    referencedColumn: $$AllocationKeyItemsTableReferences
                        ._costCenterIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AllocationKeyItemsTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $AllocationKeyItemsTable,
    AllocationKeyItem,
    $$AllocationKeyItemsTableFilterComposer,
    $$AllocationKeyItemsTableOrderingComposer,
    $$AllocationKeyItemsTableAnnotationComposer,
    $$AllocationKeyItemsTableCreateCompanionBuilder,
    $$AllocationKeyItemsTableUpdateCompanionBuilder,
    (AllocationKeyItem, $$AllocationKeyItemsTableReferences),
    AllocationKeyItem,
    PrefetchHooks Function({bool keyId, bool costCenterId})>;
typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> nameAr,
  Value<String?> symbol,
  Value<int> decimalPlaces,
  Value<bool> isActive,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> nameAr,
  Value<String?> symbol,
  Value<int> decimalPlaces,
  Value<bool> isActive,
});

class $$CurrenciesTableFilterComposer
    extends Composer<_$AccountingDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get decimalPlaces => $composableBuilder(
      column: $table.decimalPlaces, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get decimalPlaces => $composableBuilder(
      column: $table.decimalPlaces,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<int> get decimalPlaces => $composableBuilder(
      column: $table.decimalPlaces, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (
      Currency,
      BaseReferences<_$AccountingDatabase, $CurrenciesTable, Currency>
    ),
    Currency,
    PrefetchHooks Function()> {
  $$CurrenciesTableTableManager(_$AccountingDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<int> decimalPlaces = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            symbol: symbol,
            decimalPlaces: decimalPlaces,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> nameAr = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<int> decimalPlaces = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            id: id,
            code: code,
            name: name,
            nameAr: nameAr,
            symbol: symbol,
            decimalPlaces: decimalPlaces,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CurrenciesTable, Currency>(table),
                    BaseReferences<_$AccountingDatabase, $CurrenciesTable,
                        Currency>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (
      Currency,
      BaseReferences<_$AccountingDatabase, $CurrenciesTable, Currency>
    ),
    Currency,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<int> id,
  required String currencyCode,
  required DateTime date,
  required double rate,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<DateTime> date,
  Value<double> rate,
});

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AccountingDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AccountingDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AccountingDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableManager(
      _$AccountingDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> rate = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            currencyCode: currencyCode,
            date: date,
            rate: rate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String currencyCode,
            required DateTime date,
            required double rate,
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            currencyCode: currencyCode,
            date: date,
            rate: rate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ExchangeRatesTable, ExchangeRate>(table),
                    BaseReferences<_$AccountingDatabase, $ExchangeRatesTable,
                        ExchangeRate>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AccountingDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()>;
typedef $$AccountingSettingsTableCreateCompanionBuilder
    = AccountingSettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AccountingSettingsTableUpdateCompanionBuilder
    = AccountingSettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AccountingSettingsTableFilterComposer
    extends Composer<_$AccountingDatabase, $AccountingSettingsTable> {
  $$AccountingSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AccountingSettingsTableOrderingComposer
    extends Composer<_$AccountingDatabase, $AccountingSettingsTable> {
  $$AccountingSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AccountingSettingsTableAnnotationComposer
    extends Composer<_$AccountingDatabase, $AccountingSettingsTable> {
  $$AccountingSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AccountingSettingsTableTableManager extends RootTableManager<
    _$AccountingDatabase,
    $AccountingSettingsTable,
    AccountingSetting,
    $$AccountingSettingsTableFilterComposer,
    $$AccountingSettingsTableOrderingComposer,
    $$AccountingSettingsTableAnnotationComposer,
    $$AccountingSettingsTableCreateCompanionBuilder,
    $$AccountingSettingsTableUpdateCompanionBuilder,
    (
      AccountingSetting,
      BaseReferences<_$AccountingDatabase, $AccountingSettingsTable,
          AccountingSetting>
    ),
    AccountingSetting,
    PrefetchHooks Function()> {
  $$AccountingSettingsTableTableManager(
      _$AccountingDatabase db, $AccountingSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountingSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountingSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountingSettingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountingSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountingSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountingSettingsTable, AccountingSetting>(
                        table),
                    BaseReferences<
                        _$AccountingDatabase,
                        $AccountingSettingsTable,
                        AccountingSetting>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountingSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AccountingDatabase,
    $AccountingSettingsTable,
    AccountingSetting,
    $$AccountingSettingsTableFilterComposer,
    $$AccountingSettingsTableOrderingComposer,
    $$AccountingSettingsTableAnnotationComposer,
    $$AccountingSettingsTableCreateCompanionBuilder,
    $$AccountingSettingsTableUpdateCompanionBuilder,
    (
      AccountingSetting,
      BaseReferences<_$AccountingDatabase, $AccountingSettingsTable,
          AccountingSetting>
    ),
    AccountingSetting,
    PrefetchHooks Function()>;

class $AccountingDatabaseManager {
  final _$AccountingDatabase _db;
  $AccountingDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(_db, _db.journalEntryLines);
  $$AccountingPeriodsTableTableManager get accountingPeriods =>
      $$AccountingPeriodsTableTableManager(_db, _db.accountingPeriods);
  $$EntryTemplatesTableTableManager get entryTemplates =>
      $$EntryTemplatesTableTableManager(_db, _db.entryTemplates);
  $$CostDimensionsTableTableManager get costDimensions =>
      $$CostDimensionsTableTableManager(_db, _db.costDimensions);
  $$CostCentersTableTableManager get costCenters =>
      $$CostCentersTableTableManager(_db, _db.costCenters);
  $$JournalLineAllocationsTableTableManager get journalLineAllocations =>
      $$JournalLineAllocationsTableTableManager(
          _db, _db.journalLineAllocations);
  $$CostDimensionRulesTableTableManager get costDimensionRules =>
      $$CostDimensionRulesTableTableManager(_db, _db.costDimensionRules);
  $$AllocationKeysTableTableManager get allocationKeys =>
      $$AllocationKeysTableTableManager(_db, _db.allocationKeys);
  $$AllocationKeyItemsTableTableManager get allocationKeyItems =>
      $$AllocationKeyItemsTableTableManager(_db, _db.allocationKeyItems);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$AccountingSettingsTableTableManager get accountingSettings =>
      $$AccountingSettingsTableTableManager(_db, _db.accountingSettings);
}
