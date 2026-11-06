import 'package:collection/collection.dart';

/// Correspondance du champs "type" du client. On part du postulat que la liste est figée donc on peut l'implémenter en "dur"
enum CustomerType {
  premium,
  vip,
  standard,
  // Ajout d'un type inconnu pour gérer les cas "vide" + simplifier la gestion des erreures
  unknown;

  static CustomerType fromString(String? value) {
    // Gestion simple : correspondance textuelle exacte (sauf case) et unknown en fallback
    return CustomerType.values.singleWhereOrNull(
          (CustomerType element) => element.name == value?.toLowerCase(),
        ) ??
        CustomerType.unknown;
  }
}
