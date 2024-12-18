// lib/widgets/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
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
                // Find me in text
                const Text(
                  'find me in:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 20),
                // Social buttons
                _buildSocialButton(Icons.access_time),
                _buildSocialButton(Icons.facebook),
                const Spacer(),
                // Username and GitHub
                Row(
                  children: [
                    const Text(
                      '@alisonschatz',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildSocialButton(Icons.circle),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {},
        color: Colors.grey,
        hoverColor: Colors.tealAccent.withOpacity(0.1),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
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