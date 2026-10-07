import 'package:flutter/material.dart';

/// 4-pt spacing scale. Use these for padding, gaps and `spacing:` values.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Horizontal inset of screen content.
  static const double screen = lg;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppShadows {
  /// Resting cards: a soft, warm lift rather than a hard drop shadow.
  static const card = [
    BoxShadow(color: Color(0x0F5A2A3A), blurRadius: 12, offset: Offset(0, 4)),
  ];

  /// Featured / floating elements.
  static const raised = [
    BoxShadow(color: Color(0x1A762741), blurRadius: 16, offset: Offset(0, 6)),
  ];
}

/// Minimum touch target, per Material and Apple HIG guidance.
const double kMinTapTarget = 48;
