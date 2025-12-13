import 'package:flutter/material.dart';
import '../models/stock.dart';
import 'package:intl/intl.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  const StockTile({super.key, required this.stock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pnl = stock.pnlPercent;
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: Hero(
              tag: 'symbol-${stock.symbol}',
              child: SizedBox(
                width: 44,
                height: 44,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logos/${stock.symbol.toLowerCase()}.jpg',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text(
                        stock.symbol[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(stock.symbol,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(
                '${stock.qty} shares · Avg ${formatter.format(stock.avgPrice)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${stock.currentPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${pnl.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: pnl >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
