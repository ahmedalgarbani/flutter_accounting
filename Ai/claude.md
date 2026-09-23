# flutter_accounting — AI Context Reference

Welcome! This document provides a comprehensive overview of the `flutter_accounting` package to help AI assistants understand its architecture, usage patterns, and core logic.

---

## 1. Overview
`flutter_accounting` is a robust, offline-first Flutter library for standard double-entry bookkeeping. It is built using **Clean Architecture** principles and leverages **Drift (SQLite)** for performance and type-safety.

### Core Features
- **Double-Entry Validation**: Ensures `Σ Debits = Σ Credits` and prevents invalid financial states.
- **Hierarchical Chart of Accounts**: Supports unlimited sub-accounts across 5 main types (Asset, Liability, Equity, Revenue, Expense).
- **Journal Management**: Full lifecycle (Draft → Posted → Reversed).
- **Financial Reports**: Built-in Trial Balance, Balance Sheet, Income Statement, account balances and account ledgers (statements).
- **Integration helpers**: `JournalEntryBuilder`, `fa.record`, source-document linking, atomic transactions.
- **Operation Templates**: Quick generation of entries for Sales, Purchases, and Vouchers.

---

## 2. Technical Architecture
The library is divided into clear layers to ensure logic purity and testability:

- **Domain Layer (`lib/src/models/`, `lib/src/core/`)**: Contains pure Dart models and business logic (Validators). No dependencies on Flutter or Drift.
- **Data Layer (`lib/src/database/`)**: Manages SQLite tables, DAOs, and Mappers.
- **Repository Layer (`lib/src/repositories/`)**: Abstracts data access. Users interact mostly with interfaces.
- **Initialization (`lib/src/flutter_accounting_init.dart`)**: Singleton access via `FlutterAccounting.instance`.

---

## 3. Domain Models

### `AccountModel`
- `id`: Optional database ID.
- `code`: Unique account code (e.g., '111' for Cash).
- `name` / `nameAr`: Dual-language support.
- `type`: `AccountType` (Asset, Liability, etc.).
- `normalBalance`: Derived from type (Asset/Expense = Debit, others = Credit).

### `JournalEntryModel`
- `status`: `draft`, `posted`, or `reversed`.
- `lines`: List of `JournalEntryLineModel`.
- `isBalanced`: Helper to check if debits equal credits.
- `canBeModified`: Only `draft` entries can be edited.

### `EntryTemplateModel`
- Defines a pattern of operation (e.g., "Cash Sale").
- Contains placeholders (`EntryTemplateLineModel`) with labels.

---

## 4. Key Repositories & APIs
All accessed via `FlutterAccounting.instance` (or a `forTesting()` instance). Full reference: `README.md`; integration guide: `doc/INTEGRATION.md`.

### Top-level convenience (`FlutterAccounting`)
- `record(JournalEntryBuilder, {post = true, postedBy})`: resolves account codes, validates, creates and posts atomically. **Preferred way to write entries.**
- `reverseSource(sourceType, sourceId)`: reverses all posted entries linked to a host-app document (idempotent).
- `transaction(() async {...})`: atomic multi-step operations.

### `accounts` (`IAccountRepository`)
- `createAccount(AccountModel.create(...))`, `ensureAccount(code:, name:, type:, parentCode:)` (idempotent).
- `getAccountByCode`, `getPostableAccounts({type})` (active leaf accounts), `searchAccounts`, `hasChildren`.
- Tree rules: child type == parent type, no children under accounts with entries, no cycles.

### `journalEntries` (`IJournalEntryRepository`)
- `createEntry` (draft), `createAndPost`, `postEntry(id)`, `reverseEntry(id)` (atomic, sets `reversalOfId`).
- `updateEntry` / `deleteEntry`: drafts only; `updateEntry` never changes status.
- Lookups: `getEntryBySerial`, `getEntriesByReference`, `getEntriesBySource(type, id)`, `watchAllEntries()`.

### `reports` (`IReportsRepository`)
- `getTrialBalance({from, to})`, `getBalanceSheet({asOf})`, `getIncomeStatement({from, to})`.
- `getAccountBalance(id, {asOf, includeChildren})`, `getAccountLedger(id, {from, to})`.
- Reports use posted + reversed entries only (drafts excluded); dates are day-inclusive.

### `periods` (`IAccountingPeriodRepository`)
- `createFiscalYear(year, {monthly})`, `ensureOpenPeriodFor(date)`, `closePeriod`, `reopenPeriod`.
- By default every entry date must fall in an open period (`AccountingConfig.requireOpenPeriod`).

### `templates` (`IEntryTemplateRepository`)
- `getStandardTemplates()`, persisted `saveTemplate` / `getCustomTemplates` / `deleteTemplate`.
- `applyTemplate({template, accountIdMap, totalAmount})`: Returns a draft `JournalEntryModel`.

---

## 5. Built-in Validation Rules
Enforced on create, update, and post:
1. **Balance**: Debits must equal Credits (tolerance 0.001).
2. **Completeness**: At least one Debit line and one Credit line.
3. **Non-Zero / Non-Negative**: No zero or negative amounts.
4. **Accounts**: Must exist, be active, and be leaf accounts.
5. **Periods**: Date must be in an open period (configurable).
6. **Immutability**: Once `posted`, entries cannot be modified or deleted (must use `reverseEntry`).

---

## 6. Common Usage Patterns

### Initialization
```dart
final fa = await FlutterAccounting.initialize(seedDefaultAccounts: true);
await fa.periods.ensureOpenPeriodFor(DateTime.now());
```

### Recording a business event
```dart
await fa.record(
  JournalEntryBuilder(description: 'Invoice 15')
    .source('invoice', 15)
    .type(EntryType.sale)
    .debitCode('111', 1150)
    .creditCode('41', 1000)
    .creditCode('215', 150),
);
// Cancelling the invoice:
await fa.reverseSource('invoice', 15);
```

### Generating a Report
```dart
final report = await fa.reports.getIncomeStatement(
  from: DateTime(2026, 1, 1),
  to: DateTime.now(),
);
print("Net Profit: ${report.netIncome}");
```

---

## 7. AI Implementation Tips
- **Testing**: Use `FlutterAccounting.forTesting()` and create a period (`fa.periods.createFiscalYear(year)`) before writing entries.
- **Schema changes**: bump `schemaVersion`, add an `onUpgrade` step, regenerate with build_runner, and extend `test/migration_test.dart`.
- **Enums** are stored by index: only append new values.
- **Errors**: Catch `AccountingException` (sealed) and show `e.message` (Arabic).
- **Localization**: Prefer `displayName` (Arabic when available) on accounts and report rows.
