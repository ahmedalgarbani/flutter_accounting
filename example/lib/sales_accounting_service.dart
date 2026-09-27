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
  /// [branchCode] (اختياري) رمز مركز تكلفة الفرع: يُنسب إليه الإيراد والتكلفة
  /// لتظهر ربحية كل فرع. يتطلب تفعيل مراكز التكلفة.
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
    final branch = [
      if (branchCode != null) CostAllocationModel.code(branchCode),
    ];
    final entry = JournalEntryBuilder(
            description: 'فاتورة مبيعات رقم $invoiceId')
        .reference('INV-$invoiceId')
        .type(paidInCash ? EntryType.sale : EntryType.saleAgil)
        .source(_invoice, invoiceId)
        .createdBy(user)
        .debitCode(paidInCash ? AppAccounts.cash : AppAccounts.customers, total)
        .creditCode(AppAccounts.sales, netAmount, allocations: branch);

    if (vatAmount > 0) entry.creditCode(AppAccounts.vatPayable, vatAmount);

    // إثبات تكلفة البضاعة المباعة في نفس القيد
    if (costAmount > 0) {
      entry.debitCode(AppAccounts.costOfGoodsSold, costAmount, allocations: [
        ...branch,
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
