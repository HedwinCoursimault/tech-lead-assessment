import 'package:my_app/domain/items/order.dart';
import 'package:my_app/domain/items/pricing/pricing_result.dart';

enum PriceCalculationStatus {
  initial,
  loading,
  success,
  error,
}

class PriceCalculationState {
  final PriceCalculationStatus status;
  final Order? order;
  final PricingResult? result;
  final String? errorMessage;

  const PriceCalculationState({
    this.status = PriceCalculationStatus.initial,
    this.order,
    this.result,
    this.errorMessage,
  });

  bool get isLoading => status == PriceCalculationStatus.loading;
  bool get hasResult => status == PriceCalculationStatus.success;
  bool get hasError => status == PriceCalculationStatus.error;

  PriceCalculationState copyWith({
    PriceCalculationStatus? status,
    Order? order,
    PricingResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return PriceCalculationState(
      status: status ?? this.status,
      order: clearResult ? null : order ?? this.order,
      result: clearResult ? null : result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
