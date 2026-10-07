import 'package:intl/intl.dart';

/// "1,200" / "12.50" in English, "1 200" / "12,50" in Ukrainian — whole
/// amounts without decimals. (The currency symbol arrives with Settings.)
String formatAmount(double amount) {
  final whole = amount == amount.roundToDouble();
  return NumberFormat.decimalPatternDigits(
    decimalDigits: whole ? 0 : 2,
  ).format(amount);
}

/// An amount to pre-fill an input with: no grouping, so it parses back
/// unchanged ("1200", "12.5").
String formatAmountForInput(double amount) => amount == amount.roundToDouble()
    ? amount.toStringAsFixed(0)
    : amount.toString();
