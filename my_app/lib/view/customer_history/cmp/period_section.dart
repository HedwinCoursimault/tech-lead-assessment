import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/period.dart';
import 'package:my_app/domain/services/period_service.dart';
import 'package:my_app/view/customer_history/cmp/order_card.dart';

class PeriodSection extends StatelessWidget {
  final Period period;
  final Period? previous;

  const PeriodSection({
    required this.period,
    required this.previous,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double? evolution = previous != null
        ? PeriodService().getEvolution(current: period, previous: previous!)
        : null;

    if (evolution != null) {
      evolution = evolution * 100;
    }

    List<Order> orders = <Order>[...period.orders]
      ..sort((Order a, Order b) => b.orderDate.compareTo(a.orderDate));

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // En-tête de période
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_month_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat("dd MMMM yyyy", "fr_FR")
                        .format(period.referenceDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${period.orderCount} commandes"
                      " - Total : ${period.totalOrdersValue.toStringAsFixed(2)} €"
                      " - Moyenne : ${period.meanOrdersValue.toStringAsFixed(2)} €",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (evolution != null && evolution.abs() >= 0.05) ...<Widget>[
                    const SizedBox(width: 8),
                    Text(
                      "${evolution > 0 ? "+" : ""}${evolution.toStringAsFixed(1)} %",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: evolution >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Liste des commandes
          ...orders.map(
            (Order order) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OrderCard(order: order),
            ),
          ),
        ],
      ),
    );
  }
}
