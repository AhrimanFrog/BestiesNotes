/// "420", "12.50" — whole amounts without decimals.
/// (The currency symbol arrives with Settings.)
String formatAmount(double amount) => amount == amount.roundToDouble()
    ? amount.toStringAsFixed(0)
    : amount.toStringAsFixed(2);
