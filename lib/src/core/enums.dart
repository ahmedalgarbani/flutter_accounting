/// enums.dart
/// التعدادات الأساسية للمكتبة المحاسبية

// ─────────────────────────────────────────────────────────────
// نوع الحساب (Account Type)
// ─────────────────────────────────────────────────────────────
enum AccountType {
  asset,     // أصول
  liability, // خصوم
  equity,    // حقوق الملكية
  revenue,   // إيرادات
  expense,   // مصروفات
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
      case AccountType.asset:     return 'أصول';
      case AccountType.liability: return 'خصوم';
      case AccountType.equity:    return 'حقوق الملكية';
      case AccountType.revenue:   return 'إيرادات';
      case AccountType.expense:   return 'مصروفات';
    }
  }

  String get displayNameEn {
    switch (this) {
      case AccountType.asset:     return 'Asset';
      case AccountType.liability: return 'Liability';
      case AccountType.equity:    return 'Equity';
      case AccountType.revenue:   return 'Revenue';
      case AccountType.expense:   return 'Expense';
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
  draft,    // مسودة - قابلة للتعديل والحذف
  posted,   // مرحّل - محفوظة في دفتر الأستاذ
  reversed, // معكوس - تم إلغاؤها بقيد عكسي
}

extension EntryStatusX on EntryStatus {
  String get displayNameAr {
    switch (this) {
      case EntryStatus.draft:    return 'مسودة';
      case EntryStatus.posted:   return 'مرحّل';
      case EntryStatus.reversed: return 'معكوس';
    }
  }

  bool get isEditable => this == EntryStatus.draft;
  bool get isPosted    => this == EntryStatus.posted;
}
