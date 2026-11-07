import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';

class PricingContext {
  final Order order;
  final Customer customer;
  final bool isFirstOrderOfTheMonth;
  final int baseAmount;

  PricingContext({
    required this.order,
    required this.customer,
    required this.isFirstOrderOfTheMonth,
    required this.baseAmount,
  });
}
