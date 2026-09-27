/// sales_accounting_service.dart
/// طبقة التكامل: تحوّل أحداث نظامك (فاتورة، دفعة، إلغاء...) إلى قيود محاسبية.
///
/// الفكرة: شاشات تطبيقك وقواعد عمله لا تعرف شيئاً عن المدين والدائن.
/// تستدعي هذه الخدمة فقط، والخدمة تستدعي المكتبة.
library;

import 'package:flutter_accounting/flutter_accounting.dart';

import 'accounting_setup.dart';

class SalesAccountingService {
  SalesAccountingService(this._fa);

  final FlutterAccounting _fa;

  static const _invoice = 'invoice';

  /// فاتورة بيع (نقدية أو آجلة) مع ضريبة وتكلفة بضاعة اختيارية.
  ///
  /// [branchCode] (اختياري) رمز الفرع: القيد يُسجل في دفاتره، ويُنسب تلقائياً
  /// لمركز تكلفة الفرع. يتطلب تفعيل الفروع.
  Future<JournalEntryModel> onInvoiceCreated({
    required int invoiceId,
    required double netAmount,
    double vatAmount = 0,
    double costAmount = 0,
    bool paidInCash = true,
    String? branchCode,
    String? user,
  }) {
    final total = netAmount + vatAmount;
    final entry = JournalEntryBuilder(
            description: 'فاتورة مبيعات رقم $invoiceId')
        .reference('INV-$invoiceId')
        .type(paidInCash ? EntryType.sale : EntryType.saleAgil)
        .source(_invoice, invoiceId)
        .createdBy(user)
        .debitCode(paidInCash ? AppAccounts.cash : AppAccounts.customers, total)
        .creditCode(AppAccounts.sales, netAmount);
    if (branchCode != null) entry.branch(branchCode);

    if (vatAmount > 0) entry.creditCode(AppAccounts.vatPayable, vatAmount);

    // إثبات تكلفة البضاعة المباعة في نفس القيد
    if (costAmount > 0) {
      entry.debitCode(AppAccounts.costOfGoodsSold, costAmount, allocations: [
        if (branchCode != null)
          CostAllocationModel.code(AppCostCenters.salesDept),
      ]).creditCode(AppAccounts.inventory, costAmount);
    }

    return _fa.record(entry, postedBy: user);
  }

  /// تحصيل دفعة من عميل آجل (سند قبض)
  Future<JournalEntryModel> onPaymentReceived({
    required int paymentId,
    required int invoiceId,
    required double amount,
    String? user,
  }) {
    return _fa.record(
      JournalEntryBuilder(description: 'تحصيل دفعة للفاتورة $invoiceId')
          .reference('RCV-$paymentId')
          .type(EntryType.receiptVoucher)
          .source('payment', paymentId)
          .debitCode(AppAccounts.cash, amount)
          .creditCode(AppAccounts.customers, amount),
      postedBy: user,
    );
  }

  /// مصروف مدفوع نقداً (سند صرف)
  ///
  /// [allocations] / [allocationKey] (اختياري) لتوزيعه على مراكز التكلفة،
  /// مثل: `allocationKey: AppCostCenters.byArea` لتقسيمه على الفروع.
  Future<JournalEntryModel> onExpensePaid({
    required String expenseCode,
    required double amount,
    required String description,
    List<CostAllocationModel> allocations = const [],
    String? allocationKey,
    String? user,
  }) {
    return _fa.record(
      JournalEntryBuilder(description: description)
          .type(EntryType.paymentVoucher)
          .debitCode(expenseCode, amount,
              allocations: allocations, allocationKey: allocationKey)
          .creditCode(AppAccounts.cash, amount),
      postedBy: user,
    );
  }

  /// فاتورة بالدولار لعميل خارجي (تُحوَّل للريال بسعر اليوم وتحفظ بالدولار)
  Future<JournalEntryModel> onForeignInvoice({
    required int invoiceId,
    required double usdAmount,
    String? branchCode,
  }) {
    final entry = JournalEntryBuilder(description: 'فاتورة تصدير $invoiceId')
        .reference('EXP-$invoiceId')
        .type(EntryType.saleAgil)
        .source(_invoice, invoiceId)
        .currency('USD')
        .debitCode(AppAccounts.usdCustomers, usdAmount)
        .creditCode(AppAccounts.sales, usdAmount);
    if (branchCode != null) entry.branch(branchCode);
    return _fa.record(entry);
  }

  /// تحصيل من العميل الخارجي إلى البنك بسعر [rate]: فرق السعر عن سعر
  /// الفاتورة يُسجل تلقائياً ربحاً أو خسارة فروقات عملة.
  Future<JournalEntryModel> onForeignPaymentReceived({
    required double usdAmount,
    required double rate,
  }) async {
    final customers =
        await _fa.accounts.getAccountByCode(AppAccounts.usdCustomers);
    final bank = await _fa.accounts.getAccountByCode(AppAccounts.bank);
    return _fa.exchangeDifferences.settle(SettlementRequest(
      accountId: customers!.id!,
      amount: usdAmount,
      rate: rate,
      counterAccountId: bank!.id!,
      date: DateTime.now(),
    ));
  }

  /// المركز الرئيسي يدفع مصروفاً عن فرع (معاملة بين الفروع: قيد في كل فرع)
  Future<List<JournalEntryModel>> onHeadOfficePaysForBranch({
    required String branchCode,
    required String expenseCode,
    required double amount,
    required String description,
  }) async {
    final hq = await _fa.branches.getBranchByCode(AppBranches.headOffice);
    final branch = await _fa.branches.getBranchByCode(branchCode);
    final cash = await _fa.accounts.getAccountByCode(AppAccounts.cash);
    final expense = await _fa.accounts.getAccountByCode(expenseCode);
    return _fa.branches.recordInterBranch(InterBranchTransaction(
      fromBranchId: hq!.id!,
      toBranchId: branch!.id!,
      description: description,
      fromLines: [
        JournalEntryLineModel.creditLine(accountId: cash!.id!, amount: amount),
      ],
      toLines: [
        JournalEntryLineModel.debitLine(
          accountId: expense!.id!,
          amount: amount,
          allocations: [CostAllocationModel.code(AppCostCenters.adminDept)],
        ),
      ],
    ));
  }

  /// إلغاء فاتورة: يعكس كل قيودها المرحّلة (آمن للاستدعاء أكثر من مرة)
  Future<List<JournalEntryModel>> onInvoiceCancelled(int invoiceId,
          {String? user}) =>
      _fa.reverseSource(_invoice, invoiceId, postedBy: user);

  /// رصيد الصندوق الحالي
  Future<double> cashBalance() async {
    final cash = await _fa.accounts.getAccountByCode(AppAccounts.cash);
    return _fa.reports.getAccountBalance(cash!.id!);
  }
}
