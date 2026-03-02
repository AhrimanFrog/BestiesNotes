import 'dart:io' show File;

import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/widgets/initials_circle.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final Teachable teachable;

  const UserAvatar({super.key, required this.teachable});

  @override
  Widget build(BuildContext context) {
    final initials = InitialsCircle(
      initials: teachable.initials,
      circleColor: AppColors.accentPink,
    );

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accentPink, width: 2),
      ),
      child: teachable.iconPath != null
          ? ClipOval(
              child: Image.file(
                File(teachable.iconPath!),
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => initials,
              ),
            )
          : initials,
    );
  }
}
