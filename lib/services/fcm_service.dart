/*  Isolates all Firebase Cloud Messaging logic. It handles generating the device token, 
    listening for foreground messages, and processing background notifications. 
    NOTE: This class will handle three critical things: asking the user for permission 
    to show notifications, generating a unique device token (which you need to send test 
    messages), and listening for incoming alerts.
    Important Note for Firebase: Background messages require a special "top-level" function 
    that lives outside of any class so it can run even when the app is terminated. */

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// ⚡ 1. Top-Level Background Handler (Must be outside the class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

// ⚡ 2. The Core Service Class
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // A. Request permission from the user (Crucial for iOS, helpful for newer Androids)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // B. Get the Device Token (You will copy this from your terminal to test sending a message later)
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("📱 DEVICE FCM TOKEN: $fcmToken");

    // C. Initialize the Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // D. Listen for messages while the app is open (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification?.title}');
        // In a production app, you might trigger a local SnackBar here
      }
    });
  }
}
