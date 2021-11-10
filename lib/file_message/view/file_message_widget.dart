import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/file_message/file_message.dart';

class FileMessageWidget extends StatelessWidget {
  
  final ReceivedMessage message;
  final bool isOwn;
  final String username;

  const FileMessageWidget(this.message, { 
    Key? key,
    this.isOwn = false,
    this.username = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FileMessageCubit(message),
      child: FileMessageView(message, isOwn: isOwn, username: username)
    );
  }
}