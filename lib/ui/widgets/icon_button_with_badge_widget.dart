import 'package:flutter/material.dart';

class IconButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onPressed;
  final Color color;
  final int? countdownSeconds;

  const IconButtonWithBadge({
    super.key,
    required this.icon,
    required this.count,
    required this.onPressed,
    required this.color,
    this.countdownSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The actual clickable IconButton
        IconButton(
          icon: Icon(icon, size: 36, color: color),
          onPressed: onPressed,
          padding: const EdgeInsets.all(8),
        ),

        // Top-right badge for count (non-interactive)
        Positioned(
          right: 2,
          top: 2,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 20),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        // Optional countdown overlay (also non-interactive)
        if (countdownSeconds != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(76),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: TweenAnimationBuilder<int>(
                  tween: IntTween(begin: countdownSeconds!, end: 0),
                  duration: Duration(seconds: countdownSeconds!),
                  builder: (context, value, _) => Text(
                    "$value",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
