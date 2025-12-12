import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;

  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (int i = 0; i < prices.length; i++) FlSpot(i.toDouble(), prices[i])
    ];

    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);

    // Add padding so line does not touch the borders
    final range = maxY - minY;

    final List<double> ticks = _generateTicks(minY, maxY);

    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          minY: ticks.first,
          maxY: ticks.last,
          gridData: FlGridData(
            show: true,
            horizontalInterval:
                (ticks.length > 1) ? (ticks[1] - ticks[0]) : range / 3,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval:
                    (ticks.length > 1) ? (ticks[1] - ticks[0]) : range / 3,
                getTitlesWidget: (value, meta) {
                  if (!ticks.contains(value)) return const SizedBox.shrink();

                  return Text(
                    _formatAsK(value),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.20),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static List<double> _generateTicks(double minY, double maxY) {
    final roundedMin = ((minY / 100).floor() * 100).toDouble();
    final roundedMax = ((maxY / 100).ceil() * 100).toDouble();

    final ticks = <double>[];
    for (double v = roundedMin; v <= roundedMax; v += 100.0) {
      ticks.add(v);
    }

    return ticks;
  }

  /// Format like 1500 → "1.5K"
  static String _formatAsK(double value) {
    final num = value / 1000;
    return '${num.toStringAsFixed(1)}K';
  }
}
