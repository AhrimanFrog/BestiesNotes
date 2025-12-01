import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/widgets/initials_circle.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final Student student;

  const UserAvatar({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final initials = InitialsCircle(
      initials: student.initials,
      circleColor: AppColors.accentPink,
    );

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accentPink, width: 2),
      ),
      child: student.iconPath != null
          ? ClipOval(
              child: Image.network(
                student.iconPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => initials,
              ),
            )
          : initials,
    );
  }
}
