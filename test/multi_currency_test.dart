/// multi_currency_test.dart
/// اختبارات تعدد العملات: الأسعار، التحويل، عملة الحساب، التقريب،
/// التسوية بالفرق المحقق، وإعادة التقييم
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

void main() {
  late FlutterAccounting fa;
  late int usdBankId, usdCustomerId, usdSupplierId, sarBankId;
  late int salesId, purchasesId;
  final march = DateTime(2024, 3, 1);
  final june = DateTime(2024, 6, 15);

  Future<int> id(String code) async =>
      (await fa.accounts.getAccountByCode(code))!.id!;

  setUp(() async {
    fa = FlutterAccounting.forTesting(
        config: const AccountingConfig(
            multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR')));
    await AccountingSeedData.seed(fa.accounts);
    await CurrencySeedData.seed(fa.currencies);
    await fa.periods.createFiscalYear(2024);
    await fa.currencies.setExchangeRate('USD', 3.75, date: DateTime(2024));
    await fa.currencies
        .setExchangeRate('USD', 3.80, date: DateTime(2024, 6, 1));
    await fa.currencies.setExchangeRate('EUR', 4.0, date: DateTime(2024));
    await fa.currencies.setExchangeRate('KWD', 12.2, date: DateTime(2024));

    Future<int> account(String code, String name, AccountType type,
            String parent, String? currency) async =>
        (await fa.accounts.createAccount(AccountModel.create(
          code: code,
          name: name,
          type: type,
          parentId: await id(parent),
          currencyCode: currency,
        )))
            .id!;

    usdBankId =
        await account('1122', 'Bank USD', AccountType.asset, '11', 'USD');
    usdCustomerId =
        await account('1131', 'Customer USD', AccountType.asset, '11', 'USD');
    usdSupplierId = await account(
        '2111', 'Supplier USD', AccountType.liability, '21', 'USD');
    sarBankId = await id('112');
    salesId = await id('41');
    purchasesId = await id('51');
  });

  tearDown(() => fa.dispose());

  /// فاتورة بيع آجلة بالدولار لعميل
  Future<JournalEntryModel> usdSale(double amount, {DateTime? date}) =>
      fa.record(
          JournalEntryBuilder(description: 'USD sale', date: date ?? march)
              .currency('USD')
              .debit(usdCustomerId, amount)
              .credit(salesId, amount));

  /// فاتورة شراء آجلة بالدولار من مورد
  Future<JournalEntryModel> usdPurchase(double amount, {DateTime? date}) =>
      fa.record(
          JournalEntryBuilder(description: 'USD purchase', date: date ?? march)
              .currency('USD')
              .debit(purchasesId, amount)
              .credit(usdSupplierId, amount));

  // ─────────────────────────────────────────────────────────────
  group('التفعيل وعملة الأساس', () {
    test('بدون تفعيل: العملات مرفوضة والقيود العادية تعمل', () async {
      final off = FlutterAccounting.forTesting();
      addTearDown(off.dispose);
      await off.periods.createFiscalYear(2024);
      final cash = await off.accounts.createAccount(AccountModel.create(
          code: '1', name: 'Cash', type: AccountType.asset));
      final rev = await off.accounts.createAccount(AccountModel.create(
          code: '4', name: 'Rev', type: AccountType.revenue));

      await expectLater(() => off.currencies.setExchangeRate('USD', 3.75),
          throwsA(isA<MultiCurrencyDisabledException>()));
      await expectLater(
          () => off.accounts.createAccount(AccountModel.create(
              code: '2',
              name: 'x',
              type: AccountType.asset,
              currencyCode: 'USD')),
          throwsA(isA<MultiCurrencyDisabledException>()));
      await expectLater(
          () => off.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('USD')
              .debit(cash.id!, 1)
              .credit(rev.id!, 1)),
          throwsA(isA<MultiCurrencyDisabledException>()));

      final e = await off.record(
          JournalEntryBuilder(description: 'x', date: march)
              .debit(cash.id!, 1)
              .credit(rev.id!, 1));
      expect(e.lines.first.currencyCode, isNull);
    });

    test('عملة الأساس تُضاف تلقائياً وسعرها 1', () async {
      final base = await fa.currencies.ensureBaseCurrency();
      expect(base.code, 'SAR');
      expect(await fa.currencies.getExchangeRate('SAR'), 1);
      await expectLater(() => fa.currencies.setExchangeRate('SAR', 1),
          throwsA(isA<InvalidExchangeRateException>()));
      await expectLater(
          () => fa.currencies.updateCurrency(base.copyWith(isActive: false)),
          throwsA(isA<InvalidCurrencyOperationException>()));
    });

    test('لا يمكن تغيير عملة الأساس بعد تسجيل قيود', () async {
      final dir = Directory.systemTemp.createTempSync('fa_base_currency');
      addTearDown(() => dir.deleteSync(recursive: true));

      final first = await FlutterAccounting.initialize(
        databaseDirectory: dir.path,
        seedDefaultAccounts: true,
        config: const AccountingConfig(
            requireOpenPeriod: false,
            multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR')),
      );
      await first.record(JournalEntryBuilder(description: 'x')
          .debitCode('111', 1)
          .creditCode('41', 1));
      await first.dispose();

      await expectLater(
          FlutterAccounting.initialize(
            databaseDirectory: dir.path,
            config: const AccountingConfig(
                multiCurrency: MultiCurrencyConfig(baseCurrency: 'USD')),
          ),
          throwsA(isA<BaseCurrencyMismatchException>()));
      FlutterAccounting.resetInstance();
    });

    test('seedDefaultCurrencies يتطلب التفعيل، والعملات الجاهزة بمنازل صحيحة',
        () async {
      await expectLater(
          () => FlutterAccounting.initialize(seedDefaultCurrencies: true),
          throwsArgumentError);
      expect((await fa.currencies.getCurrency('KWD'))!.decimalPlaces, 3);
      expect((await fa.currencies.getCurrency('JPY'))!.decimalPlaces, 0);
      expect(await fa.currencies.getCurrencies(),
          hasLength(CurrencySeedData.all.length));
    });

    test('رمز عملة غير صالح أو مكرر', () async {
      await expectLater(
          () => fa.currencies
              .createCurrency(const CurrencyModel(code: 'usd', name: 'x')),
          throwsA(isA<InvalidCurrencyOperationException>()));
      await expectLater(
          () => fa.currencies
              .createCurrency(const CurrencyModel(code: 'USD', name: 'x')),
          throwsA(isA<DuplicateCurrencyCodeException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('أسعار الصرف', () {
    test('السعر الساري هو آخر سعر في التاريخ أو قبله', () async {
      expect(await fa.currencies.getExchangeRate('USD', date: march), 3.75);
      expect(await fa.currencies.getExchangeRate('USD', date: june), 3.80);
      expect(
          await fa.currencies
              .getExchangeRate('USD', date: DateTime(2024, 6, 1, 18)),
          3.80);
      await expectLater(
          () => fa.currencies
              .getExchangeRate('USD', date: DateTime(2023, 12, 31)),
          throwsA(isA<ExchangeRateNotFoundException>()));
      await expectLater(() => fa.currencies.getExchangeRate('GBP', date: march),
          throwsA(isA<ExchangeRateNotFoundException>()));
    });

    test('تسجيل سعر لنفس اليوم يستبدله، والسعر غير الصالح مرفوض', () async {
      await fa.currencies.setExchangeRate('USD', 3.76, date: DateTime(2024));
      expect(await fa.currencies.getExchangeRate('USD', date: march), 3.76);
      expect(await fa.currencies.getExchangeRates(code: 'USD'), hasLength(2));
      await expectLater(() => fa.currencies.setExchangeRate('USD', 0),
          throwsA(isA<InvalidExchangeRateException>()));
      await expectLater(() => fa.currencies.setExchangeRate('XYZ', 1),
          throwsA(isA<CurrencyNotFoundException>()));
    });

    test('التحويل بين عملتين عبر عملة الأساس', () async {
      expect(
          await fa.currencies.convert(100, from: 'USD', to: 'SAR', date: march),
          375);
      expect(
          await fa.currencies.convert(100, from: 'EUR', to: 'USD', date: march),
          106.67);
      expect(
          await fa.currencies.convert(100, from: 'SAR', to: 'KWD', date: march),
          8.197);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('القيود بالعملات الأجنبية', () {
    test('البند يحفظ المبلغ بالعملة والسعر، والمدين/الدائن بعملة الأساس',
        () async {
      final e = await usdPurchase(1000);
      final line = e.lines.first;
      expect(line.currencyCode, 'USD');
      expect(line.amountCurrency, 1000);
      expect(line.exchangeRate, 3.75);
      expect(line.debit, 3750);
      expect(e.isBalanced, isTrue);

      final tb = await fa.reports
          .getTrialBalance(from: DateTime(2024), to: DateTime(2024, 12, 31));
      expect(tb.isBalanced, isTrue);
      expect(tb.totalDebitBalances, 3750);
    });

    test('سعر يدوي يتقدم على السعر المسجل', () async {
      final e = await fa.record(
          JournalEntryBuilder(description: 'x', date: march)
              .currency('USD', rate: 3.7)
              .debit(purchasesId, 100)
              .credit(usdSupplierId, 100));
      expect(e.totalDebits, 370);
      expect(e.lines.first.exchangeRate, 3.7);
    });

    test('بنود بعملات مختلفة في قيد واحد', () async {
      // دفع 100 دولار من البنك بالريال
      final e =
          await fa.record(JournalEntryBuilder(description: 'x', date: march)
              .debit(usdSupplierId, 100) // عملة الحساب USD تُطبق تلقائياً
              .credit(sarBankId, 375));
      expect(e.lines.first.currencyCode, 'USD');
      expect(e.lines.first.debit, 375);
      expect(e.lines.last.currencyCode, isNull);
    });

    test('منازل العملة: الدينار الكويتي 3 منازل', () async {
      final e = await fa.record(
          JournalEntryBuilder(description: 'x', date: march)
              .currency('KWD')
              .debit(purchasesId, 10.1234)
              .credit(sarBankId, 10.1234));
      expect(e.lines.first.amountCurrency, 10.123);
      expect(e.lines.first.debit, 123.5); // 10.123 × 12.2 = 123.5006
    });

    test('عملة البند يجب أن تطابق عملة الحساب', () async {
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('EUR')
              .debit(usdBankId, 10)
              .credit(salesId, 10)),
          throwsA(isA<CurrencyMismatchException>()));
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .debit(usdBankId, 10, currency: 'SAR')
              .credit(salesId, 10)),
          throwsA(isA<CurrencyMismatchException>()));
    });

    test('عملة غير معرّفة أو موقوفة أو بلا سعر', () async {
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('XYZ')
              .debit(purchasesId, 1)
              .credit(sarBankId, 1)),
          throwsA(isA<CurrencyNotFoundException>()));
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('GBP')
              .debit(purchasesId, 1)
              .credit(sarBankId, 1)),
          throwsA(isA<ExchangeRateNotFoundException>()));
      await fa.currencies.setCurrencyActive('EUR', isActive: false);
      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('EUR')
              .debit(purchasesId, 1)
              .credit(sarBankId, 1)),
          throwsA(isA<InactiveCurrencyException>()));
    });

    test('فرق التقريب الصغير يُسوّى تلقائياً والكبير مرفوض', () async {
      final e = await fa.record(
          JournalEntryBuilder(description: 'x', date: march)
              .currency('USD', rate: 1.5)
              .debit(purchasesId, 1)
              .credit(usdSupplierId, 0.33)
              .credit(usdSupplierId, 0.33)
              .credit(usdSupplierId, 0.34));
      // 1.50 مدين مقابل 0.50 + 0.50 + 0.51 = 1.51 دائن
      final rounding = e.lines.last;
      expect(rounding.accountId, await id('50'));
      expect(rounding.debit, 0.01);
      expect(e.isBalanced, isTrue);

      await expectLater(
          () => fa.record(JournalEntryBuilder(description: 'x', date: march)
              .currency('USD')
              .debit(purchasesId, 100)
              .credit(usdSupplierId, 90)),
          throwsA(isA<UnbalancedEntryException>()));
    });

    test('المسودة تحتفظ بالعملة، والترحيل والتعديل لا يغيران المبالغ',
        () async {
      final draft = await fa.record(
          JournalEntryBuilder(description: 'x', date: march)
              .currency('USD')
              .debit(purchasesId, 100)
              .credit(usdSupplierId, 100),
          post: false);
      final updated = await fa.journalEntries.updateEntry(draft);
      expect(updated.totalDebits, 375);
      expect(updated.lines.first.amountCurrency, 100);
      final posted = await fa.journalEntries.postEntry(updated.id!);
      expect(posted.totalDebits, 375);
    });

    test('القيد العكسي يلغي الأثر بالعملة وبعملة الأساس', () async {
      final e = await usdPurchase(1000);
      final rev =
          await fa.journalEntries.reverseEntry(e.id!, reversalDate: june);
      expect(rev.lines.first.currencyCode, 'USD');
      expect(rev.lines.first.exchangeRate, 3.75); // سعر الأصل لا سعر يونيو
      final balance =
          await fa.currencies.getAccountCurrencyBalance(usdSupplierId);
      expect(balance.foreignBalance, 0);
      expect(balance.baseBalance, 0);
    });

    test('لا يمكن تغيير عملة حساب عليه قيود', () async {
      await usdPurchase(10);
      final supplier = await fa.accounts.getAccountById(usdSupplierId);
      await expectLater(
          () => fa.accounts
              .updateAccount(supplier!.copyWith(currencyCode: 'EUR')),
          throwsA(isA<InvalidCurrencyOperationException>()));
      await expectLater(
          () => fa.currencies.updateCurrency(const CurrencyModel(
              code: 'USD', name: 'US Dollar', decimalPlaces: 3)),
          throwsA(isA<InvalidCurrencyOperationException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('أرصدة وكشوف بالعملة', () {
    test('رصيد وكشف حساب بعملته وبعملة الأساس', () async {
      await usdPurchase(1000);
      await usdPurchase(500, date: june); // بسعر 3.80
      await fa.record(JournalEntryBuilder(description: 'pay', date: june)
          .debit(usdSupplierId, 200, rate: 3.80)
          .credit(usdBankId, 200, rate: 3.80));

      final balance =
          await fa.currencies.getAccountCurrencyBalance(usdSupplierId);
      expect(balance.foreignBalance, -1300);
      expect(balance.baseBalance, -(3750 + 1900 - 760));

      final ledger = await fa.currencies.getAccountCurrencyLedger(usdSupplierId,
          from: DateTime(2024, 4, 1), to: DateTime(2024, 12, 31));
      expect(ledger.currencyCode, 'USD');
      expect(ledger.openingForeign, -1000);
      expect(ledger.openingBase, -3750);
      expect(ledger.lines, hasLength(2));
      expect(ledger.lines.first.foreignAmount, -500);
      expect(ledger.lines.first.exchangeRate, 3.80);
      expect(ledger.closingForeign, -1300);
      expect(ledger.closingBase, balance.baseBalance);

      // كشف بعملة الأساس لحساب غير مقيّد بعملة
      final sar = await fa.currencies.getAccountCurrencyBalance(sarBankId);
      expect(sar.currencyCode, 'SAR');
      expect(sar.foreignBalance, 0);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('التسوية بالفرق المحقق', () {
    test('تحصيل عميل بسعر أقل: خسارة محققة، ورصيد العميل يُصفّر', () async {
      await usdSale(1000); // 3750
      final e = await fa.exchangeDifferences.settle(SettlementRequest(
        accountId: usdCustomerId,
        amount: 1000,
        counterAccountId: sarBankId,
        rate: 3.70,
        date: june,
      ));
      expect(e.entryType, EntryType.receiptVoucher);
      final lossId = await id('50');
      final loss = e.lines.firstWhere((l) => l.accountId == lossId);
      expect(loss.debit, 50);
      expect(e.lines.firstWhere((l) => l.accountId == sarBankId).debit, 3700);

      final balance =
          await fa.currencies.getAccountCurrencyBalance(usdCustomerId);
      expect(balance.foreignBalance, 0);
      expect(balance.baseBalance, 0);
    });

    test('سداد مورد: خسارة عند ارتفاع السعر وربح عند انخفاضه', () async {
      await usdPurchase(1000); // -3750
      final loss = await fa.exchangeDifferences.settle(SettlementRequest(
          accountId: usdSupplierId,
          amount: 600,
          counterAccountId: sarBankId,
          date: june)); // سعر يونيو 3.80
      final lossId = await id('50'), gainId = await id('45');
      expect(loss.lines.firstWhere((l) => l.accountId == lossId).debit, 30);
      final gain = await fa.exchangeDifferences.settle(SettlementRequest(
          accountId: usdSupplierId,
          amount: 400,
          counterAccountId: sarBankId,
          rate: 3.70,
          date: june));
      expect(gain.lines.firstWhere((l) => l.accountId == gainId).credit, 20);
      final balance =
          await fa.currencies.getAccountCurrencyBalance(usdSupplierId);
      expect(balance.foreignBalance, 0);
      expect(balance.baseBalance, 0);
    });

    test('التسوية من بنك بنفس العملة تسجّل البنك بالدولار', () async {
      await usdSale(1000);
      final e = await fa.exchangeDifferences.settle(SettlementRequest(
          accountId: usdCustomerId,
          amount: 1000,
          counterAccountId: usdBankId,
          date: june));
      final bank = e.lines.firstWhere((l) => l.accountId == usdBankId);
      expect(bank.amountCurrency, 1000);
      expect(bank.exchangeRate, 3.80);
      expect(bank.debit, 3800);
      final gainId = await id('45');
      expect(e.lines.firstWhere((l) => l.accountId == gainId).credit, 50);
    });

    test('سطر فرق العملة لا يتطلب مركز تكلفة حتى مع سياسة إلزامية', () async {
      final both = FlutterAccounting.forTesting(
          config: const AccountingConfig(
              enableCostCenters: true,
              multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR')));
      addTearDown(both.dispose);
      await AccountingSeedData.seed(both.accounts);
      await both.periods.createFiscalYear(2024);
      await both.currencies.ensureCurrency(code: 'USD', name: 'USD');
      await both.currencies.setExchangeRate('USD', 3.75, date: DateTime(2024));
      await CostCenterSeedData.seed(both.costCenters);
      final dep =
          await both.costCenters.getDimensionByCode(CostCenterSeedData.department);
      await both.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: dep!.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));
      final customer = await both.accounts.createAccount(AccountModel.create(
          code: '1131',
          name: 'USD customer',
          type: AccountType.asset,
          parentId: (await both.accounts.getAccountByCode('11'))!.id,
          currencyCode: 'USD'));
      await both.record(JournalEntryBuilder(description: 'sale', date: march)
          .currency('USD')
          .debit(customer.id!, 100)
          .creditCode('41', 100));
      final e = await both.exchangeDifferences.settle(SettlementRequest(
          accountId: customer.id!,
          amount: 100,
          rate: 3.70,
          counterAccountId: (await both.accounts.getAccountByCode('112'))!.id!,
          date: june));
      expect(e.totalDebits, 375);
    });

    test('تسوية بلا رصيد أو بعملة الأساس مرفوضة', () async {
      await expectLater(
          () => fa.exchangeDifferences.settle(SettlementRequest(
              accountId: usdCustomerId,
              amount: 10,
              counterAccountId: sarBankId,
              date: june)),
          throwsA(isA<InvalidCurrencyOperationException>()));
      await expectLater(
          () => fa.exchangeDifferences.settle(SettlementRequest(
              accountId: sarBankId,
              amount: 10,
              counterAccountId: sarBankId,
              date: june)),
          throwsA(isA<InvalidCurrencyOperationException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('إعادة التقييم', () {
    test('معاينة وتنفيذ مع العكس التلقائي', () async {
      await usdSale(1000); // أصل 3750
      await usdPurchase(1000); // خصم -3750
      final asOf = DateTime(2024, 6, 30);

      final preview = await fa.exchangeDifferences
          .previewRevaluation(RevaluationRequest(asOf: asOf));
      expect(preview.rows.map((r) => r.accountCode), ['1131', '2111']);
      expect(preview.rows.first.difference, 50); // ربح على العميل
      expect(preview.rows.last.difference, -50); // خسارة على المورد
      expect(preview.netDifference, 0);

      final result = await fa.exchangeDifferences.runRevaluation(
          RevaluationRequest(asOf: asOf, autoReverseOn: DateTime(2024, 7, 1)));
      expect(result.realizedEntry, isNull);
      expect(result.unrealizedEntry!.entryType, EntryType.exchangeDifference);
      expect(result.reversalEntry, isNotNull);

      final atJune =
          await fa.exchangeDifferences.getForeignCurrencyBalances(asOf: asOf);
      for (final r in atJune.rows) {
        expect(r.difference, 0, reason: r.accountCode);
      }
      // بعد العكس يعود الرصيد الدفتري للسعر التاريخي
      final customer = await fa.currencies
          .getAccountCurrencyBalance(usdCustomerId, asOf: DateTime(2024, 7, 1));
      expect(customer.baseBalance, 3750);
      expect(customer.foreignBalance, 1000);

      final income =
          await fa.reports.getIncomeStatement(from: DateTime(2024), to: asOf);
      expect(
          income.revenueRows.firstWhere((r) => r.accountCode == '45').balance,
          50);
      expect(
          income.expenseRows.firstWhere((r) => r.accountCode == '50').balance,
          50);
    });

    test('الحساب المُسوّى بالعملة يُسجل فرقه كمحقق ولا يُعكس', () async {
      await usdSale(1000); // 3750
      // تحصيل يدوي بسعر يونيو دون settle → رصيد العملة صفر ورصيد الأساس -50
      await fa.record(JournalEntryBuilder(description: 'manual', date: june)
          .debit(usdBankId, 1000)
          .credit(usdCustomerId, 1000));
      final result = await fa.exchangeDifferences.runRevaluation(
          RevaluationRequest(
              asOf: DateTime(2024, 6, 30),
              autoReverseOn: DateTime(2024, 7, 1)));
      expect(result.realizedEntry, isNotNull);
      // البنك الدولاري سُجل بسعر يونيو فلا فرق غير محقق، ولا قيد عكس
      expect(result.unrealizedEntry, isNull);
      expect(result.reversalEntry, isNull);
      final customer =
          await fa.currencies.getAccountCurrencyBalance(usdCustomerId);
      expect(customer.baseBalance, 0);
    });

    test('أسعار مخصصة وفلتر حسابات، ولا فروقات = خطأ', () async {
      await usdSale(100);
      final preview = await fa.exchangeDifferences.previewRevaluation(
          RevaluationRequest(
              asOf: june,
              accountIds: [usdCustomerId],
              rates: const {'USD': 4.0}));
      expect(preview.rows.single.revaluedBalance, 400);
      expect(preview.rows.single.difference, 25);

      await expectLater(
          () => fa.exchangeDifferences
              .runRevaluation(RevaluationRequest(asOf: DateTime(2024, 3, 31))),
          throwsA(isA<InvalidCurrencyOperationException>()));
    });
  });

  group('Money', () {
    test('التقريب', () {
      expect(Money.round(1.005, 2), 1.01);
      expect(Money.round(-1.005, 2), -1.01);
      expect(Money.round(10.1235, 3), 10.124);
      expect(Money.round(1234.5, 0), 1235);
      expect(Money.equals(1.004, 1.0, 2), isTrue);
      expect(Money.equals(1.006, 1.0, 2), isFalse);
    });
  });
}
