import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/user_avatar.dart';
import 'package:flutter/material.dart';

/// Up to [max] overlapping avatars, then "+n".
class AvatarStack extends StatelessWidget {
  final List<Teachable> subjects;
  final double size;
  final int max;

  const AvatarStack({
    super.key,
    required this.subjects,
    this.size = 24,
    this.max = 3,
  });

  @override
  Widget build(BuildContext context) {
    final shown = subjects.take(max).toList();
    final extra = subjects.length - shown.length;
    final step = size * 0.65;
    final ring = context.tokens.surface;

    return SizedBox(
      height: size,
      width: size + step * (shown.length - 1) + (extra > 0 ? step + 4 : 0),
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: step * i,
              child: DecoratedBox(
                // A ring in the card color separates overlapping avatars.
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ring, width: 1.5),
                ),
                child: UserAvatar(teachable: shown[i], size: size),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: step * shown.length + 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text('+$extra', style: context.textTheme.labelMedium),
              ),
            ),
        ],
      ),
    );
  }
}
