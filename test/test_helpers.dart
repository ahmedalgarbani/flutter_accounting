/// test_helpers.dart
/// أدوات مساعدة مشتركة للاختبارات
library;

import 'package:flutter_accounting/flutter_accounting.dart';

/// نسخة اختبار مع سنة مالية مفتوحة تغطي [year] (الافتراضي: السنة الحالية)
Future<FlutterAccounting> createTestAccounting({
  int? year,
  AccountingConfig config = const AccountingConfig(),
}) async {
  final fa = FlutterAccounting.forTesting(config: config);
  await fa.periods.createFiscalYear(year ?? DateTime.now().year);
  return fa;
}

AccountModel cashAccount() => AccountModel.create(
      code: '111', name: 'Cash', nameAr: 'الصندوق', type: AccountType.asset);

AccountModel revenueAccount() => AccountModel.create(
      code: '41', name: 'Sales Revenue', nameAr: 'إيرادات المبيعات', type: AccountType.revenue);

AccountModel expenseAccount() => AccountModel.create(
      code: '53', name: 'Rent Expense', nameAr: 'مصاريف الإيجار', type: AccountType.expense);

JournalEntryModel saleEntry(int cashId, int revenueId, {double amount = 5000, DateTime? date}) =>
    JournalEntryModel(
      date:        date ?? DateTime.now(),
      description: 'قيد مبيعات نقدية',
      reference:   'INV-001',
      lines: [
        JournalEntryLineModel.debitLine(accountId: cashId, amount: amount, description: 'استلام نقدي'),
        JournalEntryLineModel.creditLine(accountId: revenueId, amount: amount, description: 'إيراد مبيعات'),
      ],
    );
