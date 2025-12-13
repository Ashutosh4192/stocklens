import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;

  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (int i = 0; i < prices.length; i++) FlSpot(i.toDouble(), prices[i]),
    ];

    final rawMin = prices.reduce((a, b) => a < b ? a : b);
    final rawMax = prices.reduce((a, b) => a > b ? a : b);

    final tickMin = (rawMin / 100).floor() * 100.0;
    final tickMax = (rawMax / 100).ceil() * 100.0;

    final ticks = <double>[
      tickMin,
      tickMin + (tickMax - tickMin) / 3,
      tickMin + 2 * (tickMax - tickMin) / 3,
      tickMax,
    ];

    final padding = (tickMax - tickMin) * 0.06;
    final minY = tickMin - padding;
    final maxY = tickMax + padding;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = Theme.of(context).colorScheme.primary;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,

          // ───────── Grid ─────────
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (tickMax - tickMin) / 3,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(isDark ? 0.08 : 0.12),
              strokeWidth: 1,
            ),
          ),

          // ───────── Axis labels ─────────
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: (tickMax - tickMin) / 3,
                getTitlesWidget: (value, _) {
                  if (!ticks.any((t) => (t - value).abs() < 0.5)) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    '${(value / 1000).toStringAsFixed(1)}K',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
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
              curveSmoothness: 0.35,
              barWidth: 3,
              color: lineColor,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    lineColor.withOpacity(isDark ? 0.25 : 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 450),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}
