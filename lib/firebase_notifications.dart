import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> setupFirebaseNotifications() async {
  // 1. تهيئة Local Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 2. طلب الأذونات (لأندرويد 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _showNotification(flutterLocalNotificationsPlugin, message);
  });

  // 4. الحصول على توكن الجهاز
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("🔥FCM Token: $token"); // احفظ هذا التوكن لإرسال إشعارات مستهدفة
}

void _showNotification(
  FlutterLocalNotificationsPlugin plugin,
  RemoteMessage message,
) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'Important Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  plugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}
