import 'package:my_app/data/dto/product_dto.dart';

abstract class ProductDataSource {
  Future<List<ProductDto>> getProducts({List<String>? idList});

  Future<ProductDto?> getProductById(String id);
}
