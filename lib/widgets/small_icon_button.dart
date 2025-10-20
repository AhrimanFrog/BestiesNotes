import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;

  const SmallIconButton({super.key, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onClick,
        icon: Icon(icon, size: 22),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }
}
