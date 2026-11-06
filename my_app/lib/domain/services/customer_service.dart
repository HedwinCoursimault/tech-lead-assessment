/// Service pour le code métier sur le client
class CustomerService {
  /// Est-ce que le client est un client régulier en fonction de son nombre de commande [orderCount] sur une durée en mois [period]
  bool isRegularCustomer(int orderCount, int period) {
    // Pour calculer la moyenne du nb de commandes par mois : nb total de commande sur la durée / nombre de mois qui composent la durée
    double meanOrdersByMonths = orderCount / period.toDouble();

    // On considère qu'un client est un client régulier si il a une moyenne de plus de 2 commandes par mois
    return meanOrdersByMonths > 2;
  }
}
