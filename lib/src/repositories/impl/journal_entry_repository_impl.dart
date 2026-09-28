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
import '../../core/cost_allocation_calculator.dart';
import '../../core/money.dart';
import '../../models/currency_model.dart';
import '../../models/cost_allocation_model.dart';
import '../../models/journal_entry_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/branches_dao.dart';
import '../../database/daos/cost_centers_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../interfaces/interfaces.dart';
import 'dimension_policy_resolver.dart';

class JournalEntryRepositoryImpl implements IJournalEntryRepository {
  final JournalEntriesDao _entriesDao;
  final AccountsDao _accountsDao;
  final AccountingConfig _config;
  final CostCentersDao? _costCentersDao;
  final ICurrencyRepository? _currencyRepository;

  JournalEntryRepositoryImpl(
    this._entriesDao,
    this._accountsDao, [
    this._config = const AccountingConfig(),
    this._costCentersDao,
    this._currencyRepository,
  ]);

  ICurrencyRepository get _currencies =>
      _currencyRepository ??
      (throw StateError('ICurrencyRepository مطلوب لتعدد العملات.'));

  CostCentersDao get _costDao =>
      _costCentersDao ?? _entriesDao.attachedDatabase.costCentersDao;

  BranchesDao get _branchDao => _entriesDao.attachedDatabase.branchesDao;

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
    // 1. التحقق من القواعد المحاسبية والفترة ومراكز التكلفة
    final resolvedLines = await _validateEntry(entry);

    // 2. توليد رقم تسلسلي إذا لم يوجد أو التحقق من عدم تكراره
    final serial = entry.serialNumber ??
        await _entriesDao.generateNextSerialNumber(
          entry.date,
          prefix: await _serialPrefix(entry),
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

    final lines = _withSortOrder(resolvedLines);
    final id = await _entriesDao.insertEntryWithLines(
      entry: JournalEntryMapper.toCompanion(toSave),
      lines: lines.map(JournalEntryLineMapper.toCompanion).toList(),
      allocations: _allocationCompanions(lines),
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
        branchId: entry.branchId,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );

      // التحقق من القواعد المحاسبية والفترة ومراكز التكلفة
      final lines = await _validateEntry(updated);

      await _entriesDao.updateEntryWithLines(
        entry: JournalEntryMapper.toCompanion(updated),
        lines: lines.map(JournalEntryLineMapper.toCompanion).toList(),
        allocations: _allocationCompanions(lines),
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
            // نفس توزيع البند الأصلي كي يلغي أثره على كل مركز
            allocations: line.allocations,
            // ونفس العملة والسعر كي يلغي أثره بالعملة وبعملة الأساس
            currencyCode: line.currencyCode,
            amountCurrency: line.amountCurrency,
            exchangeRate: line.exchangeRate,
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
        branchId: original.branchId,
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

  /// يتحقق من القيد ويُعيد بنوده بعد حل توزيعها على مراكز التكلفة
  Future<List<JournalEntryLineModel>> _validateEntry(
      JournalEntryModel entry) async {
    // 0. تحويل البنود بالعملات الأجنبية إلى عملة الأساس
    entry = entry.copyWith(lines: await _resolveCurrencies(entry));

    // 1. التحقق من القواعد المحاسبية للبنود
    await _validateLines(entry.lines);

    // 2. التحقق من الفترة المحاسبية (Period Control)
    final period = await _entriesDao.getPeriodForDate(entry.date);
    if (period == null) {
      if (_config.requireOpenPeriod) {
        throw DateOutsidePeriodException(entry.date);
      }
    } else if (period.isClosed) {
      throw PeriodClosedException(entry.date);
    }

    // 2.5 الفروع
    await _validateBranch(entry, period);

    // 3. مراكز التكلفة (القيد العكسي ينسخ توزيع الأصل كما هو دون إعادة تحقق،
    //    كي يُلغى أثره حتى لو أُوقف مركز أو تغيرت السياسات بعد ذلك)
    if (entry.reversalOfId != null) return entry.lines;
    return _resolveAllocations(entry);
  }

  // ─────────────────────────────────────────────────────────────
  // مراكز التكلفة
  // ─────────────────────────────────────────────────────────────

  List<List<JournalLineAllocationsCompanion>> _allocationCompanions(
          List<JournalEntryLineModel> lines) =>
      [
        for (final line in lines)
          line.allocations.map(CostAllocationMapper.toCompanion).toList(),
      ];

  /// يحلّ مراكز كل بند (بالمعرّف أو الرمز)، ويطبق المراكز الافتراضية
  /// والسياسات، ويحسب مبالغ الحصص ويتحقق من صحتها.
  Future<List<JournalEntryLineModel>> _resolveAllocations(
      JournalEntryModel entry) async {
    final hasAny = entry.lines.any((l) => l.allocations.isNotEmpty);
    if (!_config.enableCostCenters) {
      if (hasAny) throw const CostCentersDisabledException();
      return entry.lines;
    }

    final resolver = await DimensionPolicyResolver.load(_costDao, _accountsDao);
    if (!hasAny && resolver.activeDimensions.isEmpty) return entry.lines;

    final centers = <Object, CostCenter>{};
    final isParent = <int, bool>{};

    Future<CostCenter> postableCenter(int? id, String? code) async {
      final key = id ?? code!;
      var center = centers[key];
      if (center == null) {
        center = id != null
            ? await _costDao.getCenterById(id)
            : await _costDao.getCenterByCode(code!);
        if (center == null) throw CostCenterNotFoundException(key);
        centers[key] = center;
      }
      final dimension = resolver.dimensions[center.dimensionId];
      if (!center.isActive || dimension == null || !dimension.isActive) {
        throw InactiveCostCenterException(center.code);
      }
      final parent =
          isParent[center.id] ??= await _costDao.centerHasChildren(center.id);
      if (parent) throw CostCenterIsParentException(center.code);
      return center;
    }

    CostAllocationModel attach(CostAllocationModel a, CostCenter c) =>
        a.copyWith(
          costCenterId: c.id,
          costCenterCode: c.code,
          costCenterName: c.nameAr ?? c.name,
          dimensionId: c.dimensionId,
        );

    // مركز تكلفة فرع القيد (يُنسب إليه كل بند لم يحدد مركزاً من بُعده)
    CostCenter? branchCenter;
    final branchId = entry.branchId;
    if (branchId != null && _config.branches?.linkCostCenters == true) {
      final centerId = (await _branchDao.getBranchById(branchId))?.costCenterId;
      if (centerId != null) {
        branchCenter = await _costDao.getCenterById(centerId);
      }
    }

    // حسابات فروقات العملة والتقريب لا يُشترط لها مركز تكلفة
    final fxAccountIds = await _exchangeAccountIds();

    final result = <JournalEntryLineModel>[];
    for (final line in entry.lines) {
      final allocations = <CostAllocationModel>[
        for (final a in line.allocations)
          attach(a, await postableCenter(a.costCenterId, a.costCenterCode)),
      ];

      // المراكز الافتراضية والسياسات لكل بُعد نشط
      for (final dimension in resolver.activeDimensions) {
        final effective = await resolver.resolve(line.accountId, dimension.id);
        var has = allocations.any((a) => a.dimensionId == dimension.id);
        final defaultId = branchCenter?.dimensionId == dimension.id
            ? branchCenter!.id
            : effective.defaultCostCenterId;
        if (!has &&
            defaultId != null &&
            effective.policy != DimensionPolicy.forbidden) {
          allocations.add(attach(CostAllocationModel(costCenterId: defaultId),
              await postableCenter(defaultId, null)));
          has = true;
        }
        if (effective.policy == DimensionPolicy.required &&
            !has &&
            entry.entryType != EntryType.costAllocation &&
            entry.entryType != EntryType.exchangeDifference &&
            !fxAccountIds.contains(line.accountId)) {
          throw CostCenterRequiredException(
              await _accountCode(line.accountId), dimension.code);
        }
        if (effective.policy == DimensionPolicy.forbidden && has) {
          throw CostCenterNotAllowedException(
              await _accountCode(line.accountId), dimension.code);
        }
      }

      // حساب المبالغ والتحقق لكل بُعد
      final byDimension = <int, List<CostAllocationModel>>{};
      for (final a in allocations) {
        byDimension.putIfAbsent(a.dimensionId!, () => []).add(a);
      }
      final resolved = <CostAllocationModel>[];
      for (final MapEntry(key: dimensionId, value: group)
          in byDimension.entries) {
        final dimension = resolver.dimensions[dimensionId]!;
        if (!dimension.allowSplit && group.length > 1) {
          throw InvalidCostAllocationException(
              'البعد "${dimension.code}" لا يسمح بتوزيع البند على أكثر من مركز.');
        }
        final seen = <int>{};
        for (final a in group) {
          if (!seen.add(a.costCenterId!)) {
            throw InvalidCostAllocationException(
                'المركز "${a.costCenterCode}" مكرر في نفس البند.');
          }
        }
        resolved.addAll(CostAllocationCalculator.resolveDimension(
          line.amount,
          group,
          fractionDigits: _config.allocationDecimals,
          dimensionLabel: dimension.code,
        ));
      }
      result.add(line.copyWith(allocations: resolved));
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────
  // تعدد العملات
  // ─────────────────────────────────────────────────────────────

  /// معرّفات حسابات فروقات العملة والتقريب المعرّفة في الإعدادات
  Future<Set<int>> _exchangeAccountIds() async {
    final mc = _config.multiCurrency;
    if (mc == null) return const {};
    final ids = <int>{};
    for (final code in {
      mc.realizedGainAccountCode,
      mc.realizedLossAccountCode,
      mc.unrealizedGainCode,
      mc.unrealizedLossCode,
      if (mc.roundingAccountCode != null) mc.roundingAccountCode!,
    }) {
      final account = await _accountsDao.getAccountByCode(code);
      if (account != null) ids.add(account.id);
    }
    return ids;
  }

  /// يحوّل كل بند إلى عملة الأساس ([debit]/[credit]) مع حفظ مبلغه بعملته
  /// وسعر الصرف، ويتحقق من عملة الحساب، ويسوّي فرق التقريب الصغير.
  Future<List<JournalEntryLineModel>> _resolveCurrencies(
      JournalEntryModel entry) async {
    final mc = _config.multiCurrency;
    if (mc == null) {
      if (entry.lines
          .any((l) => l.currencyCode != null || l.amountCurrency != null)) {
        throw const MultiCurrencyDisabledException();
      }
      return entry.lines;
    }

    final base = await _currencies.ensureBaseCurrency();
    final isReversal = entry.reversalOfId != null;
    final isSystem =
        entry.entryType == EntryType.exchangeDifference || isReversal;
    final currencies = <String, CurrencyModel>{};
    final result = <JournalEntryLineModel>[];
    var anyForeign = false;

    JournalEntryLineModel convert(JournalEntryLineModel line, double amount,
            {String? code, double? foreign, double? rate}) =>
        JournalEntryLineModel(
          id: line.id,
          entryId: line.entryId,
          accountId: line.accountId,
          accountCode: line.accountCode,
          accountName: line.accountName,
          debit: line.isDebit ? amount : 0,
          credit: line.isDebit ? 0 : amount,
          description: line.description,
          sortOrder: line.sortOrder,
          allocations: line.allocations,
          currencyCode: code,
          amountCurrency: foreign,
          exchangeRate: rate,
        );

    for (final line in entry.lines) {
      final account = await _accountsDao.getAccountById(line.accountId);
      final lockCode = account?.currencyCode;
      final code = line.currencyCode ?? lockCode ?? base.code;
      if (lockCode != null && lockCode != code) {
        throw CurrencyMismatchException(account!.code, lockCode, code);
      }

      // بند بعملة الأساس
      if (code == base.code) {
        result.add(convert(
            line,
            Money.round(
                line.amountCurrency ?? line.amount, base.decimalPlaces)));
        continue;
      }

      final currency = currencies[code] ??=
          await _currencies.getCurrency(code) ??
              (throw CurrencyNotFoundException(code));
      if (!currency.isActive && !isReversal) {
        throw InactiveCurrencyException(code);
      }
      anyForeign = true;

      // تعديل بعملة الأساس فقط (قيود فروقات العملة وعكسها)
      if (line.amountCurrency == 0 && isSystem) {
        result.add(convert(line, Money.round(line.amount, base.decimalPlaces),
            code: code, foreign: 0));
        continue;
      }

      final foreign = Money.round(
          line.amountCurrency ?? line.amount, currency.decimalPlaces);
      final rate = line.exchangeRate ??
          await _currencies.getExchangeRate(code, date: entry.date);
      if (rate <= 0 || rate.isNaN || rate.isInfinite) {
        throw const InvalidExchangeRateException(
            'سعر الصرف يجب أن يكون أكبر من صفر.');
      }
      result.add(convert(line, Money.round(foreign * rate, base.decimalPlaces),
          code: code, foreign: foreign, rate: rate));
    }

    // تسوية فرق التقريب الناتج عن التحويل
    if (anyForeign) {
      final diff = Money.round(
          AccountingValidator.totalDebits(result) -
              AccountingValidator.totalCredits(result),
          base.decimalPlaces);
      if (diff != 0 && diff.abs() <= mc.roundingTolerance) {
        final code = mc.roundingAccountCode ??
            (diff > 0
                ? mc.realizedGainAccountCode
                : mc.realizedLossAccountCode);
        final account = await _accountsDao.getAccountByCode(code);
        if (account == null) throw AccountNotFoundException(code);
        result.add(JournalEntryLineModel(
          accountId: account.id,
          debit: diff < 0 ? -diff : 0,
          credit: diff > 0 ? diff : 0,
          description: 'فرق تقريب تحويل العملة',
          sortOrder: result.length,
        ));
      }
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────
  // الفروع
  // ─────────────────────────────────────────────────────────────

  /// بادئة الترقيم: `JV` أو `JV-RYD` عند الترقيم المستقل لكل فرع
  Future<String> _serialPrefix(JournalEntryModel entry) async {
    final branchId = entry.branchId;
    if (branchId == null || _config.branches?.serialPerBranch != true) {
      return _config.serialPrefix;
    }
    final branch = await _branchDao.getBranchById(branchId);
    return branch == null
        ? _config.serialPrefix
        : '${_config.serialPrefix}-${branch.code}';
  }

  Future<void> _validateBranch(
      JournalEntryModel entry, AccountingPeriod? period) async {
    final config = _config.branches;
    final branchId = entry.branchId;
    if (config == null) {
      if (branchId != null) throw const BranchesDisabledException();
      return;
    }
    final isReversal = entry.reversalOfId != null;

    Branch? branch;
    if (branchId == null) {
      if (config.requireBranch && !isReversal) {
        throw const BranchRequiredException();
      }
    } else {
      branch = await _branchDao.getBranchById(branchId);
      if (branch == null) throw BranchNotFoundException(branchId);
      if (!branch.isActive && !isReversal) {
        throw InactiveBranchException(branch.code);
      }
      if (period != null &&
          await _branchDao.isPeriodClosed(period.id, branchId)) {
        throw PeriodClosedException(entry.date);
      }
    }
    if (isReversal) return;

    // تقييد الحسابات: أقرب تقييد على الحساب أو أحد آبائه يحدد الفروع المسموحة
    for (final accountId in entry.lines.map((l) => l.accountId).toSet()) {
      Account? current = await _accountsDao.getAccountById(accountId);
      final visited = <int>{};
      while (current != null && visited.add(current.id)) {
        final allowed = await _branchDao.getAccountBranchIds(current.id);
        if (allowed.isNotEmpty) {
          if (branchId == null || !allowed.contains(branchId)) {
            throw AccountNotAllowedForBranchException(
                await _accountCode(accountId), branch?.code);
          }
          break;
        }
        final parentId = current.parentId;
        current = parentId == null
            ? null
            : await _accountsDao.getAccountById(parentId);
      }
    }
  }

  Future<String> _accountCode(int accountId) async =>
      (await _accountsDao.getAccountById(accountId))?.code ??
      accountId.toString();

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
