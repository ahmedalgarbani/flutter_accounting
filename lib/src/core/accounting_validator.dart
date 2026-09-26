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
  /// 1. لا يُسمح بمبالغ سالبة ([NegativeAmountException])
  /// 2. لا يُسمح ببنود بمبلغ صفر ([ZeroAmountLineException])
  /// 3. كل بند إما مدين أو دائن وليس الاثنين ([InvalidLineAmountsException])
  /// 4. يجب وجود بند مدين وبند دائن على الأقل ([InsufficientLinesException])
  /// 5. مجموع المدين = مجموع الدائن ([UnbalancedEntryException])
  static void validateEntryLines(List<JournalEntryLineModel> lines) {
    if (lines.isEmpty) throw const InsufficientLinesException();

    double totalDebits = 0;
    double totalCredits = 0;

    // فحص كل بند أولاً كي تكون رسالة الخطأ دقيقة
    for (final line in lines) {
      // لا مبالغ سالبة
      if (line.debit < 0 || line.credit < 0) {
        throw const NegativeAmountException();
      }

      // لا مبالغ صفرية
      if (line.debit == 0 && line.credit == 0) {
        throw const ZeroAmountLineException();
      }

      // مدين أو دائن وليس الاثنين
      if (line.debit > 0 && line.credit > 0) {
        throw const InvalidLineAmountsException();
      }

      totalDebits += line.debit;
      totalCredits += line.credit;
    }

    // يجب وجود بند مدين وبند دائن على الأقل
    if (totalDebits == 0 || totalCredits == 0) {
      throw const InsufficientLinesException();
    }

    // التوازن
    if (!isBalanced(totalDebits, totalCredits)) {
      throw UnbalancedEntryException(
        totalDebits: totalDebits,
        totalCredits: totalCredits,
      );
    }
  }

  /// يتحقق دون رمي استثناء: يُعيد رسالة الخطأ أو `null` إن كان القيد صحيحاً.
  /// مفيد لعرض رسالة في الواجهة أثناء إدخال المستخدم.
  static String? checkEntryLines(List<JournalEntryLineModel> lines) {
    try {
      validateEntryLines(lines);
      return null;
    } on AccountingException catch (e) {
      return e.message;
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
  /// هامش التسامح في مقارنة المبالغ (دقة 3 منازل عشرية)
  static const double epsilon = 0.001;

  /// هل المبلغان متساويان ضمن هامش التسامح؟
  static bool isBalanced(double a, double b) => (a - b).abs() < epsilon;
}
