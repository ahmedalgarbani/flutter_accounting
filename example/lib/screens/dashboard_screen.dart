import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import '../accounting_setup.dart';
import '../sales_accounting_service.dart';

/// شاشة "العمليات": تحاكي أحداث نظام مبيعات وتعرض أثرها المحاسبي.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.service});

  final SalesAccountingService service;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _cash = 0;
  int? _lastInvoiceId;
  String _branch = AppCostCenters.riyadh;

  SalesAccountingService get _service => widget.service;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final cash = await _service.cashBalance();
    if (mounted) setState(() => _cash = cash);
  }

  int _newInvoiceId() => DateTime.now().millisecondsSinceEpoch % 1000000;

  /// كل استدعاء للمكتبة يمر من هنا: أي خطأ محاسبي يُعرض برسالته العربية الجاهزة
  Future<void> _run(
      String successMessage, Future<void> Function() action) async {
    try {
      await action();
      await _refresh();
      _toast(successMessage);
    } on AccountingException catch (e) {
      _toast(e.message, error: true);
    }
  }

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Text('رصيد الصندوق', style: TextStyle(fontSize: 18)),
              Text(_cash.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        // الفرع الذي تُنسب إليه الفواتير (مركز تكلفة)
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
                value: AppCostCenters.riyadh,
                icon: Icon(Icons.store),
                label: Text('فرع الرياض')),
            ButtonSegment(
                value: AppCostCenters.jeddah,
                icon: Icon(Icons.store),
                label: Text('فرع جدة')),
          ],
          selected: {_branch},
          onSelectionChanged: (s) => setState(() => _branch = s.first),
        ),
        const SizedBox(height: 16),
        _action(
            Icons.shopping_cart, 'فاتورة نقدية 1000 + ضريبة 150 (تكلفة 600)',
            () {
          final id = _newInvoiceId();
          return _run('تم ترحيل الفاتورة $id', () async {
            await _service.onInvoiceCreated(
                invoiceId: id,
                netAmount: 1000,
                vatAmount: 150,
                costAmount: 600,
                branchCode: _branch,
                user: 'demo');
            _lastInvoiceId = id;
          });
        }),
        _action(Icons.person, 'فاتورة آجلة 500 لعميل', () {
          final id = _newInvoiceId();
          return _run('تم ترحيل الفاتورة الآجلة $id', () async {
            await _service.onInvoiceCreated(
                invoiceId: id,
                netAmount: 500,
                paidInCash: false,
                branchCode: _branch);
            _lastInvoiceId = id;
          });
        }),
        _action(Icons.payments, 'تحصيل 200 من العميل', () {
          return _run('تم تسجيل سند القبض', () async {
            await _service.onPaymentReceived(
                paymentId: _newInvoiceId(),
                invoiceId: _lastInvoiceId ?? 0,
                amount: 200);
          });
        }),
        _action(
            Icons.home_work, 'دفع إيجار 300 (يوزَّع على الفروع حسب المساحة)',
            () {
          return _run('تم تسجيل سند الصرف', () async {
            await _service.onExpensePaid(
                expenseCode: AppAccounts.rent,
                amount: 300,
                description: 'إيجار المحلات',
                allocationKey: AppCostCenters.byArea,
                allocations: [
                  CostAllocationModel.code(AppCostCenters.adminDept),
                ]);
          });
        }),
        _action(Icons.rule, 'مصروف بدون قسم (سيُرفض: القسم إلزامي)', () {
          return _run('لن تظهر هذه الرسالة', () async {
            await _service.onExpensePaid(
                expenseCode: AppAccounts.rent,
                amount: 50,
                description: 'مصروف بلا قسم');
          });
        }),
        _action(Icons.cancel, 'إلغاء آخر فاتورة (قيد عكسي)', () {
          final id = _lastInvoiceId;
          if (id == null) {
            _toast('لا توجد فاتورة لإلغائها', error: true);
            return Future.value();
          }
          return _run('تم عكس قيود الفاتورة $id', () async {
            await _service.onInvoiceCancelled(id);
          });
        }),
        _action(Icons.error_outline, 'تجربة قيد غير متوازن (سيُرفض)', () {
          return _run('لن تظهر هذه الرسالة', () async {
            await FlutterAccounting.instance.record(
              JournalEntryBuilder(description: 'خطأ متعمد')
                  .debitCode(AppAccounts.cash, 100)
                  .creditCode(AppAccounts.sales, 90),
            );
          });
        }),
      ],
    );
  }

  Widget _action(IconData icon, String label, Future<void> Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FilledButton.tonalIcon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Align(
            alignment: AlignmentDirectional.centerStart, child: Text(label)),
      ),
    );
  }
}
