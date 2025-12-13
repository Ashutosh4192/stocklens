class Stock {
  final String symbol;
  final String companyName;
  final int qty;
  final double avgPrice;
  final double currentPrice;
  final Map<String, double>? changes;
  final List<double>? priceHistory;
  final String? insight;
  final String? logo;

  Stock({
    required this.symbol,
    required this.companyName,
    required this.qty,
    required this.avgPrice,
    required this.currentPrice,
    this.changes,
    this.priceHistory,
    this.insight,
    this.logo,
  });

  double get pnlPercent {
    return ((currentPrice - avgPrice) / avgPrice) * 100;
  }

  double get holdingValue => qty * currentPrice;

  factory Stock.fromHoldingJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] as String,
      companyName: json.containsKey('companyName')
          ? json['companyName'] as String
          : json['symbol'] as String,
      qty: (json['qty'] as num).toInt(),
      avgPrice: (json['avgPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      changes: json['changes'] != null
          ? Map<String, double>.from((json['changes'] as Map)
              .map((k, v) => MapEntry(k as String, (v as num).toDouble())))
          : null,
      priceHistory: json['priceHistory'] != null
          ? List<double>.from(
              (json['priceHistory'] as List).map((e) => (e as num).toDouble()))
          : null,
      insight: json['insight'] as String?,
    );
  }
}
