import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/product_category.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({
    required this.order,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color statusColor = _statusColor(order.status);

    List<String> categories = order.lines
        .expand<ProductCategory>((OrderLine line) => line.productCategories)
        .map<String>(
          (ProductCategory productCategory) {
            return productCategory.name;
          },
        )
        .toSet()
        .toList();

    double amount = order.lines.fold<double>(
      0,
      (double total, OrderLine line) => total + line.unitPrice * line.quantity,
    );

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Commande ${order.id}",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${amount.toStringAsFixed(2)} €",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: categories.map((String category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat("dd/MM/yyyy").format(order.orderDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(order.status),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Couleur associée au statut
Color _statusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return Colors.orange;
    case OrderStatus.shipped:
      return Colors.blue;
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.unknown:
      return Colors.grey;
  }
}

// Libellé français du statut
String _getStatusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return 'En préparation';
    case OrderStatus.shipped:
      return 'Expédiée';
    case OrderStatus.delivered:
      return 'Livrée';
    case OrderStatus.unknown:
      return 'Inconnu';
  }
}
