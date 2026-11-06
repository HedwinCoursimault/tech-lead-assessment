import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/services/customer_service.dart';

void main() {
  CustomerService service = CustomerService();
  test("Regulier implique strictement plus de 2 commandes par mois", () {
    expect(service.isRegularCustomer(13, 6), isTrue);
    expect(service.isRegularCustomer(12, 6), isFalse);
    expect(service.isRegularCustomer(6, 6), isFalse);
    expect(service.isRegularCustomer(0, 6), isFalse);
    expect(service.isRegularCustomer(60, 30), isFalse);
    expect(service.isRegularCustomer(20, 30), isFalse);
    expect(service.isRegularCustomer(150, 30), isTrue);
  });
}
