import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/repository/order_repository.dart';
import 'package:my_app/domain/services/order_service.dart';

/// Détermines si une commande est la première du mois pour son client
class IsFirstOrderOfMonthUseCase {
  final OrderRepository orderRepository;

  IsFirstOrderOfMonthUseCase({
    required this.orderRepository,
  });

  Future<bool> call({required Order order}) async {
    DateTime orderDate = order.orderDate.toUtc();
    DateTime startOfMonth = DateTime.utc(orderDate.year, orderDate.month);
    DateTime startOfNextMonth =
        DateTime.utc(orderDate.year, orderDate.month + 1);

    DateTime endOfMonth =
        startOfNextMonth.subtract(const Duration(microseconds: 1));

    List<Order> monthlyOrders = await orderRepository.getOrders(
      customerId: order.customerId,
      minDate: startOfMonth,
      maxDate: endOfMonth,
    );

    return OrderService().isFirstOrderOfMonth(
      order: order,
      monthlyOrders: monthlyOrders,
    );
  }
}
