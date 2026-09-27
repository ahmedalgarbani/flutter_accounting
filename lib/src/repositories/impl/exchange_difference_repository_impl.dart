/// exchange_difference_repository_impl.dart
/// فروقات العملة: إعادة التقييم (غير المحققة) والتسوية (المحققة)
library;

import '../../core/accounting_config.dart';
import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../core/money.dart';
import '../../database/accounting_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/currencies_dao.dart';
import '../../models/currency_model.dart';
import '../../models/currency_operation_model.dart';
import '../../models/journal_entry_line_model.dart';
import '../../models/journal_entry_model.dart';
import '../../reports/currency_report_models.dart';
import '../interfaces/interfaces.dart';

class ExchangeDifferenceRepositoryImpl
    implements IExchangeDifferenceRepository {
  final CurrenciesDao _dao;
  final AccountsDao _accountsDao;
  final ICurrencyRepository _currencies;
  final IJournalEntryRepository _journalEntries;
  final AccountingConfig _config;

  /// نوع المصدر لقيود إعادة التقييم (sourceId = تاريخ التقييم)
  static const revaluationSource = 'fx_revaluation';

  ExchangeDifferenceRepositoryImpl(
    this._dao,
    this._accountsDao,
    this._currencies,
    this._journalEntries,
    this._config,
  );

  MultiCurrencyConfig get _mc {
    final mc = _config.multiCurrency;
    if (mc == null) throw const MultiCurrencyDisabledException();
    return mc;
  }

  // ─────────────────────────────────────────────────────────────
  // أرصدة العملات الأجنبية
  // ─────────────────────────────────────────────────────────────

  @override
  Future<ForeignCurrencyBalancesReport> getForeignCurrencyBalances(
      {DateTime? asOf, List<int>? accountIds}) async {
    _mc;
    final base = await _currencies.ensureBaseCurrency();
    final date = asOf ?? DateTime.now();
    final rows = await _balanceRows(date, accountIds, const {}, base);
    return ForeignCurrencyBalancesReport(
      asOf: date,
      baseCurrency: base.code,
      generatedAt: DateTime.now(),
      rows: rows
          .where((r) =>
              (accountIds != null || _isMonetary(r.accountType)) &&
              (r.foreignBalance.abs() > 1e-9 || r.bookBalance.abs() > 1e-9))
          .toList(),
    );
  }

  /// الحسابات النقدية القابلة لإعادة التقييم: الأصول والخصوم
  static bool _isMonetary(AccountType type) =>
      type == AccountType.asset || type == AccountType.liability;

  Future<List<ForeignCurrencyBalanceRow>> _balanceRows(
    DateTime asOf,
    List<int>? accountIds,
    Map<String, double> rateOverrides,
    CurrencyModel base,
  ) async {
    final accounts = {
      for (final a in await _accountsDao.getAllAccounts()) a.id: a,
    };
    final rates = <String, double>{...rateOverrides};
    final result = <ForeignCurrencyBalanceRow>[];
    for (final b in await _dao.getForeignBalances(
        toExclusive: startOfNextDay(asOf), accountIds: accountIds)) {
      final account = accounts[b.accountId]!;
      final rate = rates[b.currencyCode] ??=
          await _currencies.getExchangeRate(b.currencyCode, date: asOf);
      result.add(ForeignCurrencyBalanceRow(
        accountId: account.id,
        accountCode: account.code,
        accountName: account.nameAr ?? account.name,
        accountType: account.type,
        currencyCode: b.currencyCode,
        foreignBalance: b.foreignBalance,
        bookBalance: Money.round(b.baseBalance, base.decimalPlaces),
        rate: rate,
        revaluedBalance:
            Money.round(b.foreignBalance * rate, base.decimalPlaces),
      ));
    }
    result.sort((a, b) => a.accountCode.compareTo(b.accountCode));
    return result;
  }

  // ─────────────────────────────────────────────────────────────
  // إعادة التقييم
  // ─────────────────────────────────────────────────────────────

  @override
  Future<RevaluationPreview> previewRevaluation(
      RevaluationRequest request) async {
    _mc;
    final base = await _currencies.ensureBaseCurrency();
    final rows = await _balanceRows(
        request.asOf, request.accountIds, request.rates, base);
    return RevaluationPreview(
      asOf: request.asOf,
      rows: rows
          .where((r) =>
              // الافتراضي: الحسابات النقدية (أصول وخصوم) فقط
              (request.accountIds != null || _isMonetary(r.accountType)) &&
              !Money.equals(r.difference, 0, base.decimalPlaces))
          .toList(),
    );
  }

  @override
  Future<RevaluationResult> runRevaluation(
    RevaluationRequest request, {
    bool post = true,
    String? postedBy,
  }) async {
    final mc = _mc;
    final preview = await previewRevaluation(request);
    if (preview.isEmpty) {
      throw const InvalidCurrencyOperationException(
          'لا توجد فروقات عملة لإعادة التقييم في هذا التاريخ.');
    }

    Future<JournalEntryModel?> record(
      List<ForeignCurrencyBalanceRow> rows, {
      required bool realized,
    }) async {
      if (rows.isEmpty) return null;
      final gainId = await _accountId(
          realized ? mc.realizedGainAccountCode : mc.unrealizedGainCode);
      final lossId = await _accountId(
          realized ? mc.realizedLossAccountCode : mc.unrealizedLossCode);
      final lines = <JournalEntryLineModel>[];
      for (final r in rows) {
        final diff = r.difference.abs();
        final increase = r.difference > 0;
        final label = '${r.currencyCode} @ ${r.rate}';
        // تعديل رصيد الحساب بعملة الأساس فقط (المبلغ بالعملة = صفر)
        lines.add(JournalEntryLineModel(
          accountId: r.accountId,
          debit: increase ? diff : 0,
          credit: increase ? 0 : diff,
          description: label,
          currencyCode: r.currencyCode,
          amountCurrency: 0,
        ));
        lines.add(JournalEntryLineModel(
          accountId: increase ? gainId : lossId,
          debit: increase ? 0 : diff,
          credit: increase ? diff : 0,
          description: '${r.accountCode} $label',
        ));
      }
      final entry = JournalEntryModel(
        date: request.asOf,
        description: request.description ??
            (realized
                ? 'فروقات عملة محققة'
                : 'إعادة تقييم أرصدة العملات الأجنبية'),
        entryType: EntryType.exchangeDifference,
        sourceType: revaluationSource,
        sourceId: startOfDay(request.asOf).toIso8601String().substring(0, 10),
        lines: lines,
      );
      return post
          ? _journalEntries.createAndPost(entry, postedBy: postedBy)
          : _journalEntries.createEntry(entry);
    }

    final realizedEntry = await record(
        preview.rows.where((r) => r.isSettled).toList(),
        realized: true);
    final unrealizedEntry = await record(
        preview.rows.where((r) => !r.isSettled).toList(),
        realized: false);

    JournalEntryModel? reversal;
    final reverseOn = request.autoReverseOn;
    if (reverseOn != null && post && unrealizedEntry != null) {
      reversal = await _journalEntries.reverseEntry(
        unrealizedEntry.id!,
        reversalDate: reverseOn,
        description: 'عكس: ${unrealizedEntry.description}',
        postedBy: postedBy,
      );
    }

    return RevaluationResult(
      realizedEntry: realizedEntry,
      unrealizedEntry: unrealizedEntry,
      reversalEntry: reversal,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // التسوية مع الفرق المحقق
  // ─────────────────────────────────────────────────────────────

  @override
  Future<JournalEntryModel> settle(
    SettlementRequest request, {
    bool post = true,
    String? postedBy,
  }) async {
    final mc = _mc;
    final base = await _currencies.ensureBaseCurrency();

    final account = await _accountsDao.getAccountById(request.accountId);
    if (account == null) throw AccountNotFoundException(request.accountId);
    final counter = await _accountsDao.getAccountById(request.counterAccountId);
    if (counter == null) {
      throw AccountNotFoundException(request.counterAccountId);
    }

    final code = request.currencyCode ?? account.currencyCode;
    if (code == null || code == base.code) {
      throw const InvalidCurrencyOperationException(
          'التسوية بفرق عملة تكون لعملة أجنبية. حدد currencyCode أو عملة الحساب.');
    }
    if (counter.currencyCode != null &&
        counter.currencyCode != code &&
        counter.currencyCode != base.code) {
      throw InvalidCurrencyOperationException(
          'الحساب المقابل "${counter.code}" بعملة "${counter.currencyCode}" '
          'ولا يمكن التسوية منه بعملة "$code".');
    }
    if (request.amount <= 0) throw const ZeroAmountLineException();

    final rate = request.rate ??
        await _currencies.getExchangeRate(code, date: request.date);
    final balance = await _currencies.getAccountCurrencyBalance(account.id,
        currencyCode: code, asOf: request.date);
    final bookRate = request.bookRate ?? balance.averageRate;
    if (bookRate == null || bookRate <= 0) {
      throw InvalidCurrencyOperationException(
          'لا يوجد رصيد بعملة "$code" على الحساب "${account.code}" لاحتساب '
          'السعر الدفتري. مرّر bookRate يدوياً.');
    }

    // رصيد مدين (عميل) يُسوّى بالدائن، ورصيد دائن (مورد) يُسوّى بالمدين
    final creditAccount = balance.foreignBalance >= 0;
    final bookAmount =
        Money.round(request.amount * bookRate, base.decimalPlaces);
    final paidAmount = Money.round(request.amount * rate, base.decimalPlaces);

    final lines = <JournalEntryLineModel>[
      JournalEntryLineModel(
        accountId: account.id,
        debit: creditAccount ? 0 : request.amount,
        credit: creditAccount ? request.amount : 0,
        currencyCode: code,
        amountCurrency: request.amount,
        exchangeRate: bookRate,
      ),
      if (counter.currencyCode == code)
        JournalEntryLineModel(
          accountId: counter.id,
          debit: creditAccount ? request.amount : 0,
          credit: creditAccount ? 0 : request.amount,
          currencyCode: code,
          amountCurrency: request.amount,
          exchangeRate: rate,
        )
      else
        JournalEntryLineModel(
          accountId: counter.id,
          debit: creditAccount ? paidAmount : 0,
          credit: creditAccount ? 0 : paidAmount,
        ),
    ];

    // الفرق المحقق = الفرق بين المبلغ الدفتري والمبلغ الفعلي
    final imbalance =
        creditAccount ? paidAmount - bookAmount : bookAmount - paidAmount;
    if (!Money.equals(imbalance, 0, base.decimalPlaces)) {
      final diff = Money.round(imbalance.abs(), base.decimalPlaces);
      // المدين أكبر ← نحتاج دائناً (ربح)، والدائن أكبر ← نحتاج مديناً (خسارة)
      final gain = imbalance > 0;
      lines.add(JournalEntryLineModel(
        accountId: await _accountId(
            gain ? mc.realizedGainAccountCode : mc.realizedLossAccountCode),
        debit: gain ? 0 : diff,
        credit: gain ? diff : 0,
        description: 'فرق عملة $code: ${request.amount} × ($rate - $bookRate)',
      ));
    }

    final entry = JournalEntryModel(
      date: request.date,
      description: request.description ??
          (creditAccount
              ? 'تحصيل ${request.amount} $code'
              : 'سداد ${request.amount} $code'),
      reference: request.reference,
      entryType:
          creditAccount ? EntryType.receiptVoucher : EntryType.paymentVoucher,
      sourceType: request.sourceType,
      sourceId: request.sourceId,
      lines: lines,
    );
    return post
        ? _journalEntries.createAndPost(entry, postedBy: postedBy)
        : _journalEntries.createEntry(entry);
  }

  Future<int> _accountId(String code) async {
    final Account? account = await _accountsDao.getAccountByCode(code);
    if (account == null) throw AccountNotFoundException(code);
    return account.id;
  }
}
