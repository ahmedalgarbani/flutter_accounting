/// cost_allocation_repository_impl.dart
/// تنفيذ التوزيع الدوري لتكاليف مركز على مراكز أخرى حسب مفتاح توزيع
library;

import '../../core/accounting_config.dart';
import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../core/system_sources.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/cost_centers_dao.dart';
import '../../models/cost_allocation_model.dart';
import '../../models/cost_allocation_run_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../models/journal_entry_model.dart';
import '../interfaces/interfaces.dart';

class CostAllocationRepositoryImpl implements ICostAllocationRepository {
  final CostCentersDao _dao;
  final AccountsDao _accountsDao;
  final ICostCenterRepository _costCenters;
  final IJournalEntryRepository _journalEntries;
  final AccountingConfig _config;

  CostAllocationRepositoryImpl(
    this._dao,
    this._accountsDao,
    this._costCenters,
    this._journalEntries, [
    this._config = const AccountingConfig(),
  ]);

  @override
  Future<CostAllocationPreview> previewAllocation(
      CostAllocationRequest request) async {
    if (!_config.enableCostCenters) throw const CostCentersDisabledException();

    final source =
        await _costCenters.getCostCenterById(request.sourceCostCenterId);
    if (source == null) {
      throw CostCenterNotFoundException(request.sourceCostCenterId);
    }
    if (await _dao.centerHasChildren(source.id!)) {
      throw CostCenterIsParentException(source.code);
    }

    final key =
        await _costCenters.getAllocationKeyById(request.allocationKeyId);
    if (key == null) {
      throw AllocationKeyNotFoundException(request.allocationKeyId);
    }
    if (key.dimensionId != source.dimensionId) {
      throw const InvalidAllocationKeyException(
          'مفتاح التوزيع والمركز المصدر يجب أن يكونا من نفس البعد.');
    }

    // الحسابات المشمولة (مع حساباتها الفرعية)، والافتراضي كل المصروفات
    final accounts = {
      for (final a in await _accountsDao.getAllAccounts()) a.id: a
    };
    final Set<int> accountIds;
    if (request.accountIds == null) {
      accountIds = {
        for (final a in accounts.values)
          if (a.type == AccountType.expense) a.id,
      };
    } else {
      accountIds = {};
      for (final id in request.accountIds!) {
        if (!accounts.containsKey(id)) throw AccountNotFoundException(id);
        accountIds
          ..add(id)
          ..addAll(await _accountsDao.getDescendantIds(id));
      }
    }

    final totals = await _dao.getCenterAccountTotals(
      dimensionId: source.dimensionId,
      from: startOfDay(request.from),
      toExclusive: startOfNextDay(request.to),
    );

    final lines = <CostAllocationPreviewLine>[];
    for (final t in totals) {
      if (t.costCenterId != source.id || !accountIds.contains(t.accountId)) {
        continue;
      }
      final net = t.totalDebit - t.totalCredit;
      if (net.abs() < 0.0005) continue;
      final account = accounts[t.accountId]!;
      lines.add(CostAllocationPreviewLine(
        accountId: account.id,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        amount: net,
        shares: await _costCenters.splitByKey(key.id!, net.abs()),
      ));
    }
    lines.sort((a, b) => a.accountCode.compareTo(b.accountCode));

    return CostAllocationPreview(
      request: request,
      sourceCostCenterCode: source.code,
      sourceCostCenterName: source.displayName,
      allocationKeyCode: key.code,
      lines: lines,
    );
  }

  @override
  Future<JournalEntryModel> runAllocation(
    CostAllocationRequest request, {
    bool post = true,
    String? postedBy,
  }) async {
    final preview = await previewAllocation(request);
    if (preview.isEmpty) {
      throw InvalidCostAllocationException(
          'لا توجد أرصدة على المركز "${preview.sourceCostCenterCode}" '
          'للتوزيع في الفترة المحددة.');
    }

    final lines = <JournalEntryLineModel>[];
    for (final p in preview.lines) {
      final amount = p.amount.abs();
      final debitBalance = p.amount > 0;
      // إخراج الرصيد من المركز المصدر...
      lines.add(JournalEntryLineModel(
        accountId: p.accountId,
        debit: debitBalance ? 0 : amount,
        credit: debitBalance ? amount : 0,
        description: 'من ${preview.sourceCostCenterName}',
        allocations: [
          CostAllocationModel(costCenterId: request.sourceCostCenterId),
        ],
      ));
      // ...وتحميله على مراكز المفتاح
      lines.add(JournalEntryLineModel(
        accountId: p.accountId,
        debit: debitBalance ? amount : 0,
        credit: debitBalance ? 0 : amount,
        description: 'حسب مفتاح ${preview.allocationKeyCode}',
        allocations: p.shares,
      ));
    }

    final entry = JournalEntryModel(
      date: request.date ?? request.to,
      description: request.description ??
          'توزيع تكاليف ${preview.sourceCostCenterName} '
              'حسب مفتاح ${preview.allocationKeyCode}',
      reference: request.reference,
      entryType: EntryType.costAllocation,
      sourceType: SystemSources.costAllocation,
      sourceId: request.sourceCostCenterId.toString(),
      lines: lines,
    );

    return post
        ? _journalEntries.createAndPost(entry, postedBy: postedBy)
        : _journalEntries.createEntry(entry);
  }
}
