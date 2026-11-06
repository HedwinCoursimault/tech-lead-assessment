import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/period.dart';
import 'package:my_app/domain/items/product_category.dart';
import 'package:my_app/domain/services/order_service.dart';
import '../helpers/helper.dart';

void main() {
  OrderService service = OrderService();
  test(
      "la valeur d'une commande correspond à la somme des produits prix * quantité.",
      () {
    Order order = makeOrder(lines: <OrderLine>[
      OrderLine(
          productId: "P1",
          productName: "A",
          unitPrice: 10,
          quantity: 2,
          productCategories: const <ProductCategory>[]),
      OrderLine(
          productId: "P2",
          productName: "B",
          unitPrice: 4.5,
          quantity: 3,
          productCategories: const <ProductCategory>[]),
    ]);
    expect(service.getOrderValue(order: order), 33.5);
  });
  test("la moyenne est bien pondérée par la quantité", () {
    Order order = makeOrder(lines: <OrderLine>[
      OrderLine(
          productId: "P1",
          productName: "A",
          unitPrice: 10,
          quantity: 2,
          productCategories: const <ProductCategory>[]),
      OrderLine(
          productId: "P2",
          productName: "B",
          unitPrice: 4,
          quantity: 1,
          productCategories: const <ProductCategory>[]),
    ]);
    expect(service.getOrderMean(order: order), closeTo(8, 0.000001));
  });
  test("Si les listes sont vide, on a bien un retour à 0", () {
    expect(service.getOrderValue(order: makeOrder(lines: <OrderLine>[])), 0);
    expect(service.getOrderMean(order: makeOrder(lines: <OrderLine>[])), 0);
    expect(service.getListOrderValue(orders: <Order>[]), 0);
    expect(service.getListOrderMean(orders: <Order>[]), 0);
  });
  test(
      "la moyenne global correspond à la moyenne de la somme totale des commandes et n'est pas pondérée par le nombre d'item dans la commande",
      () {
    expect(
        service.getListOrderMean(orders: <Order>[
          makeOrder(price: 10, quantity: 2),
          makeOrder(price: 5, quantity: 3)
        ]),
        17.5);
  });
  test("test du fonctionnement des groupement par semaine", () {
    final Map<DateTime, List<Order>> result = service.groupOrdersByPeriod(
        periodGroupingType: PeriodGroupingType.weekly,
        orders: <Order>[
          makeOrder(id: "1", date: DateTime.utc(2026, 10, 5)),
          makeOrder(id: "2", date: DateTime.utc(2026, 10, 11)),
          makeOrder(id: "3", date: DateTime.utc(2026, 10, 12)),
        ]);
    expect(result.length, 2);
    expect(result[DateTime.utc(2026, 10, 5)]!.length, 2);
    expect(result[DateTime.utc(2026, 10, 12)]!.length, 1);
  });
  test("Le regroupement hebdomadaire utilise des dates UTC", () {
    Map<DateTime, List<Order>> result = service.groupOrdersByPeriod(
      periodGroupingType: PeriodGroupingType.weekly,
      orders: <Order>[
        makeOrder(
          id: "1",
          date: DateTime.utc(2024, 11, 10, 23, 30),
        ),
        makeOrder(
          id: "2",
          date: DateTime.utc(2024, 11, 11, 0, 30),
        ),
      ],
    );

    expect(result.length, 2);

    // semaine du 4 novembre
    expect(result[DateTime.utc(2024, 11, 4)]?.length, 1);

    // nouvelle semaine du 11 novembre
    expect(result[DateTime.utc(2024, 11, 11)]?.length, 1);

    expect(result.keys.every((DateTime date) => date.isUtc), isTrue);
  });
  test("test du fonctionnement des groupements par mois", () {
    Map<DateTime, List<Order>> result = service.groupOrdersByPeriod(
        periodGroupingType: PeriodGroupingType.monthly,
        orders: <Order>[
          makeOrder(id: "1", date: DateTime.utc(2026, 12, 31)),
          makeOrder(id: "2", date: DateTime.utc(2026, 12, 29)),
          makeOrder(id: "3", date: DateTime.utc(2027, 1, 1)),
        ]);
    expect(result.length, 2);
    expect(result[DateTime.utc(2026, 12)]!.length, 2);
    expect(result[DateTime.utc(2027, 1)]!.length, 1);
  });
}
