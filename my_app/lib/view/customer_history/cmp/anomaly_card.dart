import 'package:flutter/material.dart';
import 'package:my_app/domain/items/order.dart';

class AnomalyCard extends StatefulWidget {
  final List<Order> anomalies;

  const AnomalyCard({
    super.key,
    required this.anomalies,
  });

  @override
  State<AnomalyCard> createState() => _AnomalyCardState();
}

class _AnomalyCardState extends State<AnomalyCard> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.anomalies.isEmpty) {
      return const SizedBox.shrink();
    }

    ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Commandes inhabituelles",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.orange.shade800,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                "Certaines commandes présentent un écart supérieur à 50 % par rapport à la moyenne.",
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.anomalies.map((Order order) {
                  return Chip(
                    label: Text(order.id),
                    backgroundColor: Colors.orange.shade100,
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                    labelStyle: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
