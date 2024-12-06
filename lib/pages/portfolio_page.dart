// lib/pages/portfolio_page.dart
import 'package:flutter/material.dart';
import '../widgets/nav_button.dart';
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
          _buildNavBar(),
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

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Text(
            'alison-schatz',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          NavButton('_hello', _currentPage == '_hello',
              () => _navigateToPage('_hello')),
          NavButton('_about-me', _currentPage == '_about-me',
              () => _navigateToPage('_about-me')),
          NavButton('_projects', _currentPage == '_projects',
              () => _navigateToPage('_projects')),
          NavButton('_contact-me', _currentPage == '_contact-me',
              () => _navigateToPage('_contact-me')),
        ],
      ),
    );
  }
}