import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CongratulationsWidget extends StatelessWidget {
  static const List<String> messages = [
    "🎉 You Won! 🎉",
    "🏆 Great Job! 🏆",
    "👏 Fantastic Work! 👏",
    "🎯 You Did It! 🎯"
  ];

  static String get randomMessage => messages[Random().nextInt(messages.length)];

  static final List<Widget Function(Widget, Duration)> animations = [
        (child, duration) => FadeIn(duration: duration, child: child),
        (child, duration) => BounceIn(duration: duration, child: child),
        (child, duration) => ZoomIn(duration: duration, child: child),
        (child, duration) => SlideInLeft(duration: duration, child: child),
        (child, duration) => FlipInX(duration: duration, child: child)
  ];

  static Widget Function(Widget, Duration) get randomAnimation =>
      animations[Random().nextInt(animations.length)];

  final String message;

  const CongratulationsWidget({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return randomAnimation(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              randomMessage,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
      const Duration(seconds: 1),
    );
  }
}
