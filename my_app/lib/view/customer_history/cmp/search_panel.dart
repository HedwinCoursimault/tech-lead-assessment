import 'package:flutter/material.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    required this.controller,
    required this.loading,
    required this.onPressed,
    super.key,
  });

  final TextEditingController controller;
  final bool loading;
  final Future<void> Function({required String customerId}) onPressed;

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
                  "Saisisez l'identifiant du client pour analyser ses commandes des six derniers mois."),
              const SizedBox(height: 16),
              Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Identifiant client",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: loading
                        ? null
                        : (String value) => onPressed(customerId: value),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: loading
                      ? null
                      : () => onPressed(customerId: controller.text),
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Analyser"),
                ),
              ]),
            ]),
      ),
    );
  }
}
