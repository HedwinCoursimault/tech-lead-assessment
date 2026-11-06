import 'package:my_app/data/dto/order_dto.dart';

abstract class OrderDataSource {
  Future<List<OrderDto>> getOrders({
    DateTime? minDate,
    DateTime? maxDate,
    String? customerId,
  });

  Future<OrderDto?> getOrderById(String id);
}
