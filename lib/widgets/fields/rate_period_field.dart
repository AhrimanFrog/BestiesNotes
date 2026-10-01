import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/fields/input_field.dart';

class RatePeriodField extends StatelessWidget {
  final TextEditingController rateController;
  final RatePeriod selectedPeriod;
  final ValueChanged<RatePeriod> onPeriodChanged;
  final ValueChanged<String>? onRateChanged;

  const RatePeriodField({
    super.key,
    required this.rateController,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: InputField(
            rateController,
            onChanged: onRateChanged,
            label: 'Rate',
            hint: '420',
            icon: const Icon(Icons.attach_money),
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            formatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a rate';
              }
              final rate = Rate.tryParseAmount(value);
              if (rate == null || rate <= 0) {
                return 'Please enter a valid rate';
              }
              return null;
            },
          ),
        ),
        Flexible(
          child: DropdownButtonFormField<RatePeriod>(
            initialValue: selectedPeriod,
            // Fit the slot (ellipsizing) instead of overflowing it.
            isExpanded: true,
            // Dropdowns default to titleMedium, the display font here.
            style: context.textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Period'),
            items: const [
              DropdownMenuItem(
                value: RatePeriod.perLesson,
                child: Text('Per lesson'),
              ),
              DropdownMenuItem(
                value: RatePeriod.monthly,
                child: Text('Monthly'),
              ),
            ],
            onChanged: (val) {
              if (val != null) onPeriodChanged(val);
            },
          ),
        ),
      ],
    );
  }
}
