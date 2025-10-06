enum RatePeriod { daily, monthly }

class Rate {
  int rate;
  RatePeriod period;

  Rate({required this.rate, required this.period});
}
