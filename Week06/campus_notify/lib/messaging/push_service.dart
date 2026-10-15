// lib/messaging/push_service.dart

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _local = FlutterLocalNotificationsPlugin();
String? pendingDeepLink;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handler background
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission();
  return settings.authorizationStatus == AuthorizationStatus.authorized;
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  
  await _local.initialize(
    // Hapus 'initializationSettings:'
    const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (response) {
      pendingDeepLink = response.payload;
    },
  );
}

void listenForeground(void Function(String route) go) {
  FirebaseMessaging.onMessage.listen((message) async {
    final route = message.data['route'] ?? '/';
    const androidDetails = AndroidNotificationDetails(
      'kampus_channel', 'Pengumuman',
      importance: Importance.high, priority: Priority.high,
    );
    
    await _local.show(
      // TAMBAHKAN NAMA PARAMETER id, title, body, dan notificationDetails:
      id: message.hashCode,
      title: message.notification?.title ?? 'Info',
      body: message.notification?.body ?? '',
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: route,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    go(message.data['route'] ?? '/');
  });
}

Future<void> handleTerminated(void Function(String route) go) async {
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  if (initial != null) go(initial.data['route'] ?? '/');
  if (pendingDeepLink != null) {
    go(pendingDeepLink!);
    pendingDeepLink = null;
  }
}