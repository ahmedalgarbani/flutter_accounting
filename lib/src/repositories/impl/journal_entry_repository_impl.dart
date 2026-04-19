/// journal_entry_repository_impl.dart
/// تنفيذ Repository القيود اليومية مع:
/// - التحقق من القيد المزدوج
/// - منع تعديل القيود المرحّلة
/// - دعم القيد العكسي (Reversal)
library;

import 'package:flutter_accounting/src/database/accounting_database.dart';

import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../core/accounting_validator.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../interfaces/interfaces.dart';

class JournalEntryRepositoryImpl implements IJournalEntryRepository {
  final JournalEntriesDao _entriesDao;
  final AccountsDao _accountsDao;

  JournalEntryRepositoryImpl(this._entriesDao, this._accountsDao);

  // ─────────────────────────────────────────────────────────────
  // القراءة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<JournalEntryModel>> getAllEntries() async {
    final entries = await _entriesDao.getAllEntries();
    return Future.wait(entries.map(_buildWithLines));
  }

  @override
  Future<JournalEntryModel?> getEntryById(int id) async {
    final data = await _entriesDao.getEntryById(id);
    if (data == null) return null;
    return _buildWithLines(data);
  }

  @override
  Future<List<JournalEntryModel>> getEntriesByStatus(EntryStatus status) async {
    final entries = await _entriesDao.getEntriesByStatus(status);
    return Future.wait(entries.map(_buildWithLines));
  }

  @override
  Future<List<JournalEntryModel>> getEntriesInDateRange(
    DateTime from,
    DateTime to,
  ) async {
    final entries = await _entriesDao.getEntriesInDateRange(from, to);
    return Future.wait(entries.map(_buildWithLines));
  }

  @override
  Stream<List<JournalEntryModel>> watchAllEntries() =>
      _entriesDao.watchAllEntries().asyncMap(
            (entries) => Future.wait(entries.map(_buildWithLines)),
          );

  // ─────────────────────────────────────────────────────────────
  // الكتابة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<JournalEntryModel> createEntry(JournalEntryModel entry) async {
    // 1. التحقق من القواعد المحاسبية والفترة
    await _validateEntry(entry);

    // 2. توليد رقم تسلسلي إذا لم يوجد أو التحقق من وجوده
    String serial = entry.serialNumber ?? 
                    await _entriesDao.generateNextSerialNumber(entry.date);
    
    if (await _entriesDao.serialNumberExists(serial)) {
      if (entry.id == null) { // قيد جديد
         throw DuplicateSerialNumberException(serial);
      }
    }

    final now = DateTime.now();
    final toSave = entry.copyWith(
      serialNumber: serial,
      createdAt:    now, 
      updatedAt:    now,
    );
    
    final comp = JournalEntryMapper.toCompanion(toSave);
    final lineComps =
        entry.lines.map(JournalEntryLineMapper.toCompanion).toList();

    final id = await _entriesDao.insertEntryWithLines(
      entry: comp,
      lines: lineComps,
    );

    return toSave.copyWith(id: id);
  }

  @override
  Future<JournalEntryModel> updateEntry(JournalEntryModel entry) async {
    if (entry.id == null) throw EntryNotFoundException(-1);

    final existing = await _getOrThrow(entry.id!);

    // القاعدة: لا تعديل على القيود المرحّلة
    if (!existing.isEditable) {
      throw const CannotModifyPostedEntryException();
    }

    // التحقق من القواعد المحاسبية
    await _validateLines(entry.lines);

    final updated = entry.copyWith(updatedAt: DateTime.now());
    final comp = JournalEntryMapper.toCompanion(updated);
    final lineComps =
        entry.lines.map(JournalEntryLineMapper.toCompanion).toList();

    await _entriesDao.updateEntryWithLines(entry: comp, lines: lineComps);
    return updated;
  }

  @override
  Future<void> deleteEntry(int id) async {
    final existing = await _getOrThrow(id);

    // القاعدة: لا حذف للقيود المرحّلة
    if (!existing.isEditable) {
      throw const CannotModifyPostedEntryException();
    }

    await _entriesDao.deleteEntryWithLines(id);
  }

  // ─────────────────────────────────────────────────────────────
  // الترحيل والعكس
  // ─────────────────────────────────────────────────────────────

  @override
  Future<JournalEntryModel> postEntry(int id, {String? postedBy}) async {
    final entry = await _getOrThrow(id);

    if (entry.isPosted) return entry; // مرحّل مسبقاً

    // التحقق من صحة القيد والفترة قبل الترحيل
    await _validateEntry(entry);

    final now = DateTime.now();
    final updated = entry.copyWith(
      status:   EntryStatus.posted,
      postedBy: postedBy,
      postedAt: now,
      updatedAt: now,
    );

    final comp = JournalEntryMapper.toCompanion(updated);
    // نقوم بتحديث القيد بالكامل لتسجيل بيانات الترحيل
    await _entriesDao.updateEntry(comp);
    
    return updated;
  }

  @override
  Future<JournalEntryModel> reverseEntry(
    int id, {
    DateTime? reversalDate,
  }) async {
    final original = await _getOrThrow(id);

    if (!original.isPosted) {
      throw const CannotModifyPostedEntryException();
    }

    final date = reversalDate ?? DateTime.now();

    // إنشاء القيد العكسي (قلب المدين والدائن)
    final reversalLines = original.lines
        .map((line) => line.copyWith(
              id: null,
              entryId: null,
              debit: line.credit, // مبادلة
              credit: line.debit, // مبادلة
            ))
        .toList();

    final reversalEntry = JournalEntryModel(
      date: date,
      description: 'عكس: ${original.description}',
      reference:
          original.reference != null ? 'REV-${original.reference}' : null,
      status: EntryStatus.posted,
      lines: reversalLines,
      notes: 'قيد عكسي للقيد رقم ${original.id}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // تسجيل القيد العكسي
    final created = await createEntry(reversalEntry);

    // تحديث حالة القيد الأصلي إلى "معكوس"
    await _entriesDao.updateEntryStatus(id, EntryStatus.reversed);

    return created;
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات خاصة
  // ─────────────────────────────────────────────────────────────

  Future<JournalEntryModel> _getOrThrow(int id) async {
    final entry = await getEntryById(id);
    if (entry == null) throw EntryNotFoundException(id);
    return entry;
  }

  Future<JournalEntryModel> _buildWithLines(JournalEntry data) async {
    final linesData = await _entriesDao.getLinesForEntry(data.id);
    final lines =
        linesData.map(JournalEntryLineMapper.fromEntryLineWithAccount).toList();
    return JournalEntryMapper.fromData(data, lines: lines as List<JournalEntryLineModel>);
  }

  Future<void> _validateEntry(JournalEntryModel entry) async {
    // 1. التحقق من القواعد المحاسبية للبنود
    await _validateLines(entry.lines);

    // 2. التحقق من الفترة المحاسبية (Period Control)
    final period = await _entriesDao.getPeriodForDate(entry.date);
    if (period == null) {
      throw DateOutsidePeriodException(entry.date);
    }
    if (period.isClosed) {
      throw PeriodClosedException(entry.date);
    }
  }

  Future<void> _validateLines(List<JournalEntryLineModel> lines) async {
    if (lines.isEmpty) throw const InsufficientLinesException();

    // التحقق من قواعد الـ Double-Entry
    AccountingValidator.validateEntryLines(lines);

    // التحقق من أن جميع الحسابات موجودة ونشطة وليست حسابات أب لـ (Leaf Accounts Only)
    for (final line in lines) {
      final account = await _accountsDao.getAccountById(line.accountId);
      if (account == null) throw AccountNotFoundException(line.accountId);
      
      // 1. الحساب يجب أن يكون نشطاً
      if (!account.isActive) throw InactiveAccountException(account.code);

      // 2. الحساب يجب أن يكون حساباً فرعياً (Leaf) ولا يسمح بالتسجيل على الحسابات الأب
      if (await _accountsDao.hasChildren(line.accountId)) {
        throw AccountIsParentException(account.code);
      }
    }
  }
}
