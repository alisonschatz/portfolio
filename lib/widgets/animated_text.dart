// lib/widgets/animated_text.dart
import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration delay;
  final Duration speed;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.delay = Duration.zero,
    this.speed = const Duration(milliseconds: 50),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _text = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      _timer = Timer.periodic(widget.speed, (timer) {
        if (mounted) {
          setState(() {
            if (_text.length < widget.text.length) {
              _text = widget.text.substring(0, _text.length + 1);
            } else {
              _timer?.cancel();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: widget.style,
    );
  }
}