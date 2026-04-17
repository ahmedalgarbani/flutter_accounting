# flutter_accounting 📊

مكتبة Flutter أوفلاين للمحاسبة بنظام القيد المزدوج (Double-Entry Bookkeeping).

---

## المميزات ✨

- ✅ **القيد المزدوج** — تحقق تلقائي من التوازن `Σ مدين = Σ دائن`
- ✅ **دليل الحسابات** — هرمي متعدد المستويات مع الأنواع الخمسة
- ✅ **القيود اليومية** — إنشاء / تعديل / ترحيل / عكس
- ✅ **3 تقارير مالية** — ميزان المراجعة، الميزانية العمومية، قائمة الأرباح والخسائر
- ✅ **Drift (SQLite)** — أوفلاين بالكامل، type-safe، يدعم WAL
- ✅ **Clean Architecture** — Models + Repository + DAO منفصلة
- ✅ **دليل حسابات جاهز** — 40+ حساب عربي/إنجليزي يمكن زرعه بسطر واحد

---

## التثبيت 📦

```yaml
# pubspec.yaml
dependencies:
  flutter_accounting:
    path: ../flutter_accounting  # أو من pub.dev عند النشر
```

---

## البدء السريع 🚀

### 1. التهيئة

```dart
import 'package:flutter_accounting/flutter_accounting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المكتبة (مرة واحدة عند بدء التطبيق)
  await FlutterAccounting.initialize(
    databaseName: 'my_app_accounting.db',
  );

  // اختياري: زرع دليل الحسابات الافتراضي
  // await AccountingSeedData.seed(FlutterAccounting.instance.accounts);

  runApp(const MyApp());
}
```

### 2. إنشاء حسابات

```dart
final fa = FlutterAccounting.instance;

// إنشاء حساب رئيسي
final cashAccount = await fa.accounts.createAccount(AccountModel(
  code:      '111',
  name:      'Cash',
  nameAr:    'الصندوق',
  type:      AccountType.asset,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
));

// إنشاء حساب إيرادات
final revenueAccount = await fa.accounts.createAccount(AccountModel(
  code:      '41',
  name:      'Sales Revenue',
  nameAr:    'إيرادات المبيعات',
  type:      AccountType.revenue,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
));
```

### 3. إنشاء قيد يومي وترحيله

```dart
// إنشاء القيد كمسودة
final entry = await fa.journalEntries.createEntry(JournalEntryModel(
  date:        DateTime.now(),
  description: 'قيد مبيعات نقدية',
  reference:   'INV-001',
  status:      EntryStatus.draft,
  lines: [
    JournalEntryLineModel.debitLine(
      accountId:   cashAccount.id!,
      amount:      5000,
      description: 'استلام نقدي من العميل',
    ),
    JournalEntryLineModel.creditLine(
      accountId:   revenueAccount.id!,
      amount:      5000,
      description: 'إيراد مبيعات',
    ),
  ],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
));

// ترحيل القيد (يُجري التحقق من التوازن تلقائياً)
final posted = await fa.journalEntries.postEntry(entry.id!);
print(posted.status); // EntryStatus.posted
```

### 4. القيد العكسي (Reversal)

```dart
// عكس قيد مرحّل (يُنشئ قيداً جديداً بالمبالغ معكوسة)
final reversal = await fa.journalEntries.reverseEntry(posted.id!);
print(reversal.description); // "عكس: قيد مبيعات نقدية"
```

### 5. التقارير المالية

```dart
final now       = DateTime.now();
final startYear = DateTime(now.year, 1, 1);

// ميزان المراجعة
final trialBalance = await fa.reports.getTrialBalance(
  from: startYear,
  to:   now,
);
print('متوازن: ${trialBalance.isBalanced}');
print('إجمالي المدين: ${trialBalance.totalDebitBalances}');

// الميزانية العمومية
final balanceSheet = await fa.reports.getBalanceSheet(asOf: now);
print('إجمالي الأصول: ${balanceSheet.totalAssets}');
print('إجمالي الخصوم: ${balanceSheet.totalLiabilities}');
print('حقوق الملكية: ${balanceSheet.totalEquity}');

// قائمة الأرباح والخسائر
final incomeStatement = await fa.reports.getIncomeStatement(
  from: startYear,
  to:   now,
);
print('الإيرادات: ${incomeStatement.totalRevenue}');
print('المصاريف: ${incomeStatement.totalExpenses}');
print('صافي الربح: ${incomeStatement.netIncome}');
```

---

## بنية المشروع 🏗️

```
lib/
├── flutter_accounting.dart          ← Public API (استورد هذا فقط)
└── src/
    ├── core/
    │   ├── enums.dart               ← AccountType, EntryStatus, NormalBalance
    │   ├── exceptions.dart          ← استثناءات مخصصة
    │   └── accounting_validator.dart← محرك التحقق من القيد المزدوج
    ├── models/                      ← Domain Models (Pure Dart)
    │   ├── account_model.dart
    │   ├── journal_entry_model.dart
    │   └── journal_entry_line_model.dart
    ├── reports/
    │   └── report_models.dart       ← TrialBalance, BalanceSheet, IncomeStatement
    ├── database/                    ← طبقة Drift (داخلية)
    │   ├── tables/tables.dart
    │   ├── daos/
    │   │   ├── accounts_dao.dart
    │   │   └── journal_entries_dao.dart
    │   ├── mappers/mappers.dart
    │   └── accounting_database.dart
    ├── repositories/
    │   ├── interfaces/interfaces.dart      ← Abstract contracts
    │   └── impl/
    │       ├── account_repository_impl.dart
    │       ├── journal_entry_repository_impl.dart
    │       └── reports_repository_impl.dart
    ├── seed/
    │   └── accounting_seed_data.dart  ← 40+ حساب جاهز
    └── flutter_accounting_init.dart   ← نقطة الدخول
```

---

## قواعد العمل المدمجة ⚖️

| القاعدة | التطبيق |
|---------|---------|
| `Σ مدين = Σ دائن` | عند الترحيل — `UnbalancedEntryException` |
| بند مدين + بند دائن على الأقل | عند الترحيل — `InsufficientLinesException` |
| لا مبالغ صفرية | عند الترحيل — `ZeroAmountLineException` |
| لا تعديل على المرحّل | `CannotModifyPostedEntryException` |
| الحساب يجب أن يكون نشطاً | عند الترحيل — `InactiveAccountException` |
| لا حذف حساب له قيود | `AccountHasTransactionsException` |
| لا تكرار رمز الحساب | `DuplicateAccountCodeException` |

---

## توليد كود Drift ⚙️

```bash
# تشغيل مرة واحدة بعد أي تعديل على الجداول أو الـ DAOs
dart run build_runner build --delete-conflicting-outputs
```

---

## الاختبار 🧪

```bash
flutter test test/accounting_test.dart
```

المكتبة تدعم `FlutterAccounting.forTesting()` لإنشاء قاعدة بيانات في الذاكرة بدون ملفات.

---

## الاستخدام مع Dependency Injection

```dart
// مع get_it مثلاً
GetIt.instance.registerSingleton<IAccountRepository>(
  FlutterAccounting.instance.accounts,
);
GetIt.instance.registerSingleton<IJournalEntryRepository>(
  FlutterAccounting.instance.journalEntries,
);
```

---

## الترخيص

MIT License © 2025
