# Changelog

All notable changes to this project will be documented in this file.

## [0.5.0] - 2026-09-27

Adds **cost centers** (analytic dimensions). The feature is opt-in and off by default.

### Added
- **Dimensions and cost centers**: `fa.costCenters` manages dimensions (branch, project,
  department or custom ones) and hierarchical cost centers per dimension. `ensureDimension`
  / `ensureCostCenter` are idempotent. `seedDefaultCostDimensions: true` (or
  `CostCenterSeedData.seed`) creates `BRANCH`, `PROJECT` and `DEPARTMENT`.
- **Line allocations**: `JournalEntryLineModel.allocations` / builder `allocations:` link a
  line to one center per dimension, or split it within a dimension by percentage, amount or
  a saved allocation key (`allocationKey:`). Centers can be referenced by id or code.
  Rounding goes to the last share. Reversals copy the original allocations.
- **Policies**: `DimensionRuleModel` makes a dimension required or forbidden per account
  (inherited by sub-accounts) or per account type, and can set a default center applied
  automatically. `CostDimensionModel.defaultPolicy` and `allowSplit` set dimension-wide
  behaviour.
- **Allocation keys**: saved weights (area, headcount...) and `splitByKey`.
- **Periodic allocation**: `fa.costAllocations.previewAllocation` / `runAllocation` move a
  service center's balances to other centers with an `EntryType.costAllocation` entry.
- **Reports** via `fa.costReports`: center summary with tree roll-up and unallocated totals,
  accounts × centers comparison, income statement and trial balance filtered by centers
  (with proportional multi-dimension intersection), center ledger, two-dimension matrix, and
  unallocated lines.
- `AccountingConfig.enableCostCenters` (default `false`) and `allocationDecimals` (default 2).
- New exceptions: `CostCentersDisabledException`, `CostCenterRequiredException`,
  `CostCenterNotAllowedException`, `InvalidCostAllocationException`,
  `InactiveCostCenterException`, `CostCenterIsParentException` and related not-found /
  duplicate / hierarchy exceptions.
- Example app: branch selector, rent split by allocation key, required department on
  expenses, and a new **Cost Centers** screen.

### Changed
- Database schema **v3** (automatic migration): tables `cost_dimensions`, `cost_centers`,
  `journal_line_allocations`, `cost_dimension_rules`, `allocation_keys`,
  `allocation_key_items`. Drift files regenerated.
- `EntryType.costAllocation` appended to the enum.

## [0.4.1] - 2026-09-23

A correctness and integration release. **Upgrading is strongly recommended**:
several accounting bugs in 0.3.0 produced wrong report figures.

### Fixed — accounting correctness
- **Reports included draft entries and ignored date filters.** The balances query summed
  every line regardless of entry status or date (the filter sat on a `LEFT JOIN` that did
  not restrict the sum, and dates were compared as text against integer timestamps).
  Trial Balance, Income Statement and Balance Sheet now use posted entries only and honour
  `from` / `to` / `asOf`.
- **`reverseEntry` always crashed** with a `UNIQUE constraint failed` error because
  `copyWith(id: null)` kept the original line ids. Reversal now creates fresh lines.
- **Reversed entries are kept in the ledger.** Originals marked `reversed` still count
  towards balances, and the posted reversal entry cancels them (previously the fix for the
  query above would have left only the reversal, inverting balances).
- **Trial Balance sign** — `TrialBalanceRow.balance` is now debit-positive / credit-negative
  for every account type, as documented. Before, credit-normal accounts were reported as
  debit balances, so the report could not balance.
- **Report date boundaries are day-based** — `to` / `asOf` include the whole day, so entries
  made later that day are no longer excluded.
- **Accounting periods cover full days** — `endDate` is normalised to 23:59:59; entries on the
  last day of a period no longer fail with `DateOutsidePeriodException`.
- **A reversed entry could be posted again** (double counting). `postEntry` now rejects it.
- **`updateEntry` could post an entry** by passing `status: posted`, skipping validation and
  audit fields. It now always keeps the entry as a draft.
- **Serial numbers broke after `9999`** because of text sorting. The next number now uses the
  numeric maximum (`JV-2026-10000` follows `JV-2026-9999`).
- **Deleting an account with only draft lines** raised a raw SQLite foreign-key error. It now
  raises `AccountHasTransactionsException`.
- **Validator messages** — negative amounts raised `ZeroAmountLineException`, and a zero-amount
  line could be reported as `InsufficientLinesException`. Lines are now checked first.

### Fixed — data integrity
- Sub-accounts must have the same type as their parent (`AccountTypeMismatchException`).
- Sub-accounts cannot be added under an account that already has entries
  (`ParentAccountHasTransactionsException`).
- `updateAccount` rejects cycles in the tree (`InvalidAccountHierarchyException`), recomputes
  `level` for the account and its descendants, and blocks type changes on used accounts
  (`CannotChangeAccountTypeException`).
- Periods cannot overlap (`PeriodOverlapException`) or end before they start
  (`InvalidPeriodException`). Overlapping legacy periods no longer crash lookups.
- `createEntry`, `updateEntry`, `postEntry`, `reverseEntry` and `deleteEntry` run inside
  database transactions.
- Empty `reference` / `nameAr` strings are stored as `null` instead of failing column checks.
- `FlutterAccounting.instance` throws a `StateError` with a clear message (was a null-check
  crash in release builds). Calling `initialize` again closes the previous database.

### Added
- **`JournalEntryBuilder`** — fluent entry builder that accepts account ids or account
  **codes**, exposes `totalDebits` / `totalCredits` / `difference` / `isBalanced`.
- **`fa.record(builder, {post, postedBy})`** — resolve codes, validate, create and post in
  one atomic step.
- **Source linking** — `sourceType` / `sourceId` on entries, `builder.source('invoice', 15)`,
  `journalEntries.getEntriesBySource(...)`, and `fa.reverseSource(...)` (idempotent).
- **`fa.transaction(...)`** for atomic multi-step operations.
- `journalEntries.createAndPost`, `getEntryBySerial`, `getEntriesByReference`.
- `reverseEntry` accepts `description` and `postedBy`; reversal entries carry `reversalOfId`
  and `EntryType.reversal`.
- **Reports**: `getAccountBalance(id, {asOf, includeChildren})` and
  `getAccountLedger(id, {from, to, includeChildren})` (account statement with opening and
  running balances → `AccountLedgerReport`). Report rows expose `accountNameAr` and
  `displayName`.
- **Accounts**: `AccountModel.create(...)` (no timestamps needed), `ensureAccount(...)` with
  `parentCode`, `getPostableAccounts({type})`, `searchAccounts(query)`, `hasChildren(id)`,
  `AccountModel.isRoot`.
- **Periods**: `getPeriodById`, `reopenPeriod`, `deletePeriod`, `createFiscalYear(year, {monthly})`,
  `ensureOpenPeriodFor(date)`; closing a period with drafts raises `PeriodHasDraftEntriesException`.
- **Custom templates are persisted** in a new `entry_templates` table (`saveTemplate`,
  `getCustomTemplates`, `deleteTemplate` were no-ops). Templates are validated (balanced ratios,
  unique labels, matching `accountType`), and lines can pin an `accountId`. Applied templates
  set `entryType`.
- **`AccountingConfig`** — `requireOpenPeriod`, `serialPrefix`, `serialPadding`.
- `FlutterAccounting.initialize` gains `seedDefaultAccounts`, `databaseDirectory` and `config`.
- `toMap()` / `fromMap()` on `AccountModel`, `JournalEntryModel`, `JournalEntryLineModel`,
  `AccountingPeriodModel`, `EntryTemplateModel`, `EntryTemplateLineModel`.
- `AccountingValidator.checkEntryLines` (returns a message instead of throwing) and the public
  `AccountingValidator.isBalanced` / `epsilon`.
- New `EntryType` values: `openingBalance`, `reversal`, `adjustment`; `EntryStatus.displayNameEn`.
- New exceptions: `NegativeAmountException`, `InvalidEntryStateException`,
  `EntryAlreadyReversedException`, `AccountTypeMismatchException`,
  `ParentAccountHasTransactionsException`, `CannotChangeAccountTypeException`,
  `InvalidAccountHierarchyException`, `InvalidPeriodException`, `PeriodOverlapException`,
  `PeriodNotFoundException`, `PeriodHasDraftEntriesException`, `PeriodHasEntriesException`,
  `InvalidTemplateException`.
- Batched line loading for entry lists (removes the N+1 query pattern) and database indexes on
  entry date, source, and line entry/account ids.

### Changed
- **Minimum drift version raised to 2.31.0** to match the bundled generated database
  code; this raises the minimum toolchain to Dart 3.5 / Flutter 3.24.
- **Database schema v2** with automatic migration from v1 (new journal entry columns
  `entry_type`, `source_type`, `source_id`, `reversal_of_id`, table `entry_templates`, indexes).
- `applyTemplate` throws `InvalidTemplateException` / `AccountNotFoundException` instead of
  `ArgumentError`.
- Repository interfaces gained new methods — custom implementations/mocks must add them.
- `AccountModel.isParent` is deprecated (it meant "has no parent"); use `isRoot` or
  `accounts.hasChildren(id)`.

### Documentation & examples
- README rewritten: quick start, core concepts, full API reference, rules and exceptions tables,
  upgrade notes, FAQ.
- New integration guide: `doc/INTEGRATION.md`.
- New example app: integration service layer (`SalesAccountingService`), journal, reports and
  account-statement screens, plus a service test.
- Test suite expanded from 21 to 82 tests (reports, reversals, periods, tree rules, templates,
  builder, source linking, v1→v2 migration). All 11 tests that failed on 0.3.0 now pass.

## [0.3.0] - 2026-04-19

### Added
- **Accounting Period Control**: Prevent posting transactions in closed or undefined periods.
- **Voucher Serial Numbering**: Automated generation of unique, sequential serial numbers (format: JV-YYYY-XXXX).
- **Audit Trail**: Enhanced security with `createdBy`, `postedBy`, and `postedAt` fields on journal entries.
- **Operational Hardening**: Strict validation preventing postings to main (parent) accounts and enforcing balanced double-entry rules.
- **Period Management**: New `IAccountingPeriodRepository` for opening, closing, and managing accounting years.
- **Extended Models**: Added `serialNumber` and audit fields to `JournalEntryModel`.

## [0.2.0] - 2026-04-19

### Added
- **Entry Templates**: Support for common accounting operations templates.
- Built-in templates for: Cash Sale, Cash Purchase, Credit Sale, Credit Purchase, Payment Voucher (سند صرف), and Receipt Voucher (سند قبض).
- `EntryTemplateModel` and `EntryTemplateLineModel` for custom template definitions.
- `IEntryTemplateRepository` for applying templates to generate journal entries.
- `StandardTemplates` helper class with pre-defined operational patterns.
- `EntryType` enum for categorizing operations.

## [0.1.0] - 2026-04-18

### Added
- Initial release of `flutter_accounting` package.
- Core accounting modules: Accounts, Journal Entries, and Financial Reports.
- Persistence layer using Drift (SQLite).
- Clean Architecture structure (`lib/src/`).
- Double-entry bookkeeping validator.
- Support for multiple account types (Asset, Liability, Equity, Revenue, Expense).
- Financial reports: Trial Balance, Balance Sheet, and Income Statement.
- Initial seed data for a standard chart of accounts.
- Comprehensive test suite.
