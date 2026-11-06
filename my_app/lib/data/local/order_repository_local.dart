import 'package:my_app/data/data_source/local/order_local_data_source.dart';
import 'package:my_app/data/data_source/local/product_local_data_source.dart';
import 'package:my_app/data/dto/order_dto.dart';
import 'package:my_app/data/dto/order_item_dto.dart';
import 'package:my_app/data/dto/product_dto.dart';
import 'package:my_app/data/mappers/order_mapper.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/repository/order_repository.dart';

class OrderRepositoryLocal implements OrderRepository {
  @override
  Future<Order?> getOrderById(String id) async {
    // Récupération de la commande dans le data source
    OrderDto? orderDto = await OrderLocalDataSource().getOrderById(id);

    if (orderDto == null) {
      return null;
    }

    // Récupération des ids des produits de cette commande grâce au DTO
    List<ProductDto>? productDtoList =
        await getProductListFromOrderDto(orderDto);

    // Création de l'order métier en passant par le mapper
    return OrderMapper()
        .toDomain(orderDto: orderDto, productsDto: productDtoList);
  }

  @override
  Future<List<Order>> getOrders(
      {DateTime? minDate, DateTime? maxDate, String? customerId}) async {
    // Récupération de toutes les commandes concernées
    List<OrderDto> orderDtoList = await OrderLocalDataSource().getOrders(
      customerId: customerId,
      maxDate: maxDate,
      minDate: minDate,
    );

    // Construction d'une liste avec tous les produits de toutes les commande.
    // Cela permet de ne pas requeter deux fois un produit si celui-ci est dans deux commandes
    Set<String> allProductIdsList = <String>{};
    for (OrderDto orderDto in orderDtoList) {
      List<OrderItemDto> orderItems = orderDto.items ?? <OrderItemDto>[];
      allProductIdsList.addAll(
        orderItems
            .map((OrderItemDto item) => item.productId)
            .whereType<String>(),
      );
    }

    // Récupération de tous les produits nécéssaires
    List<ProductDto> allProductDtoList = allProductIdsList.isEmpty
        ? <ProductDto>[]
        : await ProductLocalDataSource().getProducts(
            idList: allProductIdsList.toList(),
          );

    // On donne la liste de tous les produits au mapper qui s'occupe de faire le lien
    return orderDtoList.map((OrderDto orderDto) {
      return OrderMapper().toDomain(
        orderDto: orderDto,
        productsDto: allProductDtoList,
      );
    }).toList();
  }

  Future<List<ProductDto>> getProductListFromOrderDto(OrderDto orderDto) async {
    // Récupération des ids des produits de cette commande grâce au DTO
    List<String> productIds = orderDto.items?.where(
          (OrderItemDto orderItemDto) {
            return orderItemDto.productId != null;
          },
        ).map<String>(
          (OrderItemDto orderItemDto) {
            return orderItemDto.productId!;
          },
        ).toList() ??
        <String>[];

    // Récupération des produits en passant par le data source
    List<ProductDto>? productDtoList =
        await ProductLocalDataSource().getProducts(idList: productIds);
    return productDtoList;
  }
}
