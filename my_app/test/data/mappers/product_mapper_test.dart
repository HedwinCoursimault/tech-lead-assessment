import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/data/mappers/product_mapper.dart';
import 'package:my_app/domain/items/product.dart';
import 'package:my_app/domain/items/product_category.dart';

void main() {
  test("bon mapping des champs entre le dto et le domain", () {
    Product product = ProductMapper().toDomain(
        productDto: const ProductDto(
            id: "P1",
            name: "Phone",
            price: 99.9,
            categories: <String>["Tech", "Mobile"]));
    expect(product.id, "P1");
    expect(product.price, 99.9);
    expect(product.categories.map((ProductCategory e) => e.name),
        <String>["Tech", "Mobile"]);
  });
  test("lorsqu'il n'y a aucune catégorie on obtient une liste vide", () {
    Product product = ProductMapper().toDomain(
        productDto: const ProductDto(id: "P1", name: "Phone", price: 99.9));
    expect(product.categories, isEmpty);
  });
  test("gestion de l'erreur lorsqu'il manque un champs", () {
    expect(
        () => ProductMapper()
            .toDomain(productDto: const ProductDto(name: "Phone")),
        throwsFormatException);
  });
}
