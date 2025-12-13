import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../widgets/price_chart.dart';
import 'package:intl/intl.dart';

class StockDetailScreen extends StatefulWidget {
  final Stock stock;
  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _changeColumn(String label, double? value) {
    final show = value != null;
    final txt = show ? '${value.toStringAsFixed(2)}%' : '—';
    final color = value != null && value >= 0 ? Colors.green : Colors.red;
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.8))),
        const SizedBox(height: 6),
        Text(txt,
            style: TextStyle(
                color: value == null
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : color,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.stock;
    final pnl = stock.pnlPercent;
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: Text(stock.symbol)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Hero(
              tag: 'symbol-${stock.symbol}',
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logos/${stock.symbol.toLowerCase()}.jpg',
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text(
                        stock.symbol[0],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(stock.companyName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(
                      '${stock.qty} shares · Avg ${formatter.format(stock.avgPrice)}'),
                ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(formatter.format(stock.currentPrice),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 6),
              Text('${pnl.toStringAsFixed(2)}%',
                  style: TextStyle(
                      color: pnl >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w700)),
            ]),
          ]),
          const SizedBox(height: 16),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _changeColumn('Day', stock.changes?['day']),
                    _changeColumn('Week', stock.changes?['week']),
                    _changeColumn('Month', stock.changes?['month']),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (stock.priceHistory != null) ...[
                      Text('Price history',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PriceChart(prices: stock.priceHistory!),
                        ),
                      ),
                    ],
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Text('AI Insight', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(stock.insight ?? 'No insight available.',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color)),
            ),
          ),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}
