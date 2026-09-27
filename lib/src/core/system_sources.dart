/// system_sources.dart
/// أنواع المصدر (`sourceType`) للقيود التي تولّدها المكتبة
library;

/// أنواع المصدر للقيود التي تنشئها المكتبة تلقائياً، للبحث عنها بـ
/// `getEntriesBySource` أو عكسها بـ `fa.reverseSource`.
abstract final class SystemSources {
  /// قيود التوزيع الدوري للتكاليف (sourceId = معرّف المركز المصدر)
  static const costAllocation = 'cost_allocation';

  /// قيود إعادة تقييم العملات (sourceId = تاريخ التقييم yyyy-MM-dd)
  static const fxRevaluation = 'fx_revaluation';

  /// قيود المعاملات بين الفروع (sourceId مشترك بين القيدين)
  static const interBranch = 'inter_branch';
}
