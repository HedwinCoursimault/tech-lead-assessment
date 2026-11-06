import 'package:my_app/core/helpers.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/domain/items/product.dart';
import 'package:my_app/domain/items/product_category.dart';

class ProductMapper {
  Product toDomain({required ProductDto productDto}) {
    return Product(
        id: ParsingHelper()
            .parseRequiredString(value: productDto.id, field: "id"),
        name: ParsingHelper()
            .parseRequiredString(value: productDto.name, field: "name"),
        price: ParsingHelper()
            .parseRequiredDouble(value: productDto.price, field: "price"),
        categories: productDto.categories?.map<ProductCategory>(
              (String category) {
                return ProductCategory(name: category);
              },
            ).toList() ??
            List<ProductCategory>.empty());
  }
}
