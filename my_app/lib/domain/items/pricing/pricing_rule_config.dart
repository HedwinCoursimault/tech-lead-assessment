import 'package:my_app/domain/items/pricing/pricing_rule.dart';

class PricingRuleConfig {
  final PricingRule rule;
  final int priority;
  final Set<String> dependencies;
  final Set<String> invalidates;

  const PricingRuleConfig({
    required this.rule,
    this.priority = 0,
    this.dependencies = const <String>{},
    this.invalidates = const <String>{},
  });
}
