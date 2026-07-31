import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;
  final Color circleColor;

  const InitialsCircle({
    super.key,
    required this.initials,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: circleColor.withValues(alpha: 0.2),
      child: Text(
        initials,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: circleColor.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
