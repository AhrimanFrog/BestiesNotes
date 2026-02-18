import 'package:flutter/material.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/widgets/index.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: .expand,
        children: [
          Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                // Avatar Section
                UserAvatar(teachable: student),

                // Name Section
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Subtitle (Location/Price/Group)
                Text(
                  student.group?.name ?? student.contact,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Action / Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softWarmPink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${student.pricing.rate} / ${student.pricing.period.name}",
                    style: const TextStyle(
                      color: AppColors.accentPink,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: DeleteItemIcon(onDelete: onDelete),
          ),
        ],
      ),
    );
  }
}
