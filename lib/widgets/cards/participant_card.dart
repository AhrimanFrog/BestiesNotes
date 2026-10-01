import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/user_avatar.dart';
import 'package:besties_notes/widgets/buttons/delete_item_icon.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

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

  String get additionalInfo => switch (participant) {
    Student(:final group?) => group.name,
    Student(:final contact) => contact,
    _ => 'Group',
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppCard(
          onTap: onTap,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.xs,
            children: [
              UserAvatar(teachable: participant),
              const SizedBox(height: AppSpacing.xs),
              Text(
                participant.name,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                additionalInfo,
                textAlign: TextAlign.center,
                style: context.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              StatusBadge(
                label: participant.pricing.toString(),
                tone: StatusTone.accent,
              ),
            ],
          ),
        ),
        if (onDelete != null)
          Positioned(top: 0, right: 0, child: DeleteItemIcon(onDelete: onDelete)),
      ],
    );
  }
}
