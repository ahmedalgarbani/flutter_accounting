/// currencies_dao.dart
/// عمليات قاعدة البيانات للعملات وأسعار الصرف والإعدادات المثبّتة
library;

import 'package:drift/drift.dart';
import '../../core/enums.dart';
import '../accounting_database.dart';
import '../tables/tables.dart';

part 'currencies_dao.g.dart';

@DriftAccessor(tables: [
  Currencies,
  ExchangeRates,
  AccountingSettings,
  JournalEntries,
  JournalEntryLines,
])
class CurrenciesDao extends DatabaseAccessor<AccountingDatabase>
    with _$CurrenciesDaoMixin {
  CurrenciesDao(super.db);

  // ─────────────────────────────────────────────────────────────
  // العملات
  // ─────────────────────────────────────────────────────────────

  Future<List<Currency>> getCurrencies({bool activeOnly = false}) {
    final query = select(currencies)
      ..orderBy([(t) => OrderingTerm(expression: t.code)]);
    if (activeOnly) query.where((t) => t.isActive.equals(true));
    return query.get();
  }

  Future<Currency?> getCurrency(String code) =>
      (select(currencies)..where((t) => t.code.equals(code))).getSingleOrNull();

  Future<int> insertCurrency(CurrenciesCompanion entry) =>
      into(currencies).insert(entry);

  Future<void> updateCurrency(CurrenciesCompanion entry) =>
      (update(currencies)..where((t) => t.code.equals(entry.code.value)))
          .write(entry);

  /// هل استُخدمت العملة في أي بند؟
  Future<bool> currencyHasLines(String code) async {
    final row = await (select(journalEntryLines)
          ..where((t) => t.currencyCode.equals(code))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  // ─────────────────────────────────────────────────────────────
  // أسعار الصرف
  // ─────────────────────────────────────────────────────────────

  /// إدراج أو تحديث سعر يوم معيّن
  Future<void> upsertRate(String code, DateTime day, double rate) =>
      into(exchangeRates).insert(
        ExchangeRatesCompanion.insert(
            currencyCode: code, date: day, rate: rate),
        onConflict: DoUpdate(
          (_) => ExchangeRatesCompanion(rate: Value(rate)),
          target: [exchangeRates.currencyCode, exchangeRates.date],
        ),
      );

  /// آخر سعر في [date] أو قبله
  Future<ExchangeRate?> getRateOnOrBefore(String code, DateTime date) =>
      (select(exchangeRates)
            ..where((t) =>
                t.currencyCode.equals(code) &
                t.date.isSmallerOrEqualValue(date))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<ExchangeRate>> getRates({
    String? code,
    DateTime? from,
    DateTime? to,
  }) {
    final query = select(exchangeRates)
      ..orderBy([
        (t) => OrderingTerm(expression: t.currencyCode),
        (t) => OrderingTerm.desc(t.date),
      ]);
    if (code != null) query.where((t) => t.currencyCode.equals(code));
    if (from != null) query.where((t) => t.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((t) => t.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<int> deleteRate(int id) =>
      (delete(exchangeRates)..where((t) => t.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────
  // الإعدادات المثبّتة
  // ─────────────────────────────────────────────────────────────

  Future<String?> getSetting(String key) async =>
      (await (select(accountingSettings)..where((t) => t.key.equals(key)))
              .getSingleOrNull())
          ?.value;

  Future<void> setSetting(String key, String value) =>
      into(accountingSettings).insertOnConflictUpdate(
          AccountingSettingsCompanion.insert(key: key, value: value));

  /// هل توجد أي قيود؟
  Future<bool> hasEntries() async =>
      (await (select(journalEntries)..limit(1)).getSingleOrNull()) != null;

  // ─────────────────────────────────────────────────────────────
  // استعلامات التقارير (القيود المرحّلة والمعكوسة فقط)
  // ─────────────────────────────────────────────────────────────

  /// أرصدة كل (حساب، عملة أجنبية): بالعملة وبعملة الأساس (موجب = مدين)
  Future<List<ForeignBalanceRow>> getForeignBalances({
    DateTime? toExclusive,
    List<int>? accountIds,
  }) async {
    final accountFilter = accountIds == null
        ? ''
        : accountIds.isEmpty
            ? 'AND 0'
            : 'AND l.account_id IN (${List.filled(accountIds.length, '?').join(', ')})';
    final rows = await customSelect(
      '''
      SELECT
        l.account_id    AS account_id,
        l.currency_code AS currency_code,
        SUM(CASE WHEN l.debit > 0 THEN COALESCE(l.amount_currency, 0.0)
                 ELSE -COALESCE(l.amount_currency, 0.0) END) AS foreign_balance,
        SUM(l.debit - l.credit) AS base_balance
      FROM journal_entry_lines l
      INNER JOIN journal_entries e ON e.id = l.entry_id
      WHERE l.currency_code IS NOT NULL
        AND e.status IN (?, ?)
        AND (? IS NULL OR e.date < ?)
        $accountFilter
      GROUP BY l.account_id, l.currency_code
      ORDER BY l.account_id, l.currency_code
      ''',
      variables: [
        Variable.withInt(EntryStatus.posted.index),
        Variable.withInt(EntryStatus.reversed.index),
        Variable<DateTime>(toExclusive),
        Variable<DateTime>(toExclusive),
        for (final id in accountIds ?? const <int>[]) Variable.withInt(id),
      ],
      readsFrom: {journalEntryLines, journalEntries},
    ).get();
    return rows
        .map((r) => ForeignBalanceRow(
              accountId: r.read<int>('account_id'),
              currencyCode: r.read<String>('currency_code'),
              foreignBalance: r.read<double>('foreign_balance'),
              baseBalance: r.read<double>('base_balance'),
            ))
        .toList();
  }

  /// حركات حساب مع بيانات العملة، مرتبة زمنياً.
  /// [currencyCode]: عملة محددة، أو `null` لكل الحركات.
  Future<List<CurrencyLedgerRow>> getCurrencyLedgerLines({
    required int accountId,
    String? currencyCode,
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        e.id            AS entry_id,
        e.serial_number AS serial_number,
        e.date          AS date,
        e.description   AS entry_description,
        e.reference     AS reference,
        l.debit         AS debit,
        l.credit        AS credit,
        l.description   AS line_description,
        l.currency_code AS currency_code,
        l.amount_currency AS amount_currency,
        l.exchange_rate AS exchange_rate
      FROM journal_entry_lines l
      INNER JOIN journal_entries e ON e.id = l.entry_id
      WHERE l.account_id = ?
        AND (? IS NULL OR l.currency_code = ?)
        AND e.status IN (?, ?)
        AND (? IS NULL OR e.date >= ?)
        AND (? IS NULL OR e.date < ?)
      ORDER BY e.date, e.id, l.sort_order, l.id
      ''',
      variables: [
        Variable.withInt(accountId),
        Variable<String>(currencyCode),
        Variable<String>(currencyCode),
        Variable.withInt(EntryStatus.posted.index),
        Variable.withInt(EntryStatus.reversed.index),
        Variable<DateTime>(from),
        Variable<DateTime>(from),
        Variable<DateTime>(toExclusive),
        Variable<DateTime>(toExclusive),
      ],
      readsFrom: {journalEntryLines, journalEntries},
    ).get();
    return rows
        .map((r) => CurrencyLedgerRow(
              entryId: r.read<int>('entry_id'),
              serialNumber: r.read<String>('serial_number'),
              date: r.read<DateTime>('date'),
              entryDescription: r.read<String>('entry_description'),
              reference: r.read<String?>('reference'),
              debit: r.read<double>('debit'),
              credit: r.read<double>('credit'),
              lineDescription: r.read<String?>('line_description'),
              currencyCode: r.read<String?>('currency_code'),
              amountCurrency: r.read<double?>('amount_currency'),
              exchangeRate: r.read<double?>('exchange_rate'),
            ))
        .toList();
  }
}

/// رصيد (حساب، عملة)
class ForeignBalanceRow {
  final int accountId;
  final String currencyCode;
  final double foreignBalance;
  final double baseBalance;

  ForeignBalanceRow({
    required this.accountId,
    required this.currencyCode,
    required this.foreignBalance,
    required this.baseBalance,
  });
}

/// حركة حساب مع بيانات العملة
class CurrencyLedgerRow {
  final int entryId;
  final String serialNumber;
  final DateTime date;
  final String entryDescription;
  final String? reference;
  final double debit;
  final double credit;
  final String? lineDescription;
  final String? currencyCode;
  final double? amountCurrency;
  final double? exchangeRate;

  CurrencyLedgerRow({
    required this.entryId,
    required this.serialNumber,
    required this.date,
    required this.entryDescription,
    required this.reference,
    required this.debit,
    required this.credit,
    required this.lineDescription,
    required this.currencyCode,
    required this.amountCurrency,
    required this.exchangeRate,
  });

  bool get isDebit => debit > 0;

  /// المبلغ بعملة البند بإشارة (موجب = مدين)
  double get signedForeign => (amountCurrency ?? 0) * (isDebit ? 1 : -1);
}
