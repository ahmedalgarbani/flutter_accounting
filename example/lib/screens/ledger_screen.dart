import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

/// كشف حساب مع رصيد تراكمي لأي حساب يُسمح بالتسجيل عليه.
class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key, required this.fa});

  final FlutterAccounting fa;

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  List<AccountModel> _accounts = const [];
  AccountModel? _selected;
  AccountLedgerReport? _ledger;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accounts = await widget.fa.accounts.getPostableAccounts();
    if (!mounted) return;
    setState(() => _accounts = accounts);
    if (accounts.isNotEmpty) await _select(accounts.first);
  }

  Future<void> _select(AccountModel account) async {
    final ledger = await widget.fa.reports.getAccountLedger(account.id!);
    if (mounted) setState(() { _selected = account; _ledger = ledger; });
  }

  @override
  Widget build(BuildContext context) {
    final ledger = _ledger;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButton<AccountModel>(
          isExpanded: true,
          value: _selected,
          items: [
            for (final a in _accounts)
              DropdownMenuItem(value: a, child: Text('${a.code} - ${a.displayName}')),
          ],
          onChanged: (a) => a != null ? _select(a) : null,
        ),
      ),
      if (ledger != null) ...[
        ListTile(
          title: const Text('الرصيد الافتتاحي'),
          trailing: Text(ledger.openingBalance.toStringAsFixed(2)),
        ),
        Expanded(
          child: ListView(children: [
            for (final line in ledger.lines)
              ListTile(
                dense: true,
                title: Text('${line.serialNumber} • ${line.description}'),
                subtitle: Text(line.debit > 0
                    ? 'مدين ${line.debit.toStringAsFixed(2)}'
                    : 'دائن ${line.credit.toStringAsFixed(2)}'),
                trailing: Text(line.runningBalance.toStringAsFixed(2)),
              ),
          ]),
        ),
        ListTile(
          tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          title: const Text('الرصيد الختامي', style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(ledger.closingBalance.toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ]);
  }
}
