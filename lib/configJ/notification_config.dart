import 'dart:convert';

import 'package:bc_remates/config/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path/src/context.dart';


import '../model/notification.dart';


class LocalNotification1 {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const iosInitializationSetting = DarwinInitializationSettings();
    final InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: iosInitializationSetting,
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          print('onDidReceiveNotificationResponse Function');
          print(details.payload);
          print(details.payload != null);
        });
  }

  static void showNotification(RemoteMessage message) {
    NotificationPop notification = NotificationPop.fromJson(message.data);

    print(" dados da notificaçao ${message.data}");
    const iosNotificatonDetail = DarwinNotificationDetails();
    final NotificationDetails notiDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'com.bcremates.app.push_notification',
          'push_notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: iosNotificatonDetail
    );
    _notiPlugin.show(
      DateTime.now().microsecond,
      notification.title,
      notification.description,
      notiDetails,
      payload: message.data.toString(),
    );
  }
}