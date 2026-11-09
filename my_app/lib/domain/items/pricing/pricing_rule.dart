import 'package:my_app/domain/items/customer_type.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_calculation.dart';
import 'package:my_app/domain/items/pricing/pricing_rule_config.dart';
import 'package:my_app/domain/items/product_category.dart';
import 'package:my_app/domain/services/pricing_service.dart';

abstract class PricingRule {
  final String name;
  final String id;
  final String description;

  PricingRule({
    required this.name,
    required this.id,
    required this.description,
  });

  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  });

  bool shouldRemainApplied({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return true;
  }

  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  });
}

class PremiumDiscountRule extends PricingRule {
  PremiumDiscountRule()
      : super(
          id: 'premium_discount',
          name: 'Remise Premium',
          description: 'Réduction de 10 % pour les clients Premium',
        );

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.context.customer.customerType == CustomerType.premium;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Order order = calculation.context.order;

    return List<PriceAdjustment>.generate(order.lines.length, (int index) {
      OrderLine line = order.lines[index];

      // On se base sur le prix brut
      int baseAmount = PricingService().getOrderLinePrice(line);

      return PriceAdjustment(
        amount: -(baseAmount * 0.10).round(),
        appliedRuleId: id,
        explications: description,
        orderLineIndex: index,
      );
    });
  }
}

class VipDiscountRule extends PricingRule {
  VipDiscountRule()
      : super(
          id: 'vip_discount',
          name: 'Remise VIP',
          description: 'Réduction de 15 % pour les clients VIP',
        );

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.context.customer.customerType == CustomerType.vip;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Order order = calculation.context.order;

    return List<PriceAdjustment>.generate(order.lines.length, (int index) {
      OrderLine line = order.lines[index];

      // On se base sur le prix brut
      int baseAmount = PricingService().getOrderLinePrice(line);

      return PriceAdjustment(
        amount: -(baseAmount * 0.15).round(),
        appliedRuleId: id,
        explications: description,
        orderLineIndex: index,
      );
    });
  }
}

class FirstOrderDiscountRule extends PricingRule {
  FirstOrderDiscountRule()
      : super(
          id: 'first_order_discount',
          name: 'Remise première commande',
          description: 'Réduction de 5 % pour la première commande du mois',
        );

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.context.isFirstOrderOfTheMonth;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Order order = calculation.context.order;

    return List<PriceAdjustment>.generate(order.lines.length, (int index) {
      OrderLine line = order.lines[index];

      // On se base sur le prix brut
      int baseAmount = PricingService().getOrderLinePrice(line);

      return PriceAdjustment(
        amount: -(baseAmount * 0.05).round(),
        appliedRuleId: id,
        explications: description,
        orderLineIndex: index,
      );
    });
  }
}

class Sum500OrderDiscountRule extends PricingRule {
  Sum500OrderDiscountRule()
      : super(
          id: 'sum500_order_discount',
          name: 'Remise commande supérieur à 500€',
          description: 'Réduction de 5 % pour une commande supérieur à 500€',
        );

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    int? totalAmount =
        calculation.effectiveAmountAtPhase(phase: PricingPhase.base);
    if (totalAmount != null) {
      return totalAmount > 50000;
    } else {
      return false;
    }
  }

  @override
  bool shouldRemainApplied({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.currentAmount >= 50000;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Order order = calculation.context.order;

    return List<PriceAdjustment>.generate(order.lines.length, (int index) {
      // On se base sur le prix recalculé
      int baseAmount = calculation.lineAmounts[index];

      return PriceAdjustment(
        amount: -(baseAmount * 0.05).round(),
        appliedRuleId: id,
        explications: description,
        orderLineIndex: index,
      );
    });
  }
}

class Sum1000OrderDiscountRule extends PricingRule {
  Sum1000OrderDiscountRule()
      : super(
          id: 'sum1000_order_discount',
          name: 'Remise commande supérieur à 1000€',
          description: 'Réduction de 8 % pour une commande supérieur à 1000€',
        );

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    int? totalAmount =
        calculation.effectiveAmountAtPhase(phase: PricingPhase.base);
    if (totalAmount != null) {
      return totalAmount > 100000;
    } else {
      return false;
    }
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Order order = calculation.context.order;

    return List<PriceAdjustment>.generate(order.lines.length, (int index) {
      // On se base sur le prix recalculé
      int baseAmount = calculation.lineAmounts[index];

      return PriceAdjustment(
        amount: -(baseAmount * 0.08).round(),
        appliedRuleId: id,
        explications: description,
        orderLineIndex: index,
      );
    });
  }
}

class CatOrderTaxRule extends PricingRule {
  /// Clé : identifiant de la taxe, Valeur: pourcentage de la taxe
  /// Par exemple :
  /// taxRates: {
  ///  'Électronique': 0.20,
  ///  'Alimentaire': 0.055,
  /// },
  final Map<String, double> taxRates;

  CatOrderTaxRule({
    required this.taxRates,
    required super.id,
    required super.name,
    required super.description,
  });

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return getTaxedLinesIndex(
            calculation: calculation,
            pricingAmountReference: pricingAmountReference)
        .isNotEmpty;
  }

  Map<int, String> getTaxedLinesIndex({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Map<int, String> taxesPerOrderLine = <int, String>{};

    List<OrderLine> lines = calculation.context.order.lines;

    for (int i = 0; i < lines.length; i++) {
      OrderLine line = lines[i];

      double? maxTaxRate;

      for (ProductCategory category in line.productCategories) {
        double? taxRate = taxRates[category.name];

        if (taxRate != null && (maxTaxRate == null || taxRate > maxTaxRate)) {
          maxTaxRate = taxRate;
          taxesPerOrderLine[i] = category.name;
        }
      }
    }

    return taxesPerOrderLine;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    List<PriceAdjustment> adjustments = <PriceAdjustment>[];

    List<OrderLine> lines = calculation.context.order.lines;

    Map<int, String> taxableOrders = getTaxedLinesIndex(
        calculation: calculation,
        pricingAmountReference: pricingAmountReference);

    for (int currentLineIndex = 0;
        currentLineIndex < lines.length;
        currentLineIndex++) {
      String? taxKey = taxableOrders[currentLineIndex];

      if (taxKey != null) {
        int amount = calculation.lineAmounts[currentLineIndex];
        double? taxPercentage = taxRates[taxKey];

        if (taxPercentage != null) {
          adjustments.add(
            PriceAdjustment(
              amount: (amount * taxPercentage).round(),
              appliedRuleId: id,
              explications: description,
              orderLineIndex: currentLineIndex,
            ),
          );
        }
      }
    }

    return adjustments;
  }
}

class MultipleProductSameCategoryDiscountRule extends PricingRule {
  MultipleProductSameCategoryDiscountRule()
      : super(
          name: 'Réduction +3 produits de la même catégorie',
          id: '3_products_category',
          description:
              '10% de réduction sur les produits dont la catégorie comporte plus de 3 unités',
        );

  /// Retourne les catégories contenant plus de 3 produits.
  Set<String> getEligibleCategories(PricingCalculation calculation) {
    Map<String, int> quantities = <String, int>{};

    for (final OrderLine line in calculation.context.order.lines) {
      for (final ProductCategory category in line.productCategories) {
        String name = category.name;

        quantities[name] = (quantities[name] ?? 0) + line.quantity;
      }
    }

    return quantities.entries
        .where((MapEntry<String, int> entry) => entry.value > 3)
        .map((MapEntry<String, int> entry) => entry.key)
        .toSet();
  }

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return getEligibleCategories(calculation).isNotEmpty;
  }

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    Set<String> eligibleCategories = getEligibleCategories(calculation);
    List<PriceAdjustment> adjustments = <PriceAdjustment>[];

    for (int i = 0; i < calculation.context.order.lines.length; i++) {
      OrderLine line = calculation.context.order.lines[i];

      bool isEligible = line.productCategories.any(
        (ProductCategory category) =>
            eligibleCategories.contains(category.name),
      );

      if (!isEligible) continue;

      int currentAmount = calculation.lineAmounts[i];
      int discount = (currentAmount * 0.10).round();

      adjustments.add(
        PriceAdjustment(
          amount: -discount,
          appliedRuleId: id,
          explications: description,
          orderLineIndex: i,
        ),
      );
    }

    return adjustments;
  }
}

class ExpressDeliveryFees extends PricingRule {
  ExpressDeliveryFees()
      : super(
            name: 'Frais de livraison express',
            id: 'express_delivery_fees',
            description:
                'Frais de 15€ sur la commande globale pour les commandes express');

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return <PriceAdjustment>[
      PriceAdjustment(
        amount: 1500,
        appliedRuleId: id,
        explications: description,
      ),
    ];
  }

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.context.order.expressDelivery;
  }
}

class ProcessingFees extends PricingRule {
  ProcessingFees()
      : super(
            name: 'Frais de traitements',
            id: 'processing_fees',
            description:
                'Frais de 5€ sur la commande globale pour les commandes < 50€');

  @override
  List<PriceAdjustment> apply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return <PriceAdjustment>[
      PriceAdjustment(
        amount: 500,
        appliedRuleId: id,
        explications: description,
      ),
    ];
  }

  @override
  bool shouldApply({
    required PricingCalculation calculation,
    required PricingAmountReference pricingAmountReference,
  }) {
    return calculation.totalAmount < 5000;
  }
}
