import 'package:my_app/domain/items/order.dart';

abstract class OrderRepository {
  // Récupération d'une commande avec possibilité de mettre des contraintes sur certains champs
  Future<List<Order>> getOrders({
    DateTime? minDate,
    DateTime? maxDate,
    String? customerId,
  });

  Future<Order?> getOrderById(String id);
}
