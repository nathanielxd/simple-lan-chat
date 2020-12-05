import 'dart:async';
import 'dart:isolate';

import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/lan/lan.dart';
import 'package:awesomelanchat/view/pages/home_page.dart';
import 'package:awesomelanchat/view/theme/custom_theme.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void isolate(SendPort port) async {

  final instance = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = IOSInitializationSettings();
  final settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
  await instance.initialize(settings);

  final receivePort = ReceivePort();
  port.send(receivePort.sendPort);

  bool appResumed = true;

  // Listen to messages from Main.
  receivePort.listen((message) {
    if(message is bool) {
      appResumed = message;
    }
    if(message is String && !appResumed) {
      instance.show(0, 'LAN Chat', message.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails('1', 'LAN Chat Message', 'You received a message!',
            importance: Importance.low,
            priority: Priority.low,
            ticker: 'ticker'
          )
        ),
        payload: 'pl'
      );
    }
  });
}

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());

  final receivePort = ReceivePort();
  SendPort dataSender;

  await FlutterIsolate.spawn(isolate, receivePort.sendPort);
  // Listen to messages from Isolate.
  receivePort.listen((message) {
    // If the message is another SendPort and our data sender is null, 
    // we're going to use this dataSender SendPort to send data to the Isolate.
    if(dataSender == null && message is SendPort) {
      dataSender = message;
      // Start listening to LanChat
      LanChat.stream.listen((event) { 
        if(event.last is TextMessage) {
          // Send a string back to the isolate. And keep sending.
          dataSender.send((event.last as TextMessage).messages.last);
        }
      });
      // Start listening to appResumed
      appResumedController.stream.listen((event) { 
        dataSender.send(event);
      });
    }
  });
}

final appResumedController = StreamController<bool>();

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    appResumedController.add(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    appResumedController.add(state == AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => brightness == Brightness.light ? CustomTheme.light : CustomTheme.dark,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Simple LAN Chat',
          theme: theme,
          home: HomePage()
        );
      }
    );
  }
}