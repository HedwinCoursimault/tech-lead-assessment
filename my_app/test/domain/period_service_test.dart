import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/report/period.dart';
import 'package:my_app/domain/services/period_service.dart';

void main() {
  PeriodService service = PeriodService();
  Period period(double mean) {
    return Period(
        referenceDate: DateTime.utc(2026, 10),
        orders: const <Order>[],
        totalOrdersValue: mean,
        meanOrdersValue: mean);
  }

  test("test des differents calculs d'évolution", () {
    expect(
        service.getEvolution(current: period(150), previous: period(100)), 0.5);
    expect(service.getEvolution(current: period(75), previous: period(100)),
        -0.25);
    expect(
        service.getEvolution(current: period(100), previous: period(100)), 0);
  });
  test("retourne bien null si la dernière moyenne est à 0", () {
    expect(service.getEvolution(current: period(100), previous: period(0)),
        isNull);
  });
}
