import 'package:my_app/domain/items/order.dart';

class PricingService {
  /// Permet de transformer une valeur en prix exprimé en centimes
  int valueToPrice(double value) {
    return (value * 100).round();
  }

  int getOrderLinePrice(OrderLine orderLine) {
    return valueToPrice(orderLine.unitPrice * orderLine.quantity);
  }
}
