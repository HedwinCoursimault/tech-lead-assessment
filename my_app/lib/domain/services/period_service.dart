import 'package:my_app/domain/items/report/period.dart';

class PeriodService {
  // Calcul l'évolution de la valeur moyenne de commande par rapport à la période précédente
  double? getEvolution({required Period current, required Period previous}) {
    {
      if (previous.meanOrdersValue == 0) return null;

      return (current.meanOrdersValue - previous.meanOrdersValue) /
          previous.meanOrdersValue;
    }
  }
}
