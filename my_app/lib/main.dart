import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_app/config/pricing_rules.dart';
import 'package:my_app/core/repositories.dart';
import 'package:my_app/domain/items/pricing/pricing_orchestrator.dart';
import 'package:my_app/domain/use_case/calculate_order_price_use_case.dart';
import 'package:my_app/domain/use_case/get_order_use_case.dart';
import 'package:my_app/domain/use_case/is_first_order_of_month_use_case.dart';
import 'package:my_app/view/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("fr_FR");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        calculatePriceUseCase: CalculateOrderPriceUseCase(
          customerRepository: Repositories.customerRepository,
          isFirstOrderOfMonthUseCase: IsFirstOrderOfMonthUseCase(
            orderRepository: Repositories.orderRepository,
          ),
          pricingOrchestrator: PricingOrchestrator(
            ruleConfigList: PricingRules.build(),
          ),
        ),
        getOrderUseCase: GetOrderUseCase(
          orderRepository: Repositories.orderRepository,
        ),
      ),
    );
  }
}
