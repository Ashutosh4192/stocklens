import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final List<Stock> holdings;
  final bool maskValues; // true = hidden (eye closed)
  final VoidCallback onToggleMask;

  const PortfolioSummaryCard({
    super.key,
    required this.holdings,
    required this.maskValues,
    required this.onToggleMask,
  });

  double getInvested() {
    double sum = 0;
    for (final h in holdings) {
      sum += h.qty * h.avgPrice;
    }
    return sum;
  }

  double getCurrentValue() {
    double sum = 0;
    for (final h in holdings) {
      sum += h.qty * h.currentPrice;
    }
    return sum;
  }

  double getTotalReturnPct() {
    final invested = getInvested();
    if (invested == 0) return 0;
    final current = getCurrentValue();
    return ((current - invested) / invested) * 100;
  }

  double getOneDayReturnPct() {
    double investedYesterday = 0;
    double currentInvested = 0;
    for (final h in holdings) {
      final hist = h.priceHistory;
      if (hist != null && hist.length >= 2) {
        investedYesterday += hist[hist.length - 2] * h.qty;
        currentInvested += h.currentPrice * h.qty;
      } else {
        investedYesterday += h.currentPrice * h.qty;
        currentInvested += h.currentPrice * h.qty;
      }
    }
    if (investedYesterday == 0) return 0;
    return ((currentInvested - investedYesterday) / investedYesterday) * 100;
  }

  String _fmtCurrency(double value) {
    final f = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    return f.format(value);
  }

  String _fmtPct(double v) => '${v >= 0 ? '+' : ''}${v.toStringAsFixed(2)}%';

  Widget _rightValueCurrency(BuildContext context, String main,
      {String? trailingPct, Color? pctColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(main,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        if (trailingPct != null) const SizedBox(height: 6),
        if (trailingPct != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: pctColor?.withOpacity(0.16) ?? Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(trailingPct,
                style: TextStyle(
                    color: pctColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
      ],
    );
  }

  Widget _rightValuePctOnly(BuildContext context, String pct, Color pctColor) {
    // used when masked: shows only the percent pill (no currency)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: pctColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(pct,
          style: TextStyle(
              color: pctColor, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invested = getInvested();
    final current = getCurrentValue();
    final totalPct = getTotalReturnPct();
    final oneDayPct = getOneDayReturnPct();

    final positiveColor = Colors.greenAccent.shade400;
    final negativeColor = Colors.redAccent;

    final investedText = maskValues ? '••••••' : _fmtCurrency(invested);
    final totalAbsText =
        maskValues ? '••••••' : _fmtCurrency(current - invested);
    final totalPctText = _fmtPct(totalPct);
    final oneDayText = _fmtPct(oneDayPct);

    final totalPctColor = totalPct >= 0 ? positiveColor : negativeColor;
    final dayPctColor = oneDayPct >= 0 ? positiveColor : negativeColor;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // Top row: title + eye + other icons
            Row(
              children: [
                Expanded(
                  child: Text('HOLDINGS (${holdings.length})',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.9))),
                ),
                // Eye button
                IconButton(
                  onPressed: onToggleMask,
                  icon: Icon(
                      maskValues ? Icons.visibility_off : Icons.visibility),
                  tooltip: maskValues ? 'Show values' : 'Hide values',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.show_chart_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),

            const Divider(height: 16, thickness: 1),

            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                children: [
                  // 1D returns row
                  Row(
                    children: [
                      Expanded(
                          child: Text('1D returns',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color))),
                      // If masked => shows only pct. If unmasked => shows currency + pct
                      if (maskValues)
                        _rightValuePctOnly(context, oneDayText, dayPctColor)
                      else
                        _rightValueCurrency(
                            context, _fmtCurrency(current - invested),
                            trailingPct: oneDayText, pctColor: dayPctColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Total returns row
                  Row(
                    children: [
                      Expanded(
                          child: Text('Total returns',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color))),
                      if (maskValues)
                        _rightValuePctOnly(context, totalPctText, totalPctColor)
                      else
                        _rightValueCurrency(context, totalAbsText,
                            trailingPct: totalPctText, pctColor: totalPctColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Invested row
                  Row(
                    children: [
                      Expanded(
                          child: Text('Invested',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color))),
                      Text(investedText,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
