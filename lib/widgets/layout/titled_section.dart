import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class TitledSection extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.mainText,
          ),
        ),
        const SizedBox(height: 8),
        child
      ],
    );
  }
}
