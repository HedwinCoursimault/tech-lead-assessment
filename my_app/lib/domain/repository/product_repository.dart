import 'package:my_app/domain/items/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<Product?> getProductById(String id);
}
