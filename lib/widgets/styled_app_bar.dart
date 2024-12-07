// lib/widgets/styled_app_bar.dart
import 'package:flutter/material.dart';

class StyledAppBar extends StatelessWidget {
  const StyledAppBar({
    super.key,
    required this.currentPage,
    required this.onPageChange,
  });

  final String currentPage;
  final Function(String) onPageChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.tealAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Row(
              children: [
                const Text(
                  'alison-schatz',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                _buildNavButton('_hello', currentPage == '_hello', onPageChange),
                _buildNavButton('_about-me', currentPage == '_about-me', onPageChange),
                _buildNavButton('_projects', currentPage == '_projects', onPageChange),
                _buildNavButton('_contact-me', currentPage == '_contact-me', onPageChange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, bool isSelected, Function(String) onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.tealAccent : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: TextButton(
        onPressed: () => onTap(text),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: isSelected ? Colors.black12 : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent.withOpacity(0.05)
      ..strokeWidth = 1;

    // Vertical lines
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
      x += 20;
    }

    // Horizontal lines
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
      y += 20;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}