import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';
import 'package:flutter_accounting/src/seed/accounting_seed_data.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize the library
  // This sets up the database and default chart of accounts (if first time)
  final accounting = await FlutterAccounting.initialize();

  // 2. Optionally seed default accounts
  await AccountingSeedData.seed(accounting.accounts);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Accounting Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AccountingDashboard(),
    );
  }
}

class AccountingDashboard extends StatefulWidget {
  const AccountingDashboard({super.key});

  @override
  State<AccountingDashboard> createState() => _AccountingDashboardState();
}

class _AccountingDashboardState extends State<AccountingDashboard> {
  final fa = FlutterAccounting.instance;
  double totalAssets = 0;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final report = await fa.reports.getBalanceSheet(asOf: DateTime.now());
    if (mounted) {
      setState(() {
        totalAssets = report.totalAssets;
      });
    }
  }

  Future<void> _createQuickEntry() async {
    try {
      // Find cash and revenue accounts
      final accounts = await fa.accounts.getAllAccounts();
      final cashAcc = accounts.firstWhere((a) => a.code == '111'); // Cash
      final salesAcc = accounts.firstWhere((a) => a.code == '41'); // Sales

      // Create a simple journal entry: Debit Cash 100, Credit Sales 100
      final entry = JournalEntryModel(
        date: DateTime.now(),
        description: 'Example Sale',
        status: EntryStatus.posted,
        lines: [
          JournalEntryLineModel(
            accountId: cashAcc.id!,
            debit: 100,
            credit: 0,
            description: 'Received cash',
          ),
          JournalEntryLineModel(
            accountId: salesAcc.id!,
            debit: 0,
            credit: 100,
            description: 'Revenue recognized',
          ),
        ],
      );

      await fa.journalEntries.createEntry(entry);
      await _loadBalance();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounting Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Total Assets:', style: TextStyle(fontSize: 20)),
            Text(
              '\$${totalAssets.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _createQuickEntry,
              icon: const Icon(Icons.add),
              label: const Text('Add \$100 Sale Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
