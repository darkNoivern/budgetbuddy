import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    // const AndroidInitializationSettings('flutter_logo');
    const AndroidInitializationSettings('lechonk');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails(String title, String body) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            'channelId',
            'channelName',
            styleInformation: BigTextStyleInformation(
              body,
              // 'This is a longer notification message that will be displayed using the "big text" style. You can include more information in this style of notification.',
              htmlFormatBigText: true,
              contentTitle: title,
              htmlFormatContentTitle: true,
              summaryText: 'Lechonk Reminder',
              htmlFormatSummaryText: true,
            ),
            largeIcon: DrawableResourceAndroidBitmap('lechonk'),
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails(title!, body!));
  }

  Future scheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(title!, body!),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}