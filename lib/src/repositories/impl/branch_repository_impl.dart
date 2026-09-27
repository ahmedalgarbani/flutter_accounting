/// branch_repository_impl.dart
/// تنفيذ Repository الفروع ومعاملات ما بين الفروع
library;

import '../../core/accounting_config.dart';
import '../../core/accounting_validator.dart';
import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../core/system_sources.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/branches_dao.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../../models/branch_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../models/journal_entry_model.dart';
import '../interfaces/interfaces.dart';

class BranchRepositoryImpl implements IBranchRepository {
  final BranchesDao _dao;
  final AccountsDao _accountsDao;
  final JournalEntriesDao _entriesDao;
  final IAccountRepository _accounts;
  final IJournalEntryRepository _journalEntries;
  final AccountingConfig _config;

  BranchRepositoryImpl(
    this._dao,
    this._accountsDao,
    this._entriesDao,
    this._accounts,
    this._journalEntries,
    this._config,
  );

  BranchConfig get _branchConfig {
    final config = _config.branches;
    if (config == null) throw const BranchesDisabledException();
    return config;
  }

  // ─────────────────────────────────────────────────────────────
  // القراءة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<BranchModel>> getBranches({bool activeOnly = false}) async =>
      (await _dao.getBranches(activeOnly: activeOnly))
          .map(BranchMapper.fromData)
          .toList();

  @override
  Future<BranchModel?> getBranchById(int id) async {
    final data = await _dao.getBranchById(id);
    return data == null ? null : BranchMapper.fromData(data);
  }

  @override
  Future<BranchModel?> getBranchByCode(String code) async {
    final data = await _dao.getBranchByCode(code);
    return data == null ? null : BranchMapper.fromData(data);
  }

  // ─────────────────────────────────────────────────────────────
  // الكتابة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<BranchModel> createBranch(BranchModel branch) async {
    final config = _branchConfig;
    if (await _dao.codeExists(branch.code)) {
      throw DuplicateBranchCodeException(branch.code);
    }
    await _validateLinks(branch);

    return _dao.transaction(() async {
      var toSave = branch;
      final parentCode = config.interBranchParentCode;
      if (branch.interBranchAccountId == null && parentCode != null) {
        final account = await _accounts.ensureAccount(
          code: 'IB-${branch.code}',
          name: 'Inter-branch: ${branch.name}',
          nameAr: 'جاري ${branch.nameAr ?? branch.name}',
          type: AccountType.asset,
          parentCode: parentCode,
          description: 'حساب جاري الفرع ${branch.code} (معاملات ما بين الفروع)',
        );
        toSave = branch.copyWith(interBranchAccountId: account.id);
      }
      final now = DateTime.now();
      toSave = toSave.copyWith(createdAt: now, updatedAt: now);
      final id = await _dao.insertBranch(BranchMapper.toCompanion(toSave));
      return toSave.copyWith(id: id);
    });
  }

  @override
  Future<BranchModel> updateBranch(BranchModel branch) async {
    _branchConfig;
    final id = branch.id;
    if (id == null || await _dao.getBranchById(id) == null) {
      throw BranchNotFoundException(id ?? branch.code);
    }
    if (await _dao.codeExists(branch.code, excludeId: id)) {
      throw DuplicateBranchCodeException(branch.code);
    }
    await _validateLinks(branch);
    final updated = branch.copyWith(updatedAt: DateTime.now());
    await _dao.updateBranch(BranchMapper.toCompanion(updated));
    return updated;
  }

  Future<void> _validateLinks(BranchModel branch) async {
    final accountId = branch.interBranchAccountId;
    if (accountId != null &&
        await _accountsDao.getAccountById(accountId) == null) {
      throw AccountNotFoundException(accountId);
    }
    final centerId = branch.costCenterId;
    if (centerId != null &&
        await _entriesDao.attachedDatabase.costCentersDao
                .getCenterById(centerId) ==
            null) {
      throw CostCenterNotFoundException(centerId);
    }
  }

  @override
  Future<BranchModel> ensureBranch({
    required String code,
    required String name,
    String? nameAr,
    bool isHeadOffice = false,
    int? costCenterId,
  }) async {
    final existing = await getBranchByCode(code);
    if (existing != null) return existing;
    return createBranch(BranchModel(
      code: code,
      name: name,
      nameAr: nameAr,
      isHeadOffice: isHeadOffice,
      costCenterId: costCenterId,
    ));
  }

  @override
  Future<void> setBranchActive(int id, {required bool isActive}) async {
    _branchConfig;
    final branch = await getBranchById(id);
    if (branch == null) throw BranchNotFoundException(id);
    await _dao.updateBranch(
        BranchMapper.toCompanion(branch.copyWith(isActive: isActive)));
  }

  @override
  Future<void> deleteBranch(int id) async {
    _branchConfig;
    if (await _dao.getBranchById(id) == null) throw BranchNotFoundException(id);
    if (await _dao.branchHasEntries(id)) {
      throw const BranchHasEntriesException();
    }
    await _dao.deleteBranch(id);
  }

  // ─────────────────────────────────────────────────────────────
  // تقييد الحسابات
  // ─────────────────────────────────────────────────────────────

  @override
  Future<void> restrictAccount(int accountId, List<int> branchIds) async {
    _branchConfig;
    if (await _accountsDao.getAccountById(accountId) == null) {
      throw AccountNotFoundException(accountId);
    }
    for (final id in branchIds) {
      if (await _dao.getBranchById(id) == null) {
        throw BranchNotFoundException(id);
      }
    }
    await _dao.setAccountBranches(accountId, branchIds);
  }

  @override
  Future<List<int>> getAccountBranchIds(int accountId) =>
      _dao.getAccountBranchIds(accountId);

  // ─────────────────────────────────────────────────────────────
  // إقفال الفترات لكل فرع
  // ─────────────────────────────────────────────────────────────

  @override
  Future<void> closePeriod(int periodId, int branchId) async {
    _branchConfig;
    final period = await _entriesDao.getPeriodById(periodId);
    if (period == null) throw PeriodNotFoundException(periodId);
    if (await _dao.getBranchById(branchId) == null) {
      throw BranchNotFoundException(branchId);
    }
    final drafts = await _dao.countDrafts(
        branchId, period.startDate, endOfDay(period.endDate));
    if (drafts > 0) throw PeriodHasDraftEntriesException(drafts);
    await _dao.closePeriod(periodId, branchId);
  }

  @override
  Future<void> reopenPeriod(int periodId, int branchId) async {
    _branchConfig;
    await _dao.reopenPeriod(periodId, branchId);
  }

  @override
  Future<bool> isPeriodClosed(int periodId, int branchId) =>
      _dao.isPeriodClosed(periodId, branchId);

  // ─────────────────────────────────────────────────────────────
  // معاملات ما بين الفروع
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<JournalEntryModel>> recordInterBranch(
    InterBranchTransaction transaction, {
    bool post = true,
    String? postedBy,
  }) async {
    _branchConfig;
    if (transaction.fromBranchId == transaction.toBranchId) {
      throw const InvalidBranchOperationException(
          'المعاملة بين الفروع تتطلب فرعين مختلفين.');
    }
    final from = await _dao.getBranchById(transaction.fromBranchId);
    if (from == null) throw BranchNotFoundException(transaction.fromBranchId);
    final to = await _dao.getBranchById(transaction.toBranchId);
    if (to == null) throw BranchNotFoundException(transaction.toBranchId);
    final fromAccount = from.interBranchAccountId;
    final toAccount = to.interBranchAccountId;
    if (fromAccount == null || toAccount == null) {
      throw InvalidBranchOperationException(
          'الفرع "${fromAccount == null ? from.code : to.code}" ليس له حساب جاري.');
    }
    final allLines = [...transaction.fromLines, ...transaction.toLines];
    if (allLines.any((l) => l.currencyCode != null)) {
      throw const InvalidBranchOperationException(
          'بنود المعاملات بين الفروع تكون بعملة الأساس.');
    }

    double net(List<JournalEntryLineModel> lines) =>
        AccountingValidator.totalDebits(lines) -
        AccountingValidator.totalCredits(lines);
    final netFrom = net(transaction.fromLines);
    final netTo = net(transaction.toLines);
    if (AccountingValidator.isBalanced(netFrom, 0) ||
        !AccountingValidator.isBalanced(netFrom + netTo, 0)) {
      throw InvalidBranchOperationException(
          'بنود الفرعين يجب أن تتقابل: صافي المُرسِل ($netFrom) '
          'يجب أن يساوي سالب صافي المستقبِل ($netTo) وألا يكون صفراً.');
    }

    // كل فرع يسجل الفرع الآخر على حسابه الجاري
    JournalEntryLineModel balancing(int accountId, double netAmount) =>
        JournalEntryLineModel(
          accountId: accountId,
          debit: netAmount < 0 ? -netAmount : 0,
          credit: netAmount > 0 ? netAmount : 0,
          description: transaction.description,
        );

    final tag =
        '${from.code}-${to.code}-${DateTime.now().microsecondsSinceEpoch}';
    JournalEntryModel entry(int branchId, List<JournalEntryLineModel> lines) =>
        JournalEntryModel(
          date: transaction.date ?? DateTime.now(),
          description: transaction.description,
          reference: transaction.reference,
          branchId: branchId,
          sourceType: SystemSources.interBranch,
          sourceId: tag,
          lines: [
            for (var i = 0; i < lines.length; i++)
              lines[i].copyWith(sortOrder: i),
          ],
        );

    final fromEntry = entry(
        from.id, [...transaction.fromLines, balancing(toAccount, netFrom)]);
    final toEntry =
        entry(to.id, [...transaction.toLines, balancing(fromAccount, netTo)]);

    return _entriesDao.transaction(() async => [
          for (final e in [fromEntry, toEntry])
            post
                ? await _journalEntries.createAndPost(e, postedBy: postedBy)
                : await _journalEntries.createEntry(e),
        ]);
  }
}
