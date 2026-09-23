/// accounting_period_repository_impl.dart
/// تنفيذ Repository الفترات المحاسبية
library;

import '../../core/date_utils.dart';
import '../../core/enums.dart';
import '../../core/exceptions.dart';
import '../../models/accounting_period_model.dart';
import '../../database/daos/journal_entries_dao.dart';
import '../../database/mappers/mappers.dart';
import '../interfaces/interfaces.dart';

class AccountingPeriodRepositoryImpl implements IAccountingPeriodRepository {
  final JournalEntriesDao _entriesDao;

  AccountingPeriodRepositoryImpl(this._entriesDao);

  static const _monthNamesAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  @override
  Future<List<AccountingPeriodModel>> getAllPeriods() async {
    final list = await _entriesDao.getAllPeriods();
    return AccountingPeriodMapper.fromDataList(list);
  }

  @override
  Future<AccountingPeriodModel?> getPeriodById(int id) async {
    final data = await _entriesDao.getPeriodById(id);
    return data != null ? AccountingPeriodMapper.fromData(data) : null;
  }

  @override
  Future<AccountingPeriodModel?> getPeriodForDate(DateTime date) async {
    final data = await _entriesDao.getPeriodForDate(date);
    return data != null ? AccountingPeriodMapper.fromData(data) : null;
  }

  @override
  Future<AccountingPeriodModel> createPeriod(AccountingPeriodModel period) async {
    final normalized = await _validate(period);
    final id = await _entriesDao.insertPeriod(
      AccountingPeriodMapper.toCompanion(normalized),
    );
    return normalized.copyWith(id: id);
  }

  @override
  Future<AccountingPeriodModel> updatePeriod(AccountingPeriodModel period) async {
    if (period.id == null) throw const PeriodNotFoundException(-1);
    final existing = await _getOrThrow(period.id!);

    final normalized = await _validate(period);

    // تضييق الفترة لا يجب أن يُخرج قيوداً موجودة منها إلى "لا فترة"
    // (نكتفي بمنع تغيير الحدود عند وجود قيود في النطاق القديم)
    final boundsChanged = normalized.startDate != existing.startDate ||
        normalized.endDate != existing.endDate;
    if (boundsChanged &&
        await _entriesDao.countEntriesInRange(existing.startDate, existing.endDate) > 0) {
      throw const InvalidPeriodException(
        'لا يمكن تغيير حدود فترة تحتوي على قيود.',
      );
    }

    await _entriesDao.updatePeriod(AccountingPeriodMapper.toCompanion(normalized));
    return normalized;
  }

  @override
  Future<void> closePeriod(int id) async {
    final period = await _getOrThrow(id);
    if (period.isClosed) return;

    final drafts = await _entriesDao.countEntriesInRange(
      period.startDate,
      period.endDate,
      status: EntryStatus.draft,
    );
    if (drafts > 0) throw PeriodHasDraftEntriesException(drafts);

    await _entriesDao.updatePeriod(
      AccountingPeriodMapper.toCompanion(period.copyWith(isClosed: true)),
    );
  }

  @override
  Future<void> reopenPeriod(int id) async {
    final period = await _getOrThrow(id);
    if (!period.isClosed) return;
    await _entriesDao.updatePeriod(
      AccountingPeriodMapper.toCompanion(period.copyWith(isClosed: false)),
    );
  }

  @override
  Future<void> deletePeriod(int id) async {
    final period = await _getOrThrow(id);
    if (await _entriesDao.countEntriesInRange(period.startDate, period.endDate) > 0) {
      throw const PeriodHasEntriesException();
    }
    await _entriesDao.deletePeriod(id);
  }

  @override
  Future<List<AccountingPeriodModel>> createFiscalYear(
    int year, {
    bool monthly = false,
  }) async {
    final ranges = monthly
        ? [
            for (var m = 1; m <= 12; m++)
              (
                name: '${_monthNamesAr[m - 1]} $year',
                start: DateTime(year, m, 1),
                end: DateTime(year, m + 1, 0),
              ),
          ]
        : [
            (
              name: 'السنة المالية $year',
              start: DateTime(year, 1, 1),
              end: DateTime(year, 12, 31),
            ),
          ];

    final result = <AccountingPeriodModel>[];
    await _entriesDao.transaction(() async {
      for (final r in ranges) {
        final overlapping = await _entriesDao.getOverlappingPeriods(
          startOfDay(r.start),
          endOfDay(r.end),
        );
        if (overlapping.isNotEmpty) {
          // الفترة موجودة مسبقاً بنفس النطاق → تُعاد كما هي؛ غير ذلك تداخل
          final same = overlapping.where((p) =>
              startOfDay(p.startDate) == startOfDay(r.start) &&
              startOfDay(p.endDate) == startOfDay(r.end));
          if (same.isNotEmpty) {
            result.add(AccountingPeriodMapper.fromData(same.first));
            continue;
          }
          throw PeriodOverlapException(overlapping.first.name);
        }
        result.add(await createPeriod(AccountingPeriodModel(
          name: r.name,
          startDate: r.start,
          endDate: r.end,
        )));
      }
    });
    return result;
  }

  @override
  Future<AccountingPeriodModel> ensureOpenPeriodFor(DateTime date) async {
    final existing = await getPeriodForDate(date);
    if (existing != null) {
      if (existing.isClosed) throw PeriodClosedException(date);
      return existing;
    }
    final created = await createFiscalYear(date.year);
    return created.first;
  }

  // ─────────────────────────────────────────────────────────────
  // مساعدات خاصة
  // ─────────────────────────────────────────────────────────────

  Future<AccountingPeriodModel> _getOrThrow(int id) async {
    final data = await _entriesDao.getPeriodById(id);
    if (data == null) throw PeriodNotFoundException(id);
    return AccountingPeriodMapper.fromData(data);
  }

  /// يتحقق من صحة الفترة ويطبّعها لتغطي أياماً كاملة
  Future<AccountingPeriodModel> _validate(AccountingPeriodModel period) async {
    if (period.name.trim().isEmpty) {
      throw const InvalidPeriodException('اسم الفترة مطلوب.');
    }

    final normalized = period.copyWith(
      startDate: startOfDay(period.startDate),
      endDate:   endOfDay(period.endDate),
    );

    if (normalized.endDate.isBefore(normalized.startDate)) {
      throw const InvalidPeriodException(
        'تاريخ بداية الفترة يجب أن يكون قبل تاريخ نهايتها.',
      );
    }

    final overlapping = await _entriesDao.getOverlappingPeriods(
      normalized.startDate,
      normalized.endDate,
      excludeId: period.id,
    );
    if (overlapping.isNotEmpty) {
      throw PeriodOverlapException(overlapping.first.name);
    }

    return normalized;
  }
}
