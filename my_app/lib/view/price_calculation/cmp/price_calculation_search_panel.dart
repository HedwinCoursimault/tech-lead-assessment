import 'package:flutter/material.dart';

class PriceCalculationSearchPanel extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final Future<void> Function({required String orderId}) onPressed;

  const PriceCalculationSearchPanel({
    super.key,
    required this.controller,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Saisissez l'identifiant d'une commande pour calculer son prix après application des règles.",
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: !loading,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: "Identifiant commande",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: loading
                        ? null
                        : (String value) {
                            onPressed(orderId: value);
                          },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: loading
                      ? null
                      : () {
                          onPressed(orderId: controller.text);
                        },
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Calculer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
