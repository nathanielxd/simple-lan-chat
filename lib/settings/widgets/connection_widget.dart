import 'package:flutter/material.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget(this.connection, this.ownAddress, {super.key});

  final Connection connection;
  final String ownAddress;

  @override
  Widget build(BuildContext context) {
    final isOwn = connection.address == ownAddress;
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOwn ? context.colorScheme.onPrimaryContainer : null,
        borderRadius: kBorderRadius,
        border: Border.all(
          color: context.colorScheme.onPrimaryContainer,
          width: 2.5,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                connection.address,
                style: TextStyle(
                  color: isOwn
                      ? context.colorScheme.surface
                      : context.colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
              if (connection.username != null &&
                  connection.username!.isNotEmpty)
                Text(
                  connection.username!,
                  style: TextStyle(
                    color: isOwn
                        ? context.colorScheme.surface
                        : context.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            isOwn
                ? 'you'
                : connection.lastSeen!.difference(DateTime.now()).inSeconds > 10
                    ? 'now'
                    : timeago.format(connection.lastSeen!),
            style: TextStyle(
              color: isOwn
                  ? context.colorScheme.surface
                  : context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
