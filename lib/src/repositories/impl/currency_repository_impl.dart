/// currency_repository_impl.dart
/// تنفيذ Repository العملات وأسعار الصرف
library;

import '../../core/accounting_config.dart';
import '../../core/date_utils.dart';
import '../../core/exceptions.dart';
import '../../core/money.dart';
import '../../database/accounting_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/currencies_dao.dart';
import '../../database/mappers/mappers.dart';
import '../../models/currency_model.dart';
import '../../reports/currency_report_models.dart';
import '../../seed/currency_seed_data.dart';
import '../interfaces/interfaces.dart';

class CurrencyRepositoryImpl implements ICurrencyRepository {
  final CurrenciesDao _dao;
  final AccountsDao _accountsDao;
  final AccountingConfig _config;

  CurrencyRepositoryImpl(this._dao, this._accountsDao, this._config);

  static const _baseCurrencyKey = 'base_currency';

  CurrencyModel? _base;

  void _ensureEnabled() {
    if (!_config.isMultiCurrency) throw const MultiCurrencyDisabledException();
  }

  @override
  String? get baseCurrencyCode => _config.multiCurrency?.baseCurrency;

  @override
  Future<CurrencyModel> ensureBaseCurrency() async {
    _ensureEnabled();
    final cached = _base;
    if (cached != null) return cached;

    final code = baseCurrencyCode!;
    await _dao.transaction(() async {
      final stored = await _dao.getSetting(_baseCurrencyKey);
      if (stored != null && stored != code && await _dao.hasEntries()) {
        throw BaseCurrencyMismatchException(stored, code);
      }
      if (stored != code) await _dao.setSetting(_baseCurrencyKey, code);
      if (await _dao.getCurrency(code) == null) {
        final known = CurrencySeedData.find(code);
        await _dao.insertCurrency(CurrencyMapper.toCompanion(
            known ?? CurrencyModel(code: code, name: code)));
      }
    });
    return _base = CurrencyMapper.fromData((await _dao.getCurrency(code))!);
  }

  // ─────────────────────────────────────────────────────────────
  // العملات
  // ─────────────────────────────────────────────────────────────

  @override
  Future<List<CurrencyModel>> getCurrencies({bool activeOnly = false}) async =>
      (await _dao.getCurrencies(activeOnly: activeOnly))
          .map(CurrencyMapper.fromData)
          .toList();

  @override
  Future<CurrencyModel?> getCurrency(String code) async {
    final data = await _dao.getCurrency(code);
    return data == null ? null : CurrencyMapper.fromData(data);
  }

  @override
  Future<CurrencyModel> createCurrency(CurrencyModel currency) async {
    _ensureEnabled();
    _validate(currency);
    if (await _dao.getCurrency(currency.code) != null) {
      throw DuplicateCurrencyCodeException(currency.code);
    }
    await _dao.insertCurrency(CurrencyMapper.toCompanion(currency));
    return (await getCurrency(currency.code))!;
  }

  @override
  Future<CurrencyModel> updateCurrency(CurrencyModel currency) async {
    _ensureEnabled();
    _validate(currency);
    final existing = await _dao.getCurrency(currency.code);
    if (existing == null) throw CurrencyNotFoundException(currency.code);
    if (existing.decimalPlaces != currency.decimalPlaces &&
        await _dao.currencyHasLines(currency.code)) {
      throw InvalidCurrencyOperationException(
          'لا يمكن تغيير منازل العملة "${currency.code}" بعد استخدامها في قيود.');
    }
    if (currency.code == baseCurrencyCode && !currency.isActive) {
      throw const InvalidCurrencyOperationException(
          'لا يمكن إيقاف عملة الأساس.');
    }
    await _dao.updateCurrency(CurrencyMapper.toCompanion(currency));
    if (currency.code == baseCurrencyCode) _base = null;
    return (await getCurrency(currency.code))!;
  }

  @override
  Future<CurrencyModel> ensureCurrency({
    required String code,
    required String name,
    String? nameAr,
    String? symbol,
    int decimalPlaces = 2,
  }) async {
    final existing = await getCurrency(code);
    if (existing != null) return existing;
    return createCurrency(CurrencyModel(
      code: code,
      name: name,
      nameAr: nameAr,
      symbol: symbol,
      decimalPlaces: decimalPlaces,
    ));
  }

  @override
  Future<void> setCurrencyActive(String code, {required bool isActive}) async {
    final currency = await getCurrency(code);
    if (currency == null) throw CurrencyNotFoundException(code);
    await updateCurrency(currency.copyWith(isActive: isActive));
  }

