import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/user_avatar.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

/// A student or group in the grid: avatar, name, a detail line and either
/// what they owe or their rate.
class ParticipantCard extends StatelessWidget {
  final Teachable participant;
  final VoidCallback? onTap;

  /// Overrides the default detail line (group name / contact).
  final String? subtitle;

  /// Shown instead of the rate when above zero.
  final double owed;

  const ParticipantCard({
    super.key,
    required this.participant,
    this.onTap,
    this.subtitle,
    this.owed = 0,
  });

  String get _subtitle =>
      subtitle ??
      switch (participant) {
        Student(:final group?) => group.name,
        Student(:final contact) => contact,
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
            _subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (owed > 0)
            StatusBadge(
              label: 'Owes ${formatAmount(owed)}',
              tone: StatusTone.warning,
              icon: Icons.payments_outlined,
            )
          else
            StatusBadge(
              label: participant.pricing.toString(),
              tone: StatusTone.accent,
            ),
        ],
      ),
    );
  }
}
