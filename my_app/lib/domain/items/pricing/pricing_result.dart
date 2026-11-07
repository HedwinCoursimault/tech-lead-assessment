import 'package:my_app/domain/items/pricing/price_adjustment.dart';

class PricingResult {
  /// Opérations qui ont menés à ce pricing
  final List<PriceAdjustment> operations;

  /// Prix final retenu
  final int finalPrice;

  /// Prix de base
  final int basePrice;

  PricingResult({
    required this.operations,
    required this.finalPrice,
    required this.basePrice,
  });
}