  void _validate(CurrencyModel c) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(c.code)) {
      throw InvalidCurrencyOperationException(
          'رمز العملة "${c.code}" يجب أن يكون 3 أحرف إنجليزية كبيرة (ISO 4217).');
    }
    if (c.decimalPlaces < 0 || c.decimalPlaces > 6) {
      throw const InvalidCurrencyOperationException(
          'منازل العملة يجب أن تكون بين 0 و6.');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // أسعار الصرف
  // ─────────────────────────────────────────────────────────────

  @override
  Future<ExchangeRateModel> setExchangeRate(String code, double rate,
      {DateTime? date}) async {
    final base = await ensureBaseCurrency();
    if (code == base.code) {
      throw const InvalidExchangeRateException(
          'سعر عملة الأساس ثابت (1) ولا يُسجَّل.');
    }
    if (await _dao.getCurrency(code) == null) {
      throw CurrencyNotFoundException(code);
    }
    if (rate <= 0 || rate.isNaN || rate.isInfinite) {
      throw const InvalidExchangeRateException(
          'سعر الصرف يجب أن يكون أكبر من صفر.');
    }
    final day = startOfDay(date ?? DateTime.now());
    await _dao.upsertRate(code, day, rate);
    final saved = await _dao.getRateOnOrBefore(code, day);
    return CurrencyMapper.rateFromData(saved!);
  }

  @override
  Future<List<ExchangeRateModel>> getExchangeRates(
          {String? code, DateTime? from, DateTime? to}) async =>
      (await _dao.getRates(
              code: code,
              from: from == null ? null : startOfDay(from),
              to: to == null ? null : endOfDay(to)))
          .map(CurrencyMapper.rateFromData)
          .toList();

  @override
  Future<void> deleteExchangeRate(int id) async {
    _ensureEnabled();
    await _dao.deleteRate(id);
  }

  @override
  Future<double> getExchangeRate(String code, {DateTime? date}) async {
    final base = await ensureBaseCurrency();
    if (code == base.code) return 1;
    if (await _dao.getCurrency(code) == null) {
      throw CurrencyNotFoundException(code);
    }
    final at = date ?? DateTime.now();
    final rate = await _dao.getRateOnOrBefore(code, endOfDay(at));
    if (rate == null) throw ExchangeRateNotFoundException(code, at);
    return rate.rate;
  }

  @override
  Future<double> convert(double amount,
      {required String from, required String to, DateTime? date}) async {
    final target = await getCurrency(to);
    if (target == null) throw CurrencyNotFoundException(to);
    if (from == to) return Money.round(amount, target.decimalPlaces);
    final fromRate = await getExchangeRate(from, date: date);
    final toRate = await getExchangeRate(to, date: date);
    return Money.round(amount * fromRate / toRate, target.decimalPlaces);
  }

  // ─────────────────────────────────────────────────────────────
  // أرصدة وكشوف بالعملة
  // ─────────────────────────────────────────────────────────────

  @override
  Future<CurrencyBalance> getAccountCurrencyBalance(int accountId,
      {String? currencyCode, DateTime? asOf}) async {
    final (_, code, rows) = await _rows(accountId, currencyCode,
        toExclusive: asOf == null ? null : startOfNextDay(asOf));
    double foreign = 0, base = 0;
    for (final r in rows) {
      foreign += _foreignOf(r, code);
      base += r.debit - r.credit;
    }
    return CurrencyBalance(
        currencyCode: code, foreignBalance: foreign, baseBalance: base);
  }

  @override
  Future<CurrencyLedgerReport> getAccountCurrencyLedger(int accountId,
      {String? currencyCode, DateTime? from, DateTime? to}) async {
    final toDate = to ?? DateTime.now();
    double openingForeign = 0, openingBase = 0;
    if (from != null) {
      final opening = await getAccountCurrencyBalance(accountId,
          currencyCode: currencyCode,
          asOf: startOfDay(from).subtract(const Duration(days: 1)));
      openingForeign = opening.foreignBalance;
      openingBase = opening.baseBalance;
    }
    final (account, code, rows) = await _rows(accountId, currencyCode,
        from: from == null ? null : startOfDay(from),
        toExclusive: startOfNextDay(toDate));

    var runningForeign = openingForeign, runningBase = openingBase;
    final lines = <CurrencyLedgerLine>[];
    for (final r in rows) {
      final foreign = _foreignOf(r, code);
      runningForeign += foreign;
      runningBase += r.debit - r.credit;
      lines.add(CurrencyLedgerLine(
        entryId: r.entryId,
        serialNumber: r.serialNumber,
        date: r.date,
        description: r.lineDescription ?? r.entryDescription,
        reference: r.reference,
        currencyCode: r.currencyCode,
        foreignAmount: foreign,
        exchangeRate: r.exchangeRate,
        debit: r.debit,
        credit: r.credit,
        runningForeign: runningForeign,
        runningBase: runningBase,
      ));
    }

    return CurrencyLedgerReport(
      accountId: account.id,
      accountCode: account.code,
      accountName: account.nameAr ?? account.name,
      currencyCode: code,
      from: from,
      to: toDate,
      generatedAt: DateTime.now(),
      openingForeign: openingForeign,
      openingBase: openingBase,
      lines: lines,
    );
  }

  /// حركات الحساب بالعملة المطلوبة (عملة الأساس = البنود بلا عملة)
  Future<(Account, String, List<CurrencyLedgerRow>)> _rows(
    int accountId,
    String? currencyCode, {
    DateTime? from,
    DateTime? toExclusive,
  }) async {
    final base = await ensureBaseCurrency();
    final account = await _accountsDao.getAccountById(accountId);
    if (account == null) throw AccountNotFoundException(accountId);
    final code = currencyCode ?? account.currencyCode ?? base.code;
    final isBase = code == base.code;
    final rows = await _dao.getCurrencyLedgerLines(
      accountId: accountId,
      currencyCode: isBase ? null : code,
      from: from,
      toExclusive: toExclusive,
    );
    return (
      account,
      code,
      isBase ? rows.where((r) => r.currencyCode == null).toList() : rows,
    );
  }

  static double _foreignOf(CurrencyLedgerRow r, String code) =>
      r.currencyCode == null ? r.debit - r.credit : r.signedForeign;
}
