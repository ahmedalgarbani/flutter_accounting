/// accounting_period_repository_impl.dart
/// تنفيذ Repository الفترات المحاسبية

import '../../core/exceptions.dart';
import '../../models/accounting_period_model.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../interfaces/interfaces.dart';

class AccountingPeriodRepositoryImpl implements IAccountingPeriodRepository {
  final JournalEntriesDao _entriesDao;

  AccountingPeriodRepositoryImpl(this._entriesDao);

  @override
  Future<List<AccountingPeriodModel>> getAllPeriods() async {
    final list = await _entriesDao.getAllPeriods();
    return AccountingPeriodMapper.fromDataList(list);
  }

  @override
  Future<AccountingPeriodModel?> getPeriodForDate(DateTime date) async {
    final data = await _entriesDao.getPeriodForDate(date);
    return data != null ? AccountingPeriodMapper.fromData(data) : null;
  }

  @override
  Future<AccountingPeriodModel> createPeriod(AccountingPeriodModel period) async {
    final companion = AccountingPeriodMapper.toCompanion(period);
    final id = await _entriesDao.insertPeriod(companion);
    return period.copyWith(id: id);
  }

  @override
  Future<AccountingPeriodModel> updatePeriod(AccountingPeriodModel period) async {
    if (period.id == null) throw Exception('Period ID is required for update');
    final companion = AccountingPeriodMapper.toCompanion(period);
    await _entriesDao.updatePeriod(companion);
    return period;
  }

  @override
  Future<void> closePeriod(int id) async {
    final period = await _entriesDao.getPeriodById(id);
    if (period == null) throw Exception('Period not found');
    
    final updated = AccountingPeriodMapper.fromData(period).copyWith(isClosed: true);
    await updatePeriod(updated);
  }
}
