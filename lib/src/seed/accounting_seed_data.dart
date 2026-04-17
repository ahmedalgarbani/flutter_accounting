/// seed_data.dart
/// بيانات أولية: دليل الحسابات الافتراضي (النظام العربي)
///
/// الاستخدام:
/// ```dart
/// await AccountingSeedData.seed(FlutterAccounting.instance.accounts);
/// ```

import '../models/account_model.dart';
import '../core/enums.dart';
import '../repositories/interfaces/interfaces.dart';

class AccountingSeedData {
  AccountingSeedData._();

  /// يُدرج دليل الحسابات الأساسي إذا كانت قاعدة البيانات فارغة.
  static Future<void> seed(IAccountRepository repo) async {
    final count = await repo.countAccounts();
    if (count > 0) return; // لا تُزرع إذا كانت هناك بيانات

    final now = DateTime.now();

    // ═══════════════════════════════════════════════════════════
    // 1 - الأصول (Assets)
    // ═══════════════════════════════════════════════════════════
    final assets = await repo.createAccount(AccountModel(
      code: '1', name: 'Assets', nameAr: 'الأصول',
      type: AccountType.asset, level: 1,
      createdAt: now, updatedAt: now,
    ));

    final currentAssets = await repo.createAccount(AccountModel(
      code: '11', name: 'Current Assets', nameAr: 'الأصول المتداولة',
      type: AccountType.asset, parentId: assets.id, level: 2,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('111', 'Cash', 'الصندوق / النقدية',
           AccountType.asset, currentAssets.id, 3, now),
      _acc('112', 'Bank', 'البنك',
           AccountType.asset, currentAssets.id, 3, now),
      _acc('113', 'Accounts Receivable', 'المدينون / العملاء',
           AccountType.asset, currentAssets.id, 3, now),
      _acc('114', 'Notes Receivable', 'أوراق القبض',
           AccountType.asset, currentAssets.id, 3, now),
      _acc('115', 'Inventory', 'المخزون / البضاعة',
           AccountType.asset, currentAssets.id, 3, now),
      _acc('116', 'Prepaid Expenses', 'المصاريف المدفوعة مقدماً',
           AccountType.asset, currentAssets.id, 3, now),
    ]);

    final fixedAssets = await repo.createAccount(AccountModel(
      code: '12', name: 'Fixed Assets', nameAr: 'الأصول الثابتة',
      type: AccountType.asset, parentId: assets.id, level: 2,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('121', 'Land', 'الأراضي',
           AccountType.asset, fixedAssets.id, 3, now),
      _acc('122', 'Buildings', 'المباني',
           AccountType.asset, fixedAssets.id, 3, now),
      _acc('123', 'Accumulated Depreciation - Buildings',
           'مجمع إهلاك المباني',
           AccountType.asset, fixedAssets.id, 3, now),
      _acc('124', 'Equipment', 'الأثاث والمعدات',
           AccountType.asset, fixedAssets.id, 3, now),
      _acc('125', 'Accumulated Depreciation - Equipment',
           'مجمع إهلاك الأثاث والمعدات',
           AccountType.asset, fixedAssets.id, 3, now),
      _acc('126', 'Vehicles', 'السيارات',
           AccountType.asset, fixedAssets.id, 3, now),
    ]);

    // ═══════════════════════════════════════════════════════════
    // 2 - الخصوم (Liabilities)
    // ═══════════════════════════════════════════════════════════
    final liabilities = await repo.createAccount(AccountModel(
      code: '2', name: 'Liabilities', nameAr: 'الخصوم',
      type: AccountType.liability, level: 1,
      createdAt: now, updatedAt: now,
    ));

    final currentLiabilities = await repo.createAccount(AccountModel(
      code: '21', name: 'Current Liabilities', nameAr: 'الخصوم المتداولة',
      type: AccountType.liability, parentId: liabilities.id, level: 2,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('211', 'Accounts Payable', 'الدائنون / الموردون',
           AccountType.liability, currentLiabilities.id, 3, now),
      _acc('212', 'Notes Payable', 'أوراق الدفع',
           AccountType.liability, currentLiabilities.id, 3, now),
      _acc('213', 'Accrued Expenses', 'المصاريف المستحقة',
           AccountType.liability, currentLiabilities.id, 3, now),
      _acc('214', 'Deferred Revenue', 'الإيرادات المقدمة',
           AccountType.liability, currentLiabilities.id, 3, now),
      _acc('215', 'Tax Payable', 'الضرائب المستحقة',
           AccountType.liability, currentLiabilities.id, 3, now),
    ]);

    final longTermLiabilities = await repo.createAccount(AccountModel(
      code: '22', name: 'Long-term Liabilities', nameAr: 'الخصوم طويلة الأجل',
      type: AccountType.liability, parentId: liabilities.id, level: 2,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('221', 'Long-term Loans', 'قروض طويلة الأجل',
           AccountType.liability, longTermLiabilities.id, 3, now),
    ]);

    // ═══════════════════════════════════════════════════════════
    // 3 - حقوق الملكية (Equity)
    // ═══════════════════════════════════════════════════════════
    final equity = await repo.createAccount(AccountModel(
      code: '3', name: 'Equity', nameAr: 'حقوق الملكية',
      type: AccountType.equity, level: 1,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('31', 'Owner Capital', 'رأس المال',
           AccountType.equity, equity.id, 2, now),
      _acc('32', 'Retained Earnings', 'الأرباح المدورة',
           AccountType.equity, equity.id, 2, now),
      _acc('33', "Owner's Drawings", 'المسحوبات الشخصية',
           AccountType.equity, equity.id, 2, now),
    ]);

    // ═══════════════════════════════════════════════════════════
    // 4 - الإيرادات (Revenue)
    // ═══════════════════════════════════════════════════════════
    final revenue = await repo.createAccount(AccountModel(
      code: '4', name: 'Revenue', nameAr: 'الإيرادات',
      type: AccountType.revenue, level: 1,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('41', 'Sales Revenue', 'إيرادات المبيعات',
           AccountType.revenue, revenue.id, 2, now),
      _acc('42', 'Service Revenue', 'إيرادات الخدمات',
           AccountType.revenue, revenue.id, 2, now),
      _acc('43', 'Other Revenue', 'إيرادات أخرى',
           AccountType.revenue, revenue.id, 2, now),
      _acc('44', 'Interest Income', 'إيرادات الفوائد',
           AccountType.revenue, revenue.id, 2, now),
    ]);

    // ═══════════════════════════════════════════════════════════
    // 5 - المصاريف (Expenses)
    // ═══════════════════════════════════════════════════════════
    final expenses = await repo.createAccount(AccountModel(
      code: '5', name: 'Expenses', nameAr: 'المصاريف',
      type: AccountType.expense, level: 1,
      createdAt: now, updatedAt: now,
    ));

    await _createAccounts(repo, [
      _acc('51', 'Cost of Goods Sold', 'تكلفة البضاعة المباعة',
           AccountType.expense, expenses.id, 2, now),
      _acc('52', 'Salaries Expense', 'مصاريف الرواتب',
           AccountType.expense, expenses.id, 2, now),
      _acc('53', 'Rent Expense', 'مصاريف الإيجار',
           AccountType.expense, expenses.id, 2, now),
      _acc('54', 'Utilities Expense', 'مصاريف المرافق (كهرباء، ماء)',
           AccountType.expense, expenses.id, 2, now),
      _acc('55', 'Depreciation Expense', 'مصاريف الإهلاك',
           AccountType.expense, expenses.id, 2, now),
      _acc('56', 'Interest Expense', 'مصاريف الفوائد',
           AccountType.expense, expenses.id, 2, now),
      _acc('57', 'Advertising Expense', 'مصاريف الإعلان والتسويق',
           AccountType.expense, expenses.id, 2, now),
      _acc('58', 'Insurance Expense', 'مصاريف التأمين',
           AccountType.expense, expenses.id, 2, now),
      _acc('59', 'Miscellaneous Expense', 'مصاريف متنوعة',
           AccountType.expense, expenses.id, 2, now),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات خاصة
  // ─────────────────────────────────────────────────────────────

  static Future<void> _createAccounts(
    IAccountRepository repo,
    List<AccountModel> accounts,
  ) async {
    for (final account in accounts) {
      await repo.createAccount(account);
    }
  }

  static AccountModel _acc(
    String code,
    String name,
    String nameAr,
    AccountType type,
    int? parentId,
    int level,
    DateTime now,
  ) =>
      AccountModel(
        code:      code,
        name:      name,
        nameAr:    nameAr,
        type:      type,
        parentId:  parentId,
        level:     level,
        createdAt: now,
        updatedAt: now,
      );
}
