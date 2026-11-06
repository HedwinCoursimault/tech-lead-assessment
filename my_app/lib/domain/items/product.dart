import 'package:my_app/domain/items/product_category.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final List<ProductCategory> categories;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required List<ProductCategory> categories,
  }) : categories = List<ProductCategory>.unmodifiable(categories);
}
