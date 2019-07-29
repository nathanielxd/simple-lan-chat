import 'dart:async';
import 'message.dart';
import 'dart:io';

class Data {

  static List<Message> chat = List();

  static bool isDarkMode = true;
  static bool isDefaultPort = true;
  static bool isPortChangerEnabled = false;
  static bool isChatReversed = true;
  static bool isNotifications = true;
  
  static double font = 15;
  static int port = 1050;

  static List<InternetAddress> detectedAddresses = List();

  static StreamController<int> portStream = StreamController();

  static closeStream() {
    portStream.sink.close();
    portStream.close();
  }
}