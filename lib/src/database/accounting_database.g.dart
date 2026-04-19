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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, nameAr, type, parentId,
      isActive, description, level, createdAt, updatedAt);
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, entryId, accountId, debit, credit, description, sortOrder];
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
  const JournalEntryLine(
      {required this.id,
      required this.entryId,
      required this.accountId,
      required this.debit,
      required this.credit,
      this.description,
      required this.sortOrder});
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
    };
  }

  JournalEntryLine copyWith(
          {int? id,
          int? entryId,
          int? accountId,
          double? debit,
          double? credit,
          Value<String?> description = const Value.absent(),
          int? sortOrder}) =>
      JournalEntryLine(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        accountId: accountId ?? this.accountId,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        description: description.present ? description.value : this.description,
        sortOrder: sortOrder ?? this.sortOrder,
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
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entryId, accountId, debit, credit, description, sortOrder);
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
          other.sortOrder == this.sortOrder);
}

class JournalEntryLinesCompanion extends UpdateCompanion<JournalEntryLine> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<int> accountId;
  final Value<double> debit;
  final Value<double> credit;
  final Value<String?> description;
  final Value<int> sortOrder;
  const JournalEntryLinesCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  JournalEntryLinesCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required int accountId,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (accountId != null) 'account_id': accountId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  JournalEntryLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? entryId,
      Value<int>? accountId,
      Value<double>? debit,
      Value<double>? credit,
      Value<String?>? description,
      Value<int>? sortOrder}) {
    return JournalEntryLinesCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
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
          ..write('sortOrder: $sortOrder')
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

abstract class _$AccountingDatabase extends GeneratedDatabase {
  _$AccountingDatabase(QueryExecutor e) : super(e);
  $AccountingDatabaseManager get managers => $AccountingDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalEntryLinesTable journalEntryLines =
      $JournalEntryLinesTable(this);
  late final $AccountingPeriodsTable accountingPeriods =
      $AccountingPeriodsTable(this);
  late final AccountsDao accountsDao = AccountsDao(this as AccountingDatabase);
  late final JournalEntriesDao journalEntriesDao =
      JournalEntriesDao(this as AccountingDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accounts, journalEntries, journalEntryLines, accountingPeriods];
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
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AccountingDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _parentIdTable(_$AccountingDatabase db) => db.accounts
      .createAlias($_aliasNameGenerator(db.accounts.parentId, db.accounts.id));

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
              aliasName: $_aliasNameGenerator(
                  db.accounts.id, db.journalEntryLines.accountId));

  $$JournalEntryLinesTableProcessedTableManager get journalEntryLinesRefs {
    final manager =
        $$JournalEntryLinesTableTableManager($_db, $_db.journalEntryLines)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalEntryLinesRefsTable($_db));
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
    PrefetchHooks Function({bool parentId, bool journalEntryLinesRefs})> {
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
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {parentId = false, journalEntryLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntryLinesRefs) db.journalEntryLines
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
    PrefetchHooks Function({bool parentId, bool journalEntryLinesRefs})>;
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
              aliasName: $_aliasNameGenerator(
                  db.journalEntries.id, db.journalEntryLines.entryId));

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
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
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
});

final class $$JournalEntryLinesTableReferences extends BaseReferences<
    _$AccountingDatabase, $JournalEntryLinesTable, JournalEntryLine> {
  $$JournalEntryLinesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JournalEntriesTable _entryIdTable(_$AccountingDatabase db) =>
      db.journalEntries.createAlias($_aliasNameGenerator(
          db.journalEntryLines.entryId, db.journalEntries.id));

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
      db.accounts.createAlias(
          $_aliasNameGenerator(db.journalEntryLines.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
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
    PrefetchHooks Function({bool entryId, bool accountId})> {
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
          }) =>
              JournalEntryLinesCompanion(
            id: id,
            entryId: entryId,
            accountId: accountId,
            debit: debit,
            credit: credit,
            description: description,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int entryId,
            required int accountId,
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              JournalEntryLinesCompanion.insert(
            id: id,
            entryId: entryId,
            accountId: accountId,
            debit: debit,
            credit: credit,
            description: description,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JournalEntryLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({entryId = false, accountId = false}) {
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
                return [];
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
    PrefetchHooks Function({bool entryId, bool accountId})>;
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
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
}
