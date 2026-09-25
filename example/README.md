# flutter_accounting example

Demo app showing how to integrate `flutter_accounting` into a Flutter app:
a small sales workflow (invoice → payment → cancel) plus screens for journal
entries, financial reports, and an account ledger.

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
```

See [`lib/sales_accounting_service.dart`](lib/sales_accounting_service.dart) for the
recommended integration pattern, and the main [README](../README.md) plus the
[integration guide](../doc/INTEGRATION.md) for details.
