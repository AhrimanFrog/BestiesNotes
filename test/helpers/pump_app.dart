import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in the app theme so widgets can read `context.tokens`.
Widget themed(Widget child) => MaterialApp(
  theme: buildLightTheme(),
  home: Scaffold(body: child),
);

extension PumpThemed on WidgetTester {
  Future<void> pumpThemed(Widget child) => pumpWidget(themed(child));
}
