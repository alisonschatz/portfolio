// lib/pages/portfolio_page.dart
import 'package:flutter/material.dart';
import '../widgets/styled_app_bar.dart';
import '../widgets/footer.dart';
import 'sections/home_section.dart';
import 'sections/about_section.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String _currentPage = '_hello';
  final _pageController = PageController();

  void _navigateToPage(String page) {
    setState(() => _currentPage = page);
    switch (page) {
      case '_hello':
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        break;
      case '_about-me':
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StyledAppBar(
            currentPage: _currentPage,
            onPageChange: _navigateToPage,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeSection(),
                AboutSection(),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}