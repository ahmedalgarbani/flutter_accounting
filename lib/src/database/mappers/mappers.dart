/// mappers.dart
/// التحويل بين نماذج Drift ونماذج الـ Domain
library;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_accounting/src/database/accounting_database.dart';
import 'package:flutter_accounting/src/database/daos/journal_entries_dao.dart';

import '../../models/account_model.dart';
import '../../models/accounting_period_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../models/entry_template_model.dart';
import '../../models/cost_dimension_model.dart';
import '../../models/cost_center_model.dart';
import '../../models/cost_allocation_model.dart';
import '../../models/allocation_key_model.dart';
import '../../models/currency_model.dart';

/// يحوّل النص الفارغ إلى null (الأعمدة الاختيارية لا تقبل نصاً فارغاً)
String? _nullIfBlank(String? v) => (v == null || v.trim().isEmpty) ? null : v;

// ─────────────────────────────────────────────────────────────
// Account Mapper
// ─────────────────────────────────────────────────────────────

class AccountMapper {
  AccountMapper._();

  static AccountModel fromData(Account data) => AccountModel(
        id: data.id,
        code: data.code,
        name: data.name,
        nameAr: data.nameAr,
        type: data.type,
        parentId: data.parentId,
        isActive: data.isActive,
        description: data.description,
        level: data.level,
        currencyCode: data.currencyCode,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static AccountsCompanion toCompanion(AccountModel model) => AccountsCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        code: Value(model.code),
        name: Value(model.name),
        nameAr: Value(_nullIfBlank(model.nameAr)),
        type: Value(model.type),
        parentId: Value(model.parentId),
        isActive: Value(model.isActive),
        description: Value(model.description),
        level: Value(model.level),
        currencyCode: Value(_nullIfBlank(model.currencyCode)),
        updatedAt: Value(DateTime.now()),
      );

  static List<AccountModel> fromDataList(List<Account> list) =>
      list.map(fromData).toList();
}

// ─────────────────────────────────────────────────────────────
// Journal Entry Line Mapper
// ─────────────────────────────────────────────────────────────

class JournalEntryLineMapper {
  JournalEntryLineMapper._();

  static JournalEntryLineModel fromEntryLineWithAccount(
    EntryLineWithAccount data,
  ) =>
      JournalEntryLineModel(
        id: data.line.id,
        entryId: data.line.entryId,
        accountId: data.line.accountId,
        accountCode: data.account.code,
        accountName: data.account.nameAr ?? data.account.name,
        debit: data.line.debit,
        credit: data.line.credit,
        description: data.line.description,
        sortOrder: data.line.sortOrder,
        allocations:
            data.allocations.map(CostAllocationMapper.fromData).toList(),
        currencyCode: data.line.currencyCode,
        amountCurrency: data.line.amountCurrency,
        exchangeRate: data.line.exchangeRate,
      );

  static JournalEntryLinesCompanion toCompanion(JournalEntryLineModel model) =>
      JournalEntryLinesCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        entryId: model.entryId != null
            ? Value(model.entryId!)
            : const Value.absent(),
        accountId: Value(model.accountId),
        debit: Value(model.debit),
        credit: Value(model.credit),
        description: Value(model.description),
        sortOrder: Value(model.sortOrder),
        currencyCode: Value(model.currencyCode),
        amountCurrency: Value(model.amountCurrency),
        exchangeRate: Value(model.exchangeRate),
      );
}

// ─────────────────────────────────────────────────────────────
// Journal Entry Mapper
// ─────────────────────────────────────────────────────────────

class JournalEntryMapper {
  JournalEntryMapper._();

  static JournalEntryModel fromData(
    JournalEntry data, {
    List<JournalEntryLineModel> lines = const [],
  }) =>
      JournalEntryModel(
        id: data.id,
        serialNumber: data.serialNumber,
        date: data.date,
        description: data.description,
        reference: data.reference,
        status: data.status,
        lines: lines,
        notes: data.notes,
        createdBy: data.createdBy,
        postedBy: data.postedBy,
        postedAt: data.postedAt,
        entryType: data.entryType,
        sourceType: data.sourceType,
        sourceId: data.sourceId,
        reversalOfId: data.reversalOfId,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static JournalEntriesCompanion toCompanion(JournalEntryModel model) =>
      JournalEntriesCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        serialNumber: model.serialNumber != null
            ? Value(model.serialNumber!)
            : const Value.absent(),
        date: Value(model.date),
        description: Value(model.description),
        reference: Value(_nullIfBlank(model.reference)),
        status: Value(model.status),
        notes: Value(model.notes),
        createdBy: Value(model.createdBy),
        postedBy: Value(model.postedBy),
        postedAt: Value(model.postedAt),
        entryType: Value(model.entryType),
        sourceType: Value(_nullIfBlank(model.sourceType)),
        sourceId: Value(_nullIfBlank(model.sourceId)),
        reversalOfId: Value(model.reversalOfId),
        updatedAt: Value(DateTime.now()),
      );
}

