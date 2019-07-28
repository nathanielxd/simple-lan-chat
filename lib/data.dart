import 'dart:async';
import 'message.dart';
import 'dart:io';

class Data {

  static List<Message> chat = List();

  static bool isDarkMode = true;
  static bool isDefaultPort = true;
  static bool isPortChangerEnabled = false;
  static bool isChatReversed = true;
  static bool isAutoSave = false;

  static bool useBigFont = false;
  
  static double font = 14;
  static int port = 1050;

  static List<InternetAddress> detectedAddresses = List();

  static StreamController<int> portStream = StreamController();
}