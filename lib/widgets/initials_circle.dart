import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;

  const InitialsCircle({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: randomColor(), shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
