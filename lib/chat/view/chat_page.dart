import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
		return BlocProvider(
      create: (_) => ChatCubit(
        lanChat: context.read<LanChatRepository>(),
        filePicker: FilePicker.platform
      ),
      child: ChatView()
    );
  }
}