import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: InputField(
            rateController,
            onChanged: onRateChanged,
            label: l10n.rate,
            hint: '420',
            // Currency-neutral until the currency setting exists.
            icon: const Icon(Icons.payments_outlined),
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            formatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.rateRequired;
              }
              final rate = Rate.tryParseAmount(value);
              if (rate == null || rate <= 0) {
                return l10n.rateInvalid;
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
            decoration: InputDecoration(labelText: l10n.ratePeriod),
            items: [
              DropdownMenuItem(
                value: RatePeriod.perLesson,
                child: Text(l10n.ratePeriodPerLesson),
              ),
              DropdownMenuItem(
                value: RatePeriod.monthly,
                child: Text(l10n.ratePeriodMonthly),
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
