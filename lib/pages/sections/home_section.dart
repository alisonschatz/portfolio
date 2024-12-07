// lib/pages/sections/home_section.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/game/snake_game_widget.dart';
import '../../widgets/animated_text.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideIn = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 1200;

        return Stack(
          children: [
            // Background Blur Image
            Positioned.fill(
              child: Center(
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/img/bg_blur.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Content
            if (isWideScreen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildAnimatedIntroduction(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: SnakeGameWidget(),
                    ),
                  ],
                ),
              )
            else
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildAnimatedIntroduction(),
                      const SizedBox(height: 40),
                      const Center(child: SnakeGameWidget()),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedIntroduction() {
    return SlideTransition(
      position: _slideIn,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TypewriterText(
              text: 'Hi all. I am',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              delay: Duration(milliseconds: 500),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Colors.tealAccent],
              ).createShader(bounds),
              child: const TypewriterText(
                text: 'Alison Schatz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                delay: Duration(milliseconds: 1000),
                speed: Duration(milliseconds: 100),
              ),
            ),
            const TypewriterText(
              text: '> Front-end developer',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 32,
              ),
              delay: Duration(milliseconds: 2000),
            ),
            const SizedBox(height: 20),
            TypewriterText(
              text: '// complete the game to continue\n'
                  '// you can also see it on my Github page',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              delay: const Duration(milliseconds: 3000),
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://github.com/alisonschatz')),
              child: const TypewriterText(
                text: 'const githubLink = "https://github.com/alisonschatz"',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  // decoration: TextDecoration.underline,
                ),
                delay: Duration(milliseconds: 4000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}