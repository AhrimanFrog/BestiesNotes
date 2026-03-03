import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:flutter/material.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/widgets/index.dart';

class ParticipantCard extends StatelessWidget {
  final Teachable participant;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ParticipantCard({
    super.key,
    required this.participant,
    this.onTap,
    this.onDelete,
  });

  String get additionalInfo => (participant is Student)
      ? (participant as Student).group?.name ?? (participant as Student).contact
      : 'Group';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: .expand,
        children: [
          CardContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                // Avatar Section
                UserAvatar(teachable: participant),

                // Name Section
                Text(
                  participant.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  additionalInfo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Action / Status Pill
                StatusBadge(
                  label: participant.pricing.toString(),
                  accentColor: AppColors.accentPink,
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
