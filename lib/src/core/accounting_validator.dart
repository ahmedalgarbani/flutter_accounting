/// accounting_validator.dart
/// محرك التحقق من قواعد القيد المزدوج
library;

import '../models/journal_entry_line_model.dart';
import 'exceptions.dart';

class AccountingValidator {
  AccountingValidator._();

  // ─────────────────────────────────────────────────────────────
  // التحقق من بنود القيد اليومي
  // ─────────────────────────────────────────────────────────────

  /// يتحقق من صحة بنود القيد المزدوج ويرفع استثناءً عند الخطأ.
  ///
  /// القواعد:
  /// 1. يجب وجود بند مدين وبند دائن على الأقل
  /// 2. لا يُسمح ببنود بمبلغ صفر
  /// 3. كل بند يجب أن يكون إما مديناً أو دائناً وليس الاثنين معاً
  /// 4. مجموع المدين = مجموع الدائن (القيد المتوازن)
  static void validateEntryLines(List<JournalEntryLineModel> lines) {
    // القاعدة 1: عدد كافٍ من البنود
    final hasDebit  = lines.any((l) => l.debit > 0);
    final hasCredit = lines.any((l) => l.credit > 0);
    if (!hasDebit || !hasCredit) {
      throw const InsufficientLinesException();
    }

    double totalDebits  = 0;
    double totalCredits = 0;

    for (final line in lines) {
      // القاعدة 2: لا مبالغ صفرية
      if (line.debit == 0 && line.credit == 0) {
        throw const ZeroAmountLineException();
      }

      // القاعدة 3: مدين أو دائن وليس الاثنين
      if (line.debit > 0 && line.credit > 0) {
        throw const InvalidLineAmountsException();
      }

      // القاعدة 4: لا مبالغ سالبة
      if (line.debit < 0 || line.credit < 0) {
        throw const ZeroAmountLineException();
      }

      totalDebits  += line.debit;
      totalCredits += line.credit;
    }

    // القاعدة 4: التوازن
    if (!_almostEqual(totalDebits, totalCredits)) {
      throw UnbalancedEntryException(
        totalDebits: totalDebits,
        totalCredits: totalCredits,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // حساب الأرصدة
  // ─────────────────────────────────────────────────────────────

  /// يحسب إجمالي المدين لقائمة من البنود.
  static double totalDebits(List<JournalEntryLineModel> lines) =>
      lines.fold(0, (sum, l) => sum + l.debit);

  /// يحسب إجمالي الدائن لقائمة من البنود.
  static double totalCredits(List<JournalEntryLineModel> lines) =>
      lines.fold(0, (sum, l) => sum + l.credit);

  // ─────────────────────────────────────────────────────────────
  // مقارنة الأرقام العشرية
  // ─────────────────────────────────────────────────────────────
  static const double _epsilon = 0.001; // دقة 3 منازل عشرية

  static bool _almostEqual(double a, double b) => (a - b).abs() < _epsilon;
}
