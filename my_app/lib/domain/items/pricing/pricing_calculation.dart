import 'package:my_app/domain/items/pricing/price_adjustment.dart';
import 'package:my_app/domain/items/pricing/pricing_context.dart';
import 'package:my_app/domain/items/pricing/pricing_rule_config.dart';

class PricingCalculation {
  final PricingContext context;

  /// Prix en cours de chaque ligne de la commande
  final List<int> lineAmounts;

  /// Ajustements appliqués.
  final List<PriceAdjustment> adjustments = <PriceAdjustment>[];

  /// Ajustement sur le total de la commande, non réimpacté sur chaque prix
  int orderGlobalAdjustmentsAmount = 0;

  PricingPhase currentPhase = PricingPhase.base;

  /// Somme total après chaque étapes
  // ignore: always_specify_types
  Map<PricingPhase, List<int>> lineAmountAfterPhases = {};

  PricingCalculation({
    required this.context,
    required this.lineAmounts,
  });

  // Somme actuelle de tous les produits
  int get currentAmount =>
      lineAmounts.fold(0, (int sum, int amount) => sum + amount);

  // Somme courante totale, ajoutant les ajutements globaux ne dépendant pas d'articles
  int get totalAmount => currentAmount + orderGlobalAdjustmentsAmount;

  int? effectiveAmountAtPhase({required PricingPhase phase}) {
    List<int>? listAtPhase = lineAmountAfterPhases[phase];

    if (listAtPhase == null || listAtPhase.isEmpty) {
      return null;
    }

    return listAtPhase.fold<int>(0, (int sum, int amount) => sum + amount);
  }

  int? effectiveAmountFromReference(
      {required PricingAmountReference amountReference}) {
    switch (amountReference) {
      case PricingAmountReference.current:
        return currentAmount;
      case PricingAmountReference.previousPhase:
        int currentPhaseIndex = currentPhase.index;
        if (currentPhaseIndex == 0) {
          return null;
        }
        PricingPhase previousPhase = PricingPhase.values[currentPhaseIndex - 1];
        return effectiveAmountAtPhase(phase: previousPhase);
      default:
        return null;
    }
  }

  void applyAdjustment({required PriceAdjustment adjustment}) {
    int? orderLineIndex = adjustment.orderLineIndex;
    if (orderLineIndex != null) {
      lineAmounts[orderLineIndex] += adjustment.amount;
    } else {
      orderGlobalAdjustmentsAmount += adjustment.amount;
    }
    adjustments.add(adjustment);
  }
}
