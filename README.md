# flutter_accounting 📊

**Offline double-entry accounting engine for Flutter** — chart of accounts, journal entries, posting and reversal, fiscal periods, account ledgers, and financial reports (Trial Balance, Balance Sheet, Income Statement), with accounting rules enforced in code.

Works offline on **Android, iOS, Windows, macOS, and Linux**.

[العربية (Arabic Documentation)](README_AR.md)

Focus on building your core domain (POS, inventory, clinic, school, ERP) and let `flutter_accounting` handle the bookkeeping:
Chart of accounts, journal entries, posting, reversals, fiscal periods, and financial reports — ready out-of-the-box and guarded by double-entry invariants.

```dart
await fa.record(
  JournalEntryBuilder(description: 'Sales Invoice #15')
    .source('invoice', 15)
    .debitCode('111', 1150)   // Cash
    .creditCode('41', 1000)   // Sales Revenue
    .creditCode('215', 150),  // VAT Output
);
```

---

## Contents

- [Features](#features-)
- [Installation](#installation-)
- [Quick Start (5 Minutes)](#quick-start-5-minutes-)
- [Core Concepts](#core-concepts-)
- [Usage Guide](#usage-guide-)
  - [1. Chart of Accounts](#1-chart-of-accounts)
  - [2. Journal Entries](#2-journal-entries)
  - [3. JournalEntryBuilder](#3-journalentrybuilder)
  - [4. Linking with Source Documents](#4-linking-with-source-documents)
  - [5. Fiscal Periods](#5-fiscal-periods)
  - [6. Financial Reports & Ledgers](#6-financial-reports--ledgers)
  - [7. Entry Templates](#7-entry-templates)
  - [8. Configuration](#8-configuration)
  - [9. Cost Centers (Optional)](#9-cost-centers-optional)
- [Integration Guide](#integration-guide-)
- [API Reference](#api-reference-)
- [Enforced Accounting Rules](#enforced-accounting-rules-️)
- [Exceptions](#exceptions-)
- [Testing](#testing-)
- [Upgrading from 0.3.x](#upgrading-from-03x-)
- [Project Structure](#project-structure-️)
- [FAQ](#faq-)
- [License](#license)

---

## Features ✨

| | Feature |
|---|---|
| ⚖️ | **Double-Entry Engine** — Automatic enforcement: total debits = total credits, no zero/negative amounts, at least one debit and credit per entry. |
| 🌳 | **Hierarchical Chart of Accounts** — Unlimited depth, tree integrity protection (unified type, cycle prevention, parent accounts cannot hold transactions). |
| 📦 | **Ready-to-Use Seed Accounts** — 40+ standard bilingual (Arabic / English) accounts seeded with one flag. |
| 🧾 | **Audit-Ready Lifecycle** — Draft → Posted → Reversed workflow with audit trail (`createdBy`, `postedBy`, `postedAt`). |
| 🔗 | **Source Document Tracking** — Tag entries with `.source('invoice', 15)` to query, trace, and reverse entries by source document. |
| 🧱 | **Fluent Entry Builder** — `JournalEntryBuilder` resolves account IDs or account codes, tracking balance deltas in real-time. |
| ⚡ | **Atomic Operations** — `record`, `createAndPost`, `reverseEntry`, and `fa.transaction(...)` guarantee all-or-nothing execution. |
| 🔢 | **Auto-Sequenced Serials** — Yearly serial numbering (e.g. `JV-2026-0001`) with configurable prefixes and padding. |
| 📅 | **Fiscal Period Control** — Annual or monthly periods, open/close safeguards, and overlap prevention. |
| 📈 | **Financial Reports** — Trial Balance, Income Statement (P&L), Balance Sheet, Account Balance (recursive), and Account Ledger with opening/running balances. |
| 🏢 | **Cost Centers (optional)** — Branches, projects, departments or custom dimensions; split lines by percentage/amount/allocation keys, per-account policies, periodic allocation, and profitability reports. |
| 🧩 | **Entry Templates** — 7 built-in standard templates plus persistent database custom templates. |
| 🔄 | **Serialization Support** — `toMap()` and `fromMap()` across all models for exports and sync. |
| 🗄️ | **Drift (SQLite) Storage** — Fully offline, type-safe, WAL enabled, indexed for high performance, with automatic migrations. |
| 🧪 | **Test-Friendly** — `FlutterAccounting.forTesting()` in-memory database and clean repository interfaces for dependency injection. |

---

## Installation 📦

Add `flutter_accounting` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_accounting: ^0.5.0
```

Supported platforms: **Android, iOS, Windows, macOS, Linux** (powered by `sqlite3_flutter_libs`).

---

## Quick Start (5 Minutes) 🚀

### 1. Initialize (Once in `main`)

```dart
import 'package:flutter_accounting/flutter_accounting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fa = await FlutterAccounting.initialize(
    seedDefaultAccounts: true, // Seeds default standard accounts on first run
  );

  // Ensure an open fiscal period exists for the current year
  await fa.periods.ensureOpenPeriodFor(DateTime.now());

  runApp(const MyApp());
}
```

### 2. Record a Transaction

```dart
final fa = FlutterAccounting.instance;

// Cash sale of 500: Debit Cash / Credit Sales Revenue — created & posted atomically
await fa.record(
  JournalEntryBuilder(description: 'Cash Sale')
    .debitCode('111', 500)
    .creditCode('41', 500),
);
```

### 3. Fetch Reports & Balances

```dart
final income = await fa.reports.getIncomeStatement(
  from: DateTime(2026, 1, 1),
  to:   DateTime.now(),
);
print('Net Income: ${income.netIncome}');

final cash = await fa.accounts.getAccountByCode('111');
print('Cash Balance: ${await fa.reports.getAccountBalance(cash!.id!)}');
```

For complete architectural patterns and real-world recipes, see the [**Integration Guide**](doc/INTEGRATION.md).

---

## Core Concepts 📚

### Account Types and Normal Balance

| Type | `AccountType` | Normal Balance | Increases With | Displayed In |
|---|---|---|---|---|
| Asset | `asset` | Debit | Debit | Balance Sheet |
| Liability | `liability` | Credit | Credit | Balance Sheet |
| Equity | `equity` | Credit | Credit | Balance Sheet |
| Revenue | `revenue` | Credit | Credit | Income Statement |
| Expense | `expense` | Debit | Debit | Income Statement |

> All balances returned by `getAccountBalance`, `getAccountLedger`, `getBalanceSheet`, and `getIncomeStatement` follow their **normal direction** (a positive number reflects a healthy normal balance).
> The only exception is `TrialBalanceRow.balance`, where positive represents Debit and negative represents Credit.

### Journal Entry Lifecycle

```text
             postEntry / createAndPost / record
  ┌───────┐ ────────────────────────────────► ┌────────┐   reverseEntry   ┌──────────┐
  │ Draft │                                    │ Posted │ ───────────────► │ Reversed │
  │ draft │ ◄─ updateEntry / deleteEntry       │ posted │                  │ reversed │
  └───────┘                                    └────────┘                  └──────────┘
                                                               + New Reversal Entry (posted)
```

- **Draft**: Can be updated or deleted. Does not affect account balances or reports.
- **Posted**: Immutable. Affects account balances and financial reports. Cannot be edited or deleted — only reversed.
- **Reversed**: Linked to a new reversal entry (`reversalOfId`) with inverted amounts. Both entries remain in the ledger for an immutable audit trail.

### Fiscal Periods

By default, every entry's date must fall within an **open** fiscal period. Closed periods reject new entries.
If you prefer not to enforce periods in simpler apps, set `AccountingConfig(requireOpenPeriod: false)`.

---

## Usage Guide 📖

### 1. Chart of Accounts

```dart
// Seed the default standard chart of accounts
await AccountingSeedData.seed(fa.accounts);

// Create a new account
final wallet = await fa.accounts.createAccount(AccountModel.create(
  code: '1121',
  name: 'Digital Wallet',
  nameAr: 'المحفظة الإلكترونية',
  type: AccountType.asset,
  parentId: currentAssetsId,
));

// Ensure an account exists (safe to call idempotently on app launch)
final customerAccount = await fa.accounts.ensureAccount(
  code: '113001',
  name: 'Customer Ali',
  nameAr: 'العميل علي',
  type: AccountType.asset,
  parentCode: '113',
);

// Query accounts
await fa.accounts.getAccountByCode('111');
await fa.accounts.getPostableAccounts(type: AccountType.expense); // Leaf accounts only
await fa.accounts.searchAccounts('cash');
await fa.accounts.getChildAccounts(parentId);
fa.accounts.watchAllAccounts(); // Reactive Stream

// Updates & Deletion
await fa.accounts.updateAccount(wallet.copyWith(name: 'Main Digital Wallet'));
await fa.accounts.setAccountActive(wallet.id!, isActive: false);
await fa.accounts.deleteAccount(wallet.id!); // Allowed only if no transactions or children exist
```

### 2. Journal Entries

```dart
// 1. Create a draft entry
final draft = await fa.journalEntries.createEntry(JournalEntryModel(
  date: DateTime.now(),
  description: 'Office Rent',
  reference: 'RENT-01',
  lines: [
    JournalEntryLineModel.debitLine(accountId: rentExpenseId, amount: 3000),
    JournalEntryLineModel.creditLine(accountId: cashAccountId, amount: 3000),
  ],
));

// Update and post draft
await fa.journalEntries.updateEntry(draft.copyWith(description: 'Office Rent - March'));
final posted = await fa.journalEntries.postEntry(draft.id!, postedBy: 'admin');

// 2. Or create and post in a single atomic step
await fa.journalEntries.createAndPost(entry, postedBy: 'admin');

// 3. Reverse a posted entry
final reversal = await fa.journalEntries.reverseEntry(
  posted.id!,
  reversalDate: DateTime.now(),
  description: 'Reversal: Office Rent - March',
);

// Queries
await fa.journalEntries.getEntryById(id);
await fa.journalEntries.getEntryBySerial('JV-2026-0001');
await fa.journalEntries.getEntriesByStatus(EntryStatus.draft);
await fa.journalEntries.getEntriesInDateRange(from, to);
await fa.journalEntries.getEntriesByReference('INV-15');
fa.journalEntries.watchAllEntries(); // Reactive Stream
```

### 3. JournalEntryBuilder

The fluent `JournalEntryBuilder` simplifies creating balanced entries using either IDs or account codes:

```dart
final builder = JournalEntryBuilder(description: 'Purchase Goods', date: DateTime.now())
  .reference('PO-88')
  .type(EntryType.purchaseAgil)
  .source('purchase_order', 88)
  .createdBy('ahmed')
  .notes('First installment')
  .debitCode('115', 8000)                        // Inventory
  .debitCode('215', 1200, description: 'VAT')    // Input Tax
  .creditCode('211', 9200);                      // Accounts Payable

builder.totalDebits;   // 9200.0
builder.isBalanced;    // true
builder.difference;    // 0.0

// Resolve codes + create + post atomically
await fa.record(builder);

// Or save as draft only
await fa.record(builder, post: false);

// Or resolve to a JournalEntryModel without saving
final model = await builder.resolve(fa.accounts);
```

### 4. Linking with Source Documents

Link journal entries directly to business entities (invoices, receipts, orders) to query or reverse them later:

```dart
await fa.record(
  JournalEntryBuilder(description: 'Invoice #15')
    .source('invoice', 15)
    .debitCode('113', 1000)
    .creditCode('41', 1000),
);

// Retrieve all entries for Invoice #15
final entries = await fa.journalEntries.getEntriesBySource('invoice', '15');

// Void / Cancel invoice: Reverses all posted entries linked to this document atomically
await fa.reverseSource('invoice', 15, postedBy: 'admin');

// Atomic multi-step operations
await fa.transaction(() async {
  await fa.reverseSource('invoice', 15);
  await fa.record(correctedInvoiceEntry);
});
```

### 5. Fiscal Periods

```dart
await fa.periods.createFiscalYear(2026);                 // Annual period (Jan 1 - Dec 31)
await fa.periods.createFiscalYear(2026, monthly: true);  // 12 monthly periods
await fa.periods.ensureOpenPeriodFor(DateTime.now());    // Auto-create if missing

await fa.periods.createPeriod(AccountingPeriodModel(
  name: 'Q1 2027',
  startDate: DateTime(2027, 1, 1),
  endDate: DateTime(2027, 3, 31),
));

await fa.periods.closePeriod(id);   // Rejected if draft entries exist within the period
await fa.periods.reopenPeriod(id);
await fa.periods.deletePeriod(id);  // Allowed only if no entries exist in period
await fa.periods.getPeriodForDate(DateTime.now());
```

### 6. Financial Reports & Ledgers

All reports aggregate **posted entries only** and operate on full day boundaries (`to` and `asOf` include the entire day through 23:59:59.999).

```dart
final now = DateTime.now();

// 1. Trial Balance (defaults to beginning of year to current date)
final tb = await fa.reports.getTrialBalance(from: DateTime(now.year), to: now);
print('TB Balanced: ${tb.isBalanced}');
for (final row in tb.rows) {
  print('${row.accountCode} ${row.displayName}: Debit ${row.debitBalance}, Credit ${row.creditBalance}');
}

// 2. Income Statement (P&L)
final income = await fa.reports.getIncomeStatement(from: DateTime(now.year), to: now);
print('Revenue: ${income.totalRevenue}, Expenses: ${income.totalExpenses}, Net: ${income.netIncome}');

// 3. Balance Sheet (automatically calculates retained earnings)
final bs = await fa.reports.getBalanceSheet(asOf: now);
print('Assets: ${bs.totalAssets}, Liabilities: ${bs.totalLiabilities}, Equity: ${bs.totalEquity}');

// 4. Account Balance (recursive across child accounts by default)
final totalReceivables = await fa.reports.getAccountBalance(customersParentId, asOf: now);

// 5. Account Ledger (Statement with opening balance and running balances)
final ledger = await fa.reports.getAccountLedger(
  cashId,
  from: DateTime(now.year, now.month),
  to: now,
);
print('Opening: ${ledger.openingBalance}');
for (final line in ledger.lines) {
  print('${line.date} | ${line.serialNumber} | ${line.description} | Debit: ${line.debit} Credit: ${line.credit} | Running: ${line.runningBalance}');
}
print('Closing: ${ledger.closingBalance}');
```

### 7. Entry Templates

```dart
// Apply a built-in standard template
final draft = await fa.templates.applyTemplate(
  template: StandardTemplates.cashSale,
  accountIdMap: {
    'Cash/Bank Account': cashId,
    'Sales Revenue Account': salesId,
  },
  totalAmount: 1500,
);
await fa.journalEntries.createAndPost(draft);

// Save a custom template to the database
await fa.templates.saveTemplate(const EntryTemplateModel(
  name: 'Sale with 15% VAT',
  type: EntryType.sale,
  lines: [
    EntryTemplateLineModel(isDebit: true,  label: 'Cash',    accountType: AccountType.asset,     defaultRatio: 1.15),
    EntryTemplateLineModel(isDebit: false, label: 'Revenue', accountType: AccountType.revenue,   defaultRatio: 1.0),
    EntryTemplateLineModel(isDebit: false, label: 'VAT',     accountType: AccountType.liability, defaultRatio: 0.15),
  ],
));
final customTemplates = await fa.templates.getCustomTemplates();
```

Built-in templates include: `cashSale`, `cashPurchase`, `creditSale`, `creditPurchase`, `paymentVoucher`, `receiptVoucher`, and `journalEntry`.

### 8. Configuration

```dart
await FlutterAccounting.initialize(
  databaseName: 'accounting.db',
  databaseDirectory: '/custom/path',          // Optional
  seedDefaultAccounts: true,
  config: const AccountingConfig(
    requireOpenPeriod: true,   // Requires entries to fall into an open fiscal period
    serialPrefix: 'JV',        // e.g. JV-2026-0001
    serialPadding: 4,
    enableCostCenters: false,  // Opt-in cost centers (see section 9)
    allocationDecimals: 2,     // Rounding of percentage/key splits
  ),
);
```

### 9. Cost Centers (Optional)

Track profitability by **branch, project, department** — or any dimension you define. The feature is **off by default** and everything in it is optional: turn it on, and nothing becomes mandatory unless you make it so.

**Enable it**

```dart
await FlutterAccounting.initialize(
  config: const AccountingConfig(enableCostCenters: true),
  seedDefaultCostDimensions: true, // optional: BRANCH, PROJECT, DEPARTMENT
);
```

**Define dimensions and centers** (centers form a tree, like the chart of accounts)

```dart
final region = await fa.costCenters.ensureDimension(code: 'REGION', name: 'Region'); // custom dimension
await fa.costCenters.ensureCostCenter(dimensionCode: 'BRANCH', code: 'BR-WEST', name: 'Western Region');
await fa.costCenters.ensureCostCenter(
    dimensionCode: 'BRANCH', code: 'BR-JED', name: 'Jeddah', parentCode: 'BR-WEST');
```

**Allocate journal lines** — one center per dimension, or split within a dimension by percentage, amount, or a saved allocation key. Split rounding goes to the last share so the total always matches the line.

```dart
await fa.record(
  JournalEntryBuilder(description: 'Shared rent')
    .debitCode('53', 10000, allocations: [
      CostAllocationModel.percent('BR-RYD', 60),
      CostAllocationModel.percent('BR-JED', 40),
      CostAllocationModel.code('DEP-ADMIN'),     // 100% to Admin (another dimension)
    ])
    .creditCode('111', 10000),
);

// Or use a saved allocation key (e.g. by floor area: Riyadh 300 / Jeddah 200)
.debitCode('53', 10000, allocationKey: 'AREA')
```

**Policies (optional)** — make a dimension required or forbidden per account (including sub-accounts) or per account type, and set a default center applied automatically:

```dart
await fa.costCenters.setRule(DimensionRuleModel.forType(
  dimensionId: department.id!,
  accountType: AccountType.expense,
  policy: DimensionPolicy.required,     // every expense line needs a department
));
await fa.costCenters.setRule(DimensionRuleModel.forAccount(
  dimensionId: branch.id!,
  accountId: jeddahRentId,
  defaultCostCenterId: jeddah.id,       // auto-filled when not provided
));
```

Precedence: rule on the account → nearest parent account → account type → the dimension's `defaultPolicy`. Inactive dimensions are ignored; inactive or parent centers cannot receive new allocations. Reversal entries copy the original allocations.

**Periodic allocation** of a service center's costs to other centers:

```dart
final request = CostAllocationRequest(
  sourceCostCenterId: hq.id!, allocationKeyId: headcountKey.id!,
  from: DateTime(2026, 1, 1), to: DateTime(2026, 1, 31),
);
final preview = await fa.costAllocations.previewAllocation(request); // nothing saved
final entry = await fa.costAllocations.runAllocation(request);       // posted, reversible
```

**Reports** — `fa.costReports`:

| Method | Returns |
|---|---|
| `getSummary(dimensionId:)` | Revenue / expenses / net per center (tree roll-up) + unallocated |
| `getComparison(dimensionId:, costCenterIds?)` | Accounts × centers table |
| `getIncomeStatement(filter:, from:, to:)` | `IncomeStatementReport` for one or more centers |
| `getTrialBalance(filter:)` | `TrialBalanceReport` for one or more centers |
| `getLedger(costCenterId, {accountId})` | Center ledger with opening and running balances |
| `getMatrix(rowDimensionId:, columnDimensionId:)` | Cross analysis, e.g. branches × projects |
| `getUnallocatedLines(dimensionId:)` | Lines missing a center (data quality) |

`CostCenterFilter([ryd.id!, prjA.id!])` intersects dimensions proportionally (a line 60% Riyadh and 50% Project A contributes 30%); centers from the same dimension are added together.

---

## Integration Guide 🔌

See the full [**Integration Guide (doc/INTEGRATION.md)**](doc/INTEGRATION.md) for architectural patterns, accounting recipes for common workflows, dependency injection setup, and production checklists.

**Architecture summary:**

1. Call `FlutterAccounting.initialize(...)` once at startup.
2. Group your account codes into a centralized class (`AppAccounts`).
3. Create an **Accounting Service** in your app that maps business events to `fa.record(...)` with `.source(type, id)`.
4. Cancel or void transactions using `fa.reverseSource(type, id)`.
5. Catch `AccountingException` and display user-friendly error messages with `e.message`.

Check the [`example/`](example/) directory for a full working Flutter app including sales service integration, journal screens, financial reports, and integration tests.

---

## API Reference 📘

### `FlutterAccounting`

| Member | Description |
|---|---|
| `initialize({databaseName, databaseDirectory, customExecutor, config, seedDefaultAccounts, seedDefaultCostDimensions})` | Initializes the database and sets the singleton instance |
| `instance` / `isInitialized` | Accesses the initialized instance (`StateError` if uninitialized) |
| `forTesting({config})` | Creates an in-memory test instance |
| `accounts` / `journalEntries` / `reports` / `templates` / `periods` | Repository accessors |
| `costCenters` / `costAllocations` / `costReports` | Cost center accessors (see section 9) |
| `record(builder, {post, postedBy})` | Resolves, creates, and optionally posts an entry |
| `reverseSource(type, id, {reversalDate, postedBy})` | Reverses all posted entries for a source document |
| `transaction(action)` | Executes multiple database operations in an atomic transaction |
| `dispose()` | Closes the underlying database |

### `IAccountRepository` — `fa.accounts`

| Method | Description |
|---|---|
| `getAllAccounts()` / `getActiveAccounts()` | Retrieves all or active accounts |
| `getAccountById(id)` / `getAccountByCode(code)` | Retrieves a single account |
| `getAccountsByType(type)` / `getChildAccounts(parentId)` | Filters accounts by type or parent |
| `getPostableAccounts({type})` | Retrieves leaf accounts eligible for journal entries |
| `searchAccounts(query)` | Searches by code or name |
| `hasChildren(id)` / `hasTransactions(id)` / `countAccounts()` | Account tree introspection |
| `watchAllAccounts()` | Streams account list updates |
| `createAccount(model)` / `updateAccount(model)` | Creates or updates an account with hierarchy validation |
| `ensureAccount({code, name, type, parentId, parentCode, ...})` | Idempotent account creation |
| `setAccountActive(id, isActive:)` / `deleteAccount(id)` | Activates, deactivates, or deletes accounts |

### `IJournalEntryRepository` — `fa.journalEntries`

| Method | Description |
|---|---|
| `getAllEntries()` / `getEntryById(id)` / `getEntryBySerial(serial)` | Retrieves entries |
| `getEntriesByStatus(status)` / `getEntriesInDateRange(from, to)` | Filters by status or date range |
| `getEntriesByReference(ref)` / `getEntriesBySource(type, id)` | Finds entries by reference or source document |
| `watchAllEntries()` | Streams entry list updates |
| `createEntry(entry)` | Creates a draft entry |
| `updateEntry(entry)` / `deleteEntry(id)` | Updates or deletes draft entries |
| `postEntry(id, {postedBy})` | Posts a draft entry |
| `createAndPost(entry, {postedBy})` | Creates and posts an entry atomically |
| `reverseEntry(id, {reversalDate, description, postedBy})` | Reverses a posted entry atomically |

### `IReportsRepository` — `fa.reports`

| Method | Returns |
|---|---|
| `getTrialBalance({from, to})` | `TrialBalanceReport` |
| `getIncomeStatement({from, to})` | `IncomeStatementReport` |
| `getBalanceSheet({asOf})` | `BalanceSheetReport` |
| `getAccountBalance(id, {asOf, includeChildren})` | `double` (Normal balance direction) |
| `getAccountLedger(id, {from, to, includeChildren})` | `AccountLedgerReport` |

### `IAccountingPeriodRepository` — `fa.periods`

| Method | Description |
|---|---|
| `getAllPeriods()` / `getPeriodById(id)` / `getPeriodForDate(date)` | Reads fiscal periods |
| `createPeriod(p)` / `updatePeriod(p)` / `deletePeriod(id)` | Manages periods with overlap checks |
| `closePeriod(id)` / `reopenPeriod(id)` | Closes or reopens fiscal periods |
| `createFiscalYear(year, {monthly})` | Generates full fiscal year (annual or 12 months) |
| `ensureOpenPeriodFor(date)` | Ensures an open period covers the given date |

### `IEntryTemplateRepository` — `fa.templates`

| Method | Description |
|---|---|
| `getStandardTemplates()` | Built-in template collection |
| `getCustomTemplates()` / `saveTemplate(t)` / `deleteTemplate(id)` | Persistent custom templates |
| `applyTemplate({template, accountIdMap, totalAmount, ...})` | Generates a balanced draft entry from a template |

### `ICostCenterRepository` — `fa.costCenters`

| Method | Description |
|---|---|
| `getDimensions()` / `createDimension(d)` / `updateDimension(d)` / `ensureDimension(...)` | Dimensions (branch, project, ...) |
| `setDimensionActive(id, isActive:)` / `deleteDimension(id)` | Deactivate or delete an empty dimension |
| `getCostCenters({dimensionId})` / `getPostableCostCenters({dimensionId})` / `searchCostCenters(q)` | Read centers (postable = active leaves) |
| `createCostCenter(c)` / `updateCostCenter(c)` / `ensureCostCenter(...)` | Manage the center tree |
| `setCostCenterActive(id, isActive:)` / `deleteCostCenter(id)` / `hasTransactions(id)` | Lifecycle |
| `getRules()` / `setRule(rule)` / `deleteRule(id)` / `getEffectivePolicy(...)` | Dimension policies and default centers |
| `getAllocationKeys()` / `saveAllocationKey(k)` / `deleteAllocationKey(id)` / `splitByKey(id, amount)` | Allocation keys |

### `ICostAllocationRepository` — `fa.costAllocations`

| Method | Description |
|---|---|
| `previewAllocation(request)` | Computes a periodic allocation without saving |
| `runAllocation(request, {post, postedBy})` | Creates the `EntryType.costAllocation` entry |

---

## Enforced Accounting Rules ⚖️

| Invariant / Rule | Exception Thrown |
|---|---|
| `Total Debits == Total Credits` | `UnbalancedEntryException` |
| At least one Debit line and one Credit line | `InsufficientLinesException` |
| Line amount cannot be zero | `ZeroAmountLineException` |
| Line amount cannot be negative | `NegativeAmountException` |
| Line cannot have both Debit and Credit amounts | `InvalidLineAmountsException` |
| Account must exist and be active | `AccountNotFoundException` / `InactiveAccountException` |
| Transactions cannot be posted to parent accounts | `AccountIsParentException` |
| Posted entries cannot be edited or deleted directly | `CannotModifyPostedEntryException` |
| Cannot post reversed entries / cannot reverse draft entries | `InvalidEntryStateException` |
| Cannot reverse an already reversed entry | `EntryAlreadyReversedException` |
| Entry date must fall into an open fiscal period | `PeriodClosedException` / `DateOutsidePeriodException` |
| Unique serial numbers per year | `DuplicateSerialNumberException` |
| Unique account code | `DuplicateAccountCodeException` |
| Child account must match parent account type | `AccountTypeMismatchException` |
| Parent account cannot have transactions before adding children | `ParentAccountHasTransactionsException` |
| No cycles allowed in account hierarchy | `InvalidAccountHierarchyException` |
| Account type cannot be changed once transactions exist | `CannotChangeAccountTypeException` |
| Account with transactions or child accounts cannot be deleted | `AccountHasTransactionsException` / `AccountHasChildrenException` |
| Fiscal periods cannot overlap; start date must precede end date | `PeriodOverlapException` / `InvalidPeriodException` |
| Fiscal period cannot be closed if draft entries exist | `PeriodHasDraftEntriesException` |
| Template line ratios must be balanced | `InvalidTemplateException` |
| Cost center allocations per dimension must sum to the line amount | `InvalidCostAllocationException` |
| Allocations only to active leaf centers in active dimensions | `InactiveCostCenterException` / `CostCenterIsParentException` |
| Required / forbidden dimension policies | `CostCenterRequiredException` / `CostCenterNotAllowedException` |
| Cost center writes while the feature is off | `CostCentersDisabledException` |

---

## Exceptions 🚨

All exceptions inherit from the sealed class `AccountingException` and provide human-readable messages in `message`:

```dart
try {
  await fa.record(builder);
} on UnbalancedEntryException catch (e) {
  print('Unbalanced delta: ${e.totalDebits - e.totalCredits}');
} on AccountingException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
}
```

---

## Testing 🧪

```bash
flutter test                 # Run package test suite
cd example && flutter test   # Run example app tests
```

Use `FlutterAccounting.forTesting()` to spin up an isolated SQLite in-memory database per test:

```dart
setUp(() async {
  fa = FlutterAccounting.forTesting();
  await AccountingSeedData.seed(fa.accounts);
  await fa.periods.ensureOpenPeriodFor(DateTime.now());
});

tearDown(() => fa.dispose());
```

---

## Upgrading from 0.4.x ⬆️

- **Automatic migration to schema v3** adds the cost center tables; existing data is untouched.
- Cost centers are **off by default**, so nothing changes until you set `AccountingConfig(enableCostCenters: true)`.
- `EntryType.costAllocation` was added at the end of the enum. If you `switch` over `EntryType`, handle it.
- `FlutterAccounting` has new `costCenters`, `costAllocations` and `costReports` accessors. `JournalEntryLineModel` has a new `allocations` field (default empty).

## Upgrading from 0.3.x ⬆️

- **Automatic Schema Migration**: Database migrations (v1 → v2) execute automatically on startup preserving your data.
- **Accurate Financial Reports**: Reports strictly filter out drafts and enforce date ranges.
- `TrialBalanceRow.balance`: Positive = Debit, Negative = Credit across all account types.
- `applyTemplate` throws `InvalidTemplateException` and `AccountNotFoundException` instead of generic `ArgumentError`.
- `updateEntry` no longer mutates entry status; use `postEntry` to transition drafts to posted.
- `AccountModel.isParent` is deprecated; use `isRoot` or `accounts.hasChildren(id)`.

See the full [CHANGELOG.md](CHANGELOG.md) for details.

---

## Project Structure 🏗️

```text
lib/
├── flutter_accounting.dart            ← Public package API (import this)
└── src/
    ├── flutter_accounting_init.dart   ← FlutterAccounting singleton & coordinator
    ├── core/
    │   ├── enums.dart                 ← AccountType, EntryStatus, EntryType
    │   ├── exceptions.dart            ← AccountingException sealed hierarchy
    │   ├── accounting_validator.dart  ← Double-entry validation rules
    │   ├── accounting_config.dart     ← AccountingConfig
    │   ├── journal_entry_builder.dart ← JournalEntryBuilder
    │   ├── cost_allocation_calculator.dart ← Allocation splitting & rounding
    │   ├── standard_templates.dart    ← Standard templates collection
    │   └── date_utils.dart            ← Day boundary utilities
    ├── models/                        ← Pure domain models
    ├── reports/                       ← Report DTOs (financial + cost centers)
    ├── repositories/
    │   ├── interfaces/                ← Repository contracts
    │   └── impl/                      ← Repository implementations
    ├── database/                      ← Drift (SQLite): tables, DAOs, mappers
    └── seed/                          ← Chart of accounts & cost dimension seeds
doc/
└── INTEGRATION.md                     ← Integration guide & recipes
example/                               ← Full example app & integration tests
```

---

## FAQ ❓

**Can I use my own custom account numbering?**
Yes. Seeding default accounts is optional. You can build your custom chart of accounts using `createAccount` or `ensureAccount`.

**How do I edit a posted invoice or transaction?**
Reverse the previous entry and record a new corrected entry inside `fa.transaction(...)`. See [Integration Guide §6](doc/INTEGRATION.md).

**Why am I receiving a `DateOutsidePeriodException`?**
No open fiscal period covers the entry's date. Call `fa.periods.ensureOpenPeriodFor(date)` or initialize with `requireOpenPeriod: false`.

**Are multi-currency transactions supported?**
Currently, single-currency amounts are supported. Multi-currency and cost center features are planned for future releases.

**How are decimal amounts stored?**
Amounts are stored as `double` values with a `0.001` balance tolerance margin. Round values to 2 decimal places in your UI before recording.

---

## License

MIT License © 2026
