# flutter_accounting — AI Context Reference

Welcome! This document provides a comprehensive overview of the `flutter_accounting` package to help AI assistants understand its architecture, usage patterns, and core logic.

---

## 1. Overview
`flutter_accounting` is a robust, offline-first Flutter library for standard double-entry bookkeeping. It is built using **Clean Architecture** principles and leverages **Drift (SQLite)** for performance and type-safety.

### Core Features
- **Double-Entry Validation**: Ensures `Σ Debits = Σ Credits` and prevents invalid financial states.
- **Hierarchical Chart of Accounts**: Supports unlimited sub-accounts across 5 main types (Asset, Liability, Equity, Revenue, Expense).
- **Journal Management**: Full lifecycle (Draft → Posted → Reversed).
- **Financial Reports**: Built-in Trial Balance, Balance Sheet, and Income Statement.
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

Access all features via `FlutterAccounting.instance`:

### `accounts` (`IAccountRepository`)
- `createAccount(AccountModel)`
- `getAccountByCode(String code)`
- `getChildAccounts(int parentId)`
- `watchAllAccounts()` (Stream support)

### `journalEntries` (`IJournalEntryRepository`)
- `createEntry(JournalEntryModel)`
- `postEntry(int id)`: Validates and moves to ledger. **Crucial: Always post to affect reports.**
- `reverseEntry(int id)`: Creates a matching entry with opposite amounts to cancel the original.

### `reports` (`IReportsRepository`)
- `getTrialBalance({from, to})`
- `getBalanceSheet({asOf})`
- `getIncomeStatement({from, to})`

### `templates` (`IEntryTemplateRepository`)
- `getStandardTemplates()`
- `applyTemplate({template, accountIdMap, totalAmount})`: Returns a `JournalEntryModel`.

---

## 5. Built-in Validation Rules
The package strictly enforces these rules during the `postEntry` process:
1. **Balance**: Debits must equal Credits exactly.
2. **Completeness**: At least one Debit line and one Credit line.
3. **Non-Zero**: No lines with zero amount allowed.
4. **Active Accounts**: All involved accounts must be marked as active.
5. **Immutability**: Once `posted`, entries cannot be modified or deleted (must use `reverseEntry`).

---

## 6. Common Usage Patterns

### Initialization
```dart
final accounting = await FlutterAccounting.initialize();
// Optional: Seed standard Chart of Accounts
await AccountingSeedData.seed(accounting.accounts);
```

### Creating a Template Entry (Sale)
```dart
final fa = FlutterAccounting.instance;
final entry = await fa.templates.applyTemplate(
  template: StandardTemplates.cashSale,
  accountIdMap: {
    'Cash/Bank Account': 1, 
    'Sales Revenue Account': 41,
  },
  totalAmount: 500.0,
);
await fa.journalEntries.createEntry(entry);
```

### Generating a Report
```dart
final report = await fa.reports.getIncomeStatement(
  from: DateTime(2024, 1, 1),
  to: DateTime.now(),
);
print("Net Profit: ${report.netIncome}");
```

---

## 7. AI Implementation Tips
- **Testing**: Use `FlutterAccounting.forTesting()` for an in-memory database during unit/integration tests.
- **Patterns**: When creating UI for entries, always use `JournalEntryLineModel.debitLine()` and `creditLine()` factory constructors to avoid mixups.
- **Errors**: Catch `AccountingException` and its subclasses (e.g., `UnbalancedEntryException`) to provide user feedback.
- **Localization**: If the user is in an Arabic locale, prefer using `nameAr` from `AccountModel`.
