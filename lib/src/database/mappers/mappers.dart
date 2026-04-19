/// mappers.dart
/// التحويل بين نماذج Drift ونماذج الـ Domain

import 'package:drift/drift.dart';
import 'package:flutter_accounting/src/database/accounting_database.dart';
import 'package:flutter_accounting/src/database/daos/journal_entries_dao.dart';

import '../../models/account_model.dart';
import '../../models/accounting_period_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';


// ─────────────────────────────────────────────────────────────
// Account Mapper
// ─────────────────────────────────────────────────────────────

class AccountMapper {
  AccountMapper._();

  static AccountModel fromData(Account data) => AccountModel(
        id:          data.id,
        code:        data.code,
        name:        data.name,
        nameAr:      data.nameAr,
        type:        data.type,
        parentId:    data.parentId,
        isActive:    data.isActive,
        description: data.description,
        level:       data.level,
        createdAt:   data.createdAt,
        updatedAt:   data.updatedAt,
      );

  static AccountsCompanion toCompanion(AccountModel model) => AccountsCompanion(
        id:          model.id != null ? Value(model.id!) : const Value.absent(),
        code:        Value(model.code),
        name:        Value(model.name),
        nameAr:      Value(model.nameAr),
        type:        Value(model.type),
        parentId:    Value(model.parentId),
        isActive:    Value(model.isActive),
        description: Value(model.description),
        level:       Value(model.level),
        updatedAt:   Value(DateTime.now()),
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
        id:          data.line.id,
        entryId:     data.line.entryId,
        accountId:   data.line.accountId,
        accountCode: data.account.code,
        accountName: data.account.nameAr ?? data.account.name,
        debit:       data.line.debit,
        credit:      data.line.credit,
        description: data.line.description,
        sortOrder:   data.line.sortOrder,
      );

  static JournalEntryLinesCompanion toCompanion(JournalEntryLineModel model) =>
      JournalEntryLinesCompanion(
        id:          model.id != null ? Value(model.id!) : const Value.absent(),
        entryId:     model.entryId != null ? Value(model.entryId!) : const Value.absent(),
        accountId:   Value(model.accountId),
        debit:       Value(model.debit),
        credit:      Value(model.credit),
        description: Value(model.description),
        sortOrder:   Value(model.sortOrder),
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
        id:           data.id,
        serialNumber: data.serialNumber,
        date:         data.date,
        description:  data.description,
        reference:    data.reference,
        status:       data.status,
        lines:        lines,
        notes:        data.notes,
        createdBy:    data.createdBy,
        postedBy:     data.postedBy,
        postedAt:     data.postedAt,
        createdAt:    data.createdAt,
        updatedAt:    data.updatedAt,
      );

  static JournalEntriesCompanion toCompanion(JournalEntryModel model) =>
      JournalEntriesCompanion(
        id:           model.id != null ? Value(model.id!) : const Value.absent(),
        serialNumber: model.serialNumber != null ? Value(model.serialNumber!) : const Value.absent(),
        date:         Value(model.date),
        description:  Value(model.description),
        reference:    Value(model.reference),
        status:       Value(model.status),
        notes:        Value(model.notes),
        createdBy:    Value(model.createdBy),
        postedBy:     Value(model.postedBy),
        postedAt:     Value(model.postedAt),
        updatedAt:    Value(DateTime.now()),
      );
}

// ─────────────────────────────────────────────────────────────
// Accounting Period Mapper
// ─────────────────────────────────────────────────────────────

class AccountingPeriodMapper {
  AccountingPeriodMapper._();

  static AccountingPeriodModel fromData(AccountingPeriod data) =>
      AccountingPeriodModel(
        id:        data.id,
        name:      data.name,
        startDate: data.startDate,
        endDate:   data.endDate,
        isClosed:  data.isClosed,
        createdAt: data.createdAt,
      );

  static AccountingPeriodsCompanion toCompanion(AccountingPeriodModel model) =>
      AccountingPeriodsCompanion(
        id:        model.id != null ? Value(model.id!) : const Value.absent(),
        name:      Value(model.name),
        startDate: Value(model.startDate),
        endDate:   Value(model.endDate),
        isClosed:  Value(model.isClosed),
      );

  static List<AccountingPeriodModel> fromDataList(List<AccountingPeriod> list) =>
      list.map(fromData).toList();
}
