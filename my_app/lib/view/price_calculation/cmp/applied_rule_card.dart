import 'package:flutter/material.dart';
import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/view/price_calculation/cmp/price_formatter.dart';

class AppliedRuleCard extends StatelessWidget {
  final String ruleId;
  final List<PriceAdjustment> adjustments;

  const AppliedRuleCard({
    super.key,
    required this.ruleId,
    required this.adjustments,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    int totalAmount = adjustments.fold<int>(
      0,
      (int total, PriceAdjustment adjustment) => total + adjustment.amount,
    );

    String explanation = adjustments.first.explications;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.rule_outlined, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        explanation,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ruleId,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  PriceFormatter.formatAdjustment(totalAmount),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (adjustments.length > 1 || adjustments.first.orderLineIndex != null) ...<Widget>[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...adjustments.map<Widget>((PriceAdjustment adjustment) {
                int? lineIndex = adjustment.orderLineIndex;
                String label = lineIndex == null
                    ? "Commande entière"
                    : "Ligne ${lineIndex + 1}";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        PriceFormatter.formatAdjustment(adjustment.amount),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
