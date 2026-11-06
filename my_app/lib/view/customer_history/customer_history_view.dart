import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/repositories.dart';
import 'package:my_app/domain/use_case/get_customer_repport_use_case.dart';
import 'package:my_app/view/customer_history/cmp/report_body.dart';
import 'package:my_app/view/customer_history/cmp/search_panel.dart';
import 'package:my_app/view/customer_history/state/customer_history_cubit.dart';
import 'package:my_app/view/customer_history/state/customer_history_state.dart';

class CustomerHistoryPage extends StatelessWidget {
  const CustomerHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerHistoryCubit>(
      create: (BuildContext context) {
        return CustomerHistoryCubit(
          getCustomerReportUseCase: GetCustomerReportUseCase(
            customerRepository: Repositories.customerRepository,
            orderRepository: Repositories.orderRepository,
          ),
        );
      },
      child: const CustomerHistoryView(),
    );
  }
}

class CustomerHistoryView extends StatelessWidget {
  const CustomerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerHistoryCubit, CustomerHistoryState>(
      // On réagit au changement d'état seulement si il vient de passer en erreur
      listenWhen:
          (CustomerHistoryState previous, CustomerHistoryState current) =>
              current.hasError && !previous.hasError,
      listener: (BuildContext context, CustomerHistoryState state) {
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
          title: const Text("Génération rapport d'historique"),
        ),
        body: BlocBuilder<CustomerHistoryCubit, CustomerHistoryState>(
            builder: (BuildContext context, CustomerHistoryState state) {
          return Center(
            child: Column(
              children: <Widget>[
                SearchPanel(
                  controller: TextEditingController(text: ''),
                  loading: state.isLoading,
                  onPressed: ({required String customerId}) async {
                    context.read<CustomerHistoryCubit>().generateReport(
                          customerId: customerId,
                        );
                  },
                ),
                if (state.hasReport && state.report != null)
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Rapport du client ${state.report!.customerName ?? ""} (${state.report!.customerId})",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: ResultBody(
                            report: state.report!,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
