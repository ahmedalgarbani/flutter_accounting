import 'package:flutter_accounting/flutter_accounting.dart';

import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/accounting_setup.dart';
// ignore: avoid_relative_lib_imports
import '../lib/sales_accounting_service.dart';

void main() {
  late FlutterAccounting fa;
  late SalesAccountingService service;

  setUp(() async {
    fa = FlutterAccounting.forTesting();
    await AccountingSeedData.seed(fa.accounts);
    await fa.periods.ensureOpenPeriodFor(DateTime.now());
    service = SalesAccountingService(fa);
  });

  tearDown(() => fa.dispose());

  Future<double> balance(String code) async => fa.reports
      .getAccountBalance((await fa.accounts.getAccountByCode(code))!.id!);

  test('دورة فاتورة كاملة: بيع، تحصيل، إلغاء', () async {
    await service.onInvoiceCreated(
        invoiceId: 1,
        netAmount: 1000,
        vatAmount: 150,
        costAmount: 600,
        paidInCash: false);

    expect(await balance(AppAccounts.customers), 1150);
    expect(await balance(AppAccounts.vatPayable), 150);
    expect(await balance(AppAccounts.costOfGoodsSold), 600);

    await service.onPaymentReceived(paymentId: 1, invoiceId: 1, amount: 400);
    expect(await service.cashBalance(), 400);
    expect(await balance(AppAccounts.customers), 750);

    await service.onInvoiceCancelled(1);
    expect(await balance(AppAccounts.sales), 0);
    expect(await balance(AppAccounts.customers), -400); // دفعة مقدمة من العميل

    final bs = await fa.reports.getBalanceSheet(asOf: DateTime.now());
    expect(bs.isBalanced, isTrue);
    final tb = await fa.reports.getTrialBalance();
    expect(tb.isBalanced, isTrue);
  });

  group('مع مراكز التكلفة والفروع والعملات', () {
    late FlutterAccounting fc;
    late SalesAccountingService withAll;

    setUp(() async {
      fc = FlutterAccounting.forTesting(config: appConfig);
      await AccountingSeedData.seed(fc.accounts);
      await CostCenterSeedData.seed(fc.costCenters);
      await fc.periods.ensureOpenPeriodFor(DateTime.now());
      for (var i = 0; i < 2; i++) {
        // مرتين للتأكد من عدم التكرار
        await setupCostCenters(fc);
        await setupBranches(fc);
        await setupCurrencies(fc);
      }
      withAll = SalesAccountingService(fc);
    });

    tearDown(() => fc.dispose());

    test('ربحية الفروع: فاتورة لكل فرع وإيجار موزع حسب المساحة', () async {
      await withAll.onInvoiceCreated(
          invoiceId: 1,
          netAmount: 1000,
          costAmount: 600,
          branchCode: AppBranches.riyadh);
      await withAll.onInvoiceCreated(
          invoiceId: 2, netAmount: 500, branchCode: AppBranches.jeddah);
      await withAll.onExpensePaid(
          expenseCode: AppAccounts.rent,
          amount: 300,
          description: 'rent',
          allocationKey: AppCostCenters.byArea,
          allocations: [CostAllocationModel.code(AppCostCenters.adminDept)]);

      final branch =
          await fc.costCenters.getDimensionByCode(CostCenterSeedData.branch);
      final summary = await fc.costReports.getSummary(dimensionId: branch!.id!);
      double net(String code) =>
          summary.rows.firstWhere((r) => r.code == code).netIncome;
      expect(net(AppCostCenters.riyadh), 1000 - 600 - 180);
      expect(net(AppCostCenters.jeddah), 500 - 120);

      // القسم إلزامي للمصروفات
      await expectLater(
          () => withAll.onExpensePaid(
              expenseCode: AppAccounts.rent, amount: 10, description: 'x'),
          throwsA(isA<CostCenterRequiredException>()));
    });

    test('الفروع: ميزانية لكل فرع ومعاملة بين الفروع متطابقة', () async {
      await withAll.onInvoiceCreated(
          invoiceId: 1, netAmount: 1000, branchCode: AppBranches.riyadh);
      await withAll.onHeadOfficePaysForBranch(
          branchCode: AppBranches.jeddah,
          expenseCode: AppAccounts.rent,
          amount: 500,
          description: 'rent');

      final comparison = await fc.branchReports.getComparison();
      for (final b in comparison.branches) {
        expect(b.isBalanced, isTrue, reason: b.branch.code);
      }
      final jed = comparison.branches
          .firstWhere((b) => b.branch.code == AppBranches.jeddah);
      expect(jed.expenses, 500);
      expect(
          (await fc.branchReports.getInterBranchReconciliation()).isReconciled,
          isTrue);
      expect(
          (await fc.branchReports
                  .getConsolidatedBalanceSheet(asOf: DateTime.now()))
              .isBalanced,
          isTrue);
    });

    test('العملات: فاتورة بالدولار وتحصيل بسعر مختلف', () async {
      final invoice = await withAll.onForeignInvoice(
          invoiceId: 7, usdAmount: 100, branchCode: AppBranches.riyadh);
      expect(invoice.totalDebits, 375);
      final receipt =
          await withAll.onForeignPaymentReceived(usdAmount: 100, rate: 3.70);
      final loss = receipt.lines.firstWhere((l) => l.accountCode == '50');
      expect(loss.debit, 5);
      final customers =
          await fc.accounts.getAccountByCode(AppAccounts.usdCustomers);
      final balance =
          await fc.currencies.getAccountCurrencyBalance(customers!.id!);
      expect(balance.foreignBalance, 0);
      expect(balance.baseBalance, 0);
    });
  });
}
