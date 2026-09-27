import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

/// التقارير المالية + مقارنة الفروع + أرصدة العملات الأجنبية.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, required this.fa});

  final FlutterAccounting fa;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<
      (
        TrialBalanceReport,
        IncomeStatementReport,
        BalanceSheetReport,
        BranchComparisonReport?,
        ForeignCurrencyBalancesReport?,
      )> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<
      (
        TrialBalanceReport,
        IncomeStatementReport,
        BalanceSheetReport,
        BranchComparisonReport?,
        ForeignCurrencyBalancesReport?,
      )> _load() async {
    final fa = widget.fa;
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    return (
      await fa.reports.getTrialBalance(from: yearStart, to: now),
      await fa.reports.getIncomeStatement(from: yearStart, to: now),
      await fa.reports.getBalanceSheet(asOf: now),
      // الميزات الاختيارية تظهر فقط إن كانت مفعّلة
      fa.config.isBranchesEnabled
          ? await fa.branchReports.getComparison(from: yearStart, to: now)
          : null,
      fa.config.isMultiCurrency
          ? await fa.exchangeDifferences.getForeignCurrencyBalances(asOf: now)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _future = _load()),
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (tb, income, bs, branches, fx) = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('ميزان المراجعة', [
                for (final r in tb.rows)
                  _row(
                      '${r.accountCode} ${r.displayName}',
                      r.isDebitBalance
                          ? 'مدين ${_f(r.debitBalance)}'
                          : 'دائن ${_f(r.creditBalance)}'),
                _row('الإجمالي',
                    '${_f(tb.totalDebitBalances)} / ${_f(tb.totalCreditBalances)}',
                    bold: true),
                _row('متوازن؟', tb.isBalanced ? '✅' : '❌'),
              ]),
              _section('قائمة الدخل', [
                _row('الإيرادات', _f(income.totalRevenue)),
                _row('المصروفات', _f(income.totalExpenses)),
                _row(income.isProfitable ? 'صافي الربح' : 'صافي الخسارة',
                    _f(income.netIncome),
                    bold: true),
              ]),
              _section('الميزانية العمومية', [
                _row('الأصول', _f(bs.totalAssets)),
                _row('الخصوم', _f(bs.totalLiabilities)),
                _row('حقوق الملكية (شاملة الأرباح)', _f(bs.totalEquity)),
                _row('أصول = خصوم + حقوق ملكية؟', bs.isBalanced ? '✅' : '❌',
                    bold: true),
              ]),
              if (branches != null)
                _section('الفروع', [
                  for (final b in branches.branches) ...[
                    _row(b.branch.displayName, 'صافي الربح ${_f(b.netIncome)}',
                        bold: true),
                    _row(
                        '  إيرادات ${_f(b.revenue)} • مصروفات ${_f(b.expenses)}',
                        ''),
                    _row('  الأصول ${_f(b.totalAssets)} • ميزانية متوازنة؟',
                        b.isBalanced ? '✅' : '❌'),
                  ],
                ]),
              if (fx != null && fx.rows.isNotEmpty)
                _section('أرصدة العملات الأجنبية (${fx.baseCurrency})', [
                  for (final r in fx.rows)
                    _row(
                        '${r.accountCode} ${r.accountName}: '
                            '${_f(r.foreignBalance)} ${r.currencyCode}',
                        'فرق ${_f(r.difference)}'),
                  _row('صافي فرق إعادة التقييم', _f(fx.totalDifference),
                      bold: true),
                ]),
            ],
          );
        },
      ),
    );
  }

  static String _f(double v) => v.toStringAsFixed(2);

  Widget _section(String title, List<Widget> children) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ]),
        ),
      );

  Widget _row(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ]),
    );
  }
}
