import 'package:flutter/material.dart';

import 'app_metrics.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

export 'app_metrics.dart';
export 'app_tokens.dart';
export 'app_typography.dart';

ThemeData buildLightTheme() => _buildTheme(AppTokens.light, Brightness.light);

ThemeData _buildTheme(AppTokens t, Brightness brightness) {
  final textTheme = buildTextTheme(text: t.text, muted: t.textMuted);

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: t.accent,
    onPrimary: t.onAccent,
    primaryContainer: t.accentSoft,
    onPrimaryContainer: t.tone(StatusTone.accent).fg,
    secondary: t.tone(StatusTone.scheduled).fg,
    onSecondary: t.onAccent,
    secondaryContainer: t.tone(StatusTone.scheduled).bg,
    onSecondaryContainer: t.tone(StatusTone.scheduled).fg,
    tertiary: t.tone(StatusTone.done).fg,
    onTertiary: t.onAccent,
    tertiaryContainer: t.tone(StatusTone.done).bg,
    onTertiaryContainer: t.tone(StatusTone.done).fg,
    error: t.danger,
    onError: t.onAccent,
    surface: t.bg,
    onSurface: t.text,
    onSurfaceVariant: t.textMuted,
    surfaceContainerLowest: t.surface,
    surfaceContainerLow: t.surface,
    surfaceContainer: t.surface,
    surfaceContainerHigh: t.surfaceMuted,
    surfaceContainerHighest: t.surfaceMuted,
    outline: t.border,
    outlineVariant: t.divider,
    shadow: const Color(0xFF5A2A3A),
  );

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: AppRadius.lgAll,
        borderSide: BorderSide(color: color, width: width),
      );

  const buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.lg,
  );
  const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.lgAll);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: textTheme,
    fontFamily: AppFonts.body,
    scaffoldBackgroundColor: t.bg,
    canvasColor: t.bg,
    dividerColor: t.divider,
    extensions: [t],
    appBarTheme: AppBarThemeData(
      backgroundColor: t.bg,
      foregroundColor: t.text,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineSmall,
      iconTheme: IconThemeData(color: t.text),
    ),
    iconTheme: IconThemeData(color: t.textMuted, size: 22),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: t.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(color: t.textMuted),
      // Accent only while focused; a filled, idle field stays calm.
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) => textTheme.labelMedium!.copyWith(
          color: states.contains(WidgetState.error)
              ? t.danger
              : states.contains(WidgetState.focused)
              ? t.accent
              : t.textMuted,
        ),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: t.textSubtle),
      prefixIconColor: t.textMuted,
      suffixIconColor: t.textMuted,
      border: inputBorder(t.border),
      enabledBorder: inputBorder(t.border),
      focusedBorder: inputBorder(t.accent, 2),
      errorBorder: inputBorder(t.danger),
      focusedErrorBorder: inputBorder(t.danger, 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: t.accent,
        foregroundColor: t.onAccent,
        disabledBackgroundColor: t.surfaceMuted,
        disabledForegroundColor: t.textSubtle,
        minimumSize: const Size(64, kMinTapTarget + 4),
        padding: buttonPadding,
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: t.accent,
        side: BorderSide(color: t.border),
        minimumSize: const Size(64, kMinTapTarget + 4),
        padding: buttonPadding,
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: t.accent,
        minimumSize: const Size(48, kMinTapTarget),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: t.text,
        minimumSize: const Size.square(kMinTapTarget),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: t.accent,
      foregroundColor: t.onAccent,
      elevation: 2,
      highlightElevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      extendedTextStyle: textTheme.labelLarge,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: t.surface,
      selectedColor: t.accentSoft,
      checkmarkColor: t.accent,
      deleteIconColor: t.textMuted,
      labelStyle: textTheme.labelMedium?.copyWith(color: t.text),
      side: BorderSide(color: t.border),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: t.surface,
        foregroundColor: t.textMuted,
        selectedBackgroundColor: t.accentSoft,
        selectedForegroundColor: t.tone(StatusTone.accent).fg,
        side: BorderSide(color: t.border),
        textStyle: textTheme.labelMedium,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      side: BorderSide(color: t.border, width: 1.5),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: t.accent,
      unselectedLabelColor: t.textMuted,
      indicatorColor: t.accent,
      dividerColor: t.divider,
      labelStyle: textTheme.labelLarge,
      unselectedLabelStyle: textTheme.labelLarge,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: t.accentSoft,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelMedium?.copyWith(
          color: states.contains(WidgetState.selected)
              ? t.tone(StatusTone.accent).fg
              : t.textMuted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? t.tone(StatusTone.accent).fg
              : t.textMuted,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: t.bg,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: t.border,
      // Sheets host Scaffolds; clip them to the rounded top.
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: t.text,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: t.surface),
      actionTextColor: t.accentBright,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    dividerTheme: DividerThemeData(color: t.divider, thickness: 1, space: 1),
    listTileTheme: ListTileThemeData(
      iconColor: t.textMuted,
      titleTextStyle: textTheme.bodyLarge,
      subtitleTextStyle: textTheme.bodySmall,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: t.accent),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: t.surface,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: t.accentSoft,
      headerForegroundColor: t.text,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: t.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
    ),
  );
}
