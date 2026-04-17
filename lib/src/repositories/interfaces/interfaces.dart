/// interfaces.dart
/// واجهات الـ Repository (Abstract Contracts)
/// تسمح بالاستبدال والاختبار بسهولة

import '../core/enums.dart';
import '../models/account_model.dart';
import '../models/journal_entry_model.dart';
import '../reports/report_models.dart';

// ─────────────────────────────────────────────────────────────
// IAccountRepository
// ─────────────────────────────────────────────────────────────

abstract class IAccountRepository {
  // القراءة
  Future<List<AccountModel>> getAllAccounts();
  Future<List<AccountModel>> getActiveAccounts();
  Future<AccountModel?>      getAccountById(int id);
  Future<AccountModel?>      getAccountByCode(String code);
  Future<List<AccountModel>> getAccountsByType(AccountType type);
  Future<List<AccountModel>> getChildAccounts(int parentId);
  Stream<List<AccountModel>> watchAllAccounts();

  // الكتابة
  Future<AccountModel> createAccount(AccountModel account);
  Future<AccountModel> updateAccount(AccountModel account);
  Future<void>         setAccountActive(int id, {required bool isActive});
  Future<void>         deleteAccount(int id);

  // إحصائيات
  Future<int>  countAccounts();
  Future<bool> hasTransactions(int accountId);
}

// ─────────────────────────────────────────────────────────────
// IJournalEntryRepository
// ─────────────────────────────────────────────────────────────

abstract class IJournalEntryRepository {
  // القراءة
  Future<List<JournalEntryModel>> getAllEntries();
  Future<JournalEntryModel?>      getEntryById(int id);
  Future<List<JournalEntryModel>> getEntriesByStatus(EntryStatus status);
  Future<List<JournalEntryModel>> getEntriesInDateRange(DateTime from, DateTime to);
  Stream<List<JournalEntryModel>> watchAllEntries();

  // الكتابة (مسودة)
  Future<JournalEntryModel> createEntry(JournalEntryModel entry);
  Future<JournalEntryModel> updateEntry(JournalEntryModel entry);
  Future<void>              deleteEntry(int id);

  // ترحيل وعكس
  Future<JournalEntryModel> postEntry(int id);
  Future<JournalEntryModel> reverseEntry(int id, {DateTime? reversalDate});
}

// ─────────────────────────────────────────────────────────────
// IReportsRepository
// ─────────────────────────────────────────────────────────────

abstract class IReportsRepository {
  Future<TrialBalanceReport>     getTrialBalance({DateTime? from, DateTime? to});
  Future<BalanceSheetReport>     getBalanceSheet({required DateTime asOf});
  Future<IncomeStatementReport>  getIncomeStatement({required DateTime from, required DateTime to});
}
