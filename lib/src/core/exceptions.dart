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
      : super('الحساب "$accountCode" حساب رئيسي (أب)، لا يمكن التسجيل عليه مباشرة. استخدم حساباً فرعياً.');
}

/// لا يمكن إضافة حساب فرعي تحت حساب عليه قيود
class ParentAccountHasTransactionsException extends AccountingException {
  final String parentCode;
  const ParentAccountHasTransactionsException(this.parentCode)
      : super('لا يمكن إضافة حساب فرعي تحت الحساب "$parentCode" لأنه يحتوي على قيود. '
              'انقل أرصدته أولاً أو اختر حساباً أباً آخر.');
}

/// نوع الحساب الفرعي يجب أن يطابق نوع الحساب الأب
class AccountTypeMismatchException extends AccountingException {
  final String accountCode;
  final String parentCode;
  const AccountTypeMismatchException(this.accountCode, this.parentCode)
      : super('نوع الحساب "$accountCode" يجب أن يطابق نوع الحساب الأب "$parentCode".');
}

/// لا يمكن تغيير نوع حساب عليه قيود
class CannotChangeAccountTypeException extends AccountingException {
  final String accountCode;
  const CannotChangeAccountTypeException(this.accountCode)
      : super('لا يمكن تغيير نوع الحساب "$accountCode" لأنه يحتوي على قيود أو حسابات فرعية.');
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
      : super('لا يُسمح بالمبالغ السالبة. استخدم الجانب المقابل (مدين/دائن) بدلاً من ذلك.');
}

/// مبلغ البند يساوي صفر
class ZeroAmountLineException extends AccountingException {
  const ZeroAmountLineException()
      : super('لا يُسمح بإدخال بنود بمبلغ صفر.');
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
