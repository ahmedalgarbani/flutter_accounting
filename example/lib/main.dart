import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import 'accounting_setup.dart';
import 'sales_accounting_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/reports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة المكتبة + دليل الحسابات + الفترة المالية (مرة واحدة)
  final fa = await setupAccounting();

  runApp(AccountingExampleApp(service: SalesAccountingService(fa)));
}

class AccountingExampleApp extends StatelessWidget {
  const AccountingExampleApp({super.key, required this.service});

  final SalesAccountingService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Accounting Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: HomeShell(service: service),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.service});

  final SalesAccountingService service;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final fa = FlutterAccounting.instance;
    final pages = [
      DashboardScreen(service: widget.service),
      JournalScreen(fa: fa),
      ReportsScreen(fa: fa),
      LedgerScreen(fa: fa),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('مثال flutter_accounting')),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.point_of_sale), label: 'العمليات'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long), label: 'القيود'),
          NavigationDestination(
              icon: Icon(Icons.assessment), label: 'التقارير'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'كشف حساب'),
        ],
      ),
    );
  }
}
