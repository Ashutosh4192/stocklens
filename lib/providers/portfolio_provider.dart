import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/stock.dart';

class PortfolioProvider with ChangeNotifier {
  List<Stock> _holdings = [];
  Map<String, Stock> _details = {};

  bool _loading = true;
  bool get loading => _loading;

  List<Stock> get holdings => _holdings;

  double get invested => _holdings.fold(0.0, (s, h) => s + h.qty * h.avgPrice);
  double get currentValue =>
      _holdings.fold(0.0, (s, h) => s + h.qty * h.currentPrice);
  double get totalReturnPct =>
      invested == 0 ? 0.0 : ((currentValue - invested) / invested) * 100;

  double get oneDayReturnPct {
    double y = 0, c = 0;
    for (final h in _holdings) {
      final hist = h.priceHistory;
      if (hist != null && hist.length >= 2) {
        y += hist[hist.length - 2] * h.qty;
        c += h.currentPrice * h.qty;
      } else {
        y += h.currentPrice * h.qty;
        c += h.currentPrice * h.qty;
      }
    }
    return y == 0 ? 0.0 : ((c - y) / y) * 100;
  }

  Future<void> loadFromAssets() async {
    _loading = true;
    notifyListeners();
    final raw = await rootBundle.loadString('assets/data/mock_data.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final holdingsJson =
        (json['holdings'] as List).cast<Map<String, dynamic>>();
    _holdings = holdingsJson.map((h) => Stock.fromHoldingJson(h)).toList();

    final detailsJson = (json['details'] as Map<String, dynamic>);
    _details = detailsJson.map((key, value) =>
        MapEntry(key, Stock.fromHoldingJson(value as Map<String, dynamic>)));

    _loading = false;
    notifyListeners();
  }

  Stock? getDetail(String symbol) {
    return _details[symbol];
  }

  double get totalPortfolioValue {
    double sum = 0.0;
    for (final h in _holdings) {
      sum += h.holdingValue;
    }
    return sum;
  }
}
