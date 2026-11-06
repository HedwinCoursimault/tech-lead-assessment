import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/services/order_service.dart';

class ReportService {
  List<Order> detectAnomalies({
    required List<Order> orders,
    double threshold = 0.5,
  }) {
    if (orders.isEmpty) return <Order>[];

    // Calcul de la moyenne du total de chaque commande
    double average = orders
            .map((Order order) => OrderService().getOrderValue(order: order))
            .fold<double>(
                0, (double total, double orderValue) => total + orderValue) /
        orders.length;

    if (average == 0) return <Order>[];

    return orders.where((Order order) {
      double deviation =
          (OrderService().getOrderValue(order: order) - average).abs() /
              average;

      return deviation > threshold;
    }).toList();
  }
}
