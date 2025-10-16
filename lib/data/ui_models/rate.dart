enum RatePeriod { daily, monthly }

class Rate {
  final int rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});
}
