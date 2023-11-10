part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.chat = Chat.empty,
    this.ownAddress = '',
    this.message = const MessageInput.pure(),
    this.errorMessage,
  });

  final Chat chat;
  final String ownAddress;
  final MessageInput message;
  final String? errorMessage;

  ChatState copyWith({
    Chat? chat,
    MessageInput? message,
    String? ownAddress,
    bool? loading,
    String? errorMessage,
  }) =>
      ChatState(
        chat: chat ?? this.chat,
        message: message ?? this.message,
        ownAddress: ownAddress ?? this.ownAddress,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [chat, message, ownAddress, errorMessage];
}
