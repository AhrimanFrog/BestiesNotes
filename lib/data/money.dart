import 'package:intl/intl.dart';

/// "1,200" / "12.50" in English, "1 200" / "12,50" in Ukrainian — whole
/// amounts without decimals.
String formatAmount(double amount) => formatMoney(amount);

/// [formatAmount] with a currency symbol placed the way the current language
/// expects: "₴1,200" in English, "1 200 ₴" in Ukrainian. Without a
/// [currency] (ISO 4217 code) it's the bare amount.
String formatMoney(double amount, {String? currency}) {
  final digits = amount == amount.roundToDouble() ? 0 : 2;
  final format = currency == null
      ? NumberFormat.decimalPatternDigits(decimalDigits: digits)
      : NumberFormat.simpleCurrency(name: currency, decimalDigits: digits);
  return format.format(amount);
}

/// An amount to pre-fill an input with: no grouping, so it parses back
/// unchanged ("1200", "12.5").
String formatAmountForInput(double amount) => amount == amount.roundToDouble()
    ? amount.toStringAsFixed(0)
    : amount.toString();
