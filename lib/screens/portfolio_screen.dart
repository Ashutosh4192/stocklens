import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklens/widgets/portfolio_summary_card.dart';
import '../providers/portfolio_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/stock_tile.dart';
import 'stock_detail_screen.dart';
import '../models/stock.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final List<bool> _visible = [];
  bool _maskValues = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PortfolioProvider>(context, listen: false);
      provider.loadFromAssets().then((_) => _runStagger());
    });
  }

  void _runStagger() {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final count = provider.holdings.length;
    if (_visible.length < count) {
      _visible.addAll(List<bool>.filled(count - _visible.length, false));
    }
    for (int i = 0; i < count; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
        if (!mounted) return;
        setState(() {
          _visible[i] = true;
        });
      });
    }
  }

  void _navigateToDetail(BuildContext context, Stock detail) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StockDetailScreen(stock: detail),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
              scale: Tween<double>(begin: 0.99, end: 1).animate(animation),
              child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Stock',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              TextSpan(
                text: 'Lens',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(builder: (context, t, __) {
            return IconButton(
              tooltip: t.isDark ? 'Switch to light' : 'Switch to dark',
              onPressed: () => t.toggle(),
              icon: Icon(t.isDark
                  ? Icons.wb_sunny_outlined
                  : Icons.nights_stay_outlined),
            );
          }),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (_, provider, __) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_visible.length != provider.holdings.length) {
            _visible.clear();
            _visible.addAll(List<bool>.filled(provider.holdings.length, false));
            WidgetsBinding.instance.addPostFrameCallback((_) => _runStagger());
          }

          return RefreshIndicator(
            onRefresh: provider.loadFromAssets,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                    height: 5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Consumer<PortfolioProvider>(
                      builder: (context, provider, _) {
                        return PortfolioSummaryCard(
                          holdings: provider.holdings,
                          maskValues: _maskValues,
                          onToggleMask: () {
                            setState(() {
                              _maskValues = !_maskValues;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final stock = provider.holdings[index];
                    final detail = provider.getDetail(stock.symbol) ?? stock;
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: _visible[index] ? 1.0 : 0.0,
                      curve: Curves.easeOut,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 400),
                        offset: _visible[index]
                            ? Offset.zero
                            : const Offset(0, 0.04),
                        child: StockTile(
                          stock: stock,
                          onTap: () => _navigateToDetail(context, detail),
                        ),
                      ),
                    );
                  }, childCount: provider.holdings.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}
