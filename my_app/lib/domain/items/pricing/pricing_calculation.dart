import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_context.dart';

class PricingCalculation {
  final PricingContext context;

  /// Prix en cours de chaque ligne de la commande
  final List<int> lineAmounts;

  /// Ajustements appliqués.
  final List<PriceAdjustment> adjustments = <PriceAdjustment>[];

  /// Ajustement sur le total de la commande, non réimpacté sur chaque prix
  int orderGlobalAdjustmentsAmount = 0;

  PricingCalculation({
    required this.context,
    required this.lineAmounts,
  });

  int get productsAmount =>
      lineAmounts.fold(0, (int sum, int amount) => sum + amount);

  int get totalAmount => productsAmount + orderGlobalAdjustmentsAmount;

  void applyAdjustment({required PriceAdjustment adjustment}) {
    int? orderLineIndex = adjustment.orderLineIndex;
    if (orderLineIndex != null) {
      lineAmounts[orderLineIndex] += adjustment.amount;
    } else {
      orderGlobalAdjustmentsAmount += adjustment.amount;
    }
    adjustments.add(adjustment);
  }
}
