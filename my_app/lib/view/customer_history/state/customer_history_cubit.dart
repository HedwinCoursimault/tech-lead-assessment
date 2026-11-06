import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/items/report/report.dart';
import 'package:my_app/domain/use_case/get_customer_repport_use_case.dart';

import 'customer_history_state.dart';

class CustomerHistoryCubit extends Cubit<CustomerHistoryState> {
  final GetCustomerReportUseCase getCustomerReportUseCase;
  CustomerHistoryCubit({
    required this.getCustomerReportUseCase,
  }) : super(const CustomerHistoryState());

  Future<void> generateReport({
    required String customerId,
    int reportPeriod = 6,
    DateTime? referenceDate,
  }) async {
    final String id = customerId.trim();
    final int period = reportPeriod;

    // Date de référence du jeu de données de démonstration
    DateTime date = referenceDate ?? DateTime.utc(2024, 11, 15);

    // On commence par mettre la page en chargement
    emit(state.copyWith(
      status: CustomerHistoryStatus.loading,
      clearReport: true,
      clearError: true,
    ));

    // Check erreurs format avant de faire l'appel à l'UC
    if (id.isEmpty) {
      emit(state.copyWith(
        status: CustomerHistoryStatus.error,
        errorMessage: "Veuillez renseigner un identifiant client.",
        clearReport: true,
      ));
      return;
    }

    // Appel à l'UC wrappé dans try catch pour gérer les erreurs
    try {
      // Appel au UC de génération du rapport
      Report report = await getCustomerReportUseCase.call(
          customerId: id, period: period, referenceDate: date);

      // Emission du state de succes
      emit(state.copyWith(
        status: CustomerHistoryStatus.success,
        report: report,
      ));

      // Gestion des exceptions pouvant arriver pendant le traitement
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: CustomerHistoryStatus.error,
        errorMessage: exception.toString().replaceFirst("Exception: ", ""),
        clearReport: true,
      ));
    } on Error catch (_) {
      emit(state.copyWith(
        status: CustomerHistoryStatus.error,
        errorMessage: "Une erreur innatendue est survenue",
        clearReport: true,
      ));
    }
  }
}
