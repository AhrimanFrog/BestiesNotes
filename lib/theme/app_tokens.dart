import 'package:flutter/material.dart';

/// A foreground/background pair for badges, stripes and tinted surfaces.
/// Every pair keeps `fg` on `bg` at WCAG AA (≥ 4.5:1).
@immutable
class TonePair {
  final Color fg;
  final Color bg;

  const TonePair(this.fg, this.bg);

  static TonePair lerp(TonePair a, TonePair b, double t) =>
      TonePair(Color.lerp(a.fg, b.fg, t)!, Color.lerp(a.bg, b.bg, t)!);
}

enum StatusTone { scheduled, now, done, cancelled, warning, accent, neutral }

/// Semantic colors of the design system. Widgets read colors from here (via
/// `context.tokens`) instead of hard-coding them, so a dark palette later is
/// just a second instance of this class.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  /// Page background.
  final Color bg;

  /// Cards, sheets, inputs.
  final Color surface;

  /// Tinted fills: selected rows, avatar placeholders, chips.
  final Color surfaceMuted;

  final Color text;
  final Color textMuted;

  /// Placeholders and disabled text. Not for body copy (3.5:1).
  final Color textSubtle;

  final Color border;
  final Color divider;

  /// Interactive accent: filled buttons, links, focus. White text on it is AA.
  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  /// The brand's light pink: decorative only (stripes, illustrations), never
  /// behind text.
  final Color accentBright;

  final Color danger;

  /// Chart marks for paid and unpaid amounts. Checked for colour-blind
  /// separation; [chartUnpaid] is too light for text, so charts using it
  /// always show values in text as well.
  final Color chartPaid;
  final Color chartUnpaid;

  final Map<StatusTone, TonePair> tones;

  /// Distinct pastel pairs for coloring lessons by student or group.
  final List<TonePair> subjectPalette;

  const AppTokens({
    required this.bg,
    required this.surface,
    required this.surfaceMuted,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.border,
    required this.divider,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentBright,
    required this.danger,
    required this.chartPaid,
    required this.chartUnpaid,
    required this.tones,
    required this.subjectPalette,
  });

  static const light = AppTokens(
    bg: Color(0xFFFFF8F7),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFFCEEF1),
    text: Color(0xFF2B2530),
    textMuted: Color(0xFF6B6271),
    textSubtle: Color(0xFF8E8594),
    border: Color(0xFFEBD9DE),
    divider: Color(0xFFF2E4E8),
    accent: Color(0xFFC2416C),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0xFFFCE4EC),
    accentBright: Color(0xFFF291A3),
    danger: Color(0xFFB3261E),
    chartPaid: Color(0xFF2F7A3E),
    chartUnpaid: Color(0xFFE8A33D),
    tones: {
      StatusTone.scheduled: TonePair(Color(0xFF335E94), Color(0xFFE6EFFA)),
      StatusTone.now: TonePair(Color(0xFFB0365F), Color(0xFFFCE4EC)),
      StatusTone.done: TonePair(Color(0xFF2F7A3E), Color(0xFFE3F3E7)),
      StatusTone.cancelled: TonePair(Color(0xFF6B6271), Color(0xFFEFECF0)),
      StatusTone.warning: TonePair(Color(0xFF8F5300), Color(0xFFFFF0D9)),
      StatusTone.accent: TonePair(Color(0xFFB0365F), Color(0xFFFCE4EC)),
      StatusTone.neutral: TonePair(Color(0xFF6B6271), Color(0xFFF5F0F2)),
    },
    subjectPalette: [
      TonePair(Color(0xFFA33A5C), Color(0xFFFCE4EC)),
      TonePair(Color(0xFF335E94), Color(0xFFE6EFFA)),
      TonePair(Color(0xFF2F7A3E), Color(0xFFE3F3E7)),
      TonePair(Color(0xFF8F5300), Color(0xFFFFF0D9)),
      TonePair(Color(0xFF6A4A9C), Color(0xFFEFE8FA)),
      TonePair(Color(0xFF1F7272), Color(0xFFDFF3F1)),
      TonePair(Color(0xFF9C4A2E), Color(0xFFFBE9E2)),
      TonePair(Color(0xFF5B6B1F), Color(0xFFEEF3DC)),
    ],
  );

  TonePair tone(StatusTone tone) => tones[tone]!;

  /// Stable color for a student or group: the same id always gets the same
  /// pair. Unsaved entities (null id) use the accent.
  TonePair subjectColor(int? id) => id == null
      ? tone(StatusTone.accent)
      : subjectPalette[id % subjectPalette.length];

  @override
  AppTokens copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceMuted,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? border,
    Color? divider,
    Color? accent,
    Color? onAccent,
    Color? accentSoft,
    Color? accentBright,
    Color? danger,
    Color? chartPaid,
    Color? chartUnpaid,
    Map<StatusTone, TonePair>? tones,
    List<TonePair>? subjectPalette,
  }) {
    return AppTokens(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentBright: accentBright ?? this.accentBright,
      danger: danger ?? this.danger,
      chartPaid: chartPaid ?? this.chartPaid,
      chartUnpaid: chartUnpaid ?? this.chartUnpaid,
      tones: tones ?? this.tones,
      subjectPalette: subjectPalette ?? this.subjectPalette,
    );
  }

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppTokens(
      bg: c(bg, other.bg),
      surface: c(surface, other.surface),
      surfaceMuted: c(surfaceMuted, other.surfaceMuted),
      text: c(text, other.text),
      textMuted: c(textMuted, other.textMuted),
      textSubtle: c(textSubtle, other.textSubtle),
      border: c(border, other.border),
      divider: c(divider, other.divider),
      accent: c(accent, other.accent),
      onAccent: c(onAccent, other.onAccent),
      accentSoft: c(accentSoft, other.accentSoft),
      accentBright: c(accentBright, other.accentBright),
      danger: c(danger, other.danger),
      chartPaid: c(chartPaid, other.chartPaid),
      chartUnpaid: c(chartUnpaid, other.chartUnpaid),
      tones: {
        for (final tone in StatusTone.values)
          tone: TonePair.lerp(tones[tone]!, other.tones[tone]!, t),
      },
      subjectPalette: [
        for (var i = 0; i < subjectPalette.length; i++)
          TonePair.lerp(subjectPalette[i], other.subjectPalette[i], t),
      ],
    );
  }
}

extension AppThemeContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
