// lib/widgets/nav_button.dart
import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const NavButton(this.text, this.isSelected, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            decoration: isSelected ? TextDecoration.underline : null,
            decorationColor: Colors.orange,
          ),
        ),
      ),
    );
  }
}