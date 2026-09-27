/// currency_seed_data.dart
/// العملات الشائعة (اختيارية)
library;

import '../models/currency_model.dart';
import '../repositories/interfaces/interfaces.dart';

/// عملات جاهزة بمنازلها العشرية الصحيحة (ISO 4217).
///
/// ```dart
/// await CurrencySeedData.seed(fa.currencies);
/// // أو: FlutterAccounting.initialize(seedDefaultCurrencies: true, ...)
/// ```
class CurrencySeedData {
  CurrencySeedData._();

  static const all = <CurrencyModel>[
    CurrencyModel(
        code: 'SAR', name: 'Saudi Riyal', nameAr: 'ريال سعودي', symbol: 'ر.س'),
    CurrencyModel(
        code: 'USD', name: 'US Dollar', nameAr: 'دولار أمريكي', symbol: r'$'),
    CurrencyModel(code: 'EUR', name: 'Euro', nameAr: 'يورو', symbol: '€'),
    CurrencyModel(
        code: 'GBP',
        name: 'Pound Sterling',
        nameAr: 'جنيه إسترليني',
        symbol: '£'),
    CurrencyModel(
        code: 'AED', name: 'UAE Dirham', nameAr: 'درهم إماراتي', symbol: 'د.إ'),
    CurrencyModel(
        code: 'QAR', name: 'Qatari Riyal', nameAr: 'ريال قطري', symbol: 'ر.ق'),
    CurrencyModel(
        code: 'KWD',
        name: 'Kuwaiti Dinar',
        nameAr: 'دينار كويتي',
        symbol: 'د.ك',
        decimalPlaces: 3),
    CurrencyModel(
        code: 'BHD',
        name: 'Bahraini Dinar',
        nameAr: 'دينار بحريني',
        symbol: 'د.ب',
        decimalPlaces: 3),
    CurrencyModel(
        code: 'OMR',
        name: 'Omani Rial',
        nameAr: 'ريال عماني',
        symbol: 'ر.ع',
        decimalPlaces: 3),
    CurrencyModel(
        code: 'JOD',
        name: 'Jordanian Dinar',
        nameAr: 'دينار أردني',
        symbol: 'د.أ',
        decimalPlaces: 3),
    CurrencyModel(
        code: 'EGP',
        name: 'Egyptian Pound',
        nameAr: 'جنيه مصري',
        symbol: 'ج.م'),
    CurrencyModel(
        code: 'YER', name: 'Yemeni Rial', nameAr: 'ريال يمني', symbol: 'ر.ي'),
    CurrencyModel(
        code: 'IQD',
        name: 'Iraqi Dinar',
        nameAr: 'دينار عراقي',
        symbol: 'ع.د',
        decimalPlaces: 3),
    CurrencyModel(
        code: 'TRY', name: 'Turkish Lira', nameAr: 'ليرة تركية', symbol: '₺'),
    CurrencyModel(
        code: 'CNY', name: 'Chinese Yuan', nameAr: 'يوان صيني', symbol: '¥'),
    CurrencyModel(
        code: 'JPY',
        name: 'Japanese Yen',
        nameAr: 'ين ياباني',
        symbol: '¥',
        decimalPlaces: 0),
  ];

  /// العملة الجاهزة بالرمز (إن وُجدت)
  static CurrencyModel? find(String code) {
    for (final c in all) {
      if (c.code == code) return c;
    }
    return null;
  }

  /// يضيف العملات غير الموجودة (آمنة للاستدعاء أكثر من مرة)
  static Future<void> seed(ICurrencyRepository repo) async {
    for (final c in all) {
      await repo.ensureCurrency(
        code: c.code,
        name: c.name,
        nameAr: c.nameAr,
        symbol: c.symbol,
        decimalPlaces: c.decimalPlaces,
      );
    }
  }
}
