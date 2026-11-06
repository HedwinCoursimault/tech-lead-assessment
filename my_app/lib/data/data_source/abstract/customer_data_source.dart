import 'package:my_app/data/dto/customer_dto.dart';

abstract class CustomerDataSource {
  Future<List<CustomerDto>> getCustomers();

  Future<CustomerDto?> getCustomerById(String id);
}
