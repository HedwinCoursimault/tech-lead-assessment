import 'package:my_app/core/helpers.dart';
import 'package:my_app/data/dto/order_dto.dart';
import 'package:my_app/data/dto/order_item_dto.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/product_category.dart';

class OrderMapper {
  Order toDomain(
      {required OrderDto orderDto, required List<ProductDto> productsDto}) {
    // Liste des OrderItemDto
    List<OrderItemDto>? orderItemDtoList = orderDto.items;

    // Liste à construire des OrderLine à mettre dans l'Order qu'on construit
    List<OrderLine> orderLines = <OrderLine>[];

    // Si on a une liste d'items dans le dto, on va faire matcher avec le produit correspondant
    if (orderItemDtoList != null) {
      // Le but est de faire l'intersection entre les produits présent dans OrderDto.items et ceux présent dans productsDto
      // pour ensuite constituer une liste d'item final OrderLine contenant l'aggrégation des deux (qté + prix)

      // On mets les produits dans une map pour y accéder plus facilement par la suite (sans reparcourir toute la liste à chaque fois)
      Map<String, ProductDto> productDtoMap = <String, ProductDto>{
        for (ProductDto product in productsDto)
          if (product.id != null) product.id!: product
      };

      // Parcours de la liste des orderItem du dto pour créer la liste des OrderLines final
      for (OrderItemDto item in orderItemDtoList) {
        String? productId = item.productId;

        // Produit non renseigné dans la ligne de commande
        if (productId == null) {
          throw Exception(
            "La commande ${orderDto.orderId} contient un produit sans identifiant.",
          );
        }

        ProductDto? product = productDtoMap[productId];

        // Produit non trouvé dans le catalogue
        if (product == null) {
          throw Exception(
            "Le produit $productId de la commande ${orderDto.orderId} est introuvable.",
          );
        }

        orderLines.add(
          OrderLineMapper().toDomain(
            productDto: product,
            orderItemDto: item,
          ),
        );
      }
    }
    return Order(
        id: ParsingHelper()
            .parseRequiredString(value: orderDto.orderId, field: "orderId"),
        customerId: ParsingHelper().parseRequiredString(
            value: orderDto.customerId, field: "customerId"),
        orderDate: ParsingHelper()
            .parseDate(value: orderDto.orderDate, field: "orderDate"),
        status: OrderStatus.fromString(orderDto.status),
        expressDelivery: ParsingHelper().parseRequiredBool(
            value: orderDto.expressDelivery, field: "expressDelivery"),
        lines: orderLines);
  }
}

class OrderLineMapper {
  OrderLine toDomain(
      {required ProductDto productDto, required OrderItemDto orderItemDto}) {
    if (productDto.id != orderItemDto.productId) {
      throw Exception(
          "Error during order mapping : ids not matching (${productDto.id} != ${orderItemDto.productId})");
    }

    return OrderLine(
        productId: ParsingHelper()
            .parseRequiredString(value: productDto.id, field: "id"),
        productName: ParsingHelper()
            .parseRequiredString(value: productDto.name, field: "name"),
        unitPrice: ParsingHelper()
            .parseRequiredDouble(value: productDto.price, field: "price"),
        quantity: ParsingHelper()
            .parseRequiredInt(value: orderItemDto.quantity, field: "quantity"),
        productCategories: productDto.categories?.map<ProductCategory>(
              (String category) {
                return ProductCategory(name: category);
              },
            ).toList() ??
            List<ProductCategory>.empty());
  }
}
