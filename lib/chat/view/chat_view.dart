import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:simple_lan_chat/file_message/file_message.dart';
import 'package:simple_lan_chat/image_message/image_message.dart';
import 'package:simple_lan_chat/settings/settings.dart';
import 'package:simple_lan_chat/text_message/text_message.dart';

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
              builder: (_) => DialogError(state.errorMessage!),
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
                  borderRadius: kBorderRadius,
                  color: context.colorScheme.onPrimaryContainer,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Simple LAN Chat',
                          style: TextStyle(
                            color: context.colorScheme.primaryContainer,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        borderRadius: kBorderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(
                            Icons.menu,
                            color: context.colorScheme.primaryContainer,
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
                          final rightSided =
                              state.ownAddress == message.address;
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
                                side: rightSided
                                    ? MessageAnimationSide.right
                                    : MessageAnimationSide.left,
                                child: TextMessageWidget(
                                  message,
                                  isOwn: rightSided,
                                  username: username,
                                ),
                              );
                            case MessageType.file:
                              return MessageAnimation(
                                animation: curvedAnimation,
                                side: rightSided
                                    ? MessageAnimationSide.right
                                    : MessageAnimationSide.left,
                                child: message.data.isImage
                                    ? ImageMessageWidget(
                                        message,
                                        isOwn: rightSided,
                                        username: username,
                                      )
                                    : FileMessageWidget(
                                        message,
                                        isOwn: rightSided,
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
              _buildTextField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              color: context.colorScheme.surfaceVariant,
              borderRadius: kBorderRadius,
              child: TextFormField(
                controller: _messageController,
                cursorColor: context.colorScheme.onPrimaryContainer,
                decoration: InputDecoration(
                  hintText: 'enter your message',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: kBorderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.attach_file_sharp,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        onTap: () =>
                            context.read<ChatCubit>().sendFile(FileType.any),
                      ),
                      InkWell(
                        borderRadius: kBorderRadius,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                          child: Icon(
                            Icons.image,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        onTap: () =>
                            context.read<ChatCubit>().sendFile(FileType.image),
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
            borderRadius: kBorderRadius,
            color: context.colorScheme.onPrimaryContainer,
            child: InkWell(
              borderRadius: kBorderRadius,
              onTap: () => _send(context),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  'assets/send.png',
                  height: 22,
                  color: context.colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
