import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class PersonRow<T extends Teachable> extends StatelessWidget {
  final T subject;

  const PersonRow({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InitialsCircle(
          initials: subject.initials,
          circleColor: Colors.grey.withAlpha(20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentPink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Details',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
