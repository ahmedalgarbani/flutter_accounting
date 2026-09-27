# flutter_accounting 📊

**Offline double-entry accounting for Flutter** — chart of accounts, journal entries,
posting and reversal, fiscal periods, account ledgers, and financial reports
(Trial Balance, Balance Sheet, Income Statement), with accounting rules enforced in code.
Works on Android, iOS, Windows, macOS, and Linux.

**محرك محاسبي كامل (قيد مزدوج) لتطبيقات Flutter — يعمل أوفلاين.**

[English Documentation](README.md)

ركّز على تطوير نظامك (مبيعات، مخازن، عيادة، مدرسة...) واترك المحاسبة للمكتبة:
دليل الحسابات، القيود، الترحيل، العكس، الفترات المالية، والتقارير — كلها جاهزة ومحمية بقواعد محاسبية.

```dart
await fa.record(
  JournalEntryBuilder(description: 'فاتورة مبيعات 15')
    .source('invoice', 15)
    .debitCode('111', 1150)   // الصندوق
    .creditCode('41', 1000)   // المبيعات
    .creditCode('215', 150),  // الضريبة
);
```

---

## المحتويات

- [المميزات](#المميزات-)
- [التثبيت](#التثبيت-)
- [البدء السريع (5 دقائق)](#البدء-السريع-5-دقائق-)
- [المفاهيم الأساسية](#المفاهيم-الأساسية-)
- [دليل الاستخدام](#دليل-الاستخدام-)
  - [دليل الحسابات](#1-دليل-الحسابات)
  - [القيود اليومية](#2-القيود-اليومية)
  - [الباني JournalEntryBuilder](#3-الباني-journalentrybuilder)
  - [الربط بمستندات نظامك](#4-الربط-بمستندات-نظامك)
  - [الفترات المحاسبية](#5-الفترات-المحاسبية)
  - [التقارير](#6-التقارير)
  - [القوالب](#7-القوالب)
  - [الإعدادات](#8-الإعدادات)
  - [مراكز التكلفة](#9-مراكز-التكلفة-اختيارية)
  - [تعدد العملات](#10-تعدد-العملات-اختياري)
  - [الفروع](#11-الفروع-اختيارية)
- [دليل التكامل مع نظامك](#دليل-التكامل-مع-نظامك-)
- [مرجع الـ API](#مرجع-الـ-api-)
- [القواعد المحاسبية المدمجة](#القواعد-المحاسبية-المدمجة-️)
- [الاستثناءات](#الاستثناءات-)
- [الاختبار](#الاختبار-)
- [الترقية من 0.3.x](#الترقية-من-03x-)
- [بنية المشروع](#بنية-المشروع-️)
- [أسئلة شائعة](#أسئلة-شائعة-)

---

## المميزات ✨

| | الميزة |
|---|--------|
| ⚖️ | **القيد المزدوج** — تحقق تلقائي: توازن، لا مبالغ صفرية أو سالبة، مدين ودائن في كل قيد |
| 🌳 | **دليل حسابات هرمي** — مستويات غير محدودة، حماية الشجرة (نوع موحّد، لا دورات، لا تسجيل على حساب أب) |
| 📦 | **دليل حسابات جاهز** — 40+ حساب عربي/إنجليزي بسطر واحد |
| 🧾 | **دورة حياة القيد** — مسودة ← مرحّل ← معكوس، مع أثر تدقيقي (`createdBy`, `postedBy`, `postedAt`) |
| 🔗 | **الربط بمستنداتك** — `source('invoice', 15)` ثم البحث والعكس بمعرّف المستند |
| 🧱 | **باني قيود سلس** — `JournalEntryBuilder` يقبل معرّفات أو **رموز** الحسابات |
| ⚡ | **عمليات ذرّية** — `record` و`createAndPost` و`reverseEntry` و`fa.transaction` (كل شيء أو لا شيء) |
| 🔢 | **ترقيم تلقائي** — `JV-2026-0001` لكل سنة، وبادئة قابلة للتخصيص |
| 📅 | **الفترات المالية** — سنوية أو شهرية، إقفال/إعادة فتح، منع التداخل |
| 📈 | **التقارير** — ميزان المراجعة، قائمة الدخل، الميزانية العمومية، **كشف حساب** برصيد تراكمي، ورصيد أي حساب (مع أبنائه) |
| 💱 | **تعدد العملات (اختياري)** — أسعار صرف بالتاريخ، البند يحفظ عملته الأصلية، ربط الحساب بعملة، فروقات محققة عند التسوية، وإعادة تقييم نهاية الفترة مع العكس التلقائي |
| 🏬 | **الفروع (اختيارية)** — الفروع وحدات محاسبية لكل منها دفاتر متوازنة، معاملات بين الفروع، توحيد ومطابقة، ترقيم وإقفال فترات وتقييد حسابات لكل فرع |
| 🏢 | **مراكز التكلفة (اختيارية)** — فروع، مشاريع، أقسام أو أبعاد خاصة؛ توزيع البند بالنسب أو المبالغ أو مفاتيح التوزيع، سياسات لكل حساب، توزيع دوري، وتقارير ربحية |
| 🧩 | **القوالب** — 7 قوالب قياسية + قوالب مخصصة محفوظة في قاعدة البيانات |
| 🔄 | **تحويل إلى Map** — `toMap()` / `fromMap()` للمزامنة والتصدير |
| 🗄️ | **Drift (SQLite)** — أوفلاين بالكامل، type-safe، WAL، فهارس للأداء، ترقية تلقائية للمخطط |
| 🧪 | **سهولة الاختبار** — `FlutterAccounting.forTesting()` قاعدة في الذاكرة + واجهات مجردة للـ DI |

---

## التثبيت 📦

```yaml
# pubspec.yaml
dependencies:
  flutter_accounting: ^0.6.0
```

المنصات المدعومة: Android, iOS, Windows, macOS, Linux (عبر `sqlite3_flutter_libs`).

---

## البدء السريع (5 دقائق) 🚀

### 1. التهيئة (مرة واحدة في `main`)

```dart
import 'package:flutter_accounting/flutter_accounting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fa = await FlutterAccounting.initialize(
    seedDefaultAccounts: true, // دليل الحسابات الافتراضي (أول تشغيل فقط)
  );

  // فترة مالية مفتوحة للسنة الحالية (تُنشأ إن لم توجد)
  await fa.periods.ensureOpenPeriodFor(DateTime.now());

  runApp(const MyApp());
}
```

### 2. سجّل عملية

```dart
final fa = FlutterAccounting.instance;

// بيع نقدي بـ 500: الصندوق مدين / المبيعات دائن — يُحفظ ويُرحَّل مباشرة
await fa.record(
  JournalEntryBuilder(description: 'بيع نقدي')
    .debitCode('111', 500)
    .creditCode('41', 500),
);
```

### 3. اعرض النتائج

```dart
final income = await fa.reports.getIncomeStatement(
  from: DateTime(2026, 1, 1),
  to:   DateTime.now(),
);
print('صافي الربح: ${income.netIncome}');

final cash = await fa.accounts.getAccountByCode('111');
print('رصيد الصندوق: ${await fa.reports.getAccountBalance(cash!.id!)}');
```

هذا كل شيء. 🎉 للتكامل الكامل مع نظامك راجع [**دليل التكامل**](doc/INTEGRATION.md).

---

## المفاهيم الأساسية 📚

### أنواع الحسابات والرصيد الطبيعي

| النوع | `AccountType` | الرصيد الطبيعي | يزيد بـ | يظهر في |
|-------|---------------|---------------|---------|---------|
| أصول | `asset` | مدين | المدين | الميزانية |
| خصوم | `liability` | دائن | الدائن | الميزانية |
| حقوق ملكية | `equity` | دائن | الدائن | الميزانية |
| إيرادات | `revenue` | دائن | الدائن | قائمة الدخل |
| مصروفات | `expense` | مدين | المدين | قائمة الدخل |

> كل الأرصدة التي تُعيدها المكتبة (`getAccountBalance`، كشف الحساب، الميزانية، قائمة الدخل)
> تكون **بالاتجاه الطبيعي**: الرقم الموجب يعني رصيداً طبيعياً.
> الاستثناء: `TrialBalanceRow.balance` حيث الموجب = مدين والسالب = دائن.

### دورة حياة القيد

```
             postEntry / createAndPost / record
  ┌───────┐ ────────────────────────────────► ┌────────┐   reverseEntry   ┌──────────┐
  │ مسودة │                                    │ مرحّل  │ ───────────────► │ معكوس    │
  │ draft │ ◄─ updateEntry / deleteEntry       │ posted │                  │ reversed │
  └───────┘                                    └────────┘                  └──────────┘
                                                               + قيد عكسي جديد (مرحّل)
```

- **المسودة** قابلة للتعديل والحذف ولا تؤثر على الأرصدة.
- **المرحّل** يؤثر على الأرصدة ولا يُعدَّل ولا يُحذف — يُعكس فقط.
- **العكس** ينشئ قيداً مرحّلاً بمبالغ معكوسة مرتبطاً بالأصلي (`reversalOfId`)، ويبقى الاثنان في الدفتر ويلغي أحدهما الآخر.

### الفترات المحاسبية

كل قيد يجب أن يقع تاريخه في فترة **مفتوحة** (افتراضياً). الفترة المغلقة تمنع أي تسجيل بتاريخ داخلها.
يمكن تعطيل اشتراط وجود فترة بـ `AccountingConfig(requireOpenPeriod: false)` للتطبيقات البسيطة.

---

## دليل الاستخدام 📖

### 1. دليل الحسابات

```dart
// زرع الدليل الافتراضي (إن كانت القاعدة فارغة)
await AccountingSeedData.seed(fa.accounts);

// إنشاء حساب (بدون الحاجة لتمرير التواريخ)
final wallet = await fa.accounts.createAccount(AccountModel.create(
  code: '1121', name: 'Wallet', nameAr: 'المحفظة', type: AccountType.asset,
  parentId: currentAssetsId,
));

// إنشاء إن لم يوجد (آمن للاستدعاء في كل تشغيل) — مع الأب بالرمز
final ali = await fa.accounts.ensureAccount(
  code: '113001', name: 'Customer Ali', nameAr: 'العميل علي',
  type: AccountType.asset, parentCode: '113',
);

// الاستعلام
await fa.accounts.getAccountByCode('111');
await fa.accounts.getPostableAccounts(type: AccountType.expense); // لقوائم الاختيار
await fa.accounts.searchAccounts('صندوق');
await fa.accounts.getChildAccounts(parentId);
fa.accounts.watchAllAccounts(); // Stream

// التعديل
await fa.accounts.updateAccount(wallet.copyWith(nameAr: 'المحفظة الإلكترونية'));
await fa.accounts.setAccountActive(wallet.id!, isActive: false);
await fa.accounts.deleteAccount(wallet.id!); // فقط إن لم يكن عليه قيود أو أبناء
```

### 2. القيود اليومية

```dart
// مسودة
final draft = await fa.journalEntries.createEntry(JournalEntryModel(
  date: DateTime.now(),
  description: 'دفع إيجار',
  reference: 'RENT-01',
  lines: [
    JournalEntryLineModel.debitLine(accountId: rentId, amount: 3000),
    JournalEntryLineModel.creditLine(accountId: cashId, amount: 3000),
  ],
));

await fa.journalEntries.updateEntry(draft.copyWith(description: 'إيجار مارس'));
final posted = await fa.journalEntries.postEntry(draft.id!, postedBy: 'ahmed');

// أو إنشاء وترحيل في خطوة ذرّية واحدة
await fa.journalEntries.createAndPost(entry, postedBy: 'ahmed');

// عكس قيد مرحّل
final reversal = await fa.journalEntries.reverseEntry(
  posted.id!,
  reversalDate: DateTime.now(),
);

// الاستعلام
await fa.journalEntries.getEntryById(id);
await fa.journalEntries.getEntryBySerial('JV-2026-0001');
await fa.journalEntries.getEntriesByStatus(EntryStatus.draft);
await fa.journalEntries.getEntriesInDateRange(from, to); // يشمل كامل يوم النهاية
await fa.journalEntries.getEntriesByReference('INV-15');
fa.journalEntries.watchAllEntries(); // Stream
```

### 3. الباني `JournalEntryBuilder`

أسهل طريقة لبناء قيد — يقبل **معرّفات** أو **رموز** الحسابات، ويعطيك معلومات التوازن أثناء الإدخال:

```dart
final builder = JournalEntryBuilder(description: 'شراء بضاعة', date: DateTime.now())
  .reference('PO-88')
  .type(EntryType.purchaseAgil)
  .source('purchase_order', 88)
  .createdBy('ahmed')
  .notes('دفعة أولى')
  .debitCode('115', 8000)                        // المخزون
  .debitCode('215', 1200, description: 'ضريبة')  // ضريبة المدخلات
  .creditCode('211', 9200);                      // الموردون

builder.totalDebits;   // 9200
builder.isBalanced;    // true
builder.difference;    // 0

await fa.record(builder);                          // حل الرموز + إنشاء + ترحيل (ذرّي)
await fa.record(builder, post: false);             // حفظ كمسودة فقط
final model = await builder.resolve(fa.accounts);  // JournalEntryModel بدون حفظ
final model2 = builderWithIdsOnly.build();         // إن كانت كل البنود بالمعرّفات
```

### 4. الربط بمستندات نظامك

اربط كل قيد بمستنده (فاتورة، سند، طلب...) لتتمكن من إيجاده وعكسه لاحقاً:

```dart
await fa.record(
  JournalEntryBuilder(description: 'فاتورة 15').source('invoice', 15)
    .debitCode('113', 1000).creditCode('41', 1000),
);

// جلب كل قيود الفاتورة
final entries = await fa.journalEntries.getEntriesBySource('invoice', '15');

// إلغاء الفاتورة: عكس كل قيودها المرحّلة (ذرّي، وآمن للتكرار)
await fa.reverseSource('invoice', 15, postedBy: 'ahmed');

// عدة عمليات معاً: إما أن تنجح كلها أو تُلغى كلها
await fa.transaction(() async {
  await fa.reverseSource('invoice', 15);
  await fa.record(correctedInvoiceEntry);
});
```

### 5. الفترات المحاسبية

```dart
await fa.periods.createFiscalYear(2026);                 // فترة سنوية
await fa.periods.createFiscalYear(2026, monthly: true);  // 12 فترة شهرية
await fa.periods.ensureOpenPeriodFor(DateTime.now());    // أنشئ عند الحاجة

await fa.periods.createPeriod(AccountingPeriodModel(
  name: 'الربع الأول', startDate: DateTime(2027, 1, 1), endDate: DateTime(2027, 3, 31),
)); // نهاية الفترة تشمل كامل يوم 31 مارس

await fa.periods.closePeriod(id);   // يُرفض إن وُجدت مسودات
await fa.periods.reopenPeriod(id);
await fa.periods.deletePeriod(id);  // فقط إن لم تحتوِ قيوداً
await fa.periods.getPeriodForDate(DateTime.now());
```

### 6. التقارير

كل التقارير تعتمد على **القيود المرحّلة فقط** (المسودات مستبعدة)، وتعمل على مستوى اليوم
(`to` / `asOf` يشملان كامل اليوم).

```dart
final now = DateTime.now();

// ميزان المراجعة (الافتراضي: من بداية السنة حتى اليوم)
final tb = await fa.reports.getTrialBalance(from: DateTime(now.year), to: now);
tb.isBalanced; tb.totalDebitBalances; tb.totalCreditBalances;
for (final r in tb.rows) {
  print('${r.accountCode} ${r.displayName}  مدين: ${r.debitBalance}  دائن: ${r.creditBalance}');
}

// قائمة الدخل
final income = await fa.reports.getIncomeStatement(from: DateTime(now.year), to: now);
income.totalRevenue; income.totalExpenses; income.netIncome; income.isProfitable;

// الميزانية العمومية (الأرباح المحتجزة محسوبة تلقائياً)
final bs = await fa.reports.getBalanceSheet(asOf: now);
bs.totalAssets; bs.totalLiabilities; bs.totalEquity; bs.retainedEarnings; bs.isBalanced;

// رصيد حساب (يجمع الحسابات الفرعية افتراضياً)
final receivables = await fa.reports.getAccountBalance(customersId, asOf: now);

// كشف حساب مع رصيد افتتاحي وتراكمي
final ledger = await fa.reports.getAccountLedger(cashId, from: DateTime(now.year, now.month), to: now);
print('افتتاحي: ${ledger.openingBalance}');
for (final l in ledger.lines) {
  print('${l.date} ${l.serialNumber} ${l.description}  ${l.debit} / ${l.credit}  = ${l.runningBalance}');
}
print('ختامي: ${ledger.closingBalance}');
```

كل صفوف التقارير توفّر `accountName` (إنجليزي) و`accountNameAr` و`displayName` (العربي إن وُجد).

### 7. القوالب

```dart
// قالب قياسي
final draft = await fa.templates.applyTemplate(
  template: StandardTemplates.cashSale,
  accountIdMap: {'Cash/Bank Account': cashId, 'Sales Revenue Account': salesId},
  totalAmount: 1500,
);
await fa.journalEntries.createAndPost(draft);

// قالب مخصص يُحفظ في قاعدة البيانات
await fa.templates.saveTemplate(const EntryTemplateModel(
  name: 'بيع مع ضريبة 15%',
  type: EntryType.sale,
  lines: [
    EntryTemplateLineModel(isDebit: true,  label: 'الصندوق',  accountType: AccountType.asset,     defaultRatio: 1.15),
    EntryTemplateLineModel(isDebit: false, label: 'المبيعات', accountType: AccountType.revenue,   defaultRatio: 1.0),
    EntryTemplateLineModel(isDebit: false, label: 'الضريبة',  accountType: AccountType.liability, defaultRatio: 0.15),
  ],
));
final custom = await fa.templates.getCustomTemplates();
```

القوالب القياسية: `cashSale`, `cashPurchase`, `creditSale`, `creditPurchase`,
`paymentVoucher` (سند صرف), `receiptVoucher` (سند قبض), `journalEntry`.

- يمكن تثبيت حساب في بند القالب عبر `accountId` فلا يحتاج إلى إدخال في الخريطة.
- `accountType` في البند يُتحقق منه عند التطبيق.
- يُرفض القالب غير المتوازن (مجموع نسب المدين ≠ الدائن).

### 8. الإعدادات

```dart
await FlutterAccounting.initialize(
  databaseName: 'accounting.db',
  databaseDirectory: '/custom/path',          // اختياري
  seedDefaultAccounts: true,
  config: const AccountingConfig(
    requireOpenPeriod: true,   // اشتراط فترة مفتوحة لكل قيد
    serialPrefix: 'JV',        // JV-2026-0001
    serialPadding: 4,
    enableCostCenters: false,  // تفعيل مراكز التكلفة (القسم 9)
    allocationDecimals: 2,     // منازل تقريب الحصص عند التوزيع
    multiCurrency: null,       // MultiCurrencyConfig(baseCurrency: 'SAR') — القسم 10
    branches: null,            // BranchConfig() — القسم 11
  ),
);
```

### 9. مراكز التكلفة (اختيارية)

تتبّع الربحية حسب **الفرع والمشروع والقسم**، أو أي بُعد تعرّفه بنفسك. الميزة **موقوفة افتراضياً**، وكل ما فيها اختياري: فعّلها، ولن يصبح شيء إلزامياً إلا ما تجعله أنت إلزامياً.

**التفعيل**

```dart
await FlutterAccounting.initialize(
  config: const AccountingConfig(enableCostCenters: true),
  seedDefaultCostDimensions: true, // اختياري: الفرع، المشروع، القسم
);
```

**الأبعاد والمراكز** (المراكز شجرة هرمية مثل دليل الحسابات)

```dart
final region = await fa.costCenters.ensureDimension(code: 'REGION', name: 'Region', nameAr: 'المنطقة'); // بُعد خاص
await fa.costCenters.ensureCostCenter(dimensionCode: 'BRANCH', code: 'BR-WEST', name: 'West', nameAr: 'المنطقة الغربية');
await fa.costCenters.ensureCostCenter(
    dimensionCode: 'BRANCH', code: 'BR-JED', name: 'Jeddah', nameAr: 'فرع جدة', parentCode: 'BR-WEST');
```

**توزيع البنود**: مركز من كل بُعد، أو تقسيم داخل البعد بالنسبة أو بالمبلغ أو بمفتاح توزيع محفوظ. فرق التقريب يُحمَّل على آخر حصة، فيبقى المجموع مساوياً لمبلغ البند دائماً.

```dart
await fa.record(
  JournalEntryBuilder(description: 'إيجار مشترك')
    .debitCode('53', 10000, allocations: [
      CostAllocationModel.percent('BR-RYD', 60),
      CostAllocationModel.percent('BR-JED', 40),
      CostAllocationModel.code('DEP-ADMIN'),     // 100% للإدارة (بُعد آخر)
    ])
    .creditCode('111', 10000),
);

// أو بمفتاح توزيع محفوظ (مثلاً حسب المساحة: الرياض 300 / جدة 200)
.debitCode('53', 10000, allocationKey: 'AREA')
```

**السياسات (اختيارية)**: اجعل البعد إلزامياً أو ممنوعاً لحساب (مع حساباته الفرعية) أو لنوع حساب، وحدّد مركزاً افتراضياً يُطبَّق تلقائياً:

```dart
await fa.costCenters.setRule(DimensionRuleModel.forType(
  dimensionId: department.id!,
  accountType: AccountType.expense,
  policy: DimensionPolicy.required,     // كل مصروف يجب أن يحدد القسم
));
await fa.costCenters.setRule(DimensionRuleModel.forAccount(
  dimensionId: branch.id!,
  accountId: jeddahRentId,
  defaultCostCenterId: jeddah.id,       // يُملأ تلقائياً إن لم يُحدَّد
));
```

الأولوية: قاعدة الحساب، ثم أقرب حساب أب، ثم نوع الحساب، ثم `defaultPolicy` للبعد. البعد الموقوف لا تُطبَّق سياساته، والمركز الموقوف أو الأب لا يقبل توزيعاً جديداً. القيد العكسي ينسخ توزيع القيد الأصلي.

**التوزيع الدوري** لتكاليف مركز خدمي على المراكز الأخرى:

```dart
final request = CostAllocationRequest(
  sourceCostCenterId: hq.id!, allocationKeyId: headcountKey.id!,
  from: DateTime(2026, 1, 1), to: DateTime(2026, 1, 31),
);
final preview = await fa.costAllocations.previewAllocation(request); // معاينة بدون حفظ
final entry = await fa.costAllocations.runAllocation(request);       // قيد مرحّل قابل للعكس
```

**التقارير** عبر `fa.costReports`:

| الدالة | يُعيد |
|--------|-------|
| `getSummary(dimensionId:)` | إيرادات ومصروفات وصافي ربح كل مركز (تجميع هرمي) + غير الموزّع |
| `getComparison(dimensionId:, costCenterIds?)` | جدول الحسابات × المراكز |
| `getIncomeStatement(filter:, from:, to:)` | قائمة الدخل لمركز أو أكثر |
| `getTrialBalance(filter:)` | ميزان المراجعة لمركز أو أكثر |
| `getLedger(costCenterId, {accountId})` | كشف حساب المركز برصيد افتتاحي وتراكمي |
| `getMatrix(rowDimensionId:, columnDimensionId:)` | تحليل متقاطع، مثل الفروع × المشاريع |
| `getUnallocatedLines(dimensionId:)` | البنود التي بلا مركز (لضبط جودة البيانات) |

الفلتر `CostCenterFilter([ryd.id!, prjA.id!])` يقاطع الأبعاد بالتناسب (بند 60% للرياض و50% لمشروع A يساهم بـ 30%)، والمراكز من نفس البعد تُجمع معاً.

### 10. تعدد العملات (اختياري)

سجّل العمليات بأي عملة. كل بند يحفظ **مبلغه الأصلي وسعر الصرف**، ويُحوَّل إلى **عملة الأساس** في المدين والدائن، فتبقى كل التقارير المالية بعملة واحدة. المبالغ تُقرَّب حسب منازل كل عملة (الدينار الكويتي 3، الين 0)، وهو نفس أسلوب Odoo وERPNext.

```dart
await FlutterAccounting.initialize(
  seedDefaultAccounts: true,            // يشمل 45 أرباح فروقات العملة و50 خسائرها
  seedDefaultCurrencies: true,          // SAR, USD, EUR, KWD, ...
  config: const AccountingConfig(
    multiCurrency: MultiCurrencyConfig(baseCurrency: 'SAR'),
  ),
);

// الأسعار يدخلها المستخدم (وحدات الأساس لكل وحدة)، ويُطبق آخر سعر في تاريخ القيد أو قبله
await fa.currencies.setExchangeRate('USD', 3.75, date: DateTime(2026, 1, 1));

// اختياري: ربط حساب بعملة (بنك أو مورد بالدولار)
await fa.accounts.createAccount(AccountModel.create(
    code: '2111', name: 'Supplier (USD)', nameAr: 'مورد (دولار)',
    type: AccountType.liability, parentId: payablesId, currencyCode: 'USD'));

await fa.record(JournalEntryBuilder(description: 'فاتورة مورد أمريكي')
  .currency('USD')              // أو .currency('USD', rate: 3.76)
  .debitCode('51', 1000)        // 1000 دولار = 3750 ريال
  .creditCode('2111', 1000));
```

- عملة الأساس تُثبَّت في قاعدة البيانات ولا يمكن تغييرها بعد تسجيل قيود (`BaseCurrencyMismatchException`).
- فروقات التقريب الصغيرة الناتجة عن التحويل (حتى `roundingTolerance`) تُسجل تلقائياً على حساب التقريب أو الفروقات.
- `fa.currencies.getAccountCurrencyBalance(id)` و`getAccountCurrencyLedger(id)` تعرض الحساب بعملته وبعملة الأساس.

**الفروقات المحققة**: عند تسوية مبلغ أجنبي، يُسجَّل تلقائياً الفرق بين السعر الدفتري (متوسط سعر الحساب افتراضياً) وسعر السداد:

```dart
await fa.exchangeDifferences.settle(SettlementRequest(
  accountId: usdCustomerId, amount: 1000, rate: 3.70,
  counterAccountId: bankId, date: DateTime.now(),
));  // فاتورة بسعر 3.75 وتحصيل بسعر 3.70 → خسارة 50
```

**إعادة التقييم في نهاية الفترة (غير المحققة)** لحسابات الأصول والخصوم، مع معاينة وعكس تلقائي:

```dart
final preview = await fa.exchangeDifferences.previewRevaluation(
    RevaluationRequest(asOf: DateTime(2026, 6, 30)));
final result = await fa.exchangeDifferences.runRevaluation(RevaluationRequest(
    asOf: DateTime(2026, 6, 30), autoReverseOn: DateTime(2026, 7, 1)));
// result.realizedEntry (حسابات صار رصيدها بالعملة صفراً؛ لا يُعكس)
// result.unrealizedEntry + result.reversalEntry
```

`getForeignCurrencyBalances(asOf:)` يعرض رصيد كل حساب بكل عملة، وقيمته الدفترية، وقيمته بالسعر الحالي، والفرق.

### 11. الفروع (اختيارية)

الفروع **وحدات محاسبية**: كل قيد ينتمي لفرع واحد، فيكون لكل فرع ميزان مراجعة وميزانية متوازنة.

```dart
await FlutterAccounting.initialize(
  config: const AccountingConfig(branches: BranchConfig(
    requireBranch: false,        // جعل الفرع إلزامياً في كل قيد
    serialPerBranch: false,      // ترقيم JV-RYD-2026-0001
    interBranchParentCode: '11', // الأب لحسابات جاري الفروع المنشأة تلقائياً
    linkCostCenters: true,       // نسبة القيد تلقائياً لمركز تكلفة الفرع
  )),
);

final jed = await fa.branches.ensureBranch(code: 'JED', name: 'Jeddah', nameAr: 'فرع جدة'); // ينشئ حساب IB-JED
await fa.record(JournalEntryBuilder(description: 'بيع').branch('JED')
  .debitCode('111', 500).creditCode('41', 500));

// كل التقارير الحالية تقبل branchIds
await fa.reports.getBalanceSheet(asOf: now, branchIds: [jed.id!]);
```

- **المعاملات بين الفروع**: `fa.branches.recordInterBranch(InterBranchTransaction(...))` تسجل قيداً في كل فرع عبر حسابات جاري الفروع، وتُعكس معاً بـ `fa.reverseSource(SystemSources.interBranch, id)`.
- **الضوابط**: `restrictAccount(accountId, [branchIds])` لتقييد حساب بفروع (يسري على حساباته الفرعية)، و`closePeriod(periodId, branchId)` لإقفال فترة لفرع واحد.
- **التقارير** (`fa.branchReports`): `getComparison()` (قائمة دخل ومركز مالي لكل فرع، مع القيود التي بلا فرع)، و`getConsolidatedTrialBalance()` / `getConsolidatedBalanceSheet()` (باستبعاد حسابات جاري الفروع)، و`getInterBranchReconciliation()`.

---

## دليل التكامل مع نظامك 🔌

الدليل الكامل: **[doc/INTEGRATION.md](doc/INTEGRATION.md)** — يشمل النمط المعماري المقترح،
وصفات قيود جاهزة لأكثر العمليات شيوعاً، الإلغاء والتعديل، حسابات العملاء الفرعية،
حقن الاعتماديات (get_it / Riverpod / Provider)، اختبار التكامل، وقائمة تحقق قبل الإطلاق.

**الملخص:**

1. `FlutterAccounting.initialize(...)` مرة واحدة.
2. اجمع رموز حساباتك في ملف واحد (`AppAccounts`).
3. أنشئ **خدمة محاسبية** واحدة تحوّل أحداث نظامك إلى `fa.record(...)` مع `.source(type, id)`.
4. عند الإلغاء: `fa.reverseSource(type, id)`.
5. التقط `AccountingException` واعرض `e.message`.

المثال الكامل في [`example/`](example/): خدمة مبيعات ([`sales_accounting_service.dart`](example/lib/sales_accounting_service.dart))،
شاشات القيود والتقارير وكشف الحساب، واختبار للخدمة.

---

## مرجع الـ API 📘

### `FlutterAccounting`

| العضو | الوصف |
|-------|-------|
| `initialize({databaseName, databaseDirectory, customExecutor, config, seedDefaultAccounts})` | تهيئة المكتبة وتسجيل النسخة العامة |
| `instance` / `isInitialized` | الوصول للنسخة (`StateError` إن لم تُهيّأ) |
| `forTesting({config})` | نسخة بقاعدة في الذاكرة |
| `accounts` / `journalEntries` / `reports` / `templates` / `periods` | المستودعات |
| `record(builder, {post, postedBy})` | إنشاء (وترحيل) قيد من باني |
| `reverseSource(type, id, {reversalDate, postedBy})` | عكس كل قيود مستند |
| `transaction(action)` | تنفيذ عمليات متعددة ذرّياً |
| `dispose()` | إغلاق قاعدة البيانات |

### `IAccountRepository` — `fa.accounts`

| الدالة | الوصف |
|--------|-------|
| `getAllAccounts()` / `getActiveAccounts()` | كل الحسابات / النشطة |
| `getAccountById(id)` / `getAccountByCode(code)` | حساب واحد |
| `getAccountsByType(type)` / `getChildAccounts(parentId)` | تصفية |
| `getPostableAccounts({type})` | الحسابات النهائية النشطة (للاختيار في القيود) |
| `searchAccounts(query)` | بحث بالرمز أو الاسم |
| `hasChildren(id)` / `hasTransactions(id)` / `countAccounts()` | استعلامات مساعدة |
| `watchAllAccounts()` | Stream |
| `createAccount(model)` / `updateAccount(model)` | إنشاء / تعديل (مع حماية الشجرة) |
| `ensureAccount({code, name, type, parentId, parentCode, ...})` | إنشاء إن لم يوجد |
| `setAccountActive(id, isActive:)` / `deleteAccount(id)` | تفعيل / حذف |

### `IJournalEntryRepository` — `fa.journalEntries`

| الدالة | الوصف |
|--------|-------|
| `getAllEntries()` / `getEntryById(id)` / `getEntryBySerial(serial)` | القراءة |
| `getEntriesByStatus(status)` / `getEntriesInDateRange(from, to)` | تصفية |
| `getEntriesByReference(ref)` / `getEntriesBySource(type, id)` | البحث بالمرجع / المستند |
| `watchAllEntries()` | Stream |
| `createEntry(entry)` | إنشاء مسودة (أو مرحّل إن مُرِّرت الحالة `posted`) |
| `updateEntry(entry)` / `deleteEntry(id)` | للمسودات فقط |
| `postEntry(id, {postedBy})` | ترحيل |
| `createAndPost(entry, {postedBy})` | إنشاء + ترحيل ذرّياً |
| `reverseEntry(id, {reversalDate, description, postedBy})` | عكس ذرّي |

### `IReportsRepository` — `fa.reports`

| الدالة | يُعيد |
|--------|-------|
| `getTrialBalance({from, to})` | `TrialBalanceReport` |
| `getIncomeStatement({from, to})` | `IncomeStatementReport` |
| `getBalanceSheet({asOf})` | `BalanceSheetReport` |
| `getAccountBalance(id, {asOf, includeChildren})` | `double` بالاتجاه الطبيعي |
| `getAccountLedger(id, {from, to, includeChildren})` | `AccountLedgerReport` |

### `ICostCenterRepository` — `fa.costCenters`

| الدالة | الوصف |
|--------|-------|
| `getDimensions()` / `createDimension(d)` / `updateDimension(d)` / `ensureDimension(...)` | الأبعاد (فرع، مشروع...) |
| `setDimensionActive(id, isActive:)` / `deleteDimension(id)` | إيقاف بُعد أو حذف بُعد فارغ |
| `getCostCenters({dimensionId})` / `getPostableCostCenters({dimensionId})` / `searchCostCenters(q)` | قراءة المراكز (القابلة للتوزيع = النهائية النشطة) |
| `createCostCenter(c)` / `updateCostCenter(c)` / `ensureCostCenter(...)` | إدارة شجرة المراكز |
| `setCostCenterActive(id, isActive:)` / `deleteCostCenter(id)` / `hasTransactions(id)` | دورة حياة المركز |
| `getRules()` / `setRule(rule)` / `deleteRule(id)` / `getEffectivePolicy(...)` | السياسات والمراكز الافتراضية |
| `getAllocationKeys()` / `saveAllocationKey(k)` / `deleteAllocationKey(id)` / `splitByKey(id, amount)` | مفاتيح التوزيع |

### `ICostAllocationRepository` — `fa.costAllocations`

| الدالة | الوصف |
|--------|-------|
| `previewAllocation(request)` | معاينة التوزيع الدوري بدون حفظ |
| `runAllocation(request, {post, postedBy})` | إنشاء قيد `EntryType.costAllocation` |

### `ICurrencyRepository` — `fa.currencies`

| الدالة | الوصف |
|--------|-------|
| `getCurrencies()` / `createCurrency(c)` / `updateCurrency(c)` / `ensureCurrency(...)` / `setCurrencyActive(...)` | العملات |
| `ensureBaseCurrency()` / `baseCurrencyCode` | عملة الأساس (مثبّتة في قاعدة البيانات) |
| `setExchangeRate(code, rate, {date})` / `getExchangeRates(...)` / `getExchangeRate(code, {date})` | أسعار الصرف |
| `convert(amount, from:, to:, date:)` | التحويل عبر عملة الأساس |
| `getAccountCurrencyBalance(id)` / `getAccountCurrencyLedger(id)` | الحساب بعملته وبعملة الأساس |

### `IExchangeDifferenceRepository` — `fa.exchangeDifferences`

| الدالة | الوصف |
|--------|-------|
| `settle(SettlementRequest)` | تسوية مع الفرق المحقق |
| `previewRevaluation(request)` / `runRevaluation(request)` | إعادة التقييم في نهاية الفترة |
| `getForeignCurrencyBalances({asOf})` | أرصدة العملات الأجنبية وفروقاتها غير المحققة |

### `IBranchRepository` — `fa.branches` / `IBranchReportsRepository` — `fa.branchReports`

| الدالة | الوصف |
|--------|-------|
| `getBranches()` / `createBranch(b)` / `updateBranch(b)` / `ensureBranch(...)` / `setBranchActive(...)` / `deleteBranch(id)` | الفروع |
| `restrictAccount(accountId, branchIds)` / `closePeriod(periodId, branchId)` | ضوابط الفروع |
| `recordInterBranch(transaction)` | قيدان مرتبطان عبر حسابات جاري الفروع |
| `getComparison()` / `getConsolidatedTrialBalance()` / `getConsolidatedBalanceSheet(asOf:)` / `getInterBranchReconciliation()` | تقارير الفروع |

### `IAccountingPeriodRepository` — `fa.periods`

| الدالة | الوصف |
|--------|-------|
| `getAllPeriods()` / `getPeriodById(id)` / `getPeriodForDate(date)` | القراءة |
| `createPeriod(p)` / `updatePeriod(p)` / `deletePeriod(id)` | الإدارة (مع منع التداخل) |
| `closePeriod(id)` / `reopenPeriod(id)` | الإقفال |
| `createFiscalYear(year, {monthly})` | سنة مالية كاملة |
| `ensureOpenPeriodFor(date)` | فترة مفتوحة للتاريخ (تُنشأ عند الحاجة) |

### `IEntryTemplateRepository` — `fa.templates`

| الدالة | الوصف |
|--------|-------|
| `getStandardTemplates()` | القوالب المدمجة |
| `getCustomTemplates()` / `saveTemplate(t)` / `deleteTemplate(id)` | القوالب المخصصة (محفوظة) |
| `applyTemplate({template, accountIdMap, totalAmount, date, description, reference})` | ينتج مسودة قيد |

### أدوات مساعدة

| العنصر | الوصف |
|--------|-------|
| `AccountingValidator.validateEntryLines(lines)` | يرمي استثناء عند الخطأ |
| `AccountingValidator.checkEntryLines(lines)` | يُعيد رسالة الخطأ أو `null` (للواجهات) |
| `AccountModel.create(...)` | إنشاء نموذج حساب بدون تواريخ |
| `JournalEntryLineModel.debitLine(...)` / `.creditLine(...)` | بنود جاهزة |
| `toMap()` / `fromMap()` | في `AccountModel`, `JournalEntryModel`, `JournalEntryLineModel`, `AccountingPeriodModel`, `EntryTemplateModel` |
| `AccountType.displayNameAr` / `EntryStatus.displayNameAr` / `EntryType.displayNameAr` | أسماء عربية للعرض |

---

## القواعد المحاسبية المدمجة ⚖️

| القاعدة | الاستثناء |
|---------|-----------|
| `Σ مدين = Σ دائن` | `UnbalancedEntryException` |
| بند مدين وبند دائن على الأقل | `InsufficientLinesException` |
| لا مبالغ صفرية | `ZeroAmountLineException` |
| لا مبالغ سالبة | `NegativeAmountException` |
| البند مدين أو دائن وليس الاثنين | `InvalidLineAmountsException` |
| الحساب موجود ونشط | `AccountNotFoundException` / `InactiveAccountException` |
| لا تسجيل على حساب أب | `AccountIsParentException` |
| لا تعديل/حذف للقيد المرحّل | `CannotModifyPostedEntryException` |
| لا ترحيل لمعكوس، لا عكس لمسودة | `InvalidEntryStateException` |
| لا عكس مرتين | `EntryAlreadyReversedException` |
| التاريخ في فترة مفتوحة | `PeriodClosedException` / `DateOutsidePeriodException` |
| رقم قيد فريد | `DuplicateSerialNumberException` |
| رمز حساب فريد | `DuplicateAccountCodeException` |
| الحساب الفرعي بنفس نوع الأب | `AccountTypeMismatchException` |
| لا أبناء تحت حساب عليه قيود | `ParentAccountHasTransactionsException` |
| لا دورات في الشجرة | `InvalidAccountHierarchyException` |
| لا تغيير لنوع حساب مستخدم | `CannotChangeAccountTypeException` |
| لا حذف لحساب عليه قيود أو أبناء | `AccountHasTransactionsException` / `AccountHasChildrenException` |
| الفترات لا تتداخل وبدايتها قبل نهايتها | `PeriodOverlapException` / `InvalidPeriodException` |
| لا إقفال لفترة بها مسودات | `PeriodHasDraftEntriesException` |
| القالب متوازن وصالح | `InvalidTemplateException` |

---

## الاستثناءات 🚨

كل الاستثناءات ترث من `AccountingException` (sealed class) ولها `message` عربية جاهزة للعرض:

```dart
try {
  await fa.record(builder);
} on UnbalancedEntryException catch (e) {
  print('الفرق: ${e.totalDebits - e.totalCredits}');
} on AccountingException catch (e) {
  showSnackBar(e.message);
}
```

---

## الاختبار 🧪

```bash
flutter test                 # اختبارات المكتبة
cd example && flutter test   # اختبار خدمة المثال
```

```dart
setUp(() async {
  fa = FlutterAccounting.forTesting();                 // قاعدة في الذاكرة
  await AccountingSeedData.seed(fa.accounts);
  await fa.periods.ensureOpenPeriodFor(DateTime.now());
});
tearDown(() => fa.dispose());
```

---

## الترقية من 0.5.x ⬆️

- **ترقية تلقائية للمخطط v4 وv5** تضيف جداول وأعمدة العملات والفروع. البنود الحالية تُعتبر بعملة الأساس، والقيود الحالية بلا فرع.
- الميزتان موقوفتان افتراضياً (`multiCurrency: null` و`branches: null`).
- أُضيف معامل اختياري `branchIds` لدوال `IReportsRepository`. إن كنت تطبّق الواجهة بنفسك (مثل الـ mocks)، أضفه.
- أُضيفت القيمة `EntryType.exchangeDifference`، وأُضيف للدليل الجاهز الحسابان `45` (أرباح فروقات العملة) و`50` (خسائرها).

## الترقية من 0.4.x ⬆️

- **ترقية تلقائية للمخطط v3** تضيف جداول مراكز التكلفة، دون المساس بالبيانات الحالية.
- مراكز التكلفة **موقوفة افتراضياً**، فلا يتغير شيء حتى تفعّل `AccountingConfig(enableCostCenters: true)`.
- أُضيفت القيمة `EntryType.costAllocation` في نهاية التعداد؛ إن كنت تستخدم `switch` على `EntryType` فأضف حالتها.
- أُضيف إلى `FlutterAccounting` كلٌّ من `costCenters` و`costAllocations` و`costReports`، وإلى `JournalEntryLineModel` الحقل `allocations` (فارغ افتراضياً).

## الترقية من 0.3.x ⬆️

- **ترقية قاعدة البيانات تلقائية** (المخطط v1 → v2) عند أول فتح؛ البيانات الحالية محفوظة.
- **التقارير أصبحت صحيحة**: كانت تحتسب المسودات وتتجاهل فلترة التاريخ — قد تختلف الأرقام عن السابق (الأرقام الجديدة هي الصحيحة).
- `TrialBalanceRow.balance`: موجب = مدين، سالب = دائن لكل الأنواع (كما في التوثيق).
- `applyTemplate` يرمي `InvalidTemplateException` / `AccountNotFoundException` بدلاً من `ArgumentError`.
- `updateEntry` لم يعد يغيّر حالة القيد؛ استخدم `postEntry`.
- `AccountModel.isParent` مُهمل (كان يعني "جذري")؛ استخدم `isRoot` أو `accounts.hasChildren(id)`.
- الواجهات المجردة أضيفت لها دوال جديدة؛ إن كنت تطبّقها بنفسك (Mocks) أضف الدوال الجديدة.
- إن كان لديك فترات متداخلة من قبل فستستمر بالعمل، لكن لن يُسمح بإنشاء تداخل جديد.

التفاصيل الكاملة في [CHANGELOG](CHANGELOG.md).

---

## بنية المشروع 🏗️

```
lib/
├── flutter_accounting.dart            ← الـ Public API (استورد هذا فقط)
└── src/
    ├── flutter_accounting_init.dart   ← FlutterAccounting (نقطة الدخول)
    ├── core/
    │   ├── enums.dart                 ← AccountType, EntryStatus, EntryType
    │   ├── exceptions.dart            ← AccountingException وأنواعها
    │   ├── accounting_validator.dart  ← قواعد القيد المزدوج
    │   ├── accounting_config.dart     ← AccountingConfig
    │   ├── journal_entry_builder.dart ← JournalEntryBuilder
    │   ├── standard_templates.dart    ← القوالب القياسية
    │   └── date_utils.dart            ← (داخلي) حدود الأيام
    ├── models/                        ← نماذج Dart نقية
    ├── reports/                       ← نماذج التقارير (المالية ومراكز التكلفة)
    ├── repositories/
    │   ├── interfaces/interfaces.dart ← العقود المجردة
    │   └── impl/                      ← التنفيذ
    ├── database/                      ← Drift (داخلي): tables, daos, mappers
    └── seed/                          ← دليل الحسابات والأبعاد الافتراضية
doc/
└── INTEGRATION.md                     ← دليل التكامل
example/                               ← تطبيق مثال كامل + اختبار
```

### للمساهمين: توليد كود Drift

```bash
dart run build_runner build --delete-conflicting-outputs
```

عند تعديل الجداول: ارفع `schemaVersion` في `accounting_database.dart` وأضف خطوة الترقية في `onUpgrade`
واختبرها في `test/migration_test.dart`.

---

## أسئلة شائعة ❓

**هل أستطيع استخدام أرقام حسابات خاصة بي؟**
نعم. الدليل الافتراضي اختياري. أنشئ دليلك بـ `ensureAccount` / `createAccount`.

**كيف أعدّل فاتورة مرحّلة؟**
اعكس قيودها ثم سجّل الجديدة داخل `fa.transaction`. انظر [دليل التكامل §6](doc/INTEGRATION.md#6-الإلغاء-والتعديل-بعد-الترحيل).

**لماذا رُفض قيدي بـ `DateOutsidePeriodException`؟**
لا توجد فترة تغطي تاريخه. استدعِ `fa.periods.ensureOpenPeriodFor(date)` أو استخدم `requireOpenPeriod: false`.

**هل تدعم عملات متعددة / مراكز تكلفة؟**
ليس بعد. المبالغ رقم واحد بعملة واحدة. (مخطط لها مستقبلاً.)

**كيف تُخزَّن المبالغ؟**
كأرقام `double` مع هامش تسامح `0.001` في التوازن. قرّب المبالغ في تطبيقك لمنزلتين عشريتين قبل التسجيل.

---

## الترخيص

MIT License © 2026
