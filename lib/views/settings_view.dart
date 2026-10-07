import 'dart:io';

import 'package:besties_notes/cubits/settings/settings_cubit.dart';
import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/backup_service.dart';
import 'package:besties_notes/providers/notification_service.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/dialogs/choice_sheet.dart';
import 'package:besties_notes/widgets/dialogs/text_input_dialog.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Looked up once; without a platform answer the version is just left out.
final Future<PackageInfo?> _packageInfo = PackageInfo.fromPlatform()
    .then<PackageInfo?>((info) => info, onError: (Object _) => null);

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.xxxl,
        ),
        children: [
          _Group(
            title: l10n.settingsProfile,
            tiles: [
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: Text(l10n.settingsTeacherName),
                subtitle: Text(_orNotSet(settings.teacherName, l10n)),
                onTap: () async {
                  final name = await showTextInputDialog(
                    context,
                    title: l10n.settingsTeacherName,
                    initialValue: settings.teacherName,
                  );
                  if (name != null) {
                    await cubit.update((s) => s.copyWith(teacherName: name));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(l10n.settingsTeacherContact),
                subtitle: Text(_orNotSet(settings.teacherContact, l10n)),
                onTap: () async {
                  final contact = await showTextInputDialog(
                    context,
                    title: l10n.settingsTeacherContact,
                    initialValue: settings.teacherContact,
                  );
                  if (contact != null) {
                    await cubit.update(
                      (s) => s.copyWith(teacherContact: contact),
                    );
                  }
                },
              ),
            ],
          ),
          _Group(
            title: l10n.settingsLessons,
            tiles: [
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(l10n.settingsDefaultLength),
                subtitle: Text(
                  l10n.durationMinutes(settings.defaultLessonMinutes),
                ),
                onTap: () async {
                  final picked = await showChoiceSheet<int>(
                    context,
                    title: l10n.settingsDefaultLength,
                    selected: settings.defaultLessonMinutes,
                    options: [
                      for (final m in AppSettings.lessonLengths)
                        (m, l10n.durationMinutes(m)),
                    ],
                  );
                  if (picked != null) {
                    await cubit.update(
                      (s) => s.copyWith(defaultLessonMinutes: picked.$1),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range_outlined),
                title: Text(l10n.settingsWeekStart),
                subtitle: Text(_weekdayLabel(settings.weekStart, l10n)),
                onTap: () async {
                  final picked = await showChoiceSheet<int>(
                    context,
                    title: l10n.settingsWeekStart,
                    selected: settings.weekStart,
                    options: [
                      for (final d in [DateTime.monday, DateTime.sunday])
                        (d, _weekdayLabel(d, l10n)),
                    ],
                  );
                  if (picked != null) {
                    await cubit.update((s) => s.copyWith(weekStart: picked.$1));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.settingsColorLessons),
                subtitle: Text(_coloringLabel(settings.lessonColoring, l10n)),
                onTap: () async {
                  final picked = await showChoiceSheet<LessonColoring>(
                    context,
                    title: l10n.settingsColorLessons,
                    selected: settings.lessonColoring,
                    options: [
                      for (final c in LessonColoring.values)
                        (c, _coloringLabel(c, l10n)),
                    ],
                  );
                  if (picked != null) {
                    await cubit.update(
                      (s) => s.copyWith(lessonColoring: picked.$1),
                    );
                  }
                },
              ),
            ],
          ),
          const _NotificationsGroup(),
          _Group(
            title: l10n.settingsRegional,
            tiles: [
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: Text(l10n.settingsLanguage),
                subtitle: Text(_languageLabel(settings.languageCode, l10n)),
                onTap: () async {
                  final picked = await showChoiceSheet<String?>(
                    context,
                    title: l10n.settingsLanguage,
                    selected: settings.languageCode,
                    options: [
                      for (final code in [null, ...AppSettings.languages])
                        (code, _languageLabel(code, l10n)),
                    ],
                  );
                  if (picked != null) {
                    await cubit.update(
                      (s) => s.copyWith(languageCode: () => picked.$1),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: Text(l10n.settingsCurrency),
                subtitle: Text(_currencyLabel(settings.currency, l10n)),
                onTap: () async {
                  final picked = await showChoiceSheet<String?>(
                    context,
                    title: l10n.settingsCurrency,
                    selected: settings.currency,
                    options: [
                      for (final code in [null, ...AppSettings.currencies])
                        (code, _currencyLabel(code, l10n)),
                    ],
                  );
                  if (picked != null) {
                    await cubit.update(
                      (s) => s.copyWith(currency: () => picked.$1),
                    );
                  }
                },
              ),
            ],
          ),
          _Group(
            title: l10n.settingsData,
            tiles: [
              ListTile(
                leading: const Icon(Icons.ios_share_rounded),
                title: Text(l10n.settingsExport),
                subtitle: Text(l10n.settingsExportHint),
                onTap: () => _export(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings_backup_restore_rounded),
                title: Text(l10n.settingsImport),
                subtitle: Text(l10n.settingsImportHint),
                onTap: () => _import(context),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: context.tokens.danger,
                ),
                title: Text(
                  l10n.settingsClear,
                  style: TextStyle(color: context.tokens.danger),
                ),
                subtitle: Text(l10n.settingsClearHint),
                onTap: () => _clear(context),
              ),
            ],
          ),
          _Group(
            title: l10n.settingsAbout,
            tiles: [
              FutureBuilder<PackageInfo?>(
                future: _packageInfo,
                builder: (context, snapshot) {
                  final version = snapshot.data?.version;
                  return ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: Text(l10n.appTitle),
                    subtitle: version != null
                        ? Text(l10n.settingsVersion(version))
                        : null,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel_rounded),
                title: Text(l10n.settingsLicenses),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appTitle,
                  applicationLegalese:
                      '© 2025–2026 AhrimanFrog · Apache License 2.0',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------

  Future<void> _export(BuildContext context) async {
    final l10n = context.l10n;
    final session = context.read<AppSession>();
    try {
      final file = await BackupService.create(
        session.db,
        await getTemporaryDirectory(),
      );
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l10n.backupShareSubject,
        ),
      );
    } catch (_) {
      if (context.mounted) showErrorSnackBar(context, l10n.backupFailed);
    }
  }

  Future<void> _import(BuildContext context) async {
    final l10n = context.l10n;
    final session = context.read<AppSession>();

    final picked = await FilePicker.pickFiles(type: FileType.any);
    if (picked.isEmpty) return;

    // The pick may be a content URI with no path: work on a local copy.
    final candidate = File(
      p.join((await getTemporaryDirectory()).path, 'restore-candidate.sqlite'),
    );
    await candidate.writeAsBytes(await picked.single.readAsBytes());

    final BackupSummary summary;
    try {
      summary = BackupService.inspect(
        candidate,
        currentVersion: session.db.schemaVersion,
      );
    } on BackupException catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e.problem == BackupProblem.tooNew
              ? l10n.restoreTooNew
              : l10n.restoreNotABackup,
        );
      }
      return;
    }
    if (!context.mounted) return;

    final confirmed = await showConfirmDialog(
      context,
      title: l10n.restoreConfirmTitle,
      message: l10n.restoreConfirmMessage(
        l10n.studentCount(summary.students),
        l10n.lessonCount(summary.lessons),
      ),
      confirmLabel: l10n.restoreAction,
      destructive: true,
    );
    if (!confirmed) return;

    try {
      // Rebuilds the whole app on the restored data and opens the schedule.
      await session.restore(candidate);
    } catch (_) {
      if (context.mounted) showErrorSnackBar(context, l10n.restoreFailed);
    }
  }

  Future<void> _clear(BuildContext context) async {
    final l10n = context.l10n;
    final session = context.read<AppSession>();

    // Two steps: this is the one action in the app with no way back.
    final first = await showConfirmDialog(
      context,
      title: l10n.clearConfirmTitle,
      message: l10n.clearConfirmMessage,
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (!first || !context.mounted) return;
    final second = await showConfirmDialog(
      context,
      title: l10n.clearSecondTitle,
      message: l10n.clearSecondMessage,
      confirmLabel: l10n.clearAction,
      destructive: true,
    );
    if (!second) return;

    await session.db.clearAllRecords();
    await session.reload();
  }

  // ---------------------------------------------------------------------------
  // Labels
  // ---------------------------------------------------------------------------

  static String _orNotSet(String value, AppLocalizations l10n) =>
      value.isEmpty ? l10n.settingsNotSet : value;

  static String _weekdayLabel(int day, AppLocalizations l10n) =>
      day == DateTime.sunday ? l10n.settingsSunday : l10n.settingsMonday;

  static String _coloringLabel(LessonColoring c, AppLocalizations l10n) =>
      switch (c) {
        LessonColoring.status => l10n.settingsColorByStatus,
        LessonColoring.subject => l10n.settingsColorByStudent,
      };

  /// Language names are written in their own language, so they're findable
  /// whatever the current one is.
  static String _languageLabel(String? code, AppLocalizations l10n) =>
      switch (code) {
        'en' => 'English',
        'uk' => 'Українська',
        _ => l10n.settingsLanguageSystem,
      };

  static String _currencyLabel(String? code, AppLocalizations l10n) {
    if (code == null) return l10n.settingsCurrencyNone;
    final symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
    return '$code ($symbol)';
  }
}

/// Reminder settings, plus a prompt when the system blocks notifications.
class _NotificationsGroup extends StatefulWidget {
  const _NotificationsGroup();

  @override
  State<_NotificationsGroup> createState() => _NotificationsGroupState();
}

class _NotificationsGroupState extends State<_NotificationsGroup> {
  bool? _permitted;
  late final AppLifecycleListener _lifecycle;

  NotificationService get _service => context.read<NotificationService>();

  @override
  void initState() {
    super.initState();
    _check();
    // Coming back from the system settings may have changed it.
    _lifecycle = AppLifecycleListener(onResume: _check);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final permitted = await _service.isPermitted();
    if (mounted) setState(() => _permitted = permitted);
  }

  Future<void> _request() async {
    final permitted = await _service.requestPermission();
    if (mounted) setState(() => _permitted = permitted);
  }

  /// Applies [change]; turning something on asks for permission if needed.
  Future<void> _update(
    AppSettings Function(AppSettings s) change, {
    required bool turnsOn,
  }) async {
    await context.read<SettingsCubit>().update(change);
    if (turnsOn && _permitted == false) await _request();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsCubit>().state;
    final anyOn =
        settings.lessonReminderMinutes > 0 ||
        settings.debtDigest ||
        settings.bookingReminder;

    String reminderLabel(int minutes) => switch (minutes) {
      0 => l10n.settingsReminderOff,
      Duration.minutesPerDay => l10n.settingsReminderDay,
      _ => l10n.settingsReminderMinutes(minutes),
    };

    return _Group(
      title: l10n.settingsNotifications,
      tiles: [
        if (anyOn && _permitted == false)
          ListTile(
            leading: Icon(
              Icons.notifications_off_outlined,
              color: context.tokens.tone(StatusTone.warning).fg,
            ),
            title: Text(l10n.settingsNotificationsBlocked),
            trailing: TextButton(
              onPressed: _request,
              child: Text(l10n.settingsNotificationsAllow),
            ),
          ),
        ListTile(
          leading: const Icon(Icons.alarm_outlined),
          title: Text(l10n.settingsLessonReminder),
          subtitle: Text(reminderLabel(settings.lessonReminderMinutes)),
          onTap: () async {
            final picked = await showChoiceSheet<int>(
              context,
              title: l10n.settingsLessonReminder,
              selected: settings.lessonReminderMinutes,
              options: [
                for (final m in AppSettings.reminderOptions)
                  (m, reminderLabel(m)),
              ],
            );
            if (picked != null) {
              await _update(
                (s) => s.copyWith(lessonReminderMinutes: picked.$1),
                turnsOn: picked.$1 > 0,
              );
            }
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.account_balance_wallet_outlined),
          title: Text(l10n.settingsDebtDigest),
          subtitle: Text(l10n.settingsDebtDigestHint),
          value: settings.debtDigest,
          onChanged: (on) =>
              _update((s) => s.copyWith(debtDigest: on), turnsOn: on),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.event_busy_outlined),
          title: Text(l10n.settingsBookingReminder),
          subtitle: Text(l10n.settingsBookingReminderHint),
          value: settings.bookingReminder,
          onChanged: (on) =>
              _update((s) => s.copyWith(bookingReminder: on), turnsOn: on),
        ),
      ],
    );
  }
}

/// A titled card of settings rows.
class _Group extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const _Group({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Section(
        title: title,
        child: AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(children: tiles),
        ),
      ),
    );
  }
}
