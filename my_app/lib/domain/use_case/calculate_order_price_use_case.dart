import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';

class CalculateOrderPriceUseCase {
  Future<PricingResult?> call({
    required Order order,
    required Customer customer,
  }) async {
    return PricingResult(
      basePrice: 120000, // 1 200,00 €
      finalPrice: 101390, // 1 013,90 €
      operations: <PriceAdjustment>[
        PriceAdjustment(
          amount: -12000,
          appliedRuleId: "premium_discount",
          explications: "Réduction de 10 % pour les clients Premium",
          orderLineIndex: 0,
        ),
        PriceAdjustment(
          amount: -6000,
          appliedRuleId: "premium_discount",
          explications: "Réduction de 10 % pour les clients Premium",
          orderLineIndex: 1,
        ),
        PriceAdjustment(
          amount: -2700,
          appliedRuleId: "first_order_discount",
          explications: "Réduction de 5 % pour la première commande du mois",
          orderLineIndex: 1,
        ),
        PriceAdjustment(
          amount: -3000,
          appliedRuleId: "3_products_category",
          explications:
              "10 % de réduction sur les produits d'une même catégorie",
          orderLineIndex: 2,
        ),
        PriceAdjustment(
          amount: -5000,
          appliedRuleId: "sum500_order_discount",
          explications: "Réduction de 5 % pour une commande supérieure à 500 €",
        ),
        PriceAdjustment(
          amount: 1800,
          appliedRuleId: "category_tax",
          explications: "Taxe de 20 % sur les produits électroniques",
          orderLineIndex: 0,
        ),
        PriceAdjustment(
          amount: 790,
          appliedRuleId: "category_tax",
          explications: "Taxe de 5,5 % sur les produits alimentaires",
          orderLineIndex: 2,
        ),
        PriceAdjustment(
          amount: 1500,
          appliedRuleId: "express_delivery_fees",
          explications: "Frais de livraison express",
        ),
      ],
    );
  }
}
