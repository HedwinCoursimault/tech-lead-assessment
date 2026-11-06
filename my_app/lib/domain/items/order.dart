import 'package:collection/collection.dart';
import 'package:my_app/domain/items/product_category.dart';

class Order {
  final String id;
  final String customerId;
  final DateTime orderDate;
  final OrderStatus status;
  final bool expressDelivery;
  final List<OrderLine> lines;

  Order({
    required this.id,
    required this.customerId,
    required this.orderDate,
    required this.status,
    required this.expressDelivery,
    required List<OrderLine> lines,
  }) : lines = List<OrderLine>.unmodifiable(lines);
}

/// Item représentant une ligne d'une commande, avec les informations du produit lié
class OrderLine {
  /// Id du produit
  final String productId;

  /// Nom du produit
  final String productName;

  /// Prix unitaire du produit
  final double unitPrice;

  /// Quantité du produit
  final int quantity;

  /// Catégories à laquelle appartient le produit de la ligne
  final List<ProductCategory> productCategories;

  OrderLine({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.productCategories,
  });
}

/// Correspondance du champs "status" de la commande. On part du postulat que la liste est figée donc on peut l'implémenter en "dur"
enum OrderStatus {
  processing,
  delivered,
  shipped,
  // Rajout d'un status unknown pour gérer facilement les cas d'erreur
  unknown;

  static OrderStatus fromString(String? value) {
    // Gestion simple : correspondance textuelle exacte (sauf case) et unknown en fallback
    return OrderStatus.values.singleWhereOrNull(
            (OrderStatus element) => element.name == value?.toLowerCase()) ??
        OrderStatus.unknown;
  }
}
