/// mappers.dart
/// التحويل بين نماذج Drift ونماذج الـ Domain

import 'package:drift/drift.dart';
import '../core/enums.dart';
import '../models/account_model.dart';
import '../models/journal_entry_model.dart';
import '../models/journal_entry_line_model.dart';
import '../database/tables/tables.dart';
import '../database/daos/journal_entries_dao.dart';

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
        id:          data.id,
        date:        data.date,
        description: data.description,
        reference:   data.reference,
        status:      data.status,
        lines:       lines,
        notes:       data.notes,
        createdAt:   data.createdAt,
        updatedAt:   data.updatedAt,
      );

  static JournalEntriesCompanion toCompanion(JournalEntryModel model) =>
      JournalEntriesCompanion(
        id:          model.id != null ? Value(model.id!) : const Value.absent(),
        date:        Value(model.date),
        description: Value(model.description),
        reference:   Value(model.reference),
        status:      Value(model.status),
        notes:       Value(model.notes),
        updatedAt:   Value(DateTime.now()),
      );
}
