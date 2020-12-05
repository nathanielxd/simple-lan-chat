import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {

  FlutterLocalNotificationsPlugin instance;

  Future<void> initialize() async {
    instance = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = IOSInitializationSettings();
    final settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    return await instance.initialize(settings);
  }

  Future<void> show(String message) async {
    return instance.show(0, 'LAN Chat', message, 
      NotificationDetails(
        android: AndroidNotificationDetails('1', 'LAN Chat Message', 'New message!',
          importance: Importance.low,
          priority: Priority.low,
          ticker: 'ticker'
        )
      ),
      payload: 'pl'
    );
  }
}