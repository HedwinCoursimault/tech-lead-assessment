import 'package:my_app/domain/items/customer.dart';

abstract class CustomerRepository {
  Future<Customer?> getCustomerById(String id);
}
