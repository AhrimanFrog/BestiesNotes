import 'dart:io' show File;

import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/initials_circle.dart';
import 'package:flutter/material.dart';

/// A student's or group's photo, falling back to initials in the subject's
/// stable color.
class UserAvatar extends StatelessWidget {
  final Teachable teachable;
  final double size;

  const UserAvatar({super.key, required this.teachable, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final initials = InitialsCircle(
      initials: teachable.initials,
      colors: context.tokens.subjectColor(teachable.colorSeed),
      size: size,
    );

    if (teachable.iconPath == null) return initials;

    return ClipOval(
      child: Image.file(
        File(teachable.iconPath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => initials,
      ),
    );
  }
}
