// lib/widgets/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'find me in:',
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {},
            color: Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () {},
            color: Colors.grey,
          ),
          const Spacer(),
          const Text(
            '@alisonschatz',
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
            icon: const Icon(Icons.circle),
            onPressed: () {},
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}