/// reports_models.dart
/// نماذج بيانات التقارير المالية

import 'package:meta/meta.dart';
import '../core/enums.dart';

// ─────────────────────────────────────────────────────────────
// ميزان المراجعة - Trial Balance
// ─────────────────────────────────────────────────────────────

@immutable
class TrialBalanceRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final AccountType accountType;
  final double totalDebits;
  final double totalCredits;
  final double balance; // موجب = مدين، سالب = دائن

  const TrialBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.accountType,
    required this.totalDebits,
    required this.totalCredits,
    required this.balance,
  });

  bool get isDebitBalance  => balance > 0;
  bool get isCreditBalance => balance < 0;
  double get debitBalance  => balance > 0 ? balance  : 0;
  double get creditBalance => balance < 0 ? -balance : 0;
}

@immutable
class TrialBalanceReport {
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<TrialBalanceRow> rows;

  const TrialBalanceReport({
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.rows,
  });

  double get totalDebitBalances  => rows.fold(0, (s, r) => s + r.debitBalance);
  double get totalCreditBalances => rows.fold(0, (s, r) => s + r.creditBalance);
  bool   get isBalanced => (totalDebitBalances - totalCreditBalances).abs() < 0.001;

  List<TrialBalanceRow> get assetRows     => _byType(AccountType.asset);
  List<TrialBalanceRow> get liabilityRows => _byType(AccountType.liability);
  List<TrialBalanceRow> get equityRows    => _byType(AccountType.equity);
  List<TrialBalanceRow> get revenueRows   => _byType(AccountType.revenue);
  List<TrialBalanceRow> get expenseRows   => _byType(AccountType.expense);

  List<TrialBalanceRow> _byType(AccountType t) =>
      rows.where((r) => r.accountType == t).toList();
}

// ─────────────────────────────────────────────────────────────
// الميزانية العمومية - Balance Sheet
// ─────────────────────────────────────────────────────────────

@immutable
class BalanceSheetRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final AccountType type;
  final double balance;

  const BalanceSheetRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.type,
    required this.balance,
  });
}

@immutable
class BalanceSheetReport {
  final DateTime asOf;
  final DateTime generatedAt;
  final List<BalanceSheetRow> assetRows;
  final List<BalanceSheetRow> liabilityRows;
  final List<BalanceSheetRow> equityRows;
  final double retainedEarnings; // صافي الأرباح المدورة

  const BalanceSheetReport({
    required this.asOf,
    required this.generatedAt,
    required this.assetRows,
    required this.liabilityRows,
    required this.equityRows,
    required this.retainedEarnings,
  });

  double get totalAssets      => assetRows.fold(0, (s, r) => s + r.balance);
  double get totalLiabilities => liabilityRows.fold(0, (s, r) => s + r.balance);
  double get totalEquity      => equityRows.fold(0, (s, r) => s + r.balance) + retainedEarnings;

  /// أصول = خصوم + حقوق ملكية (مبدأ المعادلة المحاسبية)
  bool get isBalanced => (totalAssets - (totalLiabilities + totalEquity)).abs() < 0.01;
}

// ─────────────────────────────────────────────────────────────
// قائمة الأرباح والخسائر - Income Statement
// ─────────────────────────────────────────────────────────────

@immutable
class IncomeStatementRow {
  final int accountId;
  final String accountCode;
  final String accountName;
  final AccountType type;
  final double balance;

  const IncomeStatementRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.type,
    required this.balance,
  });
}

@immutable
class IncomeStatementReport {
  final DateTime from;
  final DateTime to;
  final DateTime generatedAt;
  final List<IncomeStatementRow> revenueRows;
  final List<IncomeStatementRow> expenseRows;

  const IncomeStatementReport({
    required this.from,
    required this.to,
    required this.generatedAt,
    required this.revenueRows,
    required this.expenseRows,
  });

  double get totalRevenue  => revenueRows.fold(0, (s, r) => s + r.balance);
  double get totalExpenses => expenseRows.fold(0, (s, r) => s + r.balance);

  /// صافي الربح (أو الخسارة إذا كانت سالبة)
  double get netIncome     => totalRevenue - totalExpenses;
  bool   get isProfitable  => netIncome >= 0;
}
