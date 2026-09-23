# دليل التكامل — ربط `flutter_accounting` بنظامك

هذا الدليل موجّه لمطوّر يبني نظاماً (نقاط بيع، مخازن، عيادة، مدرسة، توصيل، ...)
ويريد أن **يترك المحاسبة كاملة للمكتبة** ويركز على منطق تطبيقه.

> الخلاصة في سطر: **حوّل كل حدث مالي في نظامك إلى استدعاء واحد لـ `fa.record(...)`**،
> واربطه بالمستند المصدر عبر `.source(...)`، وعند الإلغاء استدعِ `fa.reverseSource(...)`.

---

## المحتويات

1. [النمط المعماري المقترح](#1-النمط-المعماري-المقترح)
2. [الخطوة 1: التهيئة](#2-الخطوة-1-التهيئة)
3. [الخطوة 2: تعريف حسابات نظامك](#3-الخطوة-2-تعريف-حسابات-نظامك)
4. [الخطوة 3: طبقة الخدمة المحاسبية](#4-الخطوة-3-طبقة-الخدمة-المحاسبية)
5. [وصفات القيود الجاهزة](#5-وصفات-القيود-الجاهزة)
6. [الإلغاء والتعديل بعد الترحيل](#6-الإلغاء-والتعديل-بعد-الترحيل)
7. [العمليات المركّبة (Transactions)](#7-العمليات-المركبة-transactions)
8. [حسابات فرعية لكل عميل/مورد](#8-حسابات-فرعية-لكل-عميلمورد)
9. [الفترات المحاسبية وإقفالها](#9-الفترات-المحاسبية-وإقفالها)
10. [عرض البيانات في الواجهة](#10-عرض-البيانات-في-الواجهة)
11. [معالجة الأخطاء](#11-معالجة-الأخطاء)
12. [حقن الاعتماديات (DI)](#12-حقن-الاعتماديات-di)
13. [اختبار تكاملك](#13-اختبار-تكاملك)
14. [المزامنة مع خادم والتصدير](#14-المزامنة-مع-خادم-والتصدير)
15. [قائمة تحقق قبل الإطلاق](#15-قائمة-تحقق-قبل-الإطلاق)

---

## 1. النمط المعماري المقترح

```
┌────────────────────────────┐
│   واجهة تطبيقك (Screens)    │   لا تعرف شيئاً عن المدين والدائن
└─────────────┬──────────────┘
              │ createInvoice(), receivePayment(), cancelInvoice()
┌─────────────▼──────────────┐
│   منطق نظامك (Services)     │   الفواتير، المخزون، العملاء...
└─────────────┬──────────────┘
              │ onInvoiceCreated(), onPaymentReceived() ...
┌─────────────▼──────────────┐
│  خدمة المحاسبة (ملف واحد)   │   ← المكان الوحيد الذي يعرف رموز الحسابات
└─────────────┬──────────────┘
              │ fa.record(...), fa.reverseSource(...)
┌─────────────▼──────────────┐
│     flutter_accounting      │   التحقق، الترحيل، الأرصدة، التقارير
└────────────────────────────┘
```

**لماذا طبقة خدمة منفصلة؟**
- تغيير دليل الحسابات أو طريقة التسجيل يتم في ملف واحد.
- يمكن اختبار القيود بمعزل عن الواجهة.
- باقي فريقك لا يحتاج معرفة محاسبية.

مثال كامل وقابل للتشغيل: [`example/lib/sales_accounting_service.dart`](../example/lib/sales_accounting_service.dart).

---

## 2. الخطوة 1: التهيئة

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fa = await FlutterAccounting.initialize(
    databaseName: 'my_app_accounting.db', // ملف منفصل عن قاعدة بيانات تطبيقك
    seedDefaultAccounts: true,            // دليل حسابات جاهز (أول تشغيل فقط)
    config: const AccountingConfig(
      requireOpenPeriod: true,            // كل قيد يجب أن يقع في فترة مفتوحة
      serialPrefix: 'JV',                 // JV-2026-0001
    ),
  );

  // سنة مالية للتاريخ الحالي (تُنشأ تلقائياً إن لم توجد)
  await fa.periods.ensureOpenPeriodFor(DateTime.now());

  runApp(const MyApp());
}
```

| الخيار | متى تستخدمه |
|--------|-------------|
| `requireOpenPeriod: true` (افتراضي) | أنظمة تحتاج رقابة وإقفال فترات |
| `requireOpenPeriod: false` | تطبيقات بسيطة لا تريد إدارة فترات. الفترات المغلقة (إن وُجدت) تبقى محمية |
| `databaseDirectory` | مسار مخصص (مثلاً على سطح المكتب) |
| `customExecutor` | executor مخصص (مثل قاعدة مشفرة بـ SQLCipher أو قاعدة في الذاكرة) |

---

## 3. الخطوة 2: تعريف حسابات نظامك

اجمع رموز الحسابات التي يستخدمها نظامك في مكان واحد:

```dart
abstract final class AppAccounts {
  static const cash            = '111';
  static const bank            = '112';
  static const customers       = '113';
  static const inventory       = '115';
  static const suppliers       = '211';
  static const vatPayable      = '215';
  static const capital         = '31';
  static const sales           = '41';
  static const costOfGoodsSold = '51';
  static const salaries        = '52';
  static const rent            = '53';
}
```

ولأي حساب خاص بنظامك غير موجود في الدليل الافتراضي استخدم `ensureAccount`
(آمن للاستدعاء في كل تشغيل — لا يكرّر):

```dart
await fa.accounts.ensureAccount(
  code: '1121', name: 'Wallet', nameAr: 'المحفظة الإلكترونية',
  type: AccountType.asset,
  parentCode: '11', // الأصول المتداولة
);
```

> 💡 **قواعد الشجرة** التي تطبّقها المكتبة تلقائياً:
> الحساب الفرعي بنفس نوع أبيه • لا تسجيل على حساب له أبناء •
> لا إضافة أبناء تحت حساب عليه قيود • لا دورات في الشجرة • المستوى يُحسب تلقائياً.

---

## 4. الخطوة 3: طبقة الخدمة المحاسبية

```dart
class AccountingService {
  AccountingService(this._fa);
  final FlutterAccounting _fa;

  Future<void> onInvoiceCreated(Invoice inv) {
    final entry = JournalEntryBuilder(description: 'فاتورة مبيعات ${inv.number}', date: inv.date)
      .reference(inv.number)
      .type(inv.isCash ? EntryType.sale : EntryType.saleAgil)
      .source('invoice', inv.id)                  // ← الربط بالمستند
      .debitCode(inv.isCash ? AppAccounts.cash : AppAccounts.customers, inv.total)
      .creditCode(AppAccounts.sales, inv.net);

    // البنود الصفرية مرفوضة، لذا أضف الضريبة فقط إن وُجدت
    if (inv.vat > 0) entry.creditCode(AppAccounts.vatPayable, inv.vat);

    return _fa.record(entry, postedBy: currentUser.name);
  }

  Future<void> onInvoiceCancelled(Invoice inv) =>
      _fa.reverseSource('invoice', inv.id, postedBy: currentUser.name);
}
```

ما يحدث داخل `fa.record(...)` في **عملية ذرّية واحدة**:
1. تحويل رموز الحسابات إلى معرّفات (`AccountNotFoundException` إن لم يوجد رمز).
2. التحقق من القيد المزدوج (توازن، لا صفر، لا سالب، مدين ودائن).
3. التحقق من أن كل حساب موجود ونشط ونهائي (Leaf).
4. التحقق من الفترة المحاسبية.
5. توليد رقم تسلسلي `JV-2026-0001`.
6. الحفظ والترحيل مع `postedBy` و`postedAt`.

إن فشلت أي خطوة لا يُحفظ شيء، ويُرمى استثناء من نوع `AccountingException` برسالة عربية جاهزة للعرض.

---

## 5. وصفات القيود الجاهزة

كل وصفة أدناه تُكتب داخل `JournalEntryBuilder(...)` ثم `fa.record(...)`.

| العملية | مدين | دائن |
|---------|------|------|
| بيع نقدي | الصندوق `111` | المبيعات `41` (+ الضريبة `215`) |
| بيع آجل | العملاء `113` | المبيعات `41` (+ الضريبة `215`) |
| تكلفة البضاعة المباعة (نظام جرد مستمر) | تكلفة المبيعات `51` | المخزون `115` |
| تحصيل من عميل (سند قبض) | الصندوق/البنك | العملاء `113` |
| شراء بضاعة نقداً | المخزون `115` | الصندوق `111` |
| شراء بضاعة آجلاً | المخزون `115` | الموردون `211` |
| سداد لمورد (سند صرف) | الموردون `211` | الصندوق/البنك |
| مصروف نقدي (إيجار، كهرباء...) | حساب المصروف `5x` | الصندوق `111` |
| رواتب مستحقة | الرواتب `52` | مصاريف مستحقة `213` |
| مردودات مبيعات نقدية | المبيعات `41` | الصندوق `111` |
| إيداع نقدية في البنك | البنك `112` | الصندوق `111` |
| رأس مال افتتاحي | الصندوق/البنك | رأس المال `31` |
| إهلاك | مصروف الإهلاك `55` | مجمع الإهلاك `123`/`125` |

### بيع مع ضريبة وتكلفة في قيد واحد

```dart
await fa.record(
  JournalEntryBuilder(description: 'فاتورة 1025')
    .source('invoice', 1025)
    .type(EntryType.sale)
    .debitCode('111', 1150)   // الصندوق
    .creditCode('41', 1000)   // المبيعات
    .creditCode('215', 150)   // ضريبة القيمة المضافة
    .debitCode('51', 600)     // تكلفة البضاعة المباعة
    .creditCode('115', 600),  // المخزون
);
```

### أرصدة افتتاحية عند بدء استخدام النظام

```dart
await fa.record(
  JournalEntryBuilder(description: 'الأرصدة الافتتاحية', date: DateTime(2026, 1, 1))
    .type(EntryType.openingBalance)
    .debitCode('111', 20000)   // الصندوق
    .debitCode('115', 50000)   // المخزون
    .creditCode('211', 15000)  // الموردون
    .creditCode('31', 55000),  // رأس المال (الفرق)
);
```

### باستخدام القوالب (لشاشات إدخال عامة)

```dart
final draft = await fa.templates.applyTemplate(
  template: StandardTemplates.cashSale,
  accountIdMap: {
    'Cash/Bank Account': cashId,
    'Sales Revenue Account': salesId,
  },
  totalAmount: 1500,
);
await fa.journalEntries.createAndPost(draft);
```

القوالب المخصصة تُحفظ في قاعدة البيانات عبر `fa.templates.saveTemplate(...)`
ويُتحقق من توازن نسبها قبل الحفظ.

---

## 6. الإلغاء والتعديل بعد الترحيل

**القاعدة المحاسبية:** القيد المرحّل لا يُعدَّل ولا يُحذف — يُعكس.

| الحالة | ماذا تفعل |
|--------|-----------|
| قيد مسودة خاطئ | `updateEntry(...)` أو `deleteEntry(id)` |
| إلغاء مستند مرحّل | `fa.reverseSource('invoice', id)` |
| عكس قيد واحد | `fa.journalEntries.reverseEntry(id)` |
| تعديل مستند مرحّل | اعكس القديم ثم سجّل الجديد داخل `fa.transaction` |

```dart
Future<void> onInvoiceEdited(Invoice updated) => fa.transaction(() async {
  await fa.reverseSource('invoice', updated.id);
  await accountingService.onInvoiceCreated(updated);
});
```

- `reverseSource` آمن للاستدعاء أكثر من مرة (لا يعكس ما عُكس مسبقاً).
- القيد العكسي يحمل `reversalOfId` (معرّف الأصلي) ونوع `EntryType.reversal`، ويُعلَّم الأصلي بحالة `reversed`.
- الأصلي والعكسي يبقيان في الدفتر ويلغي أحدهما الآخر في الأرصدة (أثر تدقيقي كامل).

---

## 7. العمليات المركّبة (Transactions)

عندما يولّد حدث واحد في نظامك أكثر من قيد، أو تريد ربط حفظ بياناتك بالقيد:

```dart
await fa.transaction(() async {
  await fa.record(saleEntry);
  await fa.record(commissionEntry);
});
```

> ⚠️ `fa.transaction` يشمل قاعدة بيانات المحاسبة فقط. إن كان نظامك يستخدم قاعدة
> بيانات أخرى، فاحفظ مستندك أولاً ثم سجّل القيد، وعند فشل القيد تراجع عن المستند
> (أو اجعل القيد مسودة `post: false` ثم رحّله لاحقاً).

---

## 8. حسابات فرعية لكل عميل/مورد

لتتبع رصيد كل عميل على حدة، أنشئ حساباً فرعياً تحت حساب العملاء قبل أول قيد عليه:

```dart
Future<AccountModel> customerAccount(Customer c) => fa.accounts.ensureAccount(
  code: '113${c.id.toString().padLeft(5, '0')}', // 11300042
  name: c.name,
  type: AccountType.asset,
  parentCode: '113',
);

// الرصيد الإجمالي لكل العملاء (يجمع الأبناء تلقائياً):
final totalReceivables = await fa.reports.getAccountBalance(customersGroupId);

// كشف حساب عميل:
final statement = await fa.reports.getAccountLedger(customerAccountId, from: DateTime(2026));
```

> ⚠️ أنشئ حسابات الأبناء **قبل** التسجيل على الحساب الأب؛ لا يُسمح بإضافة أبناء
> تحت حساب عليه قيود (`ParentAccountHasTransactionsException`).
> إذا كنت تستخدم الدليل الافتراضي وتنوي تفريع `113` فلا تسجّل عليه مباشرة.

---

## 9. الفترات المحاسبية وإقفالها

```dart
await fa.periods.createFiscalYear(2026);                // فترة سنوية واحدة
await fa.periods.createFiscalYear(2026, monthly: true); // أو 12 فترة شهرية

await fa.periods.closePeriod(periodId);   // يُرفض إن وُجدت مسودات في الفترة
await fa.periods.reopenPeriod(periodId);  // لتصحيح استثنائي
```

- نهاية الفترة تشمل **كامل** يومها الأخير (23:59:59).
- الفترات المتداخلة تُرفض (`PeriodOverlapException`).
- القيد في فترة مغلقة يُرفض (`PeriodClosedException`) — حتى القيود العكسية؛ اعكس بتاريخ في فترة مفتوحة:
  `reverseEntry(id, reversalDate: DateTime.now())`.

---

## 10. عرض البيانات في الواجهة

```dart
// قائمة قيود حية تتحدث تلقائياً
StreamBuilder(stream: fa.journalEntries.watchAllEntries(), ...);

// شجرة حسابات حية
StreamBuilder(stream: fa.accounts.watchAllAccounts(), ...);

// قائمة اختيار الحساب في نموذج إدخال: الحسابات النهائية النشطة فقط
final options = await fa.accounts.getPostableAccounts(type: AccountType.expense);

// بحث
final results = await fa.accounts.searchAccounts('صندوق');

// تحقق فوري أثناء إدخال المستخدم للبنود (بدون استثناء)
final error = AccountingValidator.checkEntryLines(lines); // null = صحيح
```

`JournalEntryBuilder` يوفّر `totalDebits` و`totalCredits` و`difference` و`isBalanced`
لعرض شريط التوازن أثناء الإدخال.

---

## 11. معالجة الأخطاء

كل أخطاء المكتبة ترث من `AccountingException` (sealed) ولها `message` بالعربية:

```dart
try {
  await accountingService.onInvoiceCreated(invoice);
} on PeriodClosedException {
  showError('الفترة مغلقة، اختر تاريخاً آخر');
} on AccountingException catch (e) {
  showError(e.message); // رسالة جاهزة للمستخدم
}
```

الجدول الكامل للاستثناءات في [README](../README.md#الاستثناءات-).

---

## 12. حقن الاعتماديات (DI)

المكتبة تعرّض واجهات مجردة (`IAccountRepository`, `IJournalEntryRepository`, ...)
فيمكنك حقنها أو استبدالها بـ Mocks.

**get_it**
```dart
final fa = await FlutterAccounting.initialize();
GetIt.I
  ..registerSingleton<FlutterAccounting>(fa)
  ..registerSingleton<IReportsRepository>(fa.reports)
  ..registerLazySingleton(() => AccountingService(GetIt.I()));
```

**Riverpod**
```dart
final accountingProvider = Provider<FlutterAccounting>((ref) => FlutterAccounting.instance);
final trialBalanceProvider = FutureProvider((ref) =>
    ref.watch(accountingProvider).reports.getTrialBalance());
```

**Provider**
```dart
Provider<FlutterAccounting>.value(value: FlutterAccounting.instance, child: MyApp());
```

---

## 13. اختبار تكاملك

استخدم قاعدة بيانات في الذاكرة — بدون ملفات ولا منصة:

```dart
late FlutterAccounting fa;

setUp(() async {
  fa = FlutterAccounting.forTesting();
  await AccountingSeedData.seed(fa.accounts);
  await fa.periods.ensureOpenPeriodFor(DateTime.now());
});

tearDown(() => fa.dispose());

test('الفاتورة الآجلة ترفع رصيد العملاء', () async {
  await AccountingService(fa).onInvoiceCreated(creditInvoice(total: 1150));
  final customers = await fa.accounts.getAccountByCode('113');
  expect(await fa.reports.getAccountBalance(customers!.id!), 1150);

  // الميزانية يجب أن تبقى متوازنة دائماً
  expect((await fa.reports.getBalanceSheet(asOf: DateTime.now())).isBalanced, isTrue);
});
```

مثال كامل: [`example/test/sales_accounting_service_test.dart`](../example/test/sales_accounting_service_test.dart).

---

## 14. المزامنة مع خادم والتصدير

كل النماذج الأساسية تدعم `toMap()` / `fromMap()`:

```dart
final entries = await fa.journalEntries.getEntriesInDateRange(from, to);
final payload = entries.map((e) => e.toMap()).toList();
await api.post('/accounting/sync', jsonEncode(payload));
```

والتقارير نماذج Dart بسيطة يمكن تحويلها لـ PDF/Excel بأي مكتبة تختارها.

---

## 15. قائمة تحقق قبل الإطلاق

- [ ] `initialize` تُستدعى مرة واحدة قبل `runApp`.
- [ ] كل رموز الحسابات في ملف واحد (`AppAccounts`).
- [ ] حسابات نظامك الخاصة تُنشأ بـ `ensureAccount`.
- [ ] توجد فترة مفتوحة للتاريخ الحالي (`ensureOpenPeriodFor`) أو `requireOpenPeriod: false`.
- [ ] كل قيد مرتبط بمستنده عبر `.source(type, id)`.
- [ ] الإلغاء يتم بـ `reverseSource`، وليس بحذف بيانات.
- [ ] الأخطاء تُلتقط كـ `AccountingException` وتُعرض `e.message`.
- [ ] اختبار واحد على الأقل يتحقق من `isBalanced` للميزانية بعد سيناريو كامل.
