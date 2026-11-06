import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/data/dto/customer_dto.dart';
import 'package:my_app/data/mappers/customer_mapper.dart';
import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/customer_type.dart';

void main() {
  CustomerMapper mapper = CustomerMapper();
  test(
      "associer les champs client et reconnaitre le type de client sans tenir compte de la casse",
      () {
    Customer customer = mapper.toDomain(
        customerDto: const CustomerDto(
            id: "C1",
            name: "Test",
            email: "a@b.fr",
            type: "VIP",
            registrationDate: "2024-01-15"));
    Customer customer2 = mapper.toDomain(
        customerDto: const CustomerDto(
            id: "C1",
            name: "Test",
            email: "a@b.fr",
            type: "vIp",
            registrationDate: "2024-01-15"));
    expect(customer.id, "C1");
    expect(customer.customerType, CustomerType.vip);
    expect(customer.registrationDate, DateTime.utc(2024, 1, 15));
    expect(customer2.customerType, CustomerType.vip);
  });
  test("fonctionnement du fallback sur unknown pour le type de client", () {
    Customer customer = mapper.toDomain(
        customerDto: const CustomerDto(
            id: "C1",
            name: "Test",
            email: "a@b.fr",
            type: "other",
            registrationDate: "2024-01-15"));
    Customer customer2 = mapper.toDomain(
        customerDto: const CustomerDto(
            id: "C1",
            name: "Test",
            email: "a@b.fr",
            type: "azer",
            registrationDate: "2024-01-15"));
    expect(customer.customerType, CustomerType.unknown);
    expect(customer2.customerType, CustomerType.unknown);
  });
  test("gestion des erreurs lorsqu'il manque des champs", () {
    expect(() => mapper.toDomain(customerDto: const CustomerDto(name: "Test")),
        throwsFormatException);
  });
}
