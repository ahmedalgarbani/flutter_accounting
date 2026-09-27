/// tables.dart
/// تعريفات جداول Drift
library;

import 'package:drift/drift.dart';
import '../../core/enums.dart';

// ─────────────────────────────────────────────────────────────
// جدول الحسابات - Accounts
// ─────────────────────────────────────────────────────────────

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 30)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr => text().withLength(min: 1, max: 255).nullable()();
  IntColumn get type => intEnum<AccountType>()();
  IntColumn get parentId => integer().nullable().references(Accounts, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();

  /// مستوى الحساب في التسلسل الهرمي (1 = حساب رئيسي، 2 = فرعي، ...)
  IntColumn get level => integer().withDefault(const Constant(1))();

  /// عملة الحساب (Schema v4) - null = أي عملة
  TextColumn get currencyCode => text().withLength(min: 3, max: 3).nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'accounts';
}

// ─────────────────────────────────────────────────────────────
// جدول الفترات المحاسبية - Accounting Periods
// ─────────────────────────────────────────────────────────────
class AccountingPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(min: 1, max: 100)(); // مثال: "يناير 2024"
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ─────────────────────────────────────────────────────────────
// جدول القيود اليومية - Journal Entries
// ─────────────────────────────────────────────────────────────

@TableIndex(name: 'idx_journal_entries_date', columns: {#date})
@TableIndex(
    name: 'idx_journal_entries_source', columns: {#sourceType, #sourceId})
@TableIndex(name: 'idx_journal_entries_branch', columns: {#branchId})
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// رقم القيد المتسلسل (Unique Serial Number)
  TextColumn get serialNumber => text().withLength(min: 1, max: 50)();

  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().withLength(min: 1, max: 500)();

  /// رقم المرجع (فاتورة، سند، ...)
  TextColumn get reference => text().withLength(min: 1, max: 100).nullable()();

  IntColumn get status => intEnum<EntryStatus>()();
  TextColumn get notes => text().nullable()();

  // تتبع التدقيق (Audit Trail)
  TextColumn get createdBy => text().nullable()();
  TextColumn get postedBy => text().nullable()();
  DateTimeColumn get postedAt => dateTime().nullable()();

  // ── أُضيفت في الإصدار 2 من المخطط (Schema v2) ──

  /// نوع العملية (مبيعات، مشتريات، سند قبض...) - اختياري
  IntColumn get entryType => intEnum<EntryType>().nullable()();

  /// ربط القيد بمستند في النظام المضيف (مثال: 'invoice' / '15')
  TextColumn get sourceType => text().nullable()();
  TextColumn get sourceId => text().nullable()();

  /// إن كان هذا القيد قيداً عكسياً: معرّف القيد الأصلي
  IntColumn get reversalOfId => integer().nullable()();

  /// الفرع الذي ينتمي إليه القيد (Schema v5)
  IntColumn get branchId => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {serialNumber}
      ];

  @override
  String get tableName => 'journal_entries';
}

// ─────────────────────────────────────────────────────────────
// جدول بنود القيود - Journal Entry Lines
// ─────────────────────────────────────────────────────────────

@TableIndex(name: 'idx_journal_entry_lines_entry', columns: {#entryId})
@TableIndex(name: 'idx_journal_entry_lines_account', columns: {#accountId})
class JournalEntryLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();

  /// المبلغ المدين (0 إذا كان البند دائناً)
  RealColumn get debit => real().withDefault(const Constant(0.0))();

  /// المبلغ الدائن (0 إذا كان البند مديناً)
  RealColumn get credit => real().withDefault(const Constant(0.0))();

  TextColumn get description => text().nullable()();

  /// ترتيب البند داخل القيد
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // ── Schema v4: تعدد العملات (null = عملة الأساس) ──
  TextColumn get currencyCode => text().withLength(min: 3, max: 3).nullable()();

  /// المبلغ بعملة البند (موجب، والجهة تتبع المدين/الدائن)
  RealColumn get amountCurrency => real().nullable()();
  RealColumn get exchangeRate => real().nullable()();

  @override
  String get tableName => 'journal_entry_lines';
}

// ─────────────────────────────────────────────────────────────
// جدول القوالب المخصصة - Entry Templates (Schema v2)
// ─────────────────────────────────────────────────────────────

class EntryTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  IntColumn get type => intEnum<EntryType>()();

  /// بنود القالب مخزّنة كـ JSON
  TextColumn get linesJson => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'entry_templates';
}

// ─────────────────────────────────────────────────────────────
// مراكز التكلفة - Cost Centers (Schema v3)
// ─────────────────────────────────────────────────────────────

/// الأبعاد التحليلية (فرع، مشروع، قسم...)
class CostDimensions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 30)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr => text().withLength(min: 1, max: 255).nullable()();
  TextColumn get description => text().nullable()();

  /// السياسة الافتراضية لكل الحسابات
  IntColumn get defaultPolicy => intEnum<DimensionPolicy>()
      .withDefault(Constant(DimensionPolicy.optional.index))();

  /// هل يُسمح بتوزيع البند على أكثر من مركز من هذا البعد؟
  BoolColumn get allowSplit => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'cost_dimensions';
}

/// مراكز التكلفة (شجرة هرمية لكل بُعد)
@TableIndex(name: 'idx_cost_centers_dimension', columns: {#dimensionId})
class CostCenters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dimensionId => integer().references(CostDimensions, #id)();
  TextColumn get code => text().withLength(min: 1, max: 30)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr => text().withLength(min: 1, max: 255).nullable()();
  IntColumn get parentId => integer().nullable().references(CostCenters, #id)();
  IntColumn get level => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'cost_centers';
}

/// توزيع بنود القيود على مراكز التكلفة
@TableIndex(name: 'idx_line_allocations_line', columns: {#lineId})
@TableIndex(name: 'idx_line_allocations_center', columns: {#costCenterId})
class JournalLineAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lineId => integer().references(JournalEntryLines, #id)();
  IntColumn get costCenterId => integer().references(CostCenters, #id)();

  /// بُعد المركز (نسخة لتسريع التقارير)
  IntColumn get dimensionId => integer().references(CostDimensions, #id)();

  /// المبلغ المخصص (موجب دائماً، والجهة تتبع البند)
  RealColumn get amount => real()();

  /// النسبة من مبلغ البند (0-100)
  RealColumn get percentage => real()();

  @override
  String get tableName => 'journal_line_allocations';
}

/// قواعد سياسة الأبعاد لكل حساب أو نوع حساب
class CostDimensionRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dimensionId => integer().references(CostDimensions, #id)();
  IntColumn get accountId => integer().nullable().references(Accounts, #id)();
  IntColumn get accountType => intEnum<AccountType>().nullable()();
  IntColumn get policy => intEnum<DimensionPolicy>()();
  IntColumn get defaultCostCenterId =>
      integer().nullable().references(CostCenters, #id)();

  @override
  String get tableName => 'cost_dimension_rules';
}

/// مفاتيح التوزيع
class AllocationKeys extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 30)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr => text().withLength(min: 1, max: 255).nullable()();
  IntColumn get dimensionId => integer().references(CostDimensions, #id)();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'allocation_keys';
}

/// أوزان المراكز داخل مفتاح التوزيع
class AllocationKeyItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get keyId => integer().references(AllocationKeys, #id)();
  IntColumn get costCenterId => integer().references(CostCenters, #id)();
  RealColumn get weight => real()();

  @override
  String get tableName => 'allocation_key_items';
}

// ─────────────────────────────────────────────────────────────
// تعدد العملات - Multi-currency (Schema v4)
// ─────────────────────────────────────────────────────────────

class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 3, max: 3)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get nameAr => text().withLength(min: 1, max: 100).nullable()();
  TextColumn get symbol => text().withLength(min: 1, max: 10).nullable()();
  IntColumn get decimalPlaces => integer().withDefault(const Constant(2))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'currencies';
}

/// أسعار الصرف مقابل عملة الأساس (سعر واحد لكل عملة في اليوم)
@TableIndex(name: 'idx_exchange_rates_lookup', columns: {#currencyCode, #date})
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  DateTimeColumn get date => dateTime()();
  RealColumn get rate => real()();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {currencyCode, date}
      ];

  @override
  String get tableName => 'exchange_rates';
}

/// إعدادات مثبّتة في قاعدة البيانات (مثل عملة الأساس)
class AccountingSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};

  @override
  String get tableName => 'accounting_settings';
}

// ─────────────────────────────────────────────────────────────
// الفروع - Branches (Schema v5)
// ─────────────────────────────────────────────────────────────

@DataClassName('Branch')
class Branches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 30)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get nameAr => text().withLength(min: 1, max: 255).nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isHeadOffice => boolean().withDefault(const Constant(false))();

  /// حساب "جاري الفرع" الذي تسجل عليه الفروع الأخرى معاملاتها معه
  IntColumn get interBranchAccountId =>
      integer().nullable().references(Accounts, #id)();

  /// مركز التكلفة المرتبط (بُعد الفرع) لنسبة الحركات إليه تلقائياً
  IntColumn get costCenterId =>
      integer().nullable().references(CostCenters, #id)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {code}
      ];

  @override
  String get tableName => 'branches';
}

/// إقفال فترة محاسبية لفرع معيّن
class BranchPeriodClosures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(AccountingPeriods, #id)();
  IntColumn get branchId => integer().references(Branches, #id)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {periodId, branchId}
      ];

  @override
  String get tableName => 'branch_period_closures';
}

/// تقييد حساب (وحساباته الفرعية) بفروع معيّنة
class AccountBranches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get branchId => integer().references(Branches, #id)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {accountId, branchId}
      ];

  @override
  String get tableName => 'account_branches';
}
