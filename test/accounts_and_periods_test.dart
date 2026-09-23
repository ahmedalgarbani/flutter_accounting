/// accounts_and_periods_test.dart
/// اختبارات قواعد شجرة الحسابات، الفترات المحاسبية، والقوالب
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import 'test_helpers.dart';

void main() {
  late FlutterAccounting fa;

  setUp(() async {
    fa = await createTestAccounting();
  });

  tearDown(() => fa.dispose());

  group('AccountRepository - شجرة الحسابات', () {
    test('المستوى يُحسب تلقائياً', () async {
      final root = await fa.accounts.createAccount(
        AccountModel.create(code: '1', name: 'Assets', type: AccountType.asset));
      final child = await fa.accounts.createAccount(
        AccountModel.create(code: '11', name: 'Current', type: AccountType.asset, parentId: root.id));
      expect(root.level, 1);
      expect(child.level, 2);
      expect(root.isRoot, isTrue);
      expect(child.isRoot, isFalse);
      expect(await fa.accounts.hasChildren(root.id!), isTrue);
    });

    test('رفض حساب فرعي بنوع مختلف عن الأب', () async {
      final root = await fa.accounts.createAccount(
        AccountModel.create(code: '1', name: 'Assets', type: AccountType.asset));
      await expectLater(
        fa.accounts.createAccount(AccountModel.create(
          code: '11', name: 'X', type: AccountType.revenue, parentId: root.id)),
        throwsA(isA<AccountTypeMismatchException>()),
      );
    });

    test('رفض إضافة حساب فرعي تحت حساب عليه قيود', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!));

      await expectLater(
        fa.accounts.createAccount(AccountModel.create(
          code: '1111', name: 'Sub cash', type: AccountType.asset, parentId: cash.id)),
        throwsA(isA<ParentAccountHasTransactionsException>()),
      );
    });

    test('رفض جعل الحساب أباً لنفسه أو لأحد أسلافه', () async {
      final a = await fa.accounts.createAccount(
        AccountModel.create(code: '1', name: 'A', type: AccountType.asset));
      final b = await fa.accounts.createAccount(
        AccountModel.create(code: '11', name: 'B', type: AccountType.asset, parentId: a.id));

      await expectLater(fa.accounts.updateAccount(a.copyWith(parentId: a.id)),
          throwsA(isA<InvalidAccountHierarchyException>()));
      await expectLater(fa.accounts.updateAccount(a.copyWith(parentId: b.id)),
          throwsA(isA<InvalidAccountHierarchyException>()));
    });

    test('نقل حساب يعيد حساب مستويات الأبناء', () async {
      final a  = await fa.accounts.createAccount(AccountModel.create(code: '1', name: 'A', type: AccountType.asset));
      final b  = await fa.accounts.createAccount(AccountModel.create(code: '2', name: 'B', type: AccountType.asset));
      final b1 = await fa.accounts.createAccount(AccountModel.create(code: '21', name: 'B1', type: AccountType.asset, parentId: b.id));

      final moved = await fa.accounts.updateAccount(b.copyWith(parentId: a.id));
      expect(moved.level, 2);
      expect((await fa.accounts.getAccountById(b1.id!))!.level, 3);
    });

    test('رفض تغيير نوع حساب عليه قيود', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!));

      await expectLater(
        fa.accounts.updateAccount(cash.copyWith(type: AccountType.expense)),
        throwsA(isA<CannotChangeAccountTypeException>()),
      );
    });

    test('رفض حذف حساب عليه مسودة (بدلاً من خطأ SQLite)', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!));

      await expectLater(fa.accounts.deleteAccount(cash.id!),
          throwsA(isA<AccountHasTransactionsException>()));
    });

    test('ensureAccount لا يكرر الحساب ويدعم parentCode', () async {
      final parent = await fa.accounts.ensureAccount(
        code: '113', name: 'Customers', type: AccountType.asset);
      final c1 = await fa.accounts.ensureAccount(
        code: '113001', name: 'Customer Ali', type: AccountType.asset, parentCode: '113');
      final again = await fa.accounts.ensureAccount(
        code: '113001', name: 'ignored', type: AccountType.asset, parentCode: '113');

      expect(c1.parentId, parent.id);
      expect(again.id, c1.id);
      expect(await fa.accounts.countAccounts(), 2);
    });

    test('getPostableAccounts يعيد الحسابات النهائية النشطة فقط', () async {
      await fa.accounts.ensureAccount(code: '1', name: 'Assets', type: AccountType.asset);
      await fa.accounts.ensureAccount(code: '111', name: 'Cash', type: AccountType.asset, parentCode: '1');
      final bank = await fa.accounts.ensureAccount(code: '112', name: 'Bank', type: AccountType.asset, parentCode: '1');
      await fa.accounts.ensureAccount(code: '41', name: 'Sales', type: AccountType.revenue);
      await fa.accounts.setAccountActive(bank.id!, isActive: false);

      final all = await fa.accounts.getPostableAccounts();
      expect(all.map((a) => a.code), ['111', '41']);

      final assets = await fa.accounts.getPostableAccounts(type: AccountType.asset);
      expect(assets.map((a) => a.code), ['111']);
    });

    test('البحث بالاسم العربي أو الرمز', () async {
      await fa.accounts.createAccount(cashAccount());
      await fa.accounts.createAccount(revenueAccount());
      expect((await fa.accounts.searchAccounts('الصندوق')).single.code, '111');
      expect((await fa.accounts.searchAccounts('41')).single.code, '41');
    });

    test('دليل الحسابات الافتراضي يُزرع مرة واحدة', () async {
      await AccountingSeedData.seed(fa.accounts);
      final count = await fa.accounts.countAccounts();
      expect(count, greaterThan(40));
      await AccountingSeedData.seed(fa.accounts);
      expect(await fa.accounts.countAccounts(), count);
    });
  });

  group('AccountingPeriodRepository', () {
    test('createFiscalYear شهرية تنشئ 12 فترة ولا تتكرر', () async {
      final periods = await fa.periods.createFiscalYear(2030, monthly: true);
      expect(periods, hasLength(12));
      expect(periods[1].endDate.day, 28); // فبراير 2030
      final again = await fa.periods.createFiscalYear(2030, monthly: true);
      expect(again.map((p) => p.id), periods.map((p) => p.id));
    });

    test('رفض الفترات المتداخلة', () async {
      await expectLater(
        fa.periods.createPeriod(AccountingPeriodModel(
          name: 'x', startDate: DateTime(DateTime.now().year, 6, 1), endDate: DateTime(DateTime.now().year + 1, 1, 31))),
        throwsA(isA<PeriodOverlapException>()),
      );
    });

    test('رفض فترة تبدأ بعد نهايتها', () async {
      await expectLater(
        fa.periods.createPeriod(AccountingPeriodModel(
          name: 'x', startDate: DateTime(2040, 2, 1), endDate: DateTime(2040, 1, 1))),
        throwsA(isA<InvalidPeriodException>()),
      );
    });

    test('يوم نهاية الفترة مشمول بالكامل', () async {
      await fa.periods.createPeriod(AccountingPeriodModel(
        name: 'Q1 2040', startDate: DateTime(2040, 1, 1), endDate: DateTime(2040, 3, 31)));
      final p = await fa.periods.getPeriodForDate(DateTime(2040, 3, 31, 22, 15));
      expect(p, isNotNull);
      expect(p!.isDateInPeriod(DateTime(2040, 3, 31, 22, 15)), isTrue);
    });

    test('رفض القيد في فترة مغلقة، والسماح بعد إعادة الفتح', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      final period = (await fa.periods.getPeriodForDate(DateTime.now()))!;

      await fa.periods.closePeriod(period.id!);
      await expectLater(fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!)),
          throwsA(isA<PeriodClosedException>()));

      await fa.periods.reopenPeriod(period.id!);
      await expectLater(fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!)), completes);
    });

    test('رفض إغلاق فترة بها مسودات', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!));
      final period = (await fa.periods.getPeriodForDate(DateTime.now()))!;

      await expectLater(fa.periods.closePeriod(period.id!),
          throwsA(isA<PeriodHasDraftEntriesException>()));
    });

    test('رفض حذف فترة بها قيود', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await fa.journalEntries.createEntry(saleEntry(cash.id!, rev.id!));
      final period = (await fa.periods.getPeriodForDate(DateTime.now()))!;

      await expectLater(fa.periods.deletePeriod(period.id!),
          throwsA(isA<PeriodHasEntriesException>()));
    });

    test('requireOpenPeriod: false يسمح بالقيود بدون فترات', () async {
      final simple = FlutterAccounting.forTesting(
        config: const AccountingConfig(requireOpenPeriod: false));
      addTearDown(simple.dispose);
      final cash = await simple.accounts.createAccount(cashAccount());
      final rev  = await simple.accounts.createAccount(revenueAccount());
      await expectLater(
        simple.journalEntries.createAndPost(saleEntry(cash.id!, rev.id!)), completes);
    });

    test('ensureOpenPeriodFor ينشئ السنة المالية عند الحاجة', () async {
      final p = await fa.periods.ensureOpenPeriodFor(DateTime(2050, 7, 1));
      expect(p.startDate, DateTime(2050, 1, 1));
      final again = await fa.periods.ensureOpenPeriodFor(DateTime(2050, 9, 1));
      expect(again.id, p.id);
    });
  });

  group('EntryTemplateRepository', () {
    test('حفظ قالب مخصص وجلبه وحذفه', () async {
      final saved = await fa.templates.saveTemplate(const EntryTemplateModel(
        name: 'بيع مع ضريبة',
        type: EntryType.sale,
        lines: [
          EntryTemplateLineModel(isDebit: true,  label: 'الصندوق', defaultRatio: 1.15),
          EntryTemplateLineModel(isDebit: false, label: 'المبيعات', defaultRatio: 1.0),
          EntryTemplateLineModel(isDebit: false, label: 'الضريبة', defaultRatio: 0.15),
        ],
      ));
      expect(saved.id, isNotNull);

      final list = await fa.templates.getCustomTemplates();
      expect(list.single.lines, hasLength(3));
      expect(list.single.lines.first.defaultRatio, 1.15);

      await fa.templates.deleteTemplate(saved.id!);
      expect(await fa.templates.getCustomTemplates(), isEmpty);
    });

    test('رفض قالب غير متوازن', () async {
      await expectLater(
        fa.templates.saveTemplate(const EntryTemplateModel(
          name: 'x', type: EntryType.sale,
          lines: [
            EntryTemplateLineModel(isDebit: true,  label: 'a', defaultRatio: 1),
            EntryTemplateLineModel(isDebit: false, label: 'b', defaultRatio: 0.5),
          ],
        )),
        throwsA(isA<InvalidTemplateException>()),
      );
    });

    test('تطبيق قالب قياسي ثم ترحيله', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());

      final draft = await fa.templates.applyTemplate(
        template: StandardTemplates.cashSale,
        accountIdMap: {'Cash/Bank Account': cash.id!, 'Sales Revenue Account': rev.id!},
        totalAmount: 400,
      );
      expect(draft.entryType, EntryType.sale);
      final posted = await fa.journalEntries.createAndPost(draft);
      expect(posted.totalDebits, 400);
    });

    test('تطبيق قالب بحساب من نوع خاطئ', () async {
      final cash = await fa.accounts.createAccount(cashAccount());
      final rev  = await fa.accounts.createAccount(revenueAccount());
      await expectLater(
        fa.templates.applyTemplate(
          template: StandardTemplates.cashSale,
          accountIdMap: {'Cash/Bank Account': rev.id!, 'Sales Revenue Account': cash.id!},
          totalAmount: 400,
        ),
        throwsA(isA<InvalidTemplateException>()),
      );
    });
  });

  group('FlutterAccounting', () {
    test('instance يرمي StateError قبل التهيئة', () {
      FlutterAccounting.resetInstance();
      expect(() => FlutterAccounting.instance, throwsStateError);
    });
  });
}