// ─────────────────────────────────────────────────────────────
// Accounting Period Mapper
// ─────────────────────────────────────────────────────────────

class AccountingPeriodMapper {
  AccountingPeriodMapper._();

  static AccountingPeriodModel fromData(AccountingPeriod data) =>
      AccountingPeriodModel(
        id: data.id,
        name: data.name,
        startDate: data.startDate,
        endDate: data.endDate,
        isClosed: data.isClosed,
        createdAt: data.createdAt,
      );

  static AccountingPeriodsCompanion toCompanion(AccountingPeriodModel model) =>
      AccountingPeriodsCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        name: Value(model.name),
        startDate: Value(model.startDate),
        endDate: Value(model.endDate),
        isClosed: Value(model.isClosed),
      );

  static List<AccountingPeriodModel> fromDataList(
          List<AccountingPeriod> list) =>
      list.map(fromData).toList();
}

// ─────────────────────────────────────────────────────────────
// Entry Template Mapper
// ─────────────────────────────────────────────────────────────

class EntryTemplateMapper {
  EntryTemplateMapper._();

  static EntryTemplateModel fromData(EntryTemplate data) {
    final decoded = jsonDecode(data.linesJson) as List;
    return EntryTemplateModel(
      id: data.id,
      name: data.name,
      description: data.description,
      type: data.type,
      lines: decoded
          .map((l) => EntryTemplateLineModel.fromMap(
              Map<String, dynamic>.from(l as Map)))
          .toList(),
    );
  }

  static EntryTemplatesCompanion toCompanion(EntryTemplateModel model) =>
      EntryTemplatesCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        name: Value(model.name),
        description: Value(model.description),
        type: Value(model.type),
        linesJson:
            Value(jsonEncode(model.lines.map((l) => l.toMap()).toList())),
      );
}

// ─────────────────────────────────────────────────────────────
// Cost Centers Mappers
// ─────────────────────────────────────────────────────────────

class CostDimensionMapper {
  CostDimensionMapper._();

  static CostDimensionModel fromData(CostDimension data) => CostDimensionModel(
        id: data.id,
        code: data.code,
        name: data.name,
        nameAr: data.nameAr,
        description: data.description,
        defaultPolicy: data.defaultPolicy,
        allowSplit: data.allowSplit,
        isActive: data.isActive,
        sortOrder: data.sortOrder,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static CostDimensionsCompanion toCompanion(CostDimensionModel model) =>
      CostDimensionsCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        code: Value(model.code),
        name: Value(model.name),
        nameAr: Value(_nullIfBlank(model.nameAr)),
        description: Value(_nullIfBlank(model.description)),
        defaultPolicy: Value(model.defaultPolicy),
        allowSplit: Value(model.allowSplit),
        isActive: Value(model.isActive),
        sortOrder: Value(model.sortOrder),
        updatedAt: Value(DateTime.now()),
      );
}

class CostCenterMapper {
  CostCenterMapper._();

  static CostCenterModel fromData(CostCenter data) => CostCenterModel(
        id: data.id,
        dimensionId: data.dimensionId,
        code: data.code,
        name: data.name,
        nameAr: data.nameAr,
        parentId: data.parentId,
        level: data.level,
        isActive: data.isActive,
        description: data.description,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static CostCentersCompanion toCompanion(CostCenterModel model) =>
      CostCentersCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        dimensionId: Value(model.dimensionId),
        code: Value(model.code),
        name: Value(model.name),
        nameAr: Value(_nullIfBlank(model.nameAr)),
        parentId: Value(model.parentId),
        level: Value(model.level),
        isActive: Value(model.isActive),
        description: Value(_nullIfBlank(model.description)),
        updatedAt: Value(DateTime.now()),
      );

