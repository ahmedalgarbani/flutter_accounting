import 'package:flutter/material.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

/// قائمة القيود (تتحدث تلقائياً عبر Stream) مع إمكانية العكس.
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key, required this.fa});

  final FlutterAccounting fa;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JournalEntryModel>>(
      stream: fa.journalEntries.watchAllEntries(),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? const [];
        if (entries.isEmpty) {
          return const Center(child: Text('لا توجد قيود بعد'));
        }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, i) => _EntryTile(fa: fa, entry: entries[i]),
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.fa, required this.entry});

  final FlutterAccounting fa;
  final JournalEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final color = switch (entry.status) {
      EntryStatus.draft => Colors.orange,
      EntryStatus.posted => Colors.green,
      EntryStatus.reversed => Colors.grey,
    };

    return ExpansionTile(
      leading: CircleAvatar(backgroundColor: color, radius: 6),
      title: Text('${entry.serialNumber} • ${entry.description}'),
      subtitle: Text(
        '${entry.status.displayNameAr}'
        '${entry.entryType != null ? ' • ${entry.entryType!.displayNameAr}' : ''}'
        ' • ${entry.totalDebits.toStringAsFixed(2)}',
      ),
      children: [
        for (final line in entry.lines)
          ListTile(
            dense: true,
            title: Text('${line.accountCode} ${line.accountName}'),
            trailing: Text(line.isDebit
                ? 'مدين ${line.debit.toStringAsFixed(2)}'
                : 'دائن ${line.credit.toStringAsFixed(2)}'),
          ),
        if (entry.isPosted && !entry.isReversal)
          TextButton.icon(
            icon: const Icon(Icons.undo),
            label: const Text('عكس القيد'),
            onPressed: () async {
              try {
                await fa.journalEntries.reverseEntry(entry.id!);
              } on AccountingException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              }
            },
          ),
      ],
    );
  }
}
