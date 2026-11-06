import 'package:my_app/domain/items/report/report.dart';

enum CustomerHistoryStatus {
  initial,
  loading,
  success,
  error,
}

class CustomerHistoryState {
  const CustomerHistoryState({
    this.status = CustomerHistoryStatus.initial,
    this.report,
    this.errorMessage,
  });

  final CustomerHistoryStatus status;
  final Report? report;
  final String? errorMessage;

  bool get isLoading => status == CustomerHistoryStatus.loading;
  bool get hasReport => status == CustomerHistoryStatus.success;
  bool get hasError => status == CustomerHistoryStatus.error;

  CustomerHistoryState copyWith({
    CustomerHistoryStatus? status,
    Report? report,
    String? errorMessage,
    bool clearReport = false,
    bool clearError = false,
  }) {
    return CustomerHistoryState(
      status: status ?? this.status,
      report: clearReport ? null : report ?? this.report,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
