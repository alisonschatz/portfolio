// lib/app/portfolio_app.dart
import 'package:flutter/material.dart';
import '../pages/portfolio_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Developer Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF001524),
      ),
      home: const PortfolioPage(),
    );
  }
}