import 'package:intl/intl.dart';

class PriceFormatter {
  static String format(int amount) {
    // Les montants du moteur de pricing sont stockés en centimes.
    NumberFormat format = NumberFormat.currency(
      locale: "fr_FR",
      symbol: "€",
    );
    return format.format(amount / 100);
  }

  static String formatAdjustment(int amount) {
    String prefix = amount > 0 ? "+" : "";
    return "$prefix${format(amount)}";
  }
}
