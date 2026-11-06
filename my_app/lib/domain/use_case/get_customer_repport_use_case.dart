import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/period.dart';
import 'package:my_app/domain/items/report.dart';
import 'package:my_app/domain/repository/customer_repository.dart';
import 'package:my_app/domain/repository/order_repository.dart';
import 'package:my_app/domain/services/customer_service.dart';
import 'package:my_app/domain/services/order_service.dart';
import 'package:my_app/domain/services/report_service.dart';

/// UC permettant de générer le rapport d'un client
class GetCustomerReportUseCase {
  final CustomerRepository customerRepository;
  final OrderRepository orderRepository;

  GetCustomerReportUseCase({
    required this.customerRepository,
    required this.orderRepository,
  });

  /// Appel au UC, aggrégations des données pour générer le rapport du client [customerId], sur une [period] donnée en mois
  Future<Report> call({
    required String customerId,
    required int period,
    required DateTime referenceDate,
  }) async {
    // On calcule le nombre de mois de manière simple : on retire le nombre de mois demandé au mois courant, en prenant en compte seulement le mois et pas le jour
    DateTime minDate = DateTime.utc(
      referenceDate.year,
      referenceDate.month - period,
      referenceDate.day,
      referenceDate.hour,
    );

    // Récupération du client pour avoir son nom si disponible
    Customer? customer = await customerRepository.getCustomerById(customerId);

    // Récupération des commandes du client sur la durée demandée
    List<Order> orders = await orderRepository.getOrders(
        customerId: customerId, minDate: minDate, maxDate: referenceDate);

    int orderCount = orders.length;
    bool isRegularCustomer =
        CustomerService().isRegularCustomer(orderCount, period);

    // Détéction des anomalies
    List<Order> anomalies = ReportService().detectAnomalies(orders: orders);

    // Création des periods
    // On réunit les commandes par période
    Map<DateTime, List<Order>> groupedOrders = OrderService()
        .groupOrdersByPeriod(
            periodGroupingType: isRegularCustomer
                ? PeriodGroupingType.weekly
                : PeriodGroupingType.monthly,
            orders: orders);

    // On itère sur les éléments de la map pour créer les Period et calculer les moyennes
    List<Period> periods = groupedOrders.entries.map<Period>(
      (MapEntry<DateTime, List<Order>> entry) {
        List<Order> orders = entry.value;

        double totalOrdersValue =
            OrderService().getListOrderValue(orders: orders);
        double meanOrdersValue =
            OrderService().getListOrderMean(orders: orders);

        return Period(
          referenceDate: entry.key,
          orders: entry.value,
          totalOrdersValue: totalOrdersValue,
          meanOrdersValue: meanOrdersValue,
        );
      },
    ).toList();

    // Création du rapport
    return Report(
      customerId: customerId,
      customerName: customer?.name,
      periods: periods,
      anomalies: anomalies,
    );
  }
}
