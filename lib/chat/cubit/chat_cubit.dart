import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/chat/chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.lanChat,
    required this.filePicker,
  }) : super(const ChatState()) {
    initialize();
  }

  final ILanChat lanChat;
  final FilePicker filePicker;

  Future<void> initialize() async {
    await lanChat.initialize();
    lanChat.stream.listen(
      (chat) => emit(
        state.copyWith(
          chat: chat,
          ownAddress: lanChat.ownConnection.address,
        ),
      ),
    );
  }

  void messageChanged(String value) {
    final message = MessageInput.dirty(value);
    emit(state.copyWith(message: message));
  }

  void sendMessage() {
    if (!state.message.isValid) {
      return;
    }
    try {
      lanChat
          .send(MessageData.text(utf8.encode(state.message.value.trimRight())));
      emit(state.copyWith(message: const MessageInput.pure()));
    } on LanChatException catch (e) {
      emit(
        state.copyWith(
          message: const MessageInput.pure(),
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> sendFile(FileType type) async {
    try {
      final result = await filePicker.pickFiles(
        type: type,
      );

      if (result != null) {
        final file = File(result.files.single.path!);

        final fileName = utf8.encode(file.path.split('/').last);
        final data = await file.readAsBytes();

        if (data.length > 40000) {
          final count = (data.length / 40000).ceil();

          if (count > 100) {
            emit(
              state.copyWith(
                errorMessage: 'This file is way too large. '
                    'Please try again in the future or '
                    "contribute to project's GitHub page.",
              ),
            );
            return;
          }

          for (var i = 0; i < count; i++) {
            final chop = data.sublist(
              (data.length * i / count).floor(),
              (data.length * (i + 1) / count).floor(),
            );

            try {
              lanChat.send(
                MessageData.file(
                  fileName,
                  chop,
                  index: i + 1,
                  size: count,
                ),
              );
              await Future<void>.delayed(const Duration(milliseconds: 100));
            } catch (e) {
              emit(state.copyWith(errorMessage: e.toString()));
            }
          }
        } else {
          lanChat.send(MessageData.file(fileName, data));
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
