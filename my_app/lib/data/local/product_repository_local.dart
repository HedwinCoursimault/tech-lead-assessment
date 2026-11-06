import 'package:my_app/data/data_source/local/product_local_data_source.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/data/mappers/product_mapper.dart';
import 'package:my_app/domain/items/product.dart';
import 'package:my_app/domain/repository/product_repository.dart';

class ProductRepositoryLocal implements ProductRepository {
   @override
  Future<Product?> getProductById(String id) async {
    ProductDto? productDto = await ProductLocalDataSource().getProductById(id);

    if (productDto == null) {
      return null;
    }

    return ProductMapper().toDomain(productDto: productDto);
  }

  @override
  Future<List<Product>> getProducts() async {
    List<ProductDto> productsDto = await ProductLocalDataSource().getProducts();

    return productsDto.map(
      (ProductDto productDto) {
        return ProductMapper().toDomain(productDto: productDto);
      },
    ).toList();
  }
}
