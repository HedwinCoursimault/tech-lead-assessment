import 'package:my_app/data/data_source/local/customer_local_data_source.dart';
import 'package:my_app/data/dto/customer_dto.dart';
import 'package:my_app/data/mappers/customer_mapper.dart';
import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/repository/customer_repository.dart';

class CustomerRepositoryLocal implements CustomerRepository {
  @override
  Future<Customer?> getCustomerById(String id) async {
    CustomerDto? customerDto =
        await CustomerLocalDataSource().getCustomerById(id);

    if (customerDto == null) {
      return null;
    }

    return CustomerMapper().toDomain(customerDto: customerDto);
  }
}
