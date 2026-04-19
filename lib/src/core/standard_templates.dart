/// standard_templates.dart
/// القوالب القياسية للعمليات المحاسبية الشائعة

import '../models/entry_template_model.dart';
import '../core/enums.dart';

class StandardTemplates {
  StandardTemplates._();

  /// قالب المبيعات النقدية
  static const EntryTemplateModel cashSale = EntryTemplateModel(
    name: 'Cash Sale',
    type: EntryType.sale,
    lines: [
      EntryTemplateLineModel(
        accountType: AccountType.asset,
        isDebit: true,
        label: 'Cash/Bank Account',
      ),
      EntryTemplateLineModel(
        accountType: AccountType.revenue,
        isDebit: false,
        label: 'Sales Revenue Account',
      ),
    ],
  );

  /// قالب المشتريات النقدية
  static const EntryTemplateModel cashPurchase = EntryTemplateModel(
    name: 'Cash Purchase',
    type: EntryType.purchase,
    lines: [
      EntryTemplateLineModel(
        accountType: AccountType.expense,
        isDebit: true,
        label: 'Purchases/Expense Account',
      ),
      EntryTemplateLineModel(
        accountType: AccountType.asset,
        isDebit: false,
        label: 'Cash/Bank Account',
      ),
    ],
  );

  /// قالب المبيعات الآجلة
  static const EntryTemplateModel creditSale = EntryTemplateModel(
    name: 'Credit Sale',
    type: EntryType.saleAgil,
    lines: [
      EntryTemplateLineModel(
        accountType: AccountType.asset,
        isDebit: true,
        label: 'Customer Account',
      ),
      EntryTemplateLineModel(
        accountType: AccountType.revenue,
        isDebit: false,
        label: 'Sales Revenue Account',
      ),
    ],
  );

  /// قالب المشتريات الآجلة
  static const EntryTemplateModel creditPurchase = EntryTemplateModel(
    name: 'Credit Purchase',
    type: EntryType.purchaseAgil,
    lines: [
      EntryTemplateLineModel(
        accountType: AccountType.expense,
        isDebit: true,
        label: 'Purchases/Expense Account',
      ),
      EntryTemplateLineModel(
        accountType: AccountType.liability,
        isDebit: false,
        label: 'Vendor Account',
      ),
    ],
  );

  /// قالب سند صرف
  static const EntryTemplateModel paymentVoucher = EntryTemplateModel(
    name: 'Payment Voucher',
    type: EntryType.paymentVoucher,
    lines: [
      EntryTemplateLineModel(
        isDebit: true,
        label: 'Target Account (Expense/Liability)',
      ),
      EntryTemplateLineModel(
        accountType: AccountType.asset,
        isDebit: false,
        label: 'Cash/Bank Account',
      ),
    ],
  );

  /// قالب سند قبض
  static const EntryTemplateModel receiptVoucher = EntryTemplateModel(
    name: 'Receipt Voucher',
    type: EntryType.receiptVoucher,
    lines: [
      EntryTemplateLineModel(
        accountType: AccountType.asset,
        isDebit: true,
        label: 'Cash/Bank Account',
      ),
      EntryTemplateLineModel(
        isDebit: false,
        label: 'Source Account (Revenue/Asset)',
      ),
    ],
  );

  /// قائمة بجميع القوالب القياسية
  static List<EntryTemplateModel> get all => [
    cashSale,
    cashPurchase,
    creditSale,
    creditPurchase,
    paymentVoucher,
    receiptVoucher,
    journalEntry,
  ];

  /// قالب قيد عام (القيد الشهير)
  static const EntryTemplateModel journalEntry = EntryTemplateModel(
    name: 'General Journal Entry',
    type: EntryType.journalEntry,
    lines: [
      EntryTemplateLineModel(
        isDebit: true,
        label: 'Debit Account',
      ),
      EntryTemplateLineModel(
        isDebit: false,
        label: 'Credit Account',
      ),
    ],
  );

  /// جلب قالب بواسطة النوع
  static EntryTemplateModel? getByType(EntryType type) {
    try {
      return all.firstWhere((e) => e.type == type);
    } catch (_) {
      return null;
    }
  }
}
