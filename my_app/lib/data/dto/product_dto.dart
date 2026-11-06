import 'package:my_app/core/helpers.dart';

class ProductDto {
  final String? id;
  final String? name;
  final double? price;
  final List<String>? categories;

  const ProductDto({
    this.id,
    this.name,
    this.price,
    this.categories,
  });

  ProductDto.fromJson(Map<String, dynamic> json)
      : id = json["id"] as String?,
        name = json["name"] as String?,
        price = ParsingHelper().toDouble(json["price"]),
        categories = (json["categories"] as List<dynamic>?)
            ?.map((dynamic element) => element as String)
            .toList();
}
