import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  late FlutterLocalNotificationsPlugin plugin;

  NotificationService._internal() {
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());
    plugin = FlutterLocalNotificationsPlugin();
    plugin.initialize(initializationSettings);
  }

  Future<void> newNotification(String title, String msg, bool vibration) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    String channelName = '消息提示';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelName, channelName,
            importance: Importance.max,
            priority: Priority.high,
            vibrationPattern: vibration ? vibrationPattern : null,
            enableVibration: vibration);
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await plugin.show(0, title, msg, notificationDetails);
  }
}
