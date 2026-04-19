/// tables.dart
/// تعريفات جداول Drift

import 'package:drift/drift.dart';
import '../../core/enums.dart';

// ─────────────────────────────────────────────────────────────
// جدول الحسابات - Accounts
// ─────────────────────────────────────────────────────────────

class Accounts extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  TextColumn get code        => text().withLength(min: 1, max: 30)();
  TextColumn get name        => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr      => text().withLength(min: 1, max: 255).nullable()();
  IntColumn  get type        => intEnum<AccountType>()();
  IntColumn  get parentId    => integer().nullable().references(Accounts, #id)();
  BoolColumn get isActive    => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();

  /// مستوى الحساب في التسلسل الهرمي (1 = حساب رئيسي، 2 = فرعي، ...)
  IntColumn get level => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [{code}];

  @override
  String get tableName => 'accounts';
}

// ─────────────────────────────────────────────────────────────
// جدول الفترات المحاسبية - Accounting Periods
// ─────────────────────────────────────────────────────────────
class AccountingPeriods extends Table {
  IntColumn  get id        => integer().autoIncrement()();
  TextColumn get name      => text().withLength(min: 1, max: 100)(); // مثال: "يناير 2024"
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate   => dateTime()();
  BoolColumn get isClosed  => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────────────────────
// جدول القيود اليومية - Journal Entries
// ─────────────────────────────────────────────────────────────

class JournalEntries extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  
  /// رقم القيد المتسلسل (Unique Serial Number)
  TextColumn get serialNumber => text().withLength(min: 1, max: 50)();

  DateTimeColumn get date    => dateTime()();
  TextColumn get description => text().withLength(min: 1, max: 500)();

  /// رقم المرجع (فاتورة، سند، ...)
  TextColumn get reference   => text().withLength(min: 1, max: 100).nullable()();

  IntColumn  get status      => intEnum<EntryStatus>()();
  TextColumn get notes       => text().nullable()();

  // تتبع التدقيق (Audit Trail)
  TextColumn get createdBy   => text().nullable()();
  TextColumn get postedBy    => text().nullable()();
  DateTimeColumn get postedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [{serialNumber}];

  @override
  String get tableName => 'journal_entries';
}

// ─────────────────────────────────────────────────────────────
// جدول بنود القيود - Journal Entry Lines
// ─────────────────────────────────────────────────────────────

class JournalEntryLines extends Table {
  IntColumn get id      => integer().autoIncrement()();
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();

  /// المبلغ المدين (0 إذا كان البند دائناً)
  RealColumn get debit  => real().withDefault(const Constant(0.0))();

  /// المبلغ الدائن (0 إذا كان البند مديناً)
  RealColumn get credit => real().withDefault(const Constant(0.0))();

  TextColumn get description => text().nullable()();

  /// ترتيب البند داخل القيد
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'journal_entry_lines';
}
