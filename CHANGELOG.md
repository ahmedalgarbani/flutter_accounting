# Changelog

All notable changes to this project will be documented in this file.

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
