import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget? child;

  const CardContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // clean card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softPink, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPink.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
