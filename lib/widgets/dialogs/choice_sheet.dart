import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Lets the user pick one of [options] (value, label).
///
/// Resolves to `(value,)` — a record, so picking an option whose value is
/// null ("No symbol", "System default") is distinguishable from dismissing
/// the sheet, which resolves to null.
Future<(T,)?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<(T, String)> options,
  required T selected,
}) {
  return showModalBottomSheet<(T,)>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                0,
                AppSpacing.xxl,
                AppSpacing.sm,
              ),
              child: Text(title, style: context.textTheme.headlineSmall),
            ),
            RadioGroup<T>(
              groupValue: selected,
              onChanged: (value) => Navigator.pop(context, (value as T,)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (value, label) in options)
                    RadioListTile<T>(value: value, title: Text(label)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
