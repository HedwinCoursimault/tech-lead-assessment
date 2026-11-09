import "package:my_app/domain/items/pricing/pricing_rule.dart";
import "package:my_app/domain/items/pricing/pricing_rule_config.dart";

/// Configuration des règles actives de l'exercice 2.
/// Les phases suivent l'ordre défini dans l'énoncé.
/// Les priorités les plus faibles sont exécutées en premier.
class PricingRules {
  static List<PricingRuleConfig> build() {
    return <PricingRuleConfig>[
      // 1. Règles de base
      PricingRuleConfig(
        rule: PremiumDiscountRule(),
        phase: PricingPhase.base,
        priority: 0,
        excludes: <String>{"vip_discount"},
      ),
      PricingRuleConfig(
        rule: VipDiscountRule(),
        phase: PricingPhase.base,
        priority: 1,
        excludes: <String>{"premium_discount"},
      ),
      PricingRuleConfig(
        rule: FirstOrderDiscountRule(),
        phase: PricingPhase.base,
        priority: 2,
      ),

      // 2. Règles conditionnelles
      PricingRuleConfig(
        rule: Sum1000OrderDiscountRule(),
        phase: PricingPhase.conditionnal,
        priority: 0,
        excludes: <String>{"sum500_order_discount"},
      ),
      PricingRuleConfig(
        rule: Sum500OrderDiscountRule(),
        phase: PricingPhase.conditionnal,
        priority: 1,
      ),

      // 3. Règles par catégorie
      PricingRuleConfig(
        rule: CatOrderTaxRule(
          id: "category_tax",
          name: "Taxe par catégorie",
          description: "Taxation selon la catégorie du produit",
          taxRates: <String, double>{
            "Électronique": 0.20,
            "Alimentaire": 0.055,
          },
        ),
        phase: PricingPhase.categorical,
        priority: 0,
      ),

      // 4. Règles de seuil cumulatif
      PricingRuleConfig(
        rule: MultipleProductSameCategoryDiscountRule(),
        phase: PricingPhase.treshold,
        priority: 0,
        invalidates: <String>{"sum500_order_discount"},
      ),

      // 5. Règles finales
      PricingRuleConfig(
        rule: ExpressDeliveryFees(),
        phase: PricingPhase.finals,
        priority: 0,
      ),
      PricingRuleConfig(
        rule: ProcessingFees(),
        phase: PricingPhase.finals,
        priority: 1,
      ),
    ];
  }
}