  static List<CostCenterModel> fromDataList(List<CostCenter> list) =>
      list.map(fromData).toList();
}

class CostAllocationMapper {
  CostAllocationMapper._();

  static CostAllocationModel fromData(AllocationWithCenter data) =>
      CostAllocationModel(
        id: data.allocation.id,
        lineId: data.allocation.lineId,
        costCenterId: data.allocation.costCenterId,
        costCenterCode: data.center.code,
        costCenterName: data.center.nameAr ?? data.center.name,
        dimensionId: data.allocation.dimensionId,
        amount: data.allocation.amount,
        percentage: data.allocation.percentage,
      );

  /// الحصة يجب أن تكون محلولة (معرّف المركز والبعد والمبلغ والنسبة)
  static JournalLineAllocationsCompanion toCompanion(
          CostAllocationModel model) =>
      JournalLineAllocationsCompanion(
        costCenterId: Value(model.costCenterId!),
        dimensionId: Value(model.dimensionId!),
        amount: Value(model.amount!),
        percentage: Value(model.percentage!),
      );
}

class DimensionRuleMapper {
  DimensionRuleMapper._();

  static DimensionRuleModel fromData(CostDimensionRule data) =>
      DimensionRuleModel(
        id: data.id,
        dimensionId: data.dimensionId,
        accountId: data.accountId,
        accountType: data.accountType,
        policy: data.policy,
        defaultCostCenterId: data.defaultCostCenterId,
      );

  static CostDimensionRulesCompanion toCompanion(DimensionRuleModel model) =>
      CostDimensionRulesCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        dimensionId: Value(model.dimensionId),
        accountId: Value(model.accountId),
        accountType: Value(model.accountId == null ? model.accountType : null),
        policy: Value(model.policy),
        defaultCostCenterId: Value(model.defaultCostCenterId),
      );
}

class AllocationKeyMapper {
  AllocationKeyMapper._();

  static AllocationKeyModel fromData(
    AllocationKey data,
    List<(AllocationKeyItem, CostCenter)> items,
  ) =>
      AllocationKeyModel(
        id: data.id,
        code: data.code,
        name: data.name,
        nameAr: data.nameAr,
        dimensionId: data.dimensionId,
        description: data.description,
        isActive: data.isActive,
        items: [
          for (final (item, center) in items)
            AllocationKeyItemModel(
              id: item.id,
              costCenterId: item.costCenterId,
              weight: item.weight,
              costCenterCode: center.code,
              costCenterName: center.nameAr ?? center.name,
            ),
        ],
      );

  static AllocationKeysCompanion toCompanion(AllocationKeyModel model) =>
      AllocationKeysCompanion(
        id: model.id != null ? Value(model.id!) : const Value.absent(),
        code: Value(model.code),
        name: Value(model.name),
        nameAr: Value(_nullIfBlank(model.nameAr)),
        dimensionId: Value(model.dimensionId),
        description: Value(_nullIfBlank(model.description)),
        isActive: Value(model.isActive),
        updatedAt: Value(DateTime.now()),
      );

  static AllocationKeyItemsCompanion itemToCompanion(
          AllocationKeyItemModel item) =>
      AllocationKeyItemsCompanion(
        costCenterId: Value(item.costCenterId),
        weight: Value(item.weight),
      );
}

// ─────────────────────────────────────────────────────────────
// Currency Mappers
// ─────────────────────────────────────────────────────────────

class CurrencyMapper {
  CurrencyMapper._();

  static CurrencyModel fromData(Currency data) => CurrencyModel(
        id: data.id,
        code: data.code,
        name: data.name,
        nameAr: data.nameAr,
        symbol: data.symbol,
        decimalPlaces: data.decimalPlaces,
        isActive: data.isActive,
      );

  static CurrenciesCompanion toCompanion(CurrencyModel model) =>
      CurrenciesCompanion(
        code: Value(model.code),
        name: Value(model.name),
        nameAr: Value(_nullIfBlank(model.nameAr)),
        symbol: Value(_nullIfBlank(model.symbol)),
        decimalPlaces: Value(model.decimalPlaces),
        isActive: Value(model.isActive),
      );

  static ExchangeRateModel rateFromData(ExchangeRate data) => ExchangeRateModel(
        id: data.id,
        currencyCode: data.currencyCode,
        date: data.date,
        rate: data.rate,
      );
}
