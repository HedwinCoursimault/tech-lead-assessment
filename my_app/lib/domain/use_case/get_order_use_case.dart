import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/repository/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository orderRepository;

  GetOrderUseCase({
    required this.orderRepository,
  });

  Future<Order?> call({required String orderId}) async {
    return orderRepository.getOrderById(orderId);
  }
}
