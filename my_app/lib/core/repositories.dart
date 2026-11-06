// Classe permettant de maintenir de manière globale l'implémentation des repository abstraits.
// Permet de remplacer de l'injection de dépendance, plus lourde et pas nécessaire dans notre cas.
import 'package:my_app/data/local/customer_repository_local.dart';
import 'package:my_app/data/local/order_repository_local.dart';
import 'package:my_app/data/local/product_repository_local.dart';
import 'package:my_app/domain/repository/customer_repository.dart';
import 'package:my_app/domain/repository/order_repository.dart';
import 'package:my_app/domain/repository/product_repository.dart';

class Repositories {
  static CustomerRepository customerRepository = CustomerRepositoryLocal();
  static OrderRepository orderRepository = OrderRepositoryLocal();
  static ProductRepository productRepository = ProductRepositoryLocal();
}
