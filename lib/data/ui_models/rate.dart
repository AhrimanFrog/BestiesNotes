enum RatePeriod { daily, monthly }

class Rate {
  final double rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});
}
