/// journal_entry_repository_impl.dart
/// تنفيذ Repository القيود اليومية مع:
/// - التحقق من القيد المزدوج
/// - منع تعديل القيود المرحّلة
/// - دعم القيد العكسي (Reversal)
library;

import 'package:flutter_accounting/src/database/accounting_database.dart';

import '../../core/accounting_config.dart';
import '../../core/date_utils.dart';
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
  final AccountingConfig _config;

  JournalEntryRepositoryImpl(
    this._entriesDao,
    this._accountsDao, [
    this._config = const AccountingConfig(),
  ]);

  // ─────────────────────────────────────────────────────────────
  // القراءة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<JournalEntryModel>> getAllEntries() async =>
      _buildAllWithLines(await _entriesDao.getAllEntries());

  @override
  Future<JournalEntryModel?> getEntryById(int id) async {
    final data = await _entriesDao.getEntryById(id);
    if (data == null) return null;
    return _buildWithLines(data);
  }

  @override
  Future<JournalEntryModel?> getEntryBySerial(String serialNumber) async {
    final data = await _entriesDao.getEntryBySerial(serialNumber);
    if (data == null) return null;
    return _buildWithLines(data);
  }

  @override
  Future<List<JournalEntryModel>> getEntriesByStatus(
          EntryStatus status) async =>
      _buildAllWithLines(await _entriesDao.getEntriesByStatus(status));

  @override
  Future<List<JournalEntryModel>> getEntriesInDateRange(
    DateTime from,
    DateTime to,
  ) async =>
      _buildAllWithLines(
        await _entriesDao.getEntriesInDateRange(startOfDay(from), endOfDay(to)),
      );

  @override
  Future<List<JournalEntryModel>> getEntriesByReference(
          String reference) async =>
      _buildAllWithLines(await _entriesDao.getEntriesByReference(reference));

  @override
  Future<List<JournalEntryModel>> getEntriesBySource(
    String sourceType,
    String sourceId,
  ) async =>
      _buildAllWithLines(
          await _entriesDao.getEntriesBySource(sourceType, sourceId));

  @override
  Stream<List<JournalEntryModel>> watchAllEntries() =>
      _entriesDao.watchAllEntries().asyncMap(_buildAllWithLines);

  // ─────────────────────────────────────────────────────────────
  // الكتابة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<JournalEntryModel> createEntry(JournalEntryModel entry) async {
    if (entry.status == EntryStatus.reversed) {
      throw const InvalidEntryStateException(
        'لا يمكن إنشاء قيد بحالة "معكوس". استخدم reverseEntry().',
      );
    }
    return _entriesDao.transaction(() => _insert(entry));
  }

  @override
  Future<JournalEntryModel> createAndPost(
    JournalEntryModel entry, {
    String? postedBy,
  }) {
    return _entriesDao.transaction(() => _insert(
          entry.copyWith(status: EntryStatus.posted, postedBy: postedBy),
        ));
  }

  /// الإدراج الفعلي (يُستدعى داخل transaction)
  Future<JournalEntryModel> _insert(JournalEntryModel entry) async {
    // 1. التحقق من القواعد المحاسبية والفترة
    await _validateEntry(entry);

    // 2. توليد رقم تسلسلي إذا لم يوجد أو التحقق من عدم تكراره
    final serial = entry.serialNumber ??
        await _entriesDao.generateNextSerialNumber(
          entry.date,
          prefix: _config.serialPrefix,
          padding: _config.serialPadding,
        );

    if (await _entriesDao.serialNumberExists(serial)) {
      throw DuplicateSerialNumberException(serial);
    }

    final now = DateTime.now();
    final isPosted = entry.status == EntryStatus.posted;
    final toSave = entry.copyWith(
      serialNumber: serial,
      postedAt: isPosted ? (entry.postedAt ?? now) : null,
      createdAt: now,
      updatedAt: now,
    );

    final lines = _withSortOrder(entry.lines);
    final id = await _entriesDao.insertEntryWithLines(
      entry: JournalEntryMapper.toCompanion(toSave),
      lines: lines.map(JournalEntryLineMapper.toCompanion).toList(),
    );

    return (await getEntryById(id))!;
  }

  @override
  Future<JournalEntryModel> updateEntry(JournalEntryModel entry) async {
    if (entry.id == null) throw const EntryNotFoundException(-1);

    return _entriesDao.transaction(() async {
      final existing = await _getOrThrow(entry.id!);

      // القاعدة: لا تعديل على القيود المرحّلة أو المعكوسة
      if (!existing.isEditable) {
        throw const CannotModifyPostedEntryException();
      }

      // الحالة والرقم التسلسلي وبيانات الترحيل لا تتغير عبر التعديل
      // (الترحيل يتم فقط عبر postEntry كي لا تُتجاوز قواعده)
      final updated = JournalEntryModel(
        id: existing.id,
        serialNumber: existing.serialNumber,
        date: entry.date,
        description: entry.description,
        reference: entry.reference,
        status: EntryStatus.draft,
        lines: _withSortOrder(entry.lines),
        notes: entry.notes,
        createdBy: existing.createdBy ?? entry.createdBy,
        entryType: entry.entryType,
        sourceType: entry.sourceType,
        sourceId: entry.sourceId,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );

      // التحقق من القواعد المحاسبية والفترة
      await _validateEntry(updated);

      await _entriesDao.updateEntryWithLines(
        entry: JournalEntryMapper.toCompanion(updated),
        lines: updated.lines.map(JournalEntryLineMapper.toCompanion).toList(),
      );
      return (await getEntryById(existing.id!))!;
    });
  }

  @override
  Future<void> deleteEntry(int id) async {
    await _entriesDao.transaction(() async {
      final existing = await _getOrThrow(id);

      // القاعدة: لا حذف للقيود المرحّلة
      if (!existing.isEditable) {
        throw const CannotModifyPostedEntryException();
      }

      await _entriesDao.deleteEntryWithLines(id);
    });
  }

  // ─────────────────────────────────────────────────────────────
  // الترحيل والعكس
  // ─────────────────────────────────────────────────────────────

  @override
  Future<JournalEntryModel> postEntry(int id, {String? postedBy}) {
    return _entriesDao.transaction(() async {
      final entry = await _getOrThrow(id);

      if (entry.isPosted) return entry; // مرحّل مسبقاً
      if (entry.isReversed) {
        throw const InvalidEntryStateException(
          'لا يمكن ترحيل قيد معكوس.',
        );
      }

      // التحقق من صحة القيد والفترة قبل الترحيل
      await _validateEntry(entry);

      final now = DateTime.now();
      final updated = entry.copyWith(
        status: EntryStatus.posted,
        postedBy: postedBy,
        postedAt: now,
        updatedAt: now,
      );

      await _entriesDao.updateEntry(JournalEntryMapper.toCompanion(updated));
      return updated;
    });
  }

  @override
  Future<JournalEntryModel> reverseEntry(
    int id, {
    DateTime? reversalDate,
    String? description,
    String? postedBy,
  }) {
    return _entriesDao.transaction(() async {
      final original = await _getOrThrow(id);

      if (original.isReversed) throw EntryAlreadyReversedException(id);
      if (!original.isPosted) {
        throw const InvalidEntryStateException(
          'لا يمكن عكس قيد غير مرحّل. المسودة يمكن تعديلها أو حذفها مباشرة.',
        );
      }

      // إنشاء القيد العكسي (قلب المدين والدائن) ببنود جديدة بلا معرّفات
      final reversalLines = [
        for (final line in original.lines)
          JournalEntryLineModel(
            accountId: line.accountId,
            accountCode: line.accountCode,
            accountName: line.accountName,
            debit: line.credit, // مبادلة
            credit: line.debit, // مبادلة
            description: line.description,
            sortOrder: line.sortOrder,
          ),
      ];

      final created = await _insert(JournalEntryModel(
        date: reversalDate ?? DateTime.now(),
        description: description ?? 'عكس: ${original.description}',
        reference:
            original.reference != null ? 'REV-${original.reference}' : null,
        status: EntryStatus.posted,
        postedBy: postedBy,
        lines: reversalLines,
        notes: 'قيد عكسي للقيد رقم ${original.serialNumber ?? original.id}',
        entryType: EntryType.reversal,
        sourceType: original.sourceType,
        sourceId: original.sourceId,
        reversalOfId: original.id,
      ));

      // تحديث حالة القيد الأصلي إلى "معكوس"
      await _entriesDao.updateEntryStatus(id, EntryStatus.reversed);

      return created;
    });
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات خاصة
  // ─────────────────────────────────────────────────────────────

  Future<JournalEntryModel> _getOrThrow(int id) async {
    final entry = await getEntryById(id);
    if (entry == null) throw EntryNotFoundException(id);
    return entry;
  }

  /// يضمن ترتيب البنود كما أُدخلت إن لم يُحدَّد sortOrder
  List<JournalEntryLineModel> _withSortOrder(
      List<JournalEntryLineModel> lines) {
    final allZero = lines.every((l) => l.sortOrder == 0);
    if (!allZero) return lines;
    return [
      for (var i = 0; i < lines.length; i++) lines[i].copyWith(sortOrder: i),
    ];
  }

  Future<JournalEntryModel> _buildWithLines(JournalEntry data) async {
    final linesData = await _entriesDao.getLinesForEntry(data.id);
    final lines =
        linesData.map(JournalEntryLineMapper.fromEntryLineWithAccount).toList();
    return JournalEntryMapper.fromData(data, lines: lines);
  }

  Future<List<JournalEntryModel>> _buildAllWithLines(
      List<JournalEntry> entries) async {
    final linesByEntry =
        await _entriesDao.getLinesForEntries(entries.map((e) => e.id).toList());
    return [
      for (final e in entries)
        JournalEntryMapper.fromData(
          e,
          lines: (linesByEntry[e.id] ?? const [])
              .map(JournalEntryLineMapper.fromEntryLineWithAccount)
              .toList(),
        ),
    ];
  }

  Future<void> _validateEntry(JournalEntryModel entry) async {
    // 1. التحقق من القواعد المحاسبية للبنود
    await _validateLines(entry.lines);

    // 2. التحقق من الفترة المحاسبية (Period Control)
    final period = await _entriesDao.getPeriodForDate(entry.date);
    if (period == null) {
      if (_config.requireOpenPeriod) {
        throw DateOutsidePeriodException(entry.date);
      }
      return;
    }
    if (period.isClosed) {
      throw PeriodClosedException(entry.date);
    }
  }

  Future<void> _validateLines(List<JournalEntryLineModel> lines) async {
    if (lines.isEmpty) throw const InsufficientLinesException();

    // التحقق من قواعد الـ Double-Entry
    AccountingValidator.validateEntryLines(lines);

    // التحقق من أن جميع الحسابات موجودة ونشطة وليست حسابات أب (Leaf Accounts Only)
    for (final accountId in lines.map((l) => l.accountId).toSet()) {
      final account = await _accountsDao.getAccountById(accountId);
      if (account == null) throw AccountNotFoundException(accountId);

      // 1. الحساب يجب أن يكون نشطاً
      if (!account.isActive) throw InactiveAccountException(account.code);

      // 2. الحساب يجب أن يكون حساباً فرعياً (Leaf) ولا يسمح بالتسجيل على الحسابات الأب
      if (await _accountsDao.hasChildren(accountId)) {
        throw AccountIsParentException(account.code);
      }
    }
  }
}
