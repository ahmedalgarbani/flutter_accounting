/// cost_center_seed_data.dart
/// الأبعاد التحليلية الجاهزة (اختيارية)
library;

import '../repositories/interfaces/interfaces.dart';

/// الأبعاد الجاهزة: الفرع، المشروع، القسم (كلها اختيارية السياسة).
///
/// ```dart
/// await CostCenterSeedData.seed(fa.costCenters);
/// // أو: FlutterAccounting.initialize(seedDefaultCostDimensions: true, ...)
/// ```
///
/// آمنة للاستدعاء أكثر من مرة: لا تُكرر بُعداً موجوداً.
class CostCenterSeedData {
  CostCenterSeedData._();

  static const branch = 'BRANCH';
  static const project = 'PROJECT';
  static const department = 'DEPARTMENT';

  static Future<void> seed(ICostCenterRepository repo) async {
    await repo.ensureDimension(code: branch, name: 'Branch', nameAr: 'الفرع');
    await repo.ensureDimension(
        code: project, name: 'Project', nameAr: 'المشروع');
    await repo.ensureDimension(
        code: department, name: 'Department', nameAr: 'القسم');
  }
}
