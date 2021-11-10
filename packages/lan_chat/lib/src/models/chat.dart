import 'package:equatable/equatable.dart';
import 'package:lan_chat/lan_chat.dart';

class Chat extends Equatable {

  final List<ReceivedMessage> messages;
  final List<Connection> connections;

  const Chat({
    required this.messages,
    required this.connections,
  });

  static const empty = Chat(messages: const[], connections: const[]);
  bool get isEmpty => this == empty;

  Chat copyWith({
    List<ReceivedMessage>? messages,
    List<Connection>? connections,
  }) => Chat(
    messages: messages ?? this.messages,
    connections: connections ?? this.connections,
  );

  @override
  List<Object?> get props => [messages, connections];
}
