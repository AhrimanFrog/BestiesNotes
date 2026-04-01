import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/widgets/fields/input_field.dart';

class RatePeriodField extends StatelessWidget {
  final TextEditingController rateController;
  final RatePeriod selectedPeriod;
  final ValueChanged<RatePeriod> onPeriodChanged;

  const RatePeriodField({
    super.key,
    required this.rateController,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InputField(
            rateController,
            label: 'Rate',
            hint: '420',
            icon: const Icon(Icons.attach_money),
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            formatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a rate';
              }
              final rate = double.tryParse(value);
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
            decoration: const InputDecoration(
              labelText: 'Period',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: RatePeriod.daily, child: Text('Daily')),
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
