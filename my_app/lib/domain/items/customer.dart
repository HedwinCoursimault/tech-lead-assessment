import 'package:my_app/domain/items/customer_type.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final CustomerType customerType;
  final DateTime registrationDate;

  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.customerType,
    required this.registrationDate,
  });
}
