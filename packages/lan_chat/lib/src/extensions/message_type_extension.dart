import 'package:lan_chat/lan_chat.dart';

extension MessageTypeExtension on MessageType {
  bool get isHeartbeat => this == MessageType.heartbeat;
  bool get isText => this == MessageType.text;
  bool get isFile => this == MessageType.file;
}