# Repository Guidelines

## Project Structure & Module Organization

This Flutter package provides offline double-entry accounting. Public exports live in `lib/flutter_accounting.dart`, implementation code in `lib/src/`, tests in `test/`, and the demo app in `example/`.

## File Structure

```text
lib/flutter_accounting.dart     Public package exports
lib/src/core/                   Accounting rules, enums, exceptions
lib/src/models/                 Domain models
lib/src/database/               Drift database, tables, DAOs, mappers
lib/src/repositories/           Repository interfaces and implementations
lib/src/reports/                Report DTOs and report logic
lib/src/seed/                   Default chart/accounting seed data
test/                           Package tests
example/                        Demo Flutter app
```

## Build, Test, and Development Commands

- `flutter pub get` installs dependencies.
- `flutter test` runs all tests.
- `flutter analyze` checks `flutter_lints`.
- `dart run build_runner build --delete-conflicting-outputs` regenerates Drift files.
- `cd example && flutter run` starts the demo app.

## Coding Style & Naming Conventions

Use Dart defaults with two-space indentation and `package:flutter_lints/flutter.yaml`.

Naming rules: files and folders use `snake_case` such as `journal_entry_model.dart`; classes and enums use `UpperCamelCase` such as `JournalEntryModel`; variables, methods, and parameters use `lowerCamelCase` such as `accountId`; private members start with `_`; tests end with `_test.dart`.

## Clean Architecture Rules

Keep models in `models/`, business rules in `core/`, persistence in `database/`, contracts in `repositories/interfaces/`, and implementations in `repositories/impl/`. Implementations may depend on interfaces, DAOs, and models, but not on UI or `example/`. Do not move database logic into models or expose Drift internals publicly unless the API change is intentional.

## Testing Guidelines

Tests use `flutter_test`. Prefer focused `group()` blocks such as `AccountRepository`, `JournalEntryRepository`, and `ReportsRepository`. Use `FlutterAccounting.forTesting()` and dispose/reset state in `tearDown()`.

## Commit & Pull Request Guidelines

History uses conventional commit prefixes, especially `feat:`. Use subjects like `feat: add trial balance filters` or `fix: reject unbalanced journal entries`. PRs need a summary, tests run, linked issues, screenshots for `example/` UI changes, and schema or generated-code notes.

## Agent-Specific Instructions

Keep edits scoped. Preserve public exports unless an API change is intentional. Update `README.md`, `CHANGELOG.md`, and tests for user-visible behavior changes.

## Do and Don't Rules

Do:
- Ask before adding, removing, or upgrading packages in `pubspec.yaml`.
- Regenerate Drift files after table or DAO changes.
- Keep changes small, tested, and aligned with existing patterns.
- Update docs and tests for behavior or API changes.

Don't:
- Do not hand-edit generated `*.g.dart` files.
- Do not introduce new architecture patterns without a clear need.
- Do not change public exports casually.
- Do not mix unrelated refactors into feature or bug-fix work.
