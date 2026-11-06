import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/services/report_service.dart';
import '../helpers/helper.dart';

void main() {
  ReportService service = ReportService();
  test("retour negatif si pas de déviation", () {
    expect(
        service.detectAnomalies(
            orders: <Order>[makeOrder(price: 100), makeOrder(price: 100)]),
        isEmpty);
    expect(
        service.detectAnomalies(
            orders: <Order>[makeOrder(price: 99), makeOrder(price: 101)]),
        isEmpty);
  });
  test("detecte des anomalies lorsce que c'est nécessaire (>50%)", () {
    List<Order> result = service.detectAnomalies(orders: <Order>[
      makeOrder(id: "A", price: 100),
      makeOrder(id: "B", price: 100),
      makeOrder(id: "C", price: 500)
    ]);
    expect(result.map((Order order) => order.id), contains("C"));
  });
  test("Si écart de pile 50%, pas de détéction", () {
    List<Order> result = service.detectAnomalies(orders: <Order>[
      makeOrder(id: "A", price: 75),
      makeOrder(id: "B", price: 225)
    ]);
    expect(result, isEmpty);
  });
  test("retourne vide pour les cas null ou =0", () {
    expect(service.detectAnomalies(orders: <Order>[]), isEmpty);
    expect(
        service.detectAnomalies(
            orders: <Order>[makeOrder(price: 0), makeOrder(price: 0)]),
        isEmpty);
  });
}
