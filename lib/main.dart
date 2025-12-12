import 'package:flutter/material.dart';

void main() {
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diversifi - Mini Portfolio',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Text("Home"),
    );
  }
}
