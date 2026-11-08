import 'package:flutter/material.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';
import 'package:my_app/view/price_calculation/cmp/applied_rule_card.dart';
import 'package:my_app/view/price_calculation/cmp/price_formatter.dart';

class PriceCalculationResultBody extends StatelessWidget {
  final Order order;
  final PricingResult result;

  const PriceCalculationResultBody({
    super.key,
    required this.order,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map<String, List<PriceAdjustment>> adjustmentsPerRule =
        <String, List<PriceAdjustment>>{};

    for (PriceAdjustment adjustment in result.operations) {
      adjustmentsPerRule
          .putIfAbsent(
            adjustment.appliedRuleId,
            () => <PriceAdjustment>[],
          )
          .add(adjustment);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: <Widget>[
        Text(
          "Commande ${order.id}",
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerLow,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                _PriceRow(
                  label: "Prix de base",
                  value: PriceFormatter.format(result.basePrice),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _PriceRow(
                  label: "Prix final",
                  value: PriceFormatter.format(result.finalPrice),
                  emphasize: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Règles appliquées (${adjustmentsPerRule.length})",
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (adjustmentsPerRule.isEmpty)
          const Text("Aucune règle appliquée à cette commande."),
        ...adjustmentsPerRule.entries.map<Widget>(
          (MapEntry<String, List<PriceAdjustment>> entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppliedRuleCard(
                ruleId: entry.key,
                adjustments: entry.value,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: emphasize
                ? theme.textTheme.titleMedium
                : theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: emphasize
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
