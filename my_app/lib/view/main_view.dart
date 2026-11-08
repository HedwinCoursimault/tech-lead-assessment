import 'package:flutter/material.dart';
import 'package:my_app/domain/use_case/calculate_order_price_use_case.dart';
import 'package:my_app/domain/use_case/get_order_use_case.dart';
import 'package:my_app/view/customer_history/customer_history_view.dart';
import 'package:my_app/view/price_calculation/price_calculation_view.dart';

class MainPage extends StatelessWidget {
  final GetOrderUseCase getOrderUseCase;
  final CalculateOrderPriceUseCase calculatePriceUseCase;

  const MainPage({
    super.key,
    required this.getOrderUseCase,
    required this.calculatePriceUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MainView(
      onCustomerHistoryPressed: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CustomerHistoryPage(),
          ),
        );
      },
      onPriceCalculationPressed: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => PriceCalculationPage(
              getOrderUseCase: getOrderUseCase,
              calculatePriceUseCase: calculatePriceUseCase,
            ),
          ),
        );
      },
    );
  }
}

class MainView extends StatelessWidget {
  final VoidCallback onCustomerHistoryPressed;
  final VoidCallback onPriceCalculationPressed;

  const MainView({
    super.key,
    required this.onCustomerHistoryPressed,
    required this.onPriceCalculationPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Implémentation des questions 1 et 2"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                "Choisir une fonctionnalité",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              QuestionCard(
                icon: Icons.history_outlined,
                title: "Historique des commandes",
                description:
                    "Afficher le rapport et les commandes d'un client.",
                onPressed: onCustomerHistoryPressed,
              ),
              const SizedBox(height: 12),
              QuestionCard(
                icon: Icons.receipt_long_outlined,
                title: "Calcul du prix d'une commande",
                description:
                    "Calculer le montant final et consulter les règles appliquées.",
                onPressed: onPriceCalculationPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const QuestionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
