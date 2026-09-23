import 'package:flutter_accounting/flutter_accounting.dart';
import 'package:flutter_accounting_example/accounting_setup.dart';
import 'package:flutter_accounting_example/sales_accounting_service.dart';
import 'package:flutter_test/flutter_test.dart';

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

  Future<double> balance(String code) async =>
      fa.reports.getAccountBalance((await fa.accounts.getAccountByCode(code))!.id!);

  test('دورة فاتورة كاملة: بيع، تحصيل، إلغاء', () async {
    await service.onInvoiceCreated(
      invoiceId: 1, netAmount: 1000, vatAmount: 150, costAmount: 600, paidInCash: false);

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
}
