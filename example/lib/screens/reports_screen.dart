import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

/// التقارير الثلاثة: ميزان المراجعة، قائمة الدخل، الميزانية العمومية.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, required this.fa});

  final FlutterAccounting fa;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<(TrialBalanceReport, IncomeStatementReport, BalanceSheetReport)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(TrialBalanceReport, IncomeStatementReport, BalanceSheetReport)> _load() async {
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    return (
      await widget.fa.reports.getTrialBalance(from: yearStart, to: now),
      await widget.fa.reports.getIncomeStatement(from: yearStart, to: now),
      await widget.fa.reports.getBalanceSheet(asOf: now),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _future = _load()),
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final (tb, income, bs) = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('ميزان المراجعة', [
                for (final r in tb.rows)
                  _row('${r.accountCode} ${r.displayName}',
                      r.isDebitBalance ? 'مدين ${_f(r.debitBalance)}' : 'دائن ${_f(r.creditBalance)}'),
                _row('الإجمالي', '${_f(tb.totalDebitBalances)} / ${_f(tb.totalCreditBalances)}', bold: true),
                _row('متوازن؟', tb.isBalanced ? '✅' : '❌'),
              ]),
              _section('قائمة الدخل', [
                _row('الإيرادات', _f(income.totalRevenue)),
                _row('المصروفات', _f(income.totalExpenses)),
                _row(income.isProfitable ? 'صافي الربح' : 'صافي الخسارة', _f(income.netIncome), bold: true),
              ]),
              _section('الميزانية العمومية', [
                _row('الأصول', _f(bs.totalAssets)),
                _row('الخصوم', _f(bs.totalLiabilities)),
                _row('حقوق الملكية (شاملة الأرباح)', _f(bs.totalEquity)),
                _row('أصول = خصوم + حقوق ملكية؟', bs.isBalanced ? '✅' : '❌', bold: true),
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
