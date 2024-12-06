// lib/pages/sections/home_section.dart
import 'package:flutter/material.dart';
import '../../widgets/game/snake_game_widget.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 100),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: _buildIntroduction(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.teal.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const SnakeGameWidget(),
          ),
        ),
        const SizedBox(width: 100),
      ],
    );
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Hi all. I am',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const Text(
          'Alison Schatz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '> Front-end developer',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '// complete the game to continue\n'
          '// you can also see it on my Github page',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const Text(
          'const githubLink = "https://github.com/alisonschatz"',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}