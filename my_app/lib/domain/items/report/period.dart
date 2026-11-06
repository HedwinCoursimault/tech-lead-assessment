import 'package:my_app/domain/items/order.dart';

/// Item représentant une période dans laquelle sont regroupées des commandes
/// La durée de ces périodes diffère selon le rythme d'achat du client
class Period {
  /// Date de référence de la période (premier jour de la période)
  final DateTime referenceDate;

  /// Commandes du client sur cette période
  final List<Order> orders;

  /// Valeur des commandes sur la périod
  final double totalOrdersValue;

  /// Valeur moyenne des commandes sur la period
  final double meanOrdersValue;

  Period({
    required this.referenceDate,
    required this.orders,
    required this.totalOrdersValue,
    required this.meanOrdersValue,
  });

  /// Nombre total de commandes sur la periode
  int get orderCount => orders.length;
}

enum PeriodGroupingType {
  weekly,
  monthly,
}
