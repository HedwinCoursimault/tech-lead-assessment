import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/data/dto/order_dto.dart';
import 'package:my_app/data/dto/order_item_dto.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/data/mappers/order_mapper.dart';
import 'package:my_app/domain/items/order.dart';

void main() {
  OrderMapper mapper = OrderMapper();
  test("mapper sur les commandes avec produits associés", () {
    Order order = mapper.toDomain(
      orderDto: const OrderDto(
          orderId: "O1",
          customerId: "C1",
          orderDate: "2024-10-10T10:00:00Z",
          status: "Delivered",
          expressDelivery: true,
          items: <OrderItemDto>[OrderItemDto(productId: "P1", quantity: 2)]),
      productsDto: const <ProductDto>[
        ProductDto(
            id: "P1", name: "Phone", price: 100, categories: <String>["Tech"])
      ],
    );
    expect(order.id, "O1");
    expect(order.status, OrderStatus.delivered);
    expect(order.expressDelivery, isTrue);
    expect(order.lines, hasLength(1));
    expect(order.lines.single.quantity, 2);
    expect(order.lines.single.productCategories.single.name, "Tech");
  });
  test("Une erreur est levée si un produit de la commande est introuvable", () {
    expect(
      () => mapper.toDomain(
        orderDto: const OrderDto(
          orderId: "O1",
          customerId: "C1",
          orderDate: "2024-10-10",
          expressDelivery: false,
          items: <OrderItemDto>[
            OrderItemDto(productId: "missing", quantity: 1),
          ],
        ),
        productsDto: const <ProductDto>[],
      ),
      throwsA(
        isA<Exception>().having(
          (Exception e) => e.toString(),
          "message",
          contains("missing"),
        ),
      ),
    );
  });

  test("Les dates des commandes sont parsées en UTC", () {
    Order order = mapper.toDomain(
      orderDto: const OrderDto(
        orderId: "O1",
        customerId: "C1",
        orderDate: "2024-11-15T23:30:00Z",
        expressDelivery: false,
      ),
      productsDto: const <ProductDto>[],
    );

    expect(order.orderDate.isUtc, isTrue);
    expect(
      order.orderDate,
      DateTime.utc(2024, 11, 15, 23, 30),
    );
  });
  test("gestion de l'erreur lorsqu'on a une erreur de format", () {
    expect(
        () => mapper.toDomain(
            orderDto: const OrderDto(), productsDto: const <ProductDto>[]),
        throwsFormatException);
  });
}
