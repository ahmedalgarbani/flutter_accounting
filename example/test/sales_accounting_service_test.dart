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

  group('مع مراكز التكلفة', () {
    late FlutterAccounting fc;
    late SalesAccountingService withCenters;

    setUp(() async {
      fc = FlutterAccounting.forTesting(
          config: const AccountingConfig(enableCostCenters: true));
      await AccountingSeedData.seed(fc.accounts);
      await CostCenterSeedData.seed(fc.costCenters);
      await fc.periods.ensureOpenPeriodFor(DateTime.now());
      await setupCostCenters(fc);
      await setupCostCenters(fc); // لا يتكرر شيء
      withCenters = SalesAccountingService(fc);
    });

    tearDown(() => fc.dispose());

    test('ربحية الفروع: فاتورة لكل فرع وإيجار موزع حسب المساحة', () async {
      await withCenters.onInvoiceCreated(
          invoiceId: 1,
          netAmount: 1000,
          costAmount: 600,
          branchCode: AppCostCenters.riyadh);
      await withCenters.onInvoiceCreated(
          invoiceId: 2, netAmount: 500, branchCode: AppCostCenters.jeddah);
      await withCenters.onExpensePaid(
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
      expect(
          () => withCenters.onExpensePaid(
              expenseCode: AppAccounts.rent, amount: 10, description: 'x'),
          throwsA(isA<CostCenterRequiredException>()));
    });
  });
}
