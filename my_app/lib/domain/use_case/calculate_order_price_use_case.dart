import 'package:my_app/domain/items/customer.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/pricing_orchestrator.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';
import 'package:my_app/domain/repository/customer_repository.dart';
import 'package:my_app/domain/use_case/is_first_order_of_month_use_case.dart';

/// Récupère les données métier nécessaires et lance le calcul des tarifs
class CalculateOrderPriceUseCase {
  final CustomerRepository customerRepository;
  final IsFirstOrderOfMonthUseCase isFirstOrderOfMonthUseCase;
  final PricingOrchestrator pricingOrchestrator;

  CalculateOrderPriceUseCase({
    required this.customerRepository,
    required this.isFirstOrderOfMonthUseCase,
    required this.pricingOrchestrator,
  });

  Future<PricingResult> call({required Order order}) async {
    Customer? customer =
        await customerRepository.getCustomerById(order.customerId);

    if (customer == null) {
      throw Exception(
        "Impossible de calculer la commande ${order.id} : "
        "client ${order.customerId} introuvable.",
      );
    }

    bool isFirstOrderOfTheMonth =
        await isFirstOrderOfMonthUseCase.call(order: order);

    return pricingOrchestrator.calculatePrice(
      order: order,
      customer: customer,
      isFirstOrderOfTheMonth: isFirstOrderOfTheMonth,
    );
  }
}
