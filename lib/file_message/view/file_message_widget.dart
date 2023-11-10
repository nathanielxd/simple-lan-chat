import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/file_message/file_message.dart';

class FileMessageWidget extends StatelessWidget {
  const FileMessageWidget(
    this.message, {
    super.key,
    this.isOwn = false,
    this.username = '',
  });

  final ReceivedMessage message;
  final bool isOwn;
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FileMessageCubit(message),
      child: FileMessageView(message, isOwn: isOwn, username: username),
    );
  }
}
