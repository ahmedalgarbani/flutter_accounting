/// branches_test.dart
/// اختبارات الفروع كوحدات محاسبية: قيود الفروع، التقارير، الترقيم،
/// تقييد الحسابات، إقفال الفترات، والمعاملات بين الفروع
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

void main() {
  late FlutterAccounting fa;
  late BranchModel hq, ryd, jed;
  late int cashId, bankId, salesId, rentId;
  final d = DateTime(2024, 3, 1);
  final yearStart = DateTime(2024);
  final yearEnd = DateTime(2024, 12, 31);

  Future<FlutterAccounting> create(BranchConfig config,
      {bool costCenters = false}) async {
    final f = FlutterAccounting.forTesting(
        config:
            AccountingConfig(branches: config, enableCostCenters: costCenters));
    await AccountingSeedData.seed(f.accounts);
    await f.periods.createFiscalYear(2024);
    return f;
  }

  Future<void> init(BranchConfig config, {bool costCenters = false}) async {
    fa = await create(config, costCenters: costCenters);
    hq = await fa.branches.ensureBranch(
        code: 'HQ',
        name: 'Head Office',
        nameAr: 'المركز الرئيسي',
        isHeadOffice: true);
    ryd = await fa.branches
        .ensureBranch(code: 'RYD', name: 'Riyadh', nameAr: 'فرع الرياض');
    jed = await fa.branches
        .ensureBranch(code: 'JED', name: 'Jeddah', nameAr: 'فرع جدة');
    Future<int> id(String code) async =>
        (await fa.accounts.getAccountByCode(code))!.id!;
    cashId = await id('111');
    bankId = await id('112');
    salesId = await id('41');
    rentId = await id('53');
  }

  tearDown(() => fa.dispose());

  Future<JournalEntryModel> sale(BranchModel? branch, double amount,
      {DateTime? date}) {
    final b = JournalEntryBuilder(description: 'sale', date: date ?? d)
        .debit(cashId, amount)
        .credit(salesId, amount);
    if (branch != null) b.branch(branch.id!);
    return fa.record(b);
  }

  Future<JournalEntryModel> rent(BranchModel branch, double amount) =>
      fa.record(JournalEntryBuilder(description: 'rent', date: d)
          .branch(branch.id!)
          .debit(rentId, amount)
          .credit(cashId, amount));

  // ─────────────────────────────────────────────────────────────
  group('التفعيل والإدارة', () {
    test('الفروع موقوفة افتراضياً', () async {
      fa = FlutterAccounting.forTesting();
      await fa.periods.createFiscalYear(2024);
      await expectLater(() => fa.branches.ensureBranch(code: 'X', name: 'X'),
          throwsA(isA<BranchesDisabledException>()));
      final c = await fa.accounts.createAccount(
          AccountModel.create(code: '1', name: 'c', type: AccountType.asset));
      final r = await fa.accounts.createAccount(
          AccountModel.create(code: '4', name: 'r', type: AccountType.revenue));
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: d)
              .branch(1)
              .debit(c.id!, 1)
              .credit(r.id!, 1)),
          throwsA(isA<BranchesDisabledException>()));
    });

    test('إنشاء فرع ينشئ حساب جاري الفرع تلقائياً', () async {
      await init(const BranchConfig());
      final account =
          await fa.accounts.getAccountById(ryd.interBranchAccountId!);
      expect(account!.code, 'IB-RYD');
      expect(account.nameAr, 'جاري فرع الرياض');
      expect(account.type, AccountType.asset);
      expect(
          (await fa.branches.ensureBranch(code: 'RYD', name: 'x')).id, ryd.id);
      await expectLater(
          () => fa.branches
              .createBranch(const BranchModel(code: 'RYD', name: 'x')),
          throwsA(isA<DuplicateBranchCodeException>()));
      expect(await fa.branches.getBranches(), hasLength(3));
    });

    test('بدون إنشاء تلقائي عند interBranchParentCode = null', () async {
      await init(const BranchConfig(interBranchParentCode: null));
      expect(ryd.interBranchAccountId, isNull);
    });

    test('فرع إلزامي، موقوف، أو غير موجود', () async {
      await init(const BranchConfig(requireBranch: true));
      await expectLater(
          () => sale(null, 10), throwsA(isA<BranchRequiredException>()));
      await fa.branches.setBranchActive(jed.id!, isActive: false);
      await expectLater(
          () => sale(jed, 10), throwsA(isA<InactiveBranchException>()));
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: d)
              .branch(999)
              .debit(cashId, 1)
              .credit(salesId, 1)),
          throwsA(isA<BranchNotFoundException>()));
      await sale(ryd, 10);
    });

    test('الفرع بالرمز في JournalEntryBuilder', () async {
      await init(const BranchConfig());
      final e = await fa.record(JournalEntryBuilder(description: 'x', date: d)
          .branch('JED')
          .debit(cashId, 5)
          .credit(salesId, 5));
      expect(e.branchId, jed.id);
      await expectLater(
          () => JournalEntryBuilder(description: 'x')
              .branch('JED')
              .debit(cashId, 1)
              .credit(salesId, 1)
              .build(),
          throwsStateError);
    });

    test('لا حذف لفرع عليه قيود، والعكس يحتفظ بالفرع', () async {
      await init(const BranchConfig());
      final e = await sale(ryd, 10);
      await expectLater(() => fa.branches.deleteBranch(ryd.id!),
          throwsA(isA<BranchHasEntriesException>()));
      await fa.branches.setBranchActive(ryd.id!, isActive: false);
      final rev = await fa.journalEntries.reverseEntry(e.id!, reversalDate: d);
      expect(rev.branchId, ryd.id);
      await fa.branches.deleteBranch(jed.id!);
      expect(await fa.branches.getBranchById(jed.id!), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('التقارير حسب الفرع', () {
    setUp(() async {
      await init(const BranchConfig());
      await sale(ryd, 1000);
      await rent(ryd, 300);
      await sale(jed, 600);
      await sale(null, 50);
    });

    test('ميزان المراجعة والميزانية وقائمة الدخل لكل فرع متوازنة', () async {
      final tb = await fa.reports
          .getTrialBalance(from: yearStart, to: yearEnd, branchIds: [ryd.id!]);
      expect(tb.isBalanced, isTrue);
      expect(
          tb.rows.firstWhere((r) => r.accountId == cashId).debitBalance, 700);

      final bs =
          await fa.reports.getBalanceSheet(asOf: yearEnd, branchIds: [jed.id!]);
      expect(bs.isBalanced, isTrue);
      expect(bs.totalAssets, 600);

      final income = await fa.reports.getIncomeStatement(
          from: yearStart, to: yearEnd, branchIds: [ryd.id!, jed.id!]);
      expect(income.totalRevenue, 1600);
      expect(income.netIncome, 1300);

      final all =
          await fa.reports.getIncomeStatement(from: yearStart, to: yearEnd);
      expect(all.totalRevenue, 1650);
    });

    test('رصيد وكشف حساب لفرع', () async {
      expect(await fa.reports.getAccountBalance(cashId, branchIds: [ryd.id!]),
          700);
      final ledger = await fa.reports
          .getAccountLedger(cashId, to: yearEnd, branchIds: [jed.id!]);
      expect(ledger.lines, hasLength(1));
      expect(ledger.closingBalance, 600);
    });

    test('مقارنة الفروع مع عمود بدون فرع', () async {
      final c =
          await fa.branchReports.getComparison(from: yearStart, to: yearEnd);
      expect(c.branches.map((b) => b.branch.code), ['HQ', 'JED', 'RYD', '']);
      final riyadh = c.branches.firstWhere((b) => b.branch.code == 'RYD');
      expect(riyadh.revenue, 1000);
      expect(riyadh.expenses, 300);
      expect(riyadh.totalAssets, 700);
      expect(riyadh.isBalanced, isTrue);
      expect(c.branches.last.branch.isUnassigned, isTrue);
      expect(c.branches.last.revenue, 50);
      expect(c.totalNetIncome, 1350);
      final salesRow = c.rows.firstWhere((r) => r.accountId == salesId);
      expect(salesRow.amountFor(jed.id), 600);
      expect(salesRow.amountFor(null), 50);

      final only = await fa.branchReports.getComparison(
          from: yearStart,
          to: yearEnd,
          branchIds: [ryd.id!],
          includeUnassigned: false);
      expect(only.branches, hasLength(1));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('الترقيم وتقييد الحسابات وإقفال الفترات', () {
    test('ترقيم مستقل لكل فرع', () async {
      await init(const BranchConfig(serialPerBranch: true));
      expect((await sale(ryd, 1)).serialNumber, 'JV-RYD-2024-0001');
      expect((await sale(ryd, 1)).serialNumber, 'JV-RYD-2024-0002');
      expect((await sale(jed, 1)).serialNumber, 'JV-JED-2024-0001');
      expect((await sale(null, 1)).serialNumber, 'JV-2024-0001');
    });

    test('تقييد حساب بفرع (ويسري على حساباته الفرعية)', () async {
      await init(const BranchConfig());
      final rydCash = await fa.accounts.createAccount(AccountModel.create(
          code: '1101',
          name: 'Riyadh cash',
          type: AccountType.asset,
          parentId: (await fa.accounts.getAccountByCode('11'))!.id));
      await fa.branches.restrictAccount(rydCash.id!, [ryd.id!]);
      expect(await fa.branches.getAccountBranchIds(rydCash.id!), [ryd.id]);

      Future<JournalEntryModel> use(BranchModel? b) {
        final e = JournalEntryBuilder(description: 'x', date: d)
            .debit(rydCash.id!, 1)
            .credit(salesId, 1);
        if (b != null) e.branch(b.id!);
        return fa.record(e);
      }

      await use(ryd);
      await expectLater(
          () => use(jed), throwsA(isA<AccountNotAllowedForBranchException>()));
      await expectLater(
          () => use(null), throwsA(isA<AccountNotAllowedForBranchException>()));

      // تقييد على الأب يسري على الأبناء
      await fa.branches.restrictAccount(rydCash.id!, []);
      await fa.branches.restrictAccount(
          (await fa.accounts.getAccountByCode('4'))!.id!, [jed.id!]);
      await expectLater(
          () => use(ryd), throwsA(isA<AccountNotAllowedForBranchException>()));
    });

    test('إقفال فترة لفرع واحد', () async {
      await init(const BranchConfig());
      final period = (await fa.periods.getAllPeriods()).single;
      final draft = await fa.record(
          JournalEntryBuilder(description: 'd', date: d)
              .branch(jed.id!)
              .debit(cashId, 1)
              .credit(salesId, 1),
          post: false);
      await expectLater(() => fa.branches.closePeriod(period.id!, jed.id!),
          throwsA(isA<PeriodHasDraftEntriesException>()));
      await fa.journalEntries.deleteEntry(draft.id!);

      await fa.branches.closePeriod(period.id!, jed.id!);
      expect(await fa.branches.isPeriodClosed(period.id!, jed.id!), isTrue);
      await expectLater(
          () => sale(jed, 10), throwsA(isA<PeriodClosedException>()));
      await sale(ryd, 10);

      await fa.branches.reopenPeriod(period.id!, jed.id!);
      await sale(jed, 10);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('المعاملات بين الفروع', () {
    late List<JournalEntryModel> entries;

    setUp(() async {
      await init(const BranchConfig());
      await sale(hq, 5000);
      // الرئيسي يدفع إيجار جدة 1000 من بنكه
      await fa.record(JournalEntryBuilder(description: 'fund bank', date: d)
          .branch(hq.id!)
          .debit(bankId, 2000)
          .credit(cashId, 2000));
      entries = await fa.branches.recordInterBranch(InterBranchTransaction(
        fromBranchId: hq.id!,
        toBranchId: jed.id!,
        date: d,
        description: 'إيجار فرع جدة',
        fromLines: [
          JournalEntryLineModel.creditLine(accountId: bankId, amount: 1000)
        ],
        toLines: [
          JournalEntryLineModel.debitLine(accountId: rentId, amount: 1000)
        ],
      ));
    });

    test('قيدان متوازنان مرتبطان على الحسابات الجارية', () async {
      expect(entries, hasLength(2));
      final (fromEntry, toEntry) = (entries[0], entries[1]);
      expect(fromEntry.branchId, hq.id);
      expect(toEntry.branchId, jed.id);
      expect(fromEntry.sourceId, toEntry.sourceId);
      expect(
          fromEntry.lines
              .firstWhere((l) => l.accountId == jed.interBranchAccountId)
              .debit,
          1000);
      expect(
          toEntry.lines
              .firstWhere((l) => l.accountId == hq.interBranchAccountId)
              .credit,
          1000);

      final jedIncome = await fa.reports.getIncomeStatement(
          from: yearStart, to: yearEnd, branchIds: [jed.id!]);
      expect(jedIncome.totalExpenses, 1000);
      final jedBs =
          await fa.reports.getBalanceSheet(asOf: yearEnd, branchIds: [jed.id!]);
      expect(jedBs.isBalanced, isTrue);
    });

    test('المطابقة والتقارير الموحّدة', () async {
      final rec = await fa.branchReports.getInterBranchReconciliation();
      expect(rec.pairs, hasLength(1));
      expect(rec.pairs.single.balanceInA, 1000); // الرئيسي يطلب جدة
      expect(rec.pairs.single.balanceInB, -1000); // جدة مدينة للرئيسي
      expect(rec.isReconciled, isTrue);

      final tb = await fa.branchReports
          .getConsolidatedTrialBalance(from: yearStart, to: yearEnd);
      expect(tb.isBalanced, isTrue);
      expect(tb.rows.any((r) => r.accountCode.startsWith('IB-')), isFalse);
      final bs =
          await fa.branchReports.getConsolidatedBalanceSheet(asOf: yearEnd);
      expect(bs.isBalanced, isTrue);
      expect(bs.totalAssets, 4000);
    });

    test('عكس المعاملة يعكس القيدين', () async {
      final reversals = await fa.reverseSource(
          SystemSources.interBranch, entries.first.sourceId!,
          reversalDate: d);
      expect(reversals, hasLength(2));
      final rec = await fa.branchReports.getInterBranchReconciliation();
      expect(rec.pairs, isEmpty);
    });

    test('معاملة غير متقابلة أو لنفس الفرع مرفوضة', () async {
      await expectLater(
          () => fa.branches.recordInterBranch(InterBranchTransaction(
                fromBranchId: hq.id!,
                toBranchId: jed.id!,
                description: 'x',
                fromLines: [
                  JournalEntryLineModel.creditLine(
                      accountId: bankId, amount: 100)
                ],
                toLines: [
                  JournalEntryLineModel.debitLine(accountId: rentId, amount: 90)
                ],
              )),
          throwsA(isA<InvalidBranchOperationException>()));
      await expectLater(
          () => fa.branches.recordInterBranch(InterBranchTransaction(
                fromBranchId: hq.id!,
                toBranchId: hq.id!,
                description: 'x',
                fromLines: const [],
                toLines: const [],
              )),
          throwsA(isA<InvalidBranchOperationException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  test('ربط الفرع بمركز تكلفة يوزع البنود عليه تلقائياً', () async {
    await init(const BranchConfig(), costCenters: true);
    await CostCenterSeedData.seed(fa.costCenters);
    final center = await fa.costCenters.ensureCostCenter(
        dimensionCode: CostCenterSeedData.branch,
        code: 'CC-RYD',
        name: 'Riyadh');
    await fa.branches.updateBranch(ryd.copyWith(costCenterId: center.id));

    final e = await sale(ryd, 100);
    expect(e.lines.every((l) => l.allocations.single.costCenterId == center.id),
        isTrue);
    final summary = await fa.costReports.getSummary(
        dimensionId: center.dimensionId, from: yearStart, to: yearEnd);
    expect(summary.rows.single.revenue, 100);
  });
}
