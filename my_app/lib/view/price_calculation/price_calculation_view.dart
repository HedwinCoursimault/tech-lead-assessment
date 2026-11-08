import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_case/calculate_order_price_use_case.dart';
import 'package:my_app/domain/use_case/get_order_use_case.dart';
import 'package:my_app/view/price_calculation/cmp/price_calculation_result_body.dart';
import 'package:my_app/view/price_calculation/cmp/price_calculation_search_panel.dart';
import 'package:my_app/view/price_calculation/state/price_calculation_cubit.dart';
import 'package:my_app/view/price_calculation/state/price_calculation_state.dart';

class PriceCalculationPage extends StatelessWidget {
  final GetOrderUseCase getOrderUseCase;
  final CalculateOrderPriceUseCase calculatePriceUseCase;

  const PriceCalculationPage({
    super.key,
    required this.getOrderUseCase,
    required this.calculatePriceUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriceCalculationCubit>(
      create: (BuildContext context) {
        return PriceCalculationCubit(
          getOrderUseCase: getOrderUseCase,
          calculatePriceUseCase: calculatePriceUseCase,
        );
      },
      child: const PriceCalculationView(),
    );
  }
}

class PriceCalculationView extends StatefulWidget {
  const PriceCalculationView({super.key});

  @override
  State<PriceCalculationView> createState() => _PriceCalculationViewState();
}

class _PriceCalculationViewState extends State<PriceCalculationView> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PriceCalculationCubit, PriceCalculationState>(
      listenWhen:
          (PriceCalculationState previous, PriceCalculationState current) {
        return current.hasError && !previous.hasError;
      },
      listener: (BuildContext context, PriceCalculationState state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? "Erreur inconnue"),
            backgroundColor:
                Theme.of(context).snackBarTheme.actionBackgroundColor,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calcul du prix d'une commande"),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<PriceCalculationCubit, PriceCalculationState>(
                builder: (BuildContext context, PriceCalculationState state) {
                  return Column(
                    children: <Widget>[
                      PriceCalculationSearchPanel(
                        controller: controller,
                        loading: state.isLoading,
                        onPressed: ({required String orderId}) {
                          return context
                              .read<PriceCalculationCubit>()
                              .calculatePrice(orderId: orderId);
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildContent(context, state),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PriceCalculationState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasResult && state.result != null && state.order != null) {
      return PriceCalculationResultBody(
        order: state.order!,
        result: state.result!,
      );
    }

    if (state.hasError) {
      return const Center(
        child: Text("Le calcul n'a pas pu être effectué."),
      );
    }

    return const Center(
      child: Text("Saisissez un identifiant de commande pour commencer."),
    );
  }
}
