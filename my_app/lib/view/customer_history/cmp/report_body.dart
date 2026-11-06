import 'package:flutter/material.dart';

import 'package:my_app/domain/items/report/report.dart';
import 'package:my_app/domain/items/report/period.dart';
import 'package:my_app/view/customer_history/cmp/anomaly_card.dart';
import 'package:my_app/view/customer_history/cmp/period_section.dart';

class ResultBody extends StatelessWidget {
  final Report report;

  const ResultBody({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    // Création d'une liste de periods qu'on trie en fonction de la date de référence (du plus récent au plus ancien)
    List<Period> periods = <Period>[
      ...report.periods
    ]..sort((Period a, Period b) => b.referenceDate.compareTo(a.referenceDate));

    // On vérifie que toutes les périodes ne contiennet pas des commandes vides
    if (periods.every((Period period) => period.orders.isEmpty)) {
      return const Center(
        child: Text("Aucune commande trouvée"),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        // Anomalies
        AnomalyCard(
          anomalies: report.anomalies,
        ),

        if (report.anomalies.isNotEmpty) const SizedBox(height: 20),

        // Historique des périodes
        ...periods.map((Period period) {
          int index = periods.indexOf(period);

          Period? previous =
              index + 1 < periods.length ? periods[index + 1] : null;

          if (period.orders.isEmpty) {
            return const SizedBox.shrink();
          }

          return PeriodSection(
            period: period,
            previous: previous,
          );
        }),
      ],
    );
  }
}
