import 'package:flutter/material.dart';
import 'package:besties_notes/widgets/index.dart' show SmallIconButton;

class ModalHeaderRow extends StatelessWidget {
  final String title;
  final IconData icon;

  const ModalHeaderRow({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 28),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SmallIconButton(
          icon: Icons.close,
          onClick: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
