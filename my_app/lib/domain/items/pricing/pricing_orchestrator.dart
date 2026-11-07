import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_calculation.dart';
import 'package:my_app/domain/items/pricing/pricing_context.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';
import 'package:my_app/domain/items/pricing/pricing_rule.dart';
import 'package:my_app/domain/items/pricing/pricing_rule_config.dart';
import 'package:my_app/domain/services/order_service.dart';
import 'package:my_app/domain/services/pricing_service.dart';

class PricingOrchestrator {
  /// Règles de base à appliquer sur le prix brut
  final List<PricingRuleConfig> ruleConfigList;

  PricingOrchestrator({
    required this.ruleConfigList,
  });

  PricingResult calculatePrice({
    required Customer customer,
    required Order order,
    required bool isFirstOrderOfTheMonth,
  }) {
    int baseAmount = PricingService().valueToPrice(
      OrderService().getOrderValue(order: order),
    );

    List<PricingRuleConfig> sortedRules = _sortRules(ruleConfigList);

    PricingContext context = PricingContext(
        order: order,
        customer: customer,
        isFirstOrderOfTheMonth: isFirstOrderOfTheMonth,
        baseAmount: baseAmount);

    PricingCalculation calculation = PricingCalculation(
        context: context,
        lineAmounts: order.lines.map<int>(
          (OrderLine orderLine) {
            return PricingService()
                .valueToPrice(orderLine.quantity * orderLine.unitPrice);
          },
        ).toList());

    // On applique toutes les règles triés par ordre
    for (PricingRuleConfig ruleConfig in sortedRules) {
      _innerRuleApply(ruleConfig.rule, calculation);
    }

    return PricingResult(
      operations: calculation.adjustments,
      finalPrice: calculation.totalAmount,
      basePrice: context.baseAmount,
    );
  }

  void _innerRuleApply(PricingRule rule, PricingCalculation calculation) {
    if (rule.shouldApply(calculation: calculation)) {
      List<PriceAdjustment>? adjustementList =
          rule.apply(calculation: calculation);

      for (PriceAdjustment adjustment in adjustementList) {
        calculation.applyAdjustment(adjustment: adjustment);
      }
    }
  }

  List<PricingRuleConfig> _sortRules(
    List<PricingRuleConfig> rules,
  ) {
    List<PricingRuleConfig> remaining = <PricingRuleConfig>[...rules];
    List<PricingRuleConfig> ordered = <PricingRuleConfig>[];
    Set<String> processedIds = <String>{};

    // Vérification des identifiants
    Set<String> ids =
        rules.map((PricingRuleConfig config) => config.rule.id).toSet();

    if (ids.length != rules.length) {
      throw StateError("Plusieurs règles possèdent le même id");
    }

    // Vérification des dépendances
    for (PricingRuleConfig config in rules) {
      for (String dependency in config.dependencies) {
        if (!ids.contains(dependency)) {
          throw StateError(
            "Dépendance inconnue : $dependency",
          );
        }
      }
    }

    // Tri des règles en fonction de leur priorité en gérant aussi
    // leurs dépendance, on évalue pas une règle tant que ses dépendances ne sont pas évaluées
    while (remaining.isNotEmpty) {
      // Règles dont les dépendances ont été traitées
      List<PricingRuleConfig> available =
          remaining.where((PricingRuleConfig config) {
        return processedIds.containsAll(config.dependencies);
      }).toList();

      if (available.isEmpty) {
        throw StateError("Dépendance circulaire détectée");
      }

      // Tri dans l'ordre des priorité croissantes
      available.sort(
        (PricingRuleConfig a, PricingRuleConfig b) {
          int comparaison = b.priority.compareTo(a.priority);

          if (comparaison != 0) {
            return comparaison;
          }

          return a.rule.id.compareTo(b.rule.id);
        },
      );

      PricingRuleConfig next = available.first;

      ordered.add(next);
      processedIds.add(next.rule.id);
      remaining.remove(next);
    }

    return ordered;
  }
}
