import 'package:flutter/material.dart';

/// Animated counter widget that transitions between numbers smoothly
class AnimatedCounter extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;
  final int decimalPlaces;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.prefix = '',
    this.suffix = '',
    this.decimalPlaces = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        String formattedValue;
        if (decimalPlaces > 0) {
          formattedValue = value.toStringAsFixed(decimalPlaces);
        } else {
          formattedValue = value.toInt().toString();
        }

        return Text(
          '$prefix$formattedValue$suffix',
          style: style,
        );
      },
    );
  }
}
