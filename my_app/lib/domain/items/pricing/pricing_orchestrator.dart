import 'package:collection/collection.dart';
import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_calculation.dart';
import 'package:my_app/domain/items/pricing/pricing_context.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';
import 'package:my_app/domain/items/pricing/pricing_rule.dart';
import 'package:my_app/domain/items/pricing/pricing_rule_config.dart';
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
    // Liste de tous les montants de toutes les lignes de la commandes
    List<int> lineAmounts = order.lines.map((OrderLine line) {
      return PricingService().valueToPrice(
        line.quantity * line.unitPrice,
      );
    }).toList();

    // Calcul du montant de base en ajoutant la somme de toutes les lignes
    int baseAmount = lineAmounts.fold<int>(
      0,
      (int total, int amount) => total + amount,
    );

    // Création du context
    PricingContext context = PricingContext(
        order: order,
        customer: customer,
        isFirstOrderOfTheMonth: isFirstOrderOfTheMonth,
        baseAmount: baseAmount);

    // Mapping des règles selon leur phase
    Map<PricingPhase, List<PricingRuleConfig>> rulesPerPhase =
        groupBy<PricingRuleConfig, PricingPhase>(
      ruleConfigList,
      (PricingRuleConfig rule) {
        return rule.phase;
      },
    );

    // Tri des liste de chaque phase
    rulesPerPhase.updateAll(
      (PricingPhase phase, List<PricingRuleConfig> rules) {
        return _sortRules(rules);
      },
    );

    PricingCalculation calculation =
        PricingCalculation(context: context, lineAmounts: lineAmounts);

    // Règles exclues par une autre règle (dépendance direct)
    Set<String> excludedRuleIds = <String>{};

    for (PricingPhase phase in PricingPhase.values) {
      // Mise à jour de la phase courante
      calculation.currentPhase = phase;

      List<PricingRuleConfig> phaseRules =
          rulesPerPhase[phase] ?? <PricingRuleConfig>[];

      for (PricingRuleConfig ruleConfig in phaseRules) {
        // On ignore les règles exclues
        if (excludedRuleIds.contains(ruleConfig.rule.id)) {
          continue;
        }
        bool applied = _applyRule(
            ruleConfig.rule, calculation, ruleConfig.pricingAmountReference);

        if (applied) {
          excludedRuleIds.addAll(ruleConfig.excludes);
        }
      }

      // Capture du montant après chaque phase
      calculation.lineAmountAfterPhases[phase] =
          List<int>.of(calculation.lineAmounts);
    }

    return PricingResult(
      operations: calculation.adjustments,
      finalPrice: calculation.totalAmount,
      basePrice: context.baseAmount,
    );
  }

  bool _applyRule(
    PricingRule rule,
    PricingCalculation calculation,
    PricingAmountReference pricingAmountReference,
  ) {
    if (rule.shouldApply(
      calculation: calculation,
      pricingAmountReference: pricingAmountReference,
    )) {
      List<PriceAdjustment> adjustments = rule.apply(
        calculation: calculation,
        pricingAmountReference: pricingAmountReference,
      );

      for (PriceAdjustment adjustment in adjustments) {
        calculation.applyAdjustment(adjustment: adjustment);
      }

      // Une règle qui n'a provoqué aucun ajustement est consiédéré comme non appliquée
      return adjustments.isNotEmpty;
    } else {
      return false;
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
          int comparaison = a.priority.compareTo(b.priority);

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
