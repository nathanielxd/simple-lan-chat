import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:simple_lan_chat/file_message/file_message.dart';
import 'package:simple_lan_chat/image_message/image_message.dart';
import 'package:simple_lan_chat/settings/settings.dart';
import 'package:simple_lan_chat/text_message/text_message.dart';
import 'package:theme/theme.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final _messageController = TextEditingController();
  final _chatKey = GlobalKey<AnimatedListState>();

  void _send(BuildContext context) {
    context.read<ChatCubit>().sendMessage();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            showDialog<void>(
              context: context,
              builder: (_) => LanChatErrorDialog(state.errorMessage!),
            );
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Simple LAN Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () =>
                            Navigator.of(context).push(SettingsPage.route),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoScrollGlowBehavior(),
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listenWhen: (previous, current) =>
                        previous.chat.messages != current.chat.messages,
                    listener: (context, state) =>
                        _chatKey.currentState?.insertItem(0),
                    buildWhen: (previous, current) =>
                        previous.chat.messages != current.chat.messages,
                    builder: (context, state) {
                      return AnimatedList(
                        key: _chatKey,
                        reverse: true,
                        itemBuilder: (context, index, animation) {
                          final message = state.chat.messages[index];
                          final isOwn = state.ownAddress == message.address;
                          final username = state.chat.connections
                                  .firstWhere(
                                    (element) =>
                                        element.address == message.address,
                                  )
                                  .username ??
                              '';
                          final curvedAnimation = animation
                              .drive(Tween<double>(begin: 0.5, end: 1))
                              .drive(CurveTween(curve: Curves.ease));
                          switch (message.data.type) {
                            case MessageType.text:
                              return MessageAnimation(
                                animation: curvedAnimation,
                                right: isOwn,
                                child: TextMessageWidget(
                                  message,
                                  isOwn: isOwn,
                                  username: username,
                                ),
                              );
                            case MessageType.file:
                              return MessageAnimation(
                                animation: curvedAnimation,
                                right: isOwn,
                                child: message.data.isImage
                                    ? ImageMessageWidget(
                                        message,
                                        isOwn: isOwn,
                                        username: username,
                                      )
                                    : FileMessageWidget(
                                        message,
                                        isOwn: isOwn,
                                        username: username,
                                      ),
                              );
                            case MessageType.heartbeat:
                              return Container();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Material(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(20),
                        child: TextFormField(
                          controller: _messageController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'enter your message',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.attach_file_sharp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onTap: () => context
                                      .read<ChatCubit>()
                                      .sendFile(FileType.any),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 15, 5),
                                    child: Icon(
                                      Icons.image,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onTap: () => context
                                      .read<ChatCubit>()
                                      .sendFile(FileType.image),
                                ),
                              ],
                            ),
                          ),
                          onChanged: (value) =>
                              context.read<ChatCubit>().messageChanged(value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _send(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            'assets/send.png',
                            height: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
