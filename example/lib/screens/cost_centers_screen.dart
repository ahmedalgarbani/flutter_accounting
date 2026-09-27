import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

/// مراكز التكلفة: ربحية كل مركز (شجرة) لبُعد مختار، مصفوفة الفروع × الأقسام،
/// وكشف حساب المركز عند الضغط عليه.
class CostCentersScreen extends StatefulWidget {
  const CostCentersScreen({super.key, required this.fa});

  final FlutterAccounting fa;

  @override
  State<CostCentersScreen> createState() => _CostCentersScreenState();
}

class _CostCentersScreenState extends State<CostCentersScreen> {
  List<CostDimensionModel> _dimensions = const [];
  CostDimensionModel? _dimension;
  CostCenterSummaryReport? _summary;
  CostCenterMatrixReport? _matrix;

  FlutterAccounting get _fa => widget.fa;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dimensions = await _fa.costCenters.getDimensions(activeOnly: true);
    if (dimensions.isEmpty) {
      if (mounted) setState(() => _dimensions = dimensions);
      return;
    }
    final dimension = _dimension == null
        ? dimensions.first
        : dimensions.firstWhere((d) => d.id == _dimension!.id,
            orElse: () => dimensions.first);
    final summary =
        await _fa.costReports.getSummary(dimensionId: dimension.id!);

    // مصفوفة الفروع × الأقسام (إن وُجد البعدان)
    CostCenterMatrixReport? matrix;
    final branch = dimensions
        .where((d) => d.code == CostCenterSeedData.branch)
        .firstOrNull;
    final department = dimensions
        .where((d) => d.code == CostCenterSeedData.department)
        .firstOrNull;
    if (branch != null && department != null) {
      matrix = await _fa.costReports.getMatrix(
          rowDimensionId: branch.id!, columnDimensionId: department.id!);
    }

    if (!mounted) return;
    setState(() {
      _dimensions = dimensions;
      _dimension = dimension;
      _summary = summary;
      _matrix = matrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dimensions.isEmpty) {
      return const Center(
        child: Text('مراكز التكلفة غير مفعّلة أو لا توجد أبعاد.\n'
            'فعّلها عبر AccountingConfig(enableCostCenters: true)'),
      );
    }
    final summary = _summary;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCenter,
        icon: const Icon(Icons.add),
        label: const Text('مركز جديد'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Wrap(spacing: 8, children: [
              for (final d in _dimensions)
                ChoiceChip(
                  label: Text(d.displayName),
                  selected: d.id == _dimension?.id,
                  onSelected: (_) {
                    _dimension = d;
                    _load();
                  },
                ),
            ]),
            const SizedBox(height: 12),
            if (summary != null) _summaryCard(summary),
            if (_matrix != null) _matrixCard(_matrix!),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(CostCenterSummaryReport s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          ListTile(
            title: Text('ربحية ${s.dimensionName}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: const Text('من بداية السنة • المركز الأب يشمل أبناءه'),
          ),
          if (s.rows.isEmpty)
            const ListTile(title: Text('لا توجد مراكز في هذا البعد بعد')),
          for (final r in s.rows)
            ListTile(
              dense: true,
              contentPadding: EdgeInsetsDirectional.only(
                  start: 16.0 + (r.level - 1) * 20, end: 16),
              leading: Icon(r.isLeaf ? Icons.circle_outlined : Icons.folder,
                  size: 18),
              title: Text('${r.code} • ${r.displayName}'),
              subtitle: Text('إيرادات ${_f(r.revenue)} • '
                  'مصروفات ${_f(r.expenses)}'),
              trailing: _net(r.netIncome),
              onTap: () => _openLedger(r),
            ),
          const Divider(),
          ListTile(
            dense: true,
            leading: const Icon(Icons.help_outline, size: 18),
            title: const Text('غير موزّع'),
            subtitle: Text('إيرادات ${_f(s.unallocatedRevenue)} • '
                'مصروفات ${_f(s.unallocatedExpenses)}'),
            trailing: _net(s.unallocatedNetIncome),
          ),
          ListTile(
            title: const Text('صافي ربح المنشأة',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: _net(s.totalNetIncome, bold: true),
          ),
        ]),
      ),
    );
  }

  Widget _matrixCard(CostCenterMatrixReport m) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('صافي الربح: الفروع × الأقسام',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: [
                const DataColumn(label: Text('')),
                for (final c in m.columnHeaders)
                  DataColumn(label: Text(c.displayName), numeric: true),
                const DataColumn(label: Text('الإجمالي'), numeric: true),
              ],
              rows: [
                for (final r in m.rowHeaders)
                  DataRow(cells: [
                    DataCell(Text(r.displayName)),
                    for (final c in m.columnHeaders)
                      DataCell(Text(_f(
                          m.cell(r.costCenterId, c.costCenterId).netIncome))),
                    DataCell(Text(_f(m.rowTotal(r.costCenterId).netIncome),
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                  ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _openLedger(CostCenterSummaryRow row) async {
    final ledger = await _fa.costReports.getLedger(row.costCenterId);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (context, controller) => ListView(
          controller: controller,
          children: [
            ListTile(
              title: Text('كشف مركز ${ledger.displayName}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('الرصيد: موجب = مدين، سالب = دائن'),
            ),
            if (ledger.lines.isEmpty)
              const ListTile(title: Text('لا توجد حركات')),
            for (final l in ledger.lines)
              ListTile(
                dense: true,
                title: Text('${l.serialNumber} • ${l.accountCode} '
                    '${l.accountName}'),
                subtitle: Text('${l.description} • ${l.costCenterCode}'),
                leading: Text(l.debit > 0
                    ? 'مدين\n${_f(l.debit)}'
                    : 'دائن\n${_f(l.credit)}'),
                trailing: Text(_f(l.runningBalance)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCenter() async {
    final dimension = _dimension;
    if (dimension == null) return;
    final code = TextEditingController();
    final name = TextEditingController();
    final parents = await _fa.costCenters
        .getCostCenters(dimensionId: dimension.id, activeOnly: true);
    int? parentId;
    if (!mounted) return;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('مركز جديد في ${dimension.displayName}'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: code,
                decoration: const InputDecoration(labelText: 'الرمز')),
            TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'الاسم')),
            DropdownButtonFormField<int?>(
              initialValue: parentId,
              decoration:
                  const InputDecoration(labelText: 'المركز الأب (اختياري)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('بدون')),
                for (final p in parents)
                  DropdownMenuItem(
                      value: p.id, child: Text('${p.code} ${p.displayName}')),
              ],
              onChanged: (v) => setDialogState(() => parentId = v),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('حفظ')),
          ],
        ),
      ),
    );
    if (saved != true) return;

    try {
      await _fa.costCenters.createCostCenter(CostCenterModel(
        dimensionId: dimension.id!,
        code: code.text.trim(),
        name: name.text.trim(),
        nameAr: name.text.trim(),
        parentId: parentId,
      ));
      await _load();
    } on AccountingException catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('تأكد من إدخال الرمز والاسم');
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  static String _f(double v) => v.toStringAsFixed(2);

  Widget _net(double v, {bool bold = false}) => Text(
        _f(v),
        style: TextStyle(
          color: v < 0 ? Colors.red : Colors.green.shade700,
          fontWeight: bold ? FontWeight.bold : FontWeight.w600,
        ),
      );
}
