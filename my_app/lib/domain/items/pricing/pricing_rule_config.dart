import 'package:my_app/domain/items/pricing/pricing_rule.dart';

/// Objet de configuration d'une règle
class PricingRuleConfig {
  final PricingRule rule;
  final PricingPhase phase;
  final int priority;
  final Set<String> dependencies;
  final Set<String> invalidates;
  final Set<String> excludes;
  final PricingAmountReference pricingAmountReference;

  const PricingRuleConfig({
    required this.rule,
    required this.phase,
    this.priority = 0,
    this.pricingAmountReference = PricingAmountReference.current,
    this.dependencies = const <String>{},
    this.invalidates = const <String>{},
    this.excludes = const <String>{},
  });
}

/// Phase de calcul
enum PricingPhase {
  base,
  conditionnal,
  categorical,
  treshold,
  finals,
}

/// Référence de calcul pour l'application d'une règle
enum PricingAmountReference {
  // Prix courant
  current,
  // Prix fixé à la phase précédente
  previousPhase,
}
