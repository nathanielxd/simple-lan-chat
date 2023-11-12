import 'package:flutter/material.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget(
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
    return Center(
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.4,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            padding: !isOwn ? const EdgeInsets.all(15) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOwn
                    ? context.colorScheme.onPrimaryContainer
                    : context.colorScheme.background,
                width: 2.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isOwn)
                  Text(
                    username.isNotEmpty ? username : message.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (!isOwn) const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(message.data.data),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
