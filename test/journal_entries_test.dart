/// journal_entries_test.dart
/// اختبارات دورة حياة القيود، الباني، والربط بالمستندات
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import 'test_helpers.dart';

void main() {
  late FlutterAccounting fa;
  late int cashId;
  late int revenueId;

  setUp(() async {
    fa = await createTestAccounting();
    cashId    = (await fa.accounts.createAccount(cashAccount())).id!;
    revenueId = (await fa.accounts.createAccount(revenueAccount())).id!;
  });

  tearDown(() => fa.dispose());

  group('JournalEntryRepository - الترحيل والعكس', () {
    test('العكس ذرّي ويربط القيد العكسي بالأصلي', () async {
      final posted = await fa.journalEntries.createAndPost(saleEntry(cashId, revenueId));
      final reversal = await fa.journalEntries.reverseEntry(posted.id!);

      expect(reversal.reversalOfId, posted.id);
      expect(reversal.isReversal, isTrue);
      expect(reversal.entryType, EntryType.reversal);
      expect(reversal.postedAt, isNotNull);
      expect(reversal.lines.map((l) => l.id), everyElement(isNotNull));
      expect((await fa.journalEntries.getEntryById(posted.id!))!.isReversed, isTrue);
    });

    test('رفض عكس قيد معكوس مسبقاً', () async {
      final posted = await fa.journalEntries.createAndPost(saleEntry(cashId, revenueId));
      await fa.journalEntries.reverseEntry(posted.id!);

      await expectLater(
        fa.journalEntries.reverseEntry(posted.id!),
        throwsA(isA<EntryAlreadyReversedException>()),
      );
    });

    test('رفض عكس مسودة', () async {
      final draft = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      await expectLater(
        fa.journalEntries.reverseEntry(draft.id!),
        throwsA(isA<InvalidEntryStateException>()),
      );
    });

    test('رفض إعادة ترحيل قيد معكوس', () async {
      final posted = await fa.journalEntries.createAndPost(saleEntry(cashId, revenueId));
      await fa.journalEntries.reverseEntry(posted.id!);

      await expectLater(
        fa.journalEntries.postEntry(posted.id!),
        throwsA(isA<InvalidEntryStateException>()),
      );
    });

    test('updateEntry لا يمكنه ترحيل القيد بتغيير الحالة', () async {
      final draft = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      final updated = await fa.journalEntries.updateEntry(
        draft.copyWith(status: EntryStatus.posted, description: 'معدل'),
      );
      expect(updated.status, EntryStatus.draft);
      expect(updated.description, 'معدل');
      expect(updated.serialNumber, draft.serialNumber);
    });

    test('createAndPost يسجل بيانات الترحيل', () async {
      final entry = await fa.journalEntries.createAndPost(
        saleEntry(cashId, revenueId), postedBy: 'ahmed');
      expect(entry.isPosted, isTrue);
      expect(entry.postedBy, 'ahmed');
      expect(entry.postedAt, isNotNull);
    });

    test('createEntry بحالة posted يرحّل القيد مع بيانات الترحيل', () async {
      final e = await fa.journalEntries.createEntry(
        saleEntry(cashId, revenueId).copyWith(status: EntryStatus.posted));
      expect(e.isPosted, isTrue);
      expect(e.postedAt, isNotNull);
      expect(await fa.reports.getAccountBalance(cashId), 5000);
    });

    test('رفض إنشاء قيد بحالة معكوس', () async {
      await expectLater(
        fa.journalEntries.createEntry(saleEntry(cashId, revenueId).copyWith(status: EntryStatus.reversed)),
        throwsA(isA<InvalidEntryStateException>()),
      );
    });

    test('فشل الترحيل داخل createAndPost لا يترك مسودة', () async {
      await fa.accounts.setAccountActive(cashId, isActive: false);
      await expectLater(
        fa.journalEntries.createAndPost(saleEntry(cashId, revenueId)),
        throwsA(isA<InactiveAccountException>()),
      );
      expect(await fa.journalEntries.getAllEntries(), isEmpty);
    });

    test('حذف مسودة', () async {
      final draft = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      await fa.journalEntries.deleteEntry(draft.id!);
      expect(await fa.journalEntries.getEntryById(draft.id!), isNull);
    });
  });

  group('JournalEntryRepository - الأرقام التسلسلية', () {
    test('الترقيم تسلسلي لكل سنة', () async {
      final year = DateTime.now().year;
      final a = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      final b = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      expect(a.serialNumber, 'JV-$year-0001');
      expect(b.serialNumber, 'JV-$year-0002');
    });

    test('التسلسل لا ينكسر بعد 9999', () async {
      final year = DateTime.now().year;
      await fa.journalEntries.createEntry(
        saleEntry(cashId, revenueId).copyWith(serialNumber: 'JV-$year-9999'));
      final next = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      expect(next.serialNumber, 'JV-$year-10000');
      final after = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      expect(after.serialNumber, 'JV-$year-10001');
    });

    test('بادئة مخصصة من الإعدادات', () async {
      final custom = await createTestAccounting(
        config: const AccountingConfig(serialPrefix: 'QY', serialPadding: 6));
      addTearDown(custom.dispose);
      final c = (await custom.accounts.createAccount(cashAccount())).id!;
      final r = (await custom.accounts.createAccount(revenueAccount())).id!;
      final e = await custom.journalEntries.createEntry(saleEntry(c, r));
      expect(e.serialNumber, 'QY-${DateTime.now().year}-000001');
    });

    test('رفض رقم تسلسلي مكرر', () async {
      await fa.journalEntries.createEntry(saleEntry(cashId, revenueId).copyWith(serialNumber: 'X-1'));
      await expectLater(
        fa.journalEntries.createEntry(saleEntry(cashId, revenueId).copyWith(serialNumber: 'X-1')),
        throwsA(isA<DuplicateSerialNumberException>()),
      );
    });

    test('البحث بالرقم التسلسلي والمرجع', () async {
      final e = await fa.journalEntries.createEntry(saleEntry(cashId, revenueId));
      expect((await fa.journalEntries.getEntryBySerial(e.serialNumber!))!.id, e.id);
      expect(await fa.journalEntries.getEntriesByReference('INV-001'), hasLength(1));
    });
  });

  group('JournalEntryBuilder و fa.record', () {
    test('إنشاء وترحيل قيد باستخدام رموز الحسابات', () async {
      final entry = await fa.record(
        JournalEntryBuilder(description: 'بيع')
            .reference('INV-7')
            .type(EntryType.sale)
            .source('invoice', 7)
            .debitCode('111', 250)
            .creditCode('41', 250),
        postedBy: 'cashier',
      );

      expect(entry.isPosted, isTrue);
      expect(entry.entryType, EntryType.sale);
      expect(entry.sourceType, 'invoice');
      expect(entry.sourceId, '7');
      expect(entry.lines.first.accountId, cashId);
      expect(entry.lines.first.accountCode, '111');
    });

    test('رمز حساب غير موجود', () async {
      await expectLater(
        fa.record(JournalEntryBuilder(description: 'x').debitCode('999', 1).creditCode('41', 1)),
        throwsA(isA<AccountNotFoundException>()),
      );
    });

    test('build() يرفض الرموز غير المحلولة', () {
      final b = JournalEntryBuilder(description: 'x').debitCode('111', 1).credit(2, 1);
      expect(b.needsResolution, isTrue);
      expect(b.build, throwsStateError);
    });

    test('معلومات التوازن في الباني', () {
      final b = JournalEntryBuilder(description: 'x').debit(1, 100).credit(2, 60);
      expect(b.isBalanced, isFalse);
      expect(b.difference, 40);
      b.credit(3, 40);
      expect(b.isBalanced, isTrue);
    });

    test('record(post: false) يحفظ مسودة', () async {
      final e = await fa.record(
        JournalEntryBuilder(description: 'x').debit(cashId, 5).credit(revenueId, 5),
        post: false,
      );
      expect(e.status, EntryStatus.draft);
    });
  });

  group('الربط بالمستندات (Source)', () {
    test('reverseSource يعكس كل قيود المستند', () async {
      await fa.record(JournalEntryBuilder(description: 'فاتورة 15')
          .source('invoice', 15).debit(cashId, 100).credit(revenueId, 100));
      await fa.record(JournalEntryBuilder(description: 'فاتورة 16')
          .source('invoice', 16).debit(cashId, 30).credit(revenueId, 30));

      final reversals = await fa.reverseSource('invoice', 15);
      expect(reversals, hasLength(1));

      // استدعاء ثانٍ لا يعكس شيئاً (idempotent)
      expect(await fa.reverseSource('invoice', 15), isEmpty);

      final entries = await fa.journalEntries.getEntriesBySource('invoice', '15');
      expect(entries, hasLength(2)); // الأصلي + العكسي
      expect(await fa.reports.getAccountBalance(cashId), 30);
    });

    test('fa.transaction تلغي كل العمليات عند الفشل', () async {
      await expectLater(
        fa.transaction(() async {
          await fa.record(JournalEntryBuilder(description: 'ok').debit(cashId, 10).credit(revenueId, 10));
          await fa.record(JournalEntryBuilder(description: 'bad').debit(cashId, 10).credit(revenueId, 5));
        }),
        throwsA(isA<UnbalancedEntryException>()),
      );
      expect(await fa.journalEntries.getAllEntries(), isEmpty);
    });
  });

  group('AccountingValidator', () {
    test('رفض المبالغ السالبة برسالة صحيحة', () {
      final lines = [
        const JournalEntryLineModel(accountId: 1, debit: -5, credit: 0),
        JournalEntryLineModel.creditLine(accountId: 2, amount: 5),
      ];
      expect(() => AccountingValidator.validateEntryLines(lines),
          throwsA(isA<NegativeAmountException>()));
    });

    test('checkEntryLines يعيد رسالة بدل رمي استثناء', () {
      expect(AccountingValidator.checkEntryLines([
        JournalEntryLineModel.debitLine(accountId: 1, amount: 5),
        JournalEntryLineModel.creditLine(accountId: 2, amount: 5),
      ]), isNull);
      expect(AccountingValidator.checkEntryLines([]), isNotNull);
    });
  });

  group('تحويل النماذج إلى Map', () {
    test('JournalEntryModel toMap/fromMap', () async {
      final e = await fa.record(JournalEntryBuilder(description: 'x')
          .source('order', 'A-1').debit(cashId, 12.5).credit(revenueId, 12.5));
      final copy = JournalEntryModel.fromMap(e.toMap());
      expect(copy.serialNumber, e.serialNumber);
      expect(copy.status, EntryStatus.posted);
      expect(copy.sourceId, 'A-1');
      expect(copy.lines, hasLength(2));
      expect(copy.totalDebits, 12.5);
    });

    test('AccountModel toMap/fromMap', () {
      final a = cashAccount();
      final copy = AccountModel.fromMap(a.toMap());
      expect(copy.code, a.code);
      expect(copy.type, a.type);
      expect(copy.nameAr, a.nameAr);
    });
  });
}
