import 'package:lan_chat/lan_chat.dart';

abstract class ILanChat {
  /// Stream of the chat on the LAN.
  Stream<Chat> get stream;
  /// Get the current chat data on the LAN.
  Chat get currentChat;
  /// Initialize the repository by creating a socket and accessing local storage for preferences.
  Future<void> initialize();
  /// Send a message to the lan and update [stream].
  void send(MessageData message);
  /// Get own connection on the LAN, including the address and the nickname.
  Connection get ownConnection;
  /// Change the nickname of the current address and update [stream] with the new connection.
  Future<void> changeUsername(String nickname);
  /// Close the lan chat socket and stream.
  Future<void> close();
}