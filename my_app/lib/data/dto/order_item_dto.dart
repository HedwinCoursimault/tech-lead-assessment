import 'package:my_app/core/helpers.dart';

class OrderItemDto {
  final String? productId;
  final int? quantity;

  const OrderItemDto({
    this.productId,
    this.quantity,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(
      productId: json["product_id"] as String?,
      quantity: ParsingHelper().toInt(json["quantity"]),
    );
  }
}
