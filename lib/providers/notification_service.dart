import 'package:besties_notes/data/reminder_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Shows the app's notifications. Everything is scheduled on the device;
/// there's no server.
abstract class NotificationService {
  /// [onOpen] receives the route of a tapped notification.
  Future<void> init({required void Function(String route) onOpen});

  /// The route of the notification that launched the app, if one did.
  Future<String?> launchRoute();

  Future<bool> isPermitted();

  /// Asks the system for permission; true when granted.
  Future<bool> requestPermission();

  /// Replaces everything scheduled with [reminders]. Channel names label the
  /// two kinds in Android's notification settings.
  Future<void> replaceAll(
    List<PlannedReminder> reminders, {
    required String lessonChannel,
    required String weeklyChannel,
  });
}

/// For tests and platforms without notifications.
class NoopNotificationService implements NotificationService {
  const NoopNotificationService();

  @override
  Future<void> init({required void Function(String route) onOpen}) async {}

  @override
  Future<String?> launchRoute() async => null;

  @override
  Future<bool> isPermitted() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders, {
    required String lessonChannel,
    required String weeklyChannel,
  }) async {}
}

class LocalNotificationService implements NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> init({required void Function(String route) onOpen}) async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (e) {
      // Unknown zone name: fall back to UTC offsets, still roughly right.
      debugPrint('Notifications: local time zone unavailable ($e)');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is asked for at a moment that explains it, not on start.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload case final route?) onOpen(route);
      },
    );
  }

  @override
  Future<String?> launchRoute() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return details?.notificationResponse?.payload;
  }

  @override
  Future<bool> isPermitted() async {
    if (_android case final android?) {
      return await android.areNotificationsEnabled() ?? false;
    }
    if (_ios case final ios?) {
      return (await ios.checkPermissions())?.isEnabled ?? false;
    }
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    if (_android case final android?) {
      return await android.requestNotificationsPermission() ?? false;
    }
    if (_ios case final ios?) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return false;
  }

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders, {
    required String lessonChannel,
    required String weeklyChannel,
  }) async {
    await _plugin.cancelAllPendingNotifications();
    for (final r in reminders) {
      final lesson = r.kind == ReminderKind.lesson;
      await _plugin.zonedSchedule(
        id: r.id,
        title: r.title,
        body: r.body,
        payload: r.route,
        scheduledDate: tz.TZDateTime.from(r.at, tz.local),
        // Inexact needs no special permission; Android may deliver it a
        // little late to save battery.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            lesson ? 'lessons' : 'weekly',
            lesson ? lessonChannel : weeklyChannel,
            importance: lesson ? Importance.high : Importance.defaultImportance,
            priority: lesson ? Priority.high : Priority.defaultPriority,
            styleInformation: BigTextStyleInformation(r.body),
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }
}
