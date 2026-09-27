/// cost_centers_test.dart
/// اختبارات مراكز التكلفة: الإعداد، التوزيع، السياسات، التوزيع الدوري، التقارير
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_accounting/flutter_accounting.dart';

import 'test_helpers.dart';

void main() {
  late FlutterAccounting fa;
  late int cashId, revenueId, expensesGroupId, rentId, salariesId;
  late CostDimensionModel branch, project, department;
  late CostCenterModel ryd, west, jed, mkk, prjA, prjB, admin, sales;
  final d = DateTime(2024, 3, 1);
  final yearStart = DateTime(2024);
  final yearEnd = DateTime(2024, 12, 31);

  setUp(() async {
    fa = FlutterAccounting.forTesting(
        config: const AccountingConfig(enableCostCenters: true));
    await fa.periods.createFiscalYear(2024);

    cashId = (await fa.accounts.createAccount(cashAccount())).id!;
    revenueId = (await fa.accounts.createAccount(revenueAccount())).id!;
    expensesGroupId = (await fa.accounts.createAccount(AccountModel.create(
            code: '5', name: 'Expenses', type: AccountType.expense)))
        .id!;
    rentId = (await fa.accounts.createAccount(AccountModel.create(
            code: '53',
            name: 'Rent',
            type: AccountType.expense,
            parentId: expensesGroupId)))
        .id!;
    salariesId = (await fa.accounts.createAccount(AccountModel.create(
            code: '54',
            name: 'Salaries',
            type: AccountType.expense,
            parentId: expensesGroupId)))
        .id!;

    await CostCenterSeedData.seed(fa.costCenters);
    branch = (await fa.costCenters.getDimensionByCode('BRANCH'))!;
    project = (await fa.costCenters.getDimensionByCode('PROJECT'))!;
    department = (await fa.costCenters.getDimensionByCode('DEPARTMENT'))!;

    Future<CostCenterModel> center(CostDimensionModel dim, String code,
            {int? parentId}) =>
        fa.costCenters.createCostCenter(CostCenterModel(
            dimensionId: dim.id!, code: code, name: code, parentId: parentId));

    ryd = await center(branch, 'BR-RYD');
    west = await center(branch, 'BR-WEST');
    jed = await center(branch, 'BR-JED', parentId: west.id);
    mkk = await center(branch, 'BR-MKK', parentId: west.id);
    prjA = await center(project, 'PRJ-A');
    prjB = await center(project, 'PRJ-B');
    admin = await center(department, 'DEP-ADMIN');
    sales = await center(department, 'DEP-SALES');
  });

  tearDown(() => fa.dispose());

  /// بيع نقدي بإيراد موزع
  Future<JournalEntryModel> sale(
          double amount, List<CostAllocationModel> allocations,
          {DateTime? date}) =>
      fa.record(JournalEntryBuilder(description: 'sale', date: date ?? d)
          .debit(cashId, amount)
          .credit(revenueId, amount, allocations: allocations));

  /// مصروف نقدي موزع
  Future<JournalEntryModel> expense(
          int accountId, double amount, List<CostAllocationModel> allocations,
          {DateTime? date}) =>
      fa.record(JournalEntryBuilder(description: 'expense', date: date ?? d)
          .debit(accountId, amount, allocations: allocations)
          .credit(cashId, amount));

  // ─────────────────────────────────────────────────────────────
  group('تفعيل الميزة', () {
    test('الميزة موقوفة افتراضياً: الكتابة مرفوضة والقيود العادية تعمل',
        () async {
      final off = FlutterAccounting.forTesting();
      addTearDown(off.dispose);
      await off.periods.createFiscalYear(2024);
      final c = (await off.accounts.createAccount(cashAccount())).id!;
      final r = (await off.accounts.createAccount(revenueAccount())).id!;

      expect(() => off.costCenters.ensureDimension(code: 'X', name: 'X'),
          throwsA(isA<CostCentersDisabledException>()));
      expect(
          () => off.record(JournalEntryBuilder(description: 'x', date: d)
              .debit(c, 10)
              .credit(r, 10, allocations: [CostAllocationModel.full(1)])),
          throwsA(isA<CostCentersDisabledException>()));

      // بدون توزيع: لا تغيير في السلوك
      final e = await off.record(JournalEntryBuilder(description: 'x', date: d)
          .debit(c, 10)
          .credit(r, 10));
      expect(e.isPosted, isTrue);
      expect(await off.costCenters.getDimensions(), isEmpty);
    });

    test('زرع الأبعاد الجاهزة يتطلب تفعيل الميزة', () async {
      expect(
          () => FlutterAccounting.initialize(
              customExecutor: NativeDatabase.memory(),
              seedDefaultCostDimensions: true),
          throwsArgumentError);
    });

    test('الزرع لا يكرر الأبعاد', () async {
      await CostCenterSeedData.seed(fa.costCenters);
      expect(await fa.costCenters.getDimensions(), hasLength(3));
    });

    test('بدون توزيع وبسياسات اختيارية: القيود لا تتأثر', () async {
      final e = await fa.record(JournalEntryBuilder(description: 'x', date: d)
          .debit(cashId, 10)
          .credit(revenueId, 10));
      expect(e.lines.every((l) => l.allocations.isEmpty), isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('CostCenterRepository', () {
    test('رموز مكررة مرفوضة', () async {
      expect(
          () => fa.costCenters.createDimension(
              const CostDimensionModel(code: 'BRANCH', name: 'x')),
          throwsA(isA<DuplicateCostDimensionCodeException>()));
      expect(
          () => fa.costCenters.createCostCenter(CostCenterModel(
              dimensionId: project.id!, code: 'BR-RYD', name: 'x')),
          throwsA(isA<DuplicateCostCenterCodeException>()));
    });

    test('المستوى يُحسب تلقائياً والأب يجب أن يكون من نفس البعد', () async {
      expect(jed.level, 2);
      expect(
          () => fa.costCenters.createCostCenter(CostCenterModel(
              dimensionId: project.id!,
              code: 'PRJ-X',
              name: 'x',
              parentId: west.id)),
          throwsA(isA<InvalidCostCenterHierarchyException>()));
    });

    test('منع الدورات في الشجرة ومنع تغيير البعد', () async {
      expect(
          () =>
              fa.costCenters.updateCostCenter(west.copyWith(parentId: jed.id)),
          throwsA(isA<InvalidCostCenterHierarchyException>()));
      expect(
          () => fa.costCenters
              .updateCostCenter(ryd.copyWith(dimensionId: project.id)),
          throwsA(isA<InvalidCostCenterHierarchyException>()));
    });

    test('نقل مركز يعيد حساب مستويات أبنائه', () async {
      final sub = await fa.costCenters.createCostCenter(CostCenterModel(
          dimensionId: branch.id!,
          code: 'BR-JED-2',
          name: 'x',
          parentId: jed.id));
      expect(sub.level, 3);
      await fa.costCenters.updateCostCenter(west.copyWith(parentId: ryd.id));
      expect((await fa.costCenters.getCostCenterById(sub.id!))!.level, 4);
    });

    test('لا مركز فرعي تحت مركز عليه حركات، ولا حذف لمركز عليه حركات',
        () async {
      await sale(100, [CostAllocationModel.full(ryd.id!)]);
      expect(
          () => fa.costCenters.createCostCenter(CostCenterModel(
              dimensionId: branch.id!,
              code: 'BR-RYD-1',
              name: 'x',
              parentId: ryd.id)),
          throwsA(isA<ParentCostCenterHasTransactionsException>()));
      expect(() => fa.costCenters.deleteCostCenter(ryd.id!),
          throwsA(isA<CostCenterHasTransactionsException>()));
      expect(() => fa.costCenters.deleteCostCenter(west.id!),
          throwsA(isA<CostCenterHasChildrenException>()));
      expect(await fa.costCenters.hasTransactions(ryd.id!), isTrue);
    });

    test('حذف بعد يحتوي على مراكز مرفوض، والبعد الفارغ يُحذف مع قواعده',
        () async {
      expect(() => fa.costCenters.deleteDimension(branch.id!),
          throwsA(isA<CostDimensionHasCentersException>()));
      final extra =
          await fa.costCenters.ensureDimension(code: 'REGION', name: 'Region');
      await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: extra.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));
      await fa.costCenters.deleteDimension(extra.id!);
      expect(await fa.costCenters.getDimensionByCode('REGION'), isNull);
      expect(await fa.costCenters.getRules(), isEmpty);
    });

    test('المراكز القابلة للتوزيع: النهائية النشطة في أبعاد نشطة', () async {
      await fa.costCenters.setCostCenterActive(mkk.id!, isActive: false);
      final postable =
          await fa.costCenters.getPostableCostCenters(dimensionId: branch.id);
      expect(postable.map((c) => c.code), ['BR-JED', 'BR-RYD']);

      await fa.costCenters.setDimensionActive(branch.id!, isActive: false);
      expect(
          await fa.costCenters.getPostableCostCenters(dimensionId: branch.id),
          isEmpty);
    });

    test('ensureCostCenter بالرموز والبحث', () async {
      final c = await fa.costCenters.ensureCostCenter(
          dimensionCode: 'BRANCH',
          code: 'BR-TBK',
          name: 'Tabuk',
          nameAr: 'تبوك',
          parentCode: 'BR-WEST');
      expect(c.parentId, west.id);
      expect(
          (await fa.costCenters.ensureCostCenter(
                  dimensionCode: 'BRANCH', code: 'BR-TBK', name: 'x'))
              .id,
          c.id);
      expect((await fa.costCenters.searchCostCenters('تبوك')).single.id, c.id);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('توزيع البنود', () {
    test('مركز من كل بُعد + توزيع بالنسب داخل البعد', () async {
      final e = await expense(rentId, 1000, [
        CostAllocationModel.percent(ryd.id!, 60),
        CostAllocationModel.percent(jed.id!, 40),
        CostAllocationModel.full(prjA.id!),
        CostAllocationModel.code('DEP-ADMIN'),
      ]);
      final line = e.lines.firstWhere((l) => l.accountId == rentId);
      expect(line.allocations, hasLength(4));
      final byCode = {for (final a in line.allocations) a.costCenterCode: a};
      expect(byCode['BR-RYD']!.amount, 600);
      expect(byCode['BR-JED']!.amount, 400);
      expect(byCode['BR-JED']!.percentage, 40);
      expect(byCode['PRJ-A']!.amount, 1000);
      expect(byCode['DEP-ADMIN']!.dimensionId, department.id);
      expect(byCode['DEP-ADMIN']!.costCenterName, 'DEP-ADMIN');

      // الجلب من القاعدة يعيد نفس التوزيع
      final loaded = await fa.journalEntries.getEntryById(e.id!);
      expect(loaded!.lines.first.allocations, hasLength(4));
    });

    test('فرق التقريب يُحمَّل على آخر حصة', () async {
      const third = 100 / 3;
      final e = await expense(rentId, 100, [
        CostAllocationModel.percent(ryd.id!, third),
        CostAllocationModel.percent(jed.id!, third),
        CostAllocationModel.percent(mkk.id!, third),
      ]);
      final amounts = e.lines.first.allocations.map((a) => a.amount).toList();
      expect(amounts, [33.33, 33.33, 33.34]);
    });

    test('توزيع بالمبالغ', () async {
      final e = await expense(rentId, 500, [
        CostAllocationModel.amount(ryd.id!, 200),
        CostAllocationModel.amount('BR-JED', 300),
      ]);
      expect(e.lines.first.allocations.map((a) => a.percentage), [40, 60]);
    });

    test('توزيع لا يساوي مبلغ البند مرفوض', () async {
      expect(
          () => expense(rentId, 500, [
                CostAllocationModel.amount(ryd.id!, 200),
                CostAllocationModel.amount(jed.id!, 200),
              ]),
          throwsA(isA<InvalidCostAllocationException>()));
      expect(
          () =>
              expense(rentId, 500, [CostAllocationModel.percent(ryd.id!, 50)]),
          throwsA(isA<InvalidCostAllocationException>()));
    });

    test('حصة سالبة أو مركز مكرر مرفوض', () async {
      expect(
          () => expense(rentId, 100, [
                CostAllocationModel.amount(ryd.id!, 150),
                CostAllocationModel.amount(jed.id!, -50),
              ]),
          throwsA(isA<InvalidCostAllocationException>()));
      expect(
          () => expense(rentId, 100, [
                CostAllocationModel.percent(ryd.id!, 50),
                CostAllocationModel.percent(ryd.id!, 50),
              ]),
          throwsA(isA<InvalidCostAllocationException>()));
    });

    test('مركز أب أو موقوف أو غير موجود مرفوض', () async {
      expect(() => expense(rentId, 100, [CostAllocationModel.full(west.id!)]),
          throwsA(isA<CostCenterIsParentException>()));
      expect(() => expense(rentId, 100, [CostAllocationModel.code('NOPE')]),
          throwsA(isA<CostCenterNotFoundException>()));

      await fa.costCenters.setCostCenterActive(ryd.id!, isActive: false);
      expect(() => expense(rentId, 100, [CostAllocationModel.full(ryd.id!)]),
          throwsA(isA<InactiveCostCenterException>()));

      await fa.costCenters.setDimensionActive(project.id!, isActive: false);
      expect(() => expense(rentId, 100, [CostAllocationModel.full(prjA.id!)]),
          throwsA(isA<InactiveCostCenterException>()));
    });

    test('بُعد لا يسمح بالتقسيم', () async {
      await fa.costCenters
          .updateDimension(department.copyWith(allowSplit: false));
      expect(
          () => expense(rentId, 100, [
                CostAllocationModel.percent(admin.id!, 50),
                CostAllocationModel.percent(sales.id!, 50),
              ]),
          throwsA(isA<InvalidCostAllocationException>()));
      await expense(rentId, 100, [CostAllocationModel.full(admin.id!)]);
    });

    test('تعديل المسودة يستبدل التوزيع، وحذفها يحذفه', () async {
      final draft = await fa.record(
          JournalEntryBuilder(description: 'draft', date: d).debit(rentId, 100,
              allocations: [
                CostAllocationModel.full(ryd.id!)
              ]).credit(cashId, 100),
          post: false);
      final updated = await fa.journalEntries.updateEntry(draft.copyWith(
        lines: [
          JournalEntryLineModel.debitLine(
              accountId: rentId,
              amount: 100,
              allocations: [CostAllocationModel.full(jed.id!)]),
          JournalEntryLineModel.creditLine(accountId: cashId, amount: 100),
        ],
      ));
      expect(updated.lines.first.allocations.single.costCenterId, jed.id);
      expect(await fa.costCenters.hasTransactions(ryd.id!), isFalse);

      final posted = await fa.journalEntries.postEntry(updated.id!);
      expect(posted.isPosted, isTrue);

      final other = await fa.record(
          JournalEntryBuilder(description: 'draft2', date: d).debit(rentId, 5,
              allocations: [
                CostAllocationModel.full(mkk.id!)
              ]).credit(cashId, 5),
          post: false);
      await fa.journalEntries.deleteEntry(other.id!);
      expect(await fa.costCenters.hasTransactions(mkk.id!), isFalse);
    });

    test('القيد العكسي ينسخ التوزيع ويلغي أثره حتى لو أُوقف المركز', () async {
      final e = await expense(rentId, 300, [
        CostAllocationModel.percent(ryd.id!, 50),
        CostAllocationModel.percent(jed.id!, 50),
      ]);
      await fa.costCenters.setCostCenterActive(ryd.id!, isActive: false);
      final rev = await fa.journalEntries.reverseEntry(e.id!, reversalDate: d);
      expect(rev.lines.firstWhere((l) => l.accountId == rentId).allocations,
          hasLength(2));

      final summary = await fa.costReports
          .getSummary(dimensionId: branch.id!, from: yearStart, to: yearEnd);
      for (final r in summary.rows) {
        expect(r.expenses, 0, reason: r.code);
      }
    });

    test('JournalEntryModel.toMap/fromMap يحفظ التوزيع', () async {
      final e = await expense(rentId, 100, [CostAllocationModel.full(ryd.id!)]);
      final copy = JournalEntryModel.fromMap(e.toMap());
      expect(copy.lines.first.allocations.single.amount, 100);
      expect(copy.lines.first.allocations.single.costCenterCode, 'BR-RYD');
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('السياسات والمراكز الافتراضية', () {
    test('قاعدة على نوع الحساب: القسم إلزامي للمصروفات', () async {
      await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: department.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));

      expect(() => expense(rentId, 100, const []),
          throwsA(isA<CostCenterRequiredException>()));
      await expense(rentId, 100, [CostAllocationModel.full(admin.id!)]);
      // الإيرادات غير متأثرة
      await sale(100, const []);
    });

    test('قاعدة الحساب الأب تسري على أبنائه وتتقدم على قاعدة النوع', () async {
      await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: project.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));
      await fa.costCenters.setRule(DimensionRuleModel.forAccount(
          dimensionId: project.id!,
          accountId: expensesGroupId,
          policy: DimensionPolicy.forbidden));

      expect(
          await fa.costCenters
              .getEffectivePolicy(accountId: rentId, dimensionId: project.id!),
          DimensionPolicy.forbidden);
      expect(() => expense(rentId, 100, [CostAllocationModel.full(prjA.id!)]),
          throwsA(isA<CostCenterNotAllowedException>()));
      await expense(rentId, 100, const []);

      // قاعدة على الحساب نفسه تتقدم على قاعدة الأب
      await fa.costCenters.setRule(DimensionRuleModel.forAccount(
          dimensionId: project.id!,
          accountId: rentId,
          policy: DimensionPolicy.optional));
      await expense(rentId, 100, [CostAllocationModel.full(prjA.id!)]);
    });

    test('setRule يحدّث القاعدة الموجودة لنفس الهدف', () async {
      final r1 = await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: department.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));
      final r2 = await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: department.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.optional));
      expect(r2.id, r1.id);
      expect(await fa.costCenters.getRules(dimensionId: department.id),
          hasLength(1));
      expect(
          () => fa.costCenters.setRule(DimensionRuleModel(
              dimensionId: department.id!, policy: DimensionPolicy.required)),
          throwsArgumentError);
    });

    test('المركز الافتراضي يُطبق تلقائياً ويمكن تجاوزه', () async {
      await fa.costCenters.setRule(DimensionRuleModel.forAccount(
          dimensionId: department.id!,
          accountId: salariesId,
          policy: DimensionPolicy.required,
          defaultCostCenterId: sales.id));

      final auto = await expense(salariesId, 800, const []);
      final a = auto.lines.first.allocations.single;
      expect(a.costCenterId, sales.id);
      expect(a.amount, 800);

      final manual =
          await expense(salariesId, 50, [CostAllocationModel.full(admin.id!)]);
      expect(manual.lines.first.allocations.single.costCenterId, admin.id);
    });

    test('المركز الافتراضي يجب أن يكون مركزاً نهائياً من نفس البعد', () async {
      expect(
          () => fa.costCenters.setRule(DimensionRuleModel.forType(
              dimensionId: branch.id!,
              accountType: AccountType.expense,
              defaultCostCenterId: west.id)),
          throwsA(isA<CostCenterIsParentException>()));
      expect(
          () => fa.costCenters.setRule(DimensionRuleModel.forType(
              dimensionId: branch.id!,
              accountType: AccountType.expense,
              defaultCostCenterId: prjA.id)),
          throwsA(isA<InvalidCostAllocationException>()));
    });

    test('السياسة الافتراضية للبعد، والبعد الموقوف لا تُطبق سياسته', () async {
      await fa.costCenters.updateDimension(
          branch.copyWith(defaultPolicy: DimensionPolicy.required));
      expect(() => sale(100, const []),
          throwsA(isA<CostCenterRequiredException>()));

      await fa.costCenters.setDimensionActive(branch.id!, isActive: false);
      await sale(100, const []);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('مفاتيح التوزيع', () {
    Future<AllocationKeyModel> areaKey() => fa.costCenters.saveAllocationKey(
          AllocationKeyModel(
            code: 'AREA',
            name: 'Area',
            dimensionId: branch.id!,
            items: [
              AllocationKeyItemModel(costCenterId: ryd.id!, weight: 300),
              AllocationKeyItemModel(costCenterId: jed.id!, weight: 200),
              AllocationKeyItemModel(costCenterId: mkk.id!, weight: 100),
            ],
          ),
        );

    test('حفظ مفتاح وجلبه وتقسيم مبلغ حسبه', () async {
      final key = await areaKey();
      expect(key.items, hasLength(3));
      expect(key.items.first.costCenterCode, 'BR-RYD');
      expect(key.percentageOf(key.items.first), 50);

      final shares = await fa.costCenters.splitByKey(key.id!, 1000);
      expect(shares.map((s) => s.amount), [500, 333.33, 166.67]);
    });

    test('تحديث المفتاح يستبدل بنوده', () async {
      final key = await areaKey();
      final updated = await fa.costCenters.saveAllocationKey(key.copyWith(
          items: [AllocationKeyItemModel(costCenterId: ryd.id!, weight: 1)]));
      expect(updated.items, hasLength(1));
      expect((await fa.costCenters.getAllocationKeys()), hasLength(1));
    });

    test('مفتاح غير صالح مرفوض', () async {
      AllocationKeyModel key(List<AllocationKeyItemModel> items) =>
          AllocationKeyModel(
              code: 'K', name: 'K', dimensionId: branch.id!, items: items);
      expect(() => fa.costCenters.saveAllocationKey(key([])),
          throwsA(isA<InvalidAllocationKeyException>()));
      expect(
          () => fa.costCenters.saveAllocationKey(
              key([AllocationKeyItemModel(costCenterId: ryd.id!, weight: 0)])),
          throwsA(isA<InvalidAllocationKeyException>()));
      expect(
          () => fa.costCenters.saveAllocationKey(key([
                AllocationKeyItemModel(costCenterId: ryd.id!, weight: 1),
                AllocationKeyItemModel(costCenterId: ryd.id!, weight: 1),
              ])),
          throwsA(isA<InvalidAllocationKeyException>()));
      expect(
          () => fa.costCenters.saveAllocationKey(
              key([AllocationKeyItemModel(costCenterId: prjA.id!, weight: 1)])),
          throwsA(isA<InvalidCostAllocationException>()));
      expect(
          () => fa.costCenters.saveAllocationKey(
              key([AllocationKeyItemModel(costCenterId: west.id!, weight: 1)])),
          throwsA(isA<CostCenterIsParentException>()));
    });

    test('allocationKey في JournalEntryBuilder مع بُعد آخر', () async {
      await areaKey();
      final e = await fa.record(
          JournalEntryBuilder(description: 'rent', date: d)
              .debitCode('53', 600, allocationKey: 'AREA', allocations: [
        CostAllocationModel.code('DEP-ADMIN'),
      ]).creditCode('111', 600));
      final allocations = e.lines.first.allocations;
      expect(allocations, hasLength(4));
      expect(
          allocations
              .where((a) => a.dimensionId == branch.id)
              .map((a) => a.amount),
          [300, 200, 100]);
      expect(
          () => JournalEntryBuilder(description: 'x')
              .debit(rentId, 1, allocationKey: 'AREA')
              .credit(cashId, 1)
              .build(),
          throwsStateError);
    });

    test('المركز المستخدم في مفتاح لا يُحذف', () async {
      await areaKey();
      expect(() => fa.costCenters.deleteCostCenter(mkk.id!),
          throwsA(isA<CostCenterHasTransactionsException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('CostAllocationRepository - التوزيع الدوري', () {
    late CostCenterModel hq;
    late AllocationKeyModel key;

    setUp(() async {
      hq = await fa.costCenters.createCostCenter(
          CostCenterModel(dimensionId: branch.id!, code: 'BR-HQ', name: 'HQ'));
      key = await fa.costCenters.saveAllocationKey(AllocationKeyModel(
        code: 'SALES-SHARE',
        name: 'Sales share',
        dimensionId: branch.id!,
        items: [
          AllocationKeyItemModel(costCenterId: ryd.id!, weight: 3),
          AllocationKeyItemModel(costCenterId: jed.id!, weight: 1),
        ],
      ));
    });

    CostAllocationRequest request({List<int>? accountIds}) =>
        CostAllocationRequest(
          sourceCostCenterId: hq.id!,
          allocationKeyId: key.id!,
          from: yearStart,
          to: DateTime(2024, 3, 31),
          accountIds: accountIds,
        );

    test('معاينة ثم تنفيذ: تنتقل الأرصدة من المركز المصدر', () async {
      await expense(rentId, 1000, [CostAllocationModel.full(hq.id!)]);
      await expense(salariesId, 400, [CostAllocationModel.full(hq.id!)]);
      await expense(rentId, 50, [CostAllocationModel.full(ryd.id!)]);

      final preview = await fa.costAllocations.previewAllocation(request());
      expect(preview.lines.map((l) => l.accountCode), ['53', '54']);
      expect(preview.totalAmount, 1400);
      expect(preview.totalsByCostCenter[ryd.id], 1050);
      expect(preview.totalsByCostCenter[jed.id], 350);

      final entry = await fa.costAllocations.runAllocation(request());
      expect(entry.entryType, EntryType.costAllocation);
      expect(entry.sourceType, 'cost_allocation');
      expect(entry.isBalanced, isTrue);

      final summary = await fa.costReports
          .getSummary(dimensionId: branch.id!, from: yearStart, to: yearEnd);
      double expOf(String code) =>
          summary.rows.firstWhere((r) => r.code == code).expenses;
      expect(expOf('BR-HQ'), 0);
      expect(expOf('BR-RYD'), 1100);
      expect(expOf('BR-JED'), 350);
      expect(summary.totalExpenses, 1450); // أرصدة الحسابات لم تتغير

      // لا شيء للتوزيع بعد التنفيذ
      expect(() => fa.costAllocations.runAllocation(request()),
          throwsA(isA<InvalidCostAllocationException>()));
    });

    test('فلتر الحسابات والتوزيع كمسودة', () async {
      await expense(rentId, 1000, [CostAllocationModel.full(hq.id!)]);
      await expense(salariesId, 400, [CostAllocationModel.full(hq.id!)]);
      final draft = await fa.costAllocations
          .runAllocation(request(accountIds: [salariesId]), post: false);
      expect(draft.isPosted, isFalse);
      expect(draft.lines, hasLength(2));
      expect(draft.totalDebits, 400);
    });

    test('القسم الإلزامي لا يمنع قيد التوزيع', () async {
      await expense(rentId, 100, [
        CostAllocationModel.full(hq.id!),
        CostAllocationModel.full(admin.id!),
      ]);
      await fa.costCenters.setRule(DimensionRuleModel.forType(
          dimensionId: department.id!,
          accountType: AccountType.expense,
          policy: DimensionPolicy.required));
      final e = await fa.costAllocations.runAllocation(request());
      expect(e.isPosted, isTrue);
    });

    test('المفتاح من بُعد آخر أو مصدر أب مرفوض', () async {
      final projectKey = await fa.costCenters.saveAllocationKey(
          AllocationKeyModel(
              code: 'P',
              name: 'P',
              dimensionId: project.id!,
              items: [
            AllocationKeyItemModel(costCenterId: prjA.id!, weight: 1),
          ]));
      expect(
          () => fa.costAllocations.previewAllocation(CostAllocationRequest(
              sourceCostCenterId: hq.id!,
              allocationKeyId: projectKey.id!,
              from: yearStart,
              to: yearEnd)),
          throwsA(isA<InvalidAllocationKeyException>()));
      expect(
          () => fa.costAllocations.previewAllocation(CostAllocationRequest(
              sourceCostCenterId: west.id!,
              allocationKeyId: key.id!,
              from: yearStart,
              to: yearEnd)),
          throwsA(isA<CostCenterIsParentException>()));
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('CostReportsRepository', () {
    setUp(() async {
      // الرياض: إيراد 1000 (مشروع A) ومصروف 300 (A)
      await sale(1000, [
        CostAllocationModel.full(ryd.id!),
        CostAllocationModel.full(prjA.id!),
      ]);
      await expense(rentId, 300, [
        CostAllocationModel.full(ryd.id!),
        CostAllocationModel.full(prjA.id!),
      ]);
      // جدة: إيراد 600 نصفه A ونصفه B
      await sale(600, [
        CostAllocationModel.full(jed.id!),
        CostAllocationModel.percent(prjA.id!, 50),
        CostAllocationModel.percent(prjB.id!, 50),
      ]);
      // مكة: مصروف 200 (B)
      await expense(salariesId, 200, [
        CostAllocationModel.full(mkk.id!),
        CostAllocationModel.full(prjB.id!),
      ]);
      // غير موزع على الفروع: إيراد 50 ومصروف 20
      await sale(50, const []);
      await expense(rentId, 20, [CostAllocationModel.full(prjB.id!)]);
      // مسودة وقيد خارج الفترة لا يدخلان
      await fa.record(
          JournalEntryBuilder(description: 'draft', date: d)
              .debit(cashId, 999)
              .credit(revenueId, 999,
                  allocations: [CostAllocationModel.full(ryd.id!)]),
          post: false);
      await fa.periods.createFiscalYear(2025);
      await sale(77, [CostAllocationModel.full(ryd.id!)],
          date: DateTime(2025, 1, 5));
    });

    test('الملخص: تجميع هرمي وغير موزع وإجماليات المنشأة', () async {
      final s = await fa.costReports
          .getSummary(dimensionId: branch.id!, from: yearStart, to: yearEnd);
      expect(
          s.rows.map((r) => r.code), ['BR-RYD', 'BR-WEST', 'BR-JED', 'BR-MKK']);
      final byCode = {for (final r in s.rows) r.code: r};
      expect(byCode['BR-RYD']!.netIncome, 700);
      expect(byCode['BR-WEST']!.revenue, 600);
      expect(byCode['BR-WEST']!.expenses, 200);
      expect(byCode['BR-WEST']!.isLeaf, isFalse);
      expect(byCode['BR-JED']!.level, 2);
      expect(s.unallocatedRevenue, 50);
      expect(s.unallocatedExpenses, 20);
      expect(s.totalRevenue, 1650);
      expect(s.totalExpenses, 520);
      expect(s.childrenOf(west.id!).map((r) => r.code), ['BR-JED', 'BR-MKK']);

      final income =
          await fa.reports.getIncomeStatement(from: yearStart, to: yearEnd);
      expect(s.totalNetIncome, income.netIncome);
    });

    test('المقارنة: الحسابات × المراكز الجذرية + غير موزع', () async {
      final c = await fa.costReports
          .getComparison(dimensionId: branch.id!, from: yearStart, to: yearEnd);
      expect(
          c.columns.map((col) => col.header.code), ['BR-RYD', 'BR-WEST', '']);
      expect(c.columns.last.header.isUnallocated, isTrue);
      final rent = c.rows.firstWhere((r) => r.accountId == rentId);
      expect(rent.amountFor(ryd.id), 300);
      expect(rent.amountFor(west.id), 0);
      expect(rent.amountFor(null), 20);
      expect(rent.total, 320);
      expect(c.columns[1].netIncome, 400);
      expect(c.rows.any((r) => r.accountId == cashId), isFalse);

      final withBs = await fa.costReports.getComparison(
          dimensionId: branch.id!,
          from: yearStart,
          to: yearEnd,
          costCenterIds: [jed.id!, mkk.id!],
          includeUnallocated: false,
          incomeStatementOnly: false);
      expect(withBs.columns, hasLength(2));
      expect(withBs.rows.any((r) => r.accountId == cashId), isFalse,
          reason: 'النقدية لم تُوزع على مراكز');
    });

    test('قائمة الدخل لمركز أب تشمل أبناءه', () async {
      final r = await fa.costReports.getIncomeStatement(
          filter: CostCenterFilter.single(west.id!),
          from: yearStart,
          to: yearEnd);
      expect(r.totalRevenue, 600);
      expect(r.totalExpenses, 200);
      final only = await fa.costReports.getIncomeStatement(
          filter: CostCenterFilter.single(west.id!, includeChildren: false),
          from: yearStart,
          to: yearEnd);
      expect(only.netIncome, 0);
    });

    test('تقاطع بُعدين بالتناسب (فرع × مشروع)', () async {
      final jedA = await fa.costReports.getIncomeStatement(
          filter: CostCenterFilter([jed.id!, prjA.id!]),
          from: yearStart,
          to: yearEnd);
      expect(jedA.totalRevenue, 300);

      // مراكز من نفس البعد تُجمع
      final ab = await fa.costReports.getIncomeStatement(
          filter: CostCenterFilter([prjA.id!, prjB.id!]),
          from: yearStart,
          to: yearEnd);
      expect(ab.totalRevenue, 1600);
      expect(ab.totalExpenses, 520);
    });

    test('ميزان المراجعة لمركز', () async {
      final tb = await fa.costReports.getTrialBalance(
          filter: CostCenterFilter.single(ryd.id!),
          from: yearStart,
          to: yearEnd);
      expect(tb.rows.map((r) => r.accountCode), ['41', '53']);
      expect(tb.rows.first.creditBalance, 1000);
      expect(tb.rows.last.debitBalance, 300);
    });

    test('كشف حساب مركز مع رصيد افتتاحي وفلتر حساب', () async {
      await sale(10, [CostAllocationModel.full(ryd.id!)],
          date: DateTime(2024, 1, 10));
      final ledger = await fa.costReports.getLedger(ryd.id!,
          from: DateTime(2024, 2, 1), to: DateTime(2025, 12, 31));
      expect(ledger.openingBalance, -10);
      expect(ledger.lines, hasLength(3));
      expect(ledger.totalCredits, 1077);
      expect(ledger.totalDebits, 300);
      expect(ledger.closingBalance, -10 - 1077 + 300);

      final westRent = await fa.costReports.getLedger(west.id!,
          accountId: expensesGroupId, from: yearStart, to: yearEnd);
      expect(westRent.lines.single.costCenterCode, 'BR-MKK');
      expect(westRent.lines.single.debit, 200);
    });

    test('المصفوفة فرع × مشروع مع غير الموزع', () async {
      final m = await fa.costReports.getMatrix(
          rowDimensionId: branch.id!,
          columnDimensionId: project.id!,
          from: yearStart,
          to: yearEnd);
      expect(m.rowHeaders.map((h) => h.code), ['BR-RYD', 'BR-WEST', '']);
      expect(m.columnHeaders.map((h) => h.code), ['PRJ-A', 'PRJ-B', '']);
      expect(m.cell(ryd.id, prjA.id).netIncome, 700);
      expect(m.cell(west.id, prjA.id).revenue, 300);
      expect(m.cell(west.id, prjB.id).revenue, 300);
      expect(m.cell(west.id, prjB.id).expenses, 200);
      expect(m.cell(null, prjB.id).expenses, 20);
      expect(m.cell(null, null).revenue, 50);
      expect(m.rowTotal(west.id).netIncome, 400);
      expect(m.columnTotal(prjB.id).netIncome, 80);
      expect(m.grandTotal.netIncome, 1130);
      expect(
          () => fa.costReports.getMatrix(
              rowDimensionId: branch.id!, columnDimensionId: branch.id!),
          throwsArgumentError);
    });

    test('البنود غير الموزعة', () async {
      final r = await fa.costReports.getUnallocatedLines(
          dimensionId: branch.id!, from: yearStart, to: yearEnd);
      expect(r.lines, hasLength(2));
      expect(r.totalUnallocated, 70);
      expect(r.dimensionCode, 'BRANCH');

      final all = await fa.costReports.getUnallocatedLines(
          dimensionId: branch.id!,
          from: yearStart,
          to: yearEnd,
          incomeStatementOnly: false);
      expect(all.lines.any((l) => l.accountId == cashId), isTrue);

      final dep = await fa.costReports.getUnallocatedLines(
          dimensionId: department.id!, from: yearStart, to: yearEnd);
      expect(dep.totalUnallocated, 1650 + 520);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('CostAllocationCalculator', () {
    test('splitByWeights', () {
      expect(CostAllocationCalculator.splitByWeights(100, [1, 1, 1]),
          [33.33, 33.33, 33.34]);
      expect(
          CostAllocationCalculator.splitByWeights(10, [1, 2],
              fractionDigits: 3),
          [3.333, 6.667]);
      expect(() => CostAllocationCalculator.splitByWeights(10, []),
          throwsA(isA<InvalidAllocationKeyException>()));
    });
  });
}
