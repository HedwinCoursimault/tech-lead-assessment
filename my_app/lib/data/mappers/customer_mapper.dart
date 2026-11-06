import 'package:my_app/core/helpers.dart';
import 'package:my_app/data/dto/customer_dto.dart';
import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/customer_type.dart';

class CustomerMapper {
  Customer toDomain({required CustomerDto customerDto}) {
    return Customer(
      id: ParsingHelper()
          .parseRequiredString(value: customerDto.id, field: "id"),
      name: ParsingHelper()
          .parseRequiredString(value: customerDto.name, field: "name"),
      email: ParsingHelper()
          .parseRequiredString(value: customerDto.email, field: "email"),
      customerType: CustomerType.fromString(customerDto.type),
      registrationDate: ParsingHelper().parseDate(
          value: "${customerDto.registrationDate}", field: "registrationDate"),
    );
  }
}
