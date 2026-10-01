import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;
  final TonePair colors;
  final double size;

  const InitialsCircle({
    super.key,
    required this.initials,
    required this.colors,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.bg, shape: BoxShape.circle),
      child: Text(
        // Long names would overflow a small circle.
        initials.length > 2 ? initials.substring(0, 2) : initials,
        style: TextStyle(
          fontFamily: AppFonts.display,
          fontSize: size * 0.38,
          color: colors.fg,
        ),
      ),
    );
  }
}
