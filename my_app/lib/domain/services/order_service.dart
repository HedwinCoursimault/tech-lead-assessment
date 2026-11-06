import 'package:collection/collection.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/report/period.dart';

/// Service permetant la manipulation de commandes
class OrderService {
  /// Groupe les commandes [orders] par périodes en fonction du [periodGroupingType]
  Map<DateTime, List<Order>> groupOrdersByPeriod({
    required PeriodGroupingType periodGroupingType,
    required List<Order> orders,
  }) {
    // Groupement des commandes par période : on calcule la date de référence de la période (début du mois ou de la semaine)
    // pour chaque commande, en groupant au fur et a mesure les commandes dans le groupe auquels elles appartiennent
    return groupBy<Order, DateTime>(
      orders,
      (Order order) {
        DateTime date = order.orderDate;

        switch (periodGroupingType) {
          case PeriodGroupingType.weekly:
            DateTime startOfWeek = date.subtract(
              Duration(days: date.weekday - 1),
            );
            return DateTime.utc(
              startOfWeek.year,
              startOfWeek.month,
              startOfWeek.day,
            );

          case PeriodGroupingType.monthly:
            return DateTime.utc(date.year, date.month);
        }
      },
    );
  }

  /// Calcul de la valeur totale d'une commande
  double getOrderValue({required Order order}) {
    return order.lines.fold<double>(
      0,
      (double previousValue, OrderLine entry) {
        return previousValue + (entry.unitPrice * entry.quantity);
      },
    );
  }

  /// Calcul de la valeur moyenne d'une commande
  double getOrderMean({required Order order}) {
    if (order.lines.isEmpty) return 0;

    ({double totalPrice, int totalQuantity}) resultRecord = order.lines
        .fold((totalPrice: 0.0, totalQuantity: 0),
            (({double totalPrice, int totalQuantity}) record, OrderLine line) {
      return (
        totalPrice: record.totalPrice + line.quantity * line.unitPrice,
        totalQuantity: record.totalQuantity + line.quantity,
      );
    });

    return resultRecord.totalPrice / resultRecord.totalQuantity;
  }

  /// Calcul de la valeur totale d'une liste de commande
  double getListOrderValue({required List<Order> orders}) {
    return orders.fold(
      0,
      (double previousValue, Order element) {
        return previousValue + getOrderValue(order: element);
      },
    );
  }

  /// Calcul de la valeur moyenne d'une liste de commande (moyenne de la valeur totale de chaque commande)
  double getListOrderMean({required List<Order> orders}) {
    if (orders.isEmpty) return 0;

    return getListOrderValue(orders: orders) / orders.length;
  }
}
