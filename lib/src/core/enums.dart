/// enums.dart
/// التعدادات الأساسية للمكتبة المحاسبية
///
/// ⚠️ التعدادات تُخزَّن في قاعدة البيانات بترتيبها (index)،
/// لذا أضف القيم الجديدة دائماً في النهاية ولا تغيّر ترتيب القيم الموجودة.
library;

// ─────────────────────────────────────────────────────────────
// نوع الحساب (Account Type)
// ─────────────────────────────────────────────────────────────
enum AccountType {
  asset, // أصول
  liability, // خصوم
  equity, // حقوق الملكية
  revenue, // إيرادات
  expense, // مصروفات
}

extension AccountTypeX on AccountType {
  /// الرصيد الطبيعي للحساب
  NormalBalance get normalBalance {
    switch (this) {
      case AccountType.asset:
      case AccountType.expense:
        return NormalBalance.debit;
      case AccountType.liability:
      case AccountType.equity:
      case AccountType.revenue:
        return NormalBalance.credit;
    }
  }

  /// هل ينتمي هذا النوع إلى قائمة المركز المالي؟
  bool get isBalanceSheetAccount =>
      this == AccountType.asset ||
      this == AccountType.liability ||
      this == AccountType.equity;

  /// هل ينتمي هذا النوع إلى قائمة الدخل؟
  bool get isIncomeStatementAccount =>
      this == AccountType.revenue || this == AccountType.expense;

  String get displayNameAr {
    switch (this) {
      case AccountType.asset:
        return 'أصول';
      case AccountType.liability:
        return 'خصوم';
      case AccountType.equity:
        return 'حقوق الملكية';
      case AccountType.revenue:
        return 'إيرادات';
      case AccountType.expense:
        return 'مصروفات';
    }
  }

  String get displayNameEn {
    switch (this) {
      case AccountType.asset:
        return 'Asset';
      case AccountType.liability:
        return 'Liability';
      case AccountType.equity:
        return 'Equity';
      case AccountType.revenue:
        return 'Revenue';
      case AccountType.expense:
        return 'Expense';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// الرصيد الطبيعي (Normal Balance)
// ─────────────────────────────────────────────────────────────
enum NormalBalance { debit, credit }

// ─────────────────────────────────────────────────────────────
// حالة القيد اليومي (Journal Entry Status)
// ─────────────────────────────────────────────────────────────
enum EntryStatus {
  draft, // مسودة - قابلة للتعديل والحذف
  posted, // مرحّل - محفوظة في دفتر الأستاذ
  reversed, // معكوس - تم إلغاؤها بقيد عكسي
}

extension EntryStatusX on EntryStatus {
  String get displayNameAr {
    switch (this) {
      case EntryStatus.draft:
        return 'مسودة';
      case EntryStatus.posted:
        return 'مرحّل';
      case EntryStatus.reversed:
        return 'معكوس';
    }
  }

  String get displayNameEn {
    switch (this) {
      case EntryStatus.draft:
        return 'Draft';
      case EntryStatus.posted:
        return 'Posted';
      case EntryStatus.reversed:
        return 'Reversed';
    }
  }

  bool get isEditable => this == EntryStatus.draft;
  bool get isPosted => this == EntryStatus.posted;

  /// هل يؤثر القيد على الأرصدة؟ (المرحّل والمعكوس كلاهما في دفتر الأستاذ،
  /// والقيد العكسي المقابل يلغي أثر القيد المعكوس)
  bool get affectsBalances =>
      this == EntryStatus.posted || this == EntryStatus.reversed;
}

// ─────────────────────────────────────────────────────────────
// نوع القيد أو العملية (Entry Type / Operation Type)
// ─────────────────────────────────────────────────────────────
enum EntryType {
  sale, // مبيعات نقدية
  purchase, // مشتريات نقدية
  saleAgil, // مبيعات آجلة
  purchaseAgil, // مشتريات آجلة
  paymentVoucher, // سند صرف
  receiptVoucher, // سند قبض
  journalEntry, // قيد يومية عام
  openingBalance, // قيد افتتاحي
  reversal, // قيد عكسي
  adjustment, // قيد تسوية
  costAllocation, // قيد توزيع تكاليف بين مراكز التكلفة
}

extension EntryTypeX on EntryType {
  String get displayNameAr {
    switch (this) {
      case EntryType.sale:
        return 'مبيعات نقدية';
      case EntryType.purchase:
        return 'مشتريات نقدية';
      case EntryType.saleAgil:
        return 'مبيعات آجلة';
      case EntryType.purchaseAgil:
        return 'مشتريات آجلة';
      case EntryType.paymentVoucher:
        return 'سند صرف';
      case EntryType.receiptVoucher:
        return 'سند قبض';
      case EntryType.journalEntry:
        return 'قيد يومية';
      case EntryType.openingBalance:
        return 'قيد افتتاحي';
      case EntryType.reversal:
        return 'قيد عكسي';
      case EntryType.adjustment:
        return 'قيد تسوية';
      case EntryType.costAllocation:
        return 'توزيع تكاليف';
    }
  }

  String get displayNameEn {
    switch (this) {
      case EntryType.sale:
        return 'Cash Sale';
      case EntryType.purchase:
        return 'Cash Purchase';
      case EntryType.saleAgil:
        return 'Credit Sale';
      case EntryType.purchaseAgil:
        return 'Credit Purchase';
      case EntryType.paymentVoucher:
        return 'Payment Voucher';
      case EntryType.receiptVoucher:
        return 'Receipt Voucher';
      case EntryType.journalEntry:
        return 'Journal Entry';
      case EntryType.openingBalance:
        return 'Opening Balance';
      case EntryType.reversal:
        return 'Reversal';
      case EntryType.adjustment:
        return 'Adjustment';
      case EntryType.costAllocation:
        return 'Cost Allocation';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// سياسة البعد التحليلي على حساب (Dimension Policy)
// ─────────────────────────────────────────────────────────────

/// هل يجب ربط بنود حساب ما بمركز تكلفة من بُعد معيّن؟
enum DimensionPolicy {
  optional, // اختياري (الافتراضي): يمكن ربط البند بمركز أو تركه
  required, // إلزامي: يُرفض البند بدون مركز من هذا البعد
  forbidden, // ممنوع: لا يُسمح بربط البند بمركز من هذا البعد
}

extension DimensionPolicyX on DimensionPolicy {
  String get displayNameAr {
    switch (this) {
      case DimensionPolicy.optional:
        return 'اختياري';
      case DimensionPolicy.required:
        return 'إلزامي';
      case DimensionPolicy.forbidden:
        return 'ممنوع';
    }
  }

  String get displayNameEn {
    switch (this) {
      case DimensionPolicy.optional:
        return 'Optional';
      case DimensionPolicy.required:
        return 'Required';
      case DimensionPolicy.forbidden:
        return 'Forbidden';
    }
  }
}
