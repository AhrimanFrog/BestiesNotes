import 'package:besties_notes/common/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final Color accentColor;
  final String label;

  const StatusBadge({
    super.key,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          fontWeight: FontWeight.w600,
          color: accentColor,
        ),
      ),
    );
  }
}
