// Objet métier représentant un rapport d'un client sur une période de 6 mois
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/report/period.dart';

class Report {
  /// Client concerné par le rapport
  final String customerId;

  /// Nom du client concerné par le rapport
  /// On peut éventuellement ne pas avoir accès au nom du client, non bloquant
  final String? customerName;

  /// Liste des periods de ce rapport, ces periods étant elles mêmes un regroupement de commandes
  final List<Period> periods;

  final List<Order> anomalies;

  Report({
    required this.customerId,
    required this.periods,
    required this.customerName,
    required List<Order> anomalies,
  }) : anomalies = List<Order>.unmodifiable(anomalies);
}
