import 'package:flutter/material.dart';

/// Yeseva One carries the personality (screen titles, names, card titles);
/// Nunito keeps everything else soft and legible. Both cover Latin and
/// Cyrillic. Nunito is a variable font — `fontWeight` drives its weight axis,
/// so any weight works.
abstract final class AppFonts {
  static const display = 'YesevaOne';
  static const body = 'Nunito';
}

/// Role guide:
/// - headlineMedium — screen titles
/// - titleLarge — detail headers (a student's name)
/// - titleMedium — card titles, section headers
/// - titleSmall — emphasized body text, day headers
/// - bodyLarge / bodyMedium — copy
/// - bodySmall — secondary copy (muted)
/// - labelLarge — buttons
/// - labelMedium — metadata (times, counts; muted)
/// - labelSmall — badges
TextTheme buildTextTheme({required Color text, required Color muted}) {
  TextStyle display(double size, double height) => TextStyle(
    fontFamily: AppFonts.display,
    fontSize: size,
    height: height,
    color: text,
  );

  TextStyle body(
    double size,
    FontWeight weight, {
    Color? color,
    double height = 1.4,
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: AppFonts.body,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color ?? text,
  );

  return TextTheme(
    displaySmall: display(34, 1.15),
    headlineMedium: display(28, 1.2),
    headlineSmall: display(24, 1.2),
    titleLarge: display(22, 1.25),
    titleMedium: display(17, 1.3),
    titleSmall: body(15, FontWeight.w700, height: 1.3),
    bodyLarge: body(16, FontWeight.w400, height: 1.45),
    bodyMedium: body(14, FontWeight.w400),
    bodySmall: body(13, FontWeight.w400, color: muted),
    labelLarge: body(15, FontWeight.w700, height: 1.2, letterSpacing: 0.1),
    labelMedium: body(12, FontWeight.w600, color: muted, height: 1.3),
    labelSmall: body(11, FontWeight.w700, height: 1.2, letterSpacing: 0.3),
  );
}
