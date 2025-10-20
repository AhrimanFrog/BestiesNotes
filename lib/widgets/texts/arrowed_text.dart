import 'package:flutter/material.dart';

class ArrowedText extends StatelessWidget {
  final String origin;
  final String destination;
  final Color _color;
  final double _fontSize;
  final FontWeight? _fontWeight;

  const ArrowedText({
    super.key,
    required this.origin,
    required this.destination,
    isMain = true,
  }) : _color = isMain ? Colors.black : Colors.grey,
       _fontSize = isMain ? 16 : 14,
       _fontWeight = isMain ? FontWeight.w500 : null;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Text(
          origin,
          style: TextStyle(
            fontSize: _fontSize,
            color: _color,
            fontWeight: _fontWeight,
          ),
        ),
        Icon(Icons.arrow_forward, size: _fontSize + 2, color: _color),
        Text(
          destination,
          style: TextStyle(
            fontSize: _fontSize,
            color: _color,
            fontWeight: _fontWeight,
          ),
        ),
      ],
    );
  }
}
