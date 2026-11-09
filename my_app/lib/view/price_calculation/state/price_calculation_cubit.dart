import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';
import 'package:my_app/domain/use_case/calculate_order_price_use_case.dart';
import 'package:my_app/domain/use_case/get_order_use_case.dart';
import 'package:my_app/view/price_calculation/state/price_calculation_state.dart';

class PriceCalculationCubit extends Cubit<PriceCalculationState> {
  final GetOrderUseCase getOrderUseCase;
  final CalculateOrderPriceUseCase calculatePriceUseCase;

  PriceCalculationCubit({
    required this.getOrderUseCase,
    required this.calculatePriceUseCase,
  }) : super(const PriceCalculationState());

  Future<void> calculatePrice({required String orderId}) async {
    String id = orderId.trim();

    emit(state.copyWith(
      status: PriceCalculationStatus.loading,
      clearResult: true,
      clearError: true,
    ));

    if (id.isEmpty) {
      emit(state.copyWith(
        status: PriceCalculationStatus.error,
        errorMessage: "Veuillez renseigner un identifiant de commande.",
        clearResult: true,
      ));
      return;
    }

    try {
      Order? order = await getOrderUseCase.call(orderId: id);
      if (order != null) {
        PricingResult result = await calculatePriceUseCase.call(order: order);
        emit(state.copyWith(
          status: PriceCalculationStatus.success,
          order: order,
          result: result,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: PriceCalculationStatus.error,
          errorMessage: "Impossible de trouver une commande avec l'id $orderId",
          clearResult: true,
        ));
      }
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: PriceCalculationStatus.error,
        errorMessage: exception.toString().replaceFirst("Exception: ", ""),
        clearResult: true,
      ));
    } on Error catch (_) {
      emit(state.copyWith(
        status: PriceCalculationStatus.error,
        errorMessage: "Une erreur inattendue est survenue.",
        clearResult: true,
      ));
    }
  }
}
