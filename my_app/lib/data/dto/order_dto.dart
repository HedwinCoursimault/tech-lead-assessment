import 'package:my_app/core/helpers.dart';
import 'package:my_app/data/dto/order_item_dto.dart';

class OrderDto {
  final String? orderId;
  final String? customerId;
  final String? orderDate;
  final String? status;
  final bool? expressDelivery;
  final List<OrderItemDto>? items;

  const OrderDto({
    this.orderId,
    this.customerId,
    this.orderDate,
    this.status,
    this.expressDelivery,
    this.items,
  });

  OrderDto.fromJson(Map<String, dynamic> json)
      : orderId = json["order_id"] as String?,
        customerId = json["customer_id"] as String?,
        orderDate = json["order_date"] as String?,
        status = json["status"] as String?,
        expressDelivery = ParsingHelper().toBool(json["express_delivery"]),
        items = (json["items"] as List<dynamic>?)
            ?.map<OrderItemDto>((dynamic json) => OrderItemDto.fromJson(json))
            .toList();
}
