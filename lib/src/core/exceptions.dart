/// exceptions.dart
/// استثناءات المكتبة المحاسبية
///
/// جميع الاستثناءات ترث من [AccountingException] (sealed)، لذا يمكنك
/// التقاطها كلها بـ `on AccountingException catch (e)` وعرض `e.message`
/// للمستخدم مباشرة، أو استخدام `switch` شامل على النوع.
library;

// ─────────────────────────────────────────────────────────────
// الاستثناء الأساسي
// ─────────────────────────────────────────────────────────────
sealed class AccountingException implements Exception {
  final String message;
  const AccountingException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// ─────────────────────────────────────────────────────────────
// استثناءات دليل الحسابات
// ─────────────────────────────────────────────────────────────

/// رمز الحساب مكرر
class DuplicateAccountCodeException extends AccountingException {
  final String code;
  const DuplicateAccountCodeException(this.code)
      : super('رمز الحساب "$code" موجود مسبقاً.');
}

/// الحساب غير موجود
class AccountNotFoundException extends AccountingException {
  final dynamic identifier;
  const AccountNotFoundException(this.identifier)
      : super('الحساب "$identifier" غير موجود.');
}

/// الحساب غير نشط
class InactiveAccountException extends AccountingException {
  final String accountCode;
  const InactiveAccountException(this.accountCode)
      : super('الحساب "$accountCode" غير نشط ولا يمكن الترحيل عليه.');
}

/// لا يمكن حذف حساب يحتوي على أرصدة أو قيود
class AccountHasTransactionsException extends AccountingException {
  const AccountHasTransactionsException()
      : super('لا يمكن حذف الحساب لأنه يحتوي على قيود محاسبية.');
}

/// لا يمكن استخدام حساب أب في القيود المحاسبية
class AccountIsParentException extends AccountingException {
  final String accountCode;
  const AccountIsParentException(this.accountCode)
      : super(
            'الحساب "$accountCode" حساب رئيسي (أب)، لا يمكن التسجيل عليه مباشرة. استخدم حساباً فرعياً.');
}

/// لا يمكن إضافة حساب فرعي تحت حساب عليه قيود
class ParentAccountHasTransactionsException extends AccountingException {
  final String parentCode;
  const ParentAccountHasTransactionsException(this.parentCode)
      : super(
            'لا يمكن إضافة حساب فرعي تحت الحساب "$parentCode" لأنه يحتوي على قيود. '
            'انقل أرصدته أولاً أو اختر حساباً أباً آخر.');
}

/// نوع الحساب الفرعي يجب أن يطابق نوع الحساب الأب
class AccountTypeMismatchException extends AccountingException {
  final String accountCode;
  final String parentCode;
  const AccountTypeMismatchException(this.accountCode, this.parentCode)
      : super(
            'نوع الحساب "$accountCode" يجب أن يطابق نوع الحساب الأب "$parentCode".');
}

/// لا يمكن تغيير نوع حساب عليه قيود
class CannotChangeAccountTypeException extends AccountingException {
  final String accountCode;
  const CannotChangeAccountTypeException(this.accountCode)
      : super(
            'لا يمكن تغيير نوع الحساب "$accountCode" لأنه يحتوي على قيود أو حسابات فرعية.');
}

/// هيكل شجرة الحسابات غير صالح (مثل جعل الحساب أباً لنفسه أو لأحد أسلافه)
class InvalidAccountHierarchyException extends AccountingException {
  const InvalidAccountHierarchyException(super.message);
}

/// لا يمكن حذف حساب أب يحتوي على حسابات فرعية
class AccountHasChildrenException extends AccountingException {
  const AccountHasChildrenException()
      : super('لا يمكن حذف الحساب لأنه يحتوي على حسابات فرعية.');
}

// ─────────────────────────────────────────────────────────────
// استثناءات القيد اليومي
// ─────────────────────────────────────────────────────────────

/// القيد غير متوازن (Debits ≠ Credits)
class UnbalancedEntryException extends AccountingException {
  final double totalDebits;
  final double totalCredits;
  UnbalancedEntryException({
    required this.totalDebits,
    required this.totalCredits,
  }) : super(
          'القيد غير متوازن: '
          'إجمالي المدين ($totalDebits) ≠ إجمالي الدائن ($totalCredits).',
        );
}

/// التاريخ يقع في فترة محاسبية مغلقة
class PeriodClosedException extends AccountingException {
  final DateTime date;
  const PeriodClosedException(this.date)
      : super('التاريخ $date يقع ضمن فترة محاسبية مغلقة ولا يمكن التسجيل فيه.');
}

/// بيانات الفترة غير صالحة (مثل تاريخ البداية بعد تاريخ النهاية)
class InvalidPeriodException extends AccountingException {
  const InvalidPeriodException(super.message);
}

/// الفترة تتداخل مع فترة موجودة
class PeriodOverlapException extends AccountingException {
  final String existingPeriodName;
  const PeriodOverlapException(this.existingPeriodName)
      : super('الفترة تتداخل مع الفترة الموجودة "$existingPeriodName".');
}

/// الفترة غير موجودة
class PeriodNotFoundException extends AccountingException {
  final int periodId;
  const PeriodNotFoundException(this.periodId)
      : super('الفترة المحاسبية رقم $periodId غير موجودة.');
}

/// لا يمكن إغلاق فترة تحتوي على قيود مسودة
class PeriodHasDraftEntriesException extends AccountingException {
  final int draftCount;
  const PeriodHasDraftEntriesException(this.draftCount)
      : super('لا يمكن إغلاق الفترة: تحتوي على $draftCount قيد/قيود مسودة. '
            'رحّلها أو احذفها أولاً.');
}

/// لا يمكن حذف فترة تحتوي على قيود
class PeriodHasEntriesException extends AccountingException {
  const PeriodHasEntriesException()
      : super('لا يمكن حذف الفترة لأنها تحتوي على قيود.');
}

/// التاريخ لا يتبع أي فترة محاسبية معرفة
class DateOutsidePeriodException extends AccountingException {
  final DateTime date;
  const DateOutsidePeriodException(this.date)
      : super('التاريخ $date لا يتبع أي فترة محاسبية نشطة.');
}

/// رقم القيد مكرر
class DuplicateSerialNumberException extends AccountingException {
  final String serialNumber;
  const DuplicateSerialNumberException(this.serialNumber)
      : super('رقم القيد "$serialNumber" موجود مسبقاً.');
}

/// القيد لا يحتوي على بنود كافية
class InsufficientLinesException extends AccountingException {
  const InsufficientLinesException()
      : super('القيد يجب أن يحتوي على بند مدين وبند دائن على الأقل.');
}

/// مبلغ سالب في أحد البنود
class NegativeAmountException extends AccountingException {
  const NegativeAmountException()
      : super(
            'لا يُسمح بالمبالغ السالبة. استخدم الجانب المقابل (مدين/دائن) بدلاً من ذلك.');
}

/// مبلغ البند يساوي صفر
class ZeroAmountLineException extends AccountingException {
  const ZeroAmountLineException() : super('لا يُسمح بإدخال بنود بمبلغ صفر.');
}

/// محاولة تعديل قيد مرحّل
class CannotModifyPostedEntryException extends AccountingException {
  const CannotModifyPostedEntryException()
      : super('لا يمكن تعديل أو حذف قيد مرحّل. قم بإنشاء قيد عكسي.');
}

/// العملية غير مسموحة في حالة القيد الحالية (مثل ترحيل قيد معكوس أو عكس مسودة)
class InvalidEntryStateException extends AccountingException {
  const InvalidEntryStateException(super.message);
}

/// القيد معكوس مسبقاً
class EntryAlreadyReversedException extends AccountingException {
  final int entryId;
  const EntryAlreadyReversedException(this.entryId)
      : super('القيد رقم $entryId معكوس مسبقاً.');
}

/// القيد غير موجود
class EntryNotFoundException extends AccountingException {
  final int entryId;
  const EntryNotFoundException(this.entryId)
      : super('القيد رقم $entryId غير موجود.');
}

/// البند يحتوي على مدين ودائن في نفس الوقت
class InvalidLineAmountsException extends AccountingException {
  const InvalidLineAmountsException()
      : super('لا يمكن أن يحتوي البند على مبلغ مدين ومبلغ دائن في نفس الوقت.');
}

// ─────────────────────────────────────────────────────────────
// استثناءات القوالب
// ─────────────────────────────────────────────────────────────

/// خطأ في القالب أو في تطبيقه (حساب مفقود لبند، قالب غير متوازن...)
class InvalidTemplateException extends AccountingException {
  const InvalidTemplateException(super.message);
}

// ─────────────────────────────────────────────────────────────
// استثناءات مراكز التكلفة
// ─────────────────────────────────────────────────────────────

/// ميزة مراكز التكلفة غير مفعّلة في [AccountingConfig.enableCostCenters]
class CostCentersDisabledException extends AccountingException {
  const CostCentersDisabledException()
      : super('مراكز التكلفة غير مفعّلة. فعّلها عبر '
            'AccountingConfig(enableCostCenters: true).');
}

/// البعد التحليلي غير موجود
class CostDimensionNotFoundException extends AccountingException {
  final dynamic identifier;
  const CostDimensionNotFoundException(this.identifier)
      : super('البعد التحليلي "$identifier" غير موجود.');
}

/// رمز البعد التحليلي مكرر
class DuplicateCostDimensionCodeException extends AccountingException {
  final String code;
  const DuplicateCostDimensionCodeException(this.code)
      : super('رمز البعد "$code" موجود مسبقاً.');
}

/// لا يمكن حذف بعد يحتوي على مراكز تكلفة
class CostDimensionHasCentersException extends AccountingException {
  const CostDimensionHasCentersException()
      : super('لا يمكن حذف البعد لأنه يحتوي على مراكز تكلفة. '
            'احذفها أو أوقف البعد بدلاً من ذلك.');
}

/// مركز التكلفة غير موجود
class CostCenterNotFoundException extends AccountingException {
  final dynamic identifier;
  const CostCenterNotFoundException(this.identifier)
      : super('مركز التكلفة "$identifier" غير موجود.');
}

/// رمز مركز التكلفة مكرر
class DuplicateCostCenterCodeException extends AccountingException {
  final String code;
  const DuplicateCostCenterCodeException(this.code)
      : super('رمز مركز التكلفة "$code" موجود مسبقاً.');
}

/// مركز التكلفة (أو بُعده) غير نشط
class InactiveCostCenterException extends AccountingException {
  final String code;
  const InactiveCostCenterException(this.code)
      : super('مركز التكلفة "$code" غير نشط (أو بُعده موقوف) '
            'ولا يمكن التوزيع عليه.');
}

/// لا يمكن التوزيع على مركز أب
class CostCenterIsParentException extends AccountingException {
  final String code;
  const CostCenterIsParentException(this.code)
      : super('مركز التكلفة "$code" مركز رئيسي (أب)، لا يمكن التوزيع عليه '
            'مباشرة. استخدم مركزاً فرعياً.');
}

/// لا يمكن حذف مركز له مراكز فرعية
class CostCenterHasChildrenException extends AccountingException {
  const CostCenterHasChildrenException()
      : super('لا يمكن حذف مركز التكلفة لأنه يحتوي على مراكز فرعية.');
}

/// لا يمكن حذف مركز عليه حركات أو مستخدم في مفتاح توزيع أو قاعدة
class CostCenterHasTransactionsException extends AccountingException {
  const CostCenterHasTransactionsException()
      : super('لا يمكن حذف مركز التكلفة لأنه مستخدم في قيود أو مفاتيح توزيع '
            'أو قواعد. أوقفه بدلاً من ذلك.');
}

/// لا يمكن إضافة مركز فرعي تحت مركز عليه حركات
class ParentCostCenterHasTransactionsException extends AccountingException {
  final String parentCode;
  const ParentCostCenterHasTransactionsException(this.parentCode)
      : super('لا يمكن إضافة مركز فرعي تحت "$parentCode" لأن عليه حركات.');
}

/// هيكل شجرة مراكز التكلفة غير صالح
class InvalidCostCenterHierarchyException extends AccountingException {
  const InvalidCostCenterHierarchyException(super.message);
}

/// الحساب يتطلب مركز تكلفة من بعد معيّن ([DimensionPolicy.required])
class CostCenterRequiredException extends AccountingException {
  final String accountCode;
  final String dimensionCode;
  const CostCenterRequiredException(this.accountCode, this.dimensionCode)
      : super('الحساب "$accountCode" يتطلب تحديد مركز تكلفة من البعد '
            '"$dimensionCode".');
}

/// الحساب لا يقبل مراكز من بعد معيّن ([DimensionPolicy.forbidden])
class CostCenterNotAllowedException extends AccountingException {
  final String accountCode;
  final String dimensionCode;
  const CostCenterNotAllowedException(this.accountCode, this.dimensionCode)
      : super('الحساب "$accountCode" لا يقبل مراكز تكلفة من البعد '
            '"$dimensionCode".');
}

/// توزيع غير صالح (مجموع لا يساوي مبلغ البند، مبلغ سالب، مركز مكرر...)
class InvalidCostAllocationException extends AccountingException {
  const InvalidCostAllocationException(super.message);
}

/// مفتاح التوزيع غير موجود
class AllocationKeyNotFoundException extends AccountingException {
  final dynamic identifier;
  const AllocationKeyNotFoundException(this.identifier)
      : super('مفتاح التوزيع "$identifier" غير موجود.');
}

/// رمز مفتاح التوزيع مكرر
class DuplicateAllocationKeyCodeException extends AccountingException {
  final String code;
  const DuplicateAllocationKeyCodeException(this.code)
      : super('رمز مفتاح التوزيع "$code" موجود مسبقاً.');
}

/// مفتاح توزيع غير صالح (بلا مراكز، أوزان سالبة، مراكز من بعد آخر...)
class InvalidAllocationKeyException extends AccountingException {
  const InvalidAllocationKeyException(super.message);
}

// ─────────────────────────────────────────────────────────────
// استثناءات تعدد العملات
// ─────────────────────────────────────────────────────────────

/// تعدد العملات غير مفعّل في [AccountingConfig.multiCurrency]
class MultiCurrencyDisabledException extends AccountingException {
  const MultiCurrencyDisabledException()
      : super('تعدد العملات غير مفعّل. فعّله عبر '
            'AccountingConfig(multiCurrency: MultiCurrencyConfig(baseCurrency: ...)).');
}

/// العملة غير معرّفة
class CurrencyNotFoundException extends AccountingException {
  final String code;
  const CurrencyNotFoundException(this.code)
      : super('العملة "$code" غير معرّفة.');
}

/// رمز العملة مكرر
class DuplicateCurrencyCodeException extends AccountingException {
  final String code;
  const DuplicateCurrencyCodeException(this.code)
      : super('العملة "$code" موجودة مسبقاً.');
}

/// العملة موقوفة
class InactiveCurrencyException extends AccountingException {
  final String code;
  const InactiveCurrencyException(this.code)
      : super('العملة "$code" موقوفة ولا يمكن التسجيل بها.');
}

/// لا يوجد سعر صرف للعملة في التاريخ المطلوب أو قبله
class ExchangeRateNotFoundException extends AccountingException {
  final String currencyCode;
  final DateTime date;
  const ExchangeRateNotFoundException(this.currencyCode, this.date)
      : super('لا يوجد سعر صرف للعملة "$currencyCode" في تاريخ $date أو قبله. '
            'أدخل السعر أولاً أو مرّره يدوياً.');
}

/// سعر صرف غير صالح (صفر أو سالب...)
class InvalidExchangeRateException extends AccountingException {
  const InvalidExchangeRateException(super.message);
}

/// عملة البند لا تطابق عملة الحساب
class CurrencyMismatchException extends AccountingException {
  final String accountCode;
  final String accountCurrency;
  final String lineCurrency;
  const CurrencyMismatchException(
      this.accountCode, this.accountCurrency, this.lineCurrency)
      : super('الحساب "$accountCode" بعملة "$accountCurrency" ولا يقبل بنوداً '
            'بعملة "$lineCurrency".');
}

/// عملة الأساس في الإعدادات تختلف عن المثبّتة في قاعدة البيانات
class BaseCurrencyMismatchException extends AccountingException {
  final String storedCurrency;
  final String configuredCurrency;
  const BaseCurrencyMismatchException(
      this.storedCurrency, this.configuredCurrency)
      : super(
            'عملة الأساس في قاعدة البيانات "$storedCurrency" ولا يمكن تغييرها '
            'إلى "$configuredCurrency" بعد تسجيل قيود.');
}

/// عملية عملات غير صالحة (تغيير عملة حساب عليه حركات، تسوية بلا رصيد...)
class InvalidCurrencyOperationException extends AccountingException {
  const InvalidCurrencyOperationException(super.message);
}

// ─────────────────────────────────────────────────────────────
// استثناءات الفروع
// ─────────────────────────────────────────────────────────────

/// الفروع غير مفعّلة في [AccountingConfig.branches]
class BranchesDisabledException extends AccountingException {
  const BranchesDisabledException()
      : super(
            'الفروع غير مفعّلة. فعّلها عبر AccountingConfig(branches: BranchConfig()).');
}

/// الفرع غير موجود
class BranchNotFoundException extends AccountingException {
  final dynamic identifier;
  const BranchNotFoundException(this.identifier)
      : super('الفرع "$identifier" غير موجود.');
}

/// رمز الفرع مكرر
class DuplicateBranchCodeException extends AccountingException {
  final String code;
  const DuplicateBranchCodeException(this.code)
      : super('رمز الفرع "$code" موجود مسبقاً.');
}

/// الفرع موقوف
class InactiveBranchException extends AccountingException {
  final String code;
  const InactiveBranchException(this.code)
      : super('الفرع "$code" موقوف ولا يمكن التسجيل عليه.');
}

/// القيد يجب أن يحدد فرعاً ([BranchConfig.requireBranch])
class BranchRequiredException extends AccountingException {
  const BranchRequiredException() : super('يجب تحديد فرع القيد.');
}

/// الحساب مقيّد بفروع أخرى
class AccountNotAllowedForBranchException extends AccountingException {
  final String accountCode;
  final String? branchCode;
  const AccountNotAllowedForBranchException(this.accountCode, this.branchCode)
      : super('الحساب "$accountCode" غير مسموح للفرع "${branchCode ?? '-'}".');
}

/// لا يمكن حذف فرع عليه قيود
class BranchHasEntriesException extends AccountingException {
  const BranchHasEntriesException()
      : super('لا يمكن حذف الفرع لأنه يحتوي على قيود. أوقفه بدلاً من ذلك.');
}

/// عملية فروع غير صالحة (فرع بلا حساب جاري، معاملة بين فروع غير متوازنة...)
class InvalidBranchOperationException extends AccountingException {
  const InvalidBranchOperationException(super.message);
}
