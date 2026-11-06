import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/product_category.dart';

Order makeOrder(
    {String id = "O1",
    DateTime? date,
    double price = 10,
    int quantity = 1,
    List<OrderLine>? lines}) {
  return Order(
    id: id,
    customerId: "C1",
    orderDate: date ?? DateTime.utc(2026, 10, 10),
    status: OrderStatus.delivered,
    expressDelivery: false,
    lines: lines ??
        <OrderLine>[
          OrderLine(
              productId: "P1",
              productName: "Test",
              unitPrice: price,
              quantity: quantity,
              productCategories: const <ProductCategory>[
                ProductCategory(name: "Test")
              ])
        ],
  );
}
