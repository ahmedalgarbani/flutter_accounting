/// exceptions.dart
/// استثناءات المكتبة المحاسبية

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
