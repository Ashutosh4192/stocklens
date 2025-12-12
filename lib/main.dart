import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/portfolio_screen.dart';

void main() {
  runApp(const DiversifiApp());
}

class DiversifiApp extends StatelessWidget {
  const DiversifiApp({super.key});

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      appBarTheme: const AppBarTheme(elevation: 0),
      useMaterial3: true,
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.black,
      cardTheme: CardTheme(
          color: Colors.grey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      appBarTheme: const AppBarTheme(elevation: 0),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Diversifi - Mini Portfolio',
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            themeMode: themeProvider.mode,
            home: const PortfolioScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
