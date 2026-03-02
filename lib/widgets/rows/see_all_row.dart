import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class SeeAllRow extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const SeeAllRow({super.key, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 2,
          children: [
            Text(
              'See all $count lessons',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.accentPink,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.accentPink,
            ),
          ],
        ),
      ),
    );
  }
}
