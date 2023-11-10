import 'package:flutter/material.dart';
import 'package:lan_chat/lan_chat.dart';
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
        color: isOwn ? Theme.of(context).primaryColor : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor,
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
                  color: isOwn ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
              if (connection.username != null &&
                  connection.username!.isNotEmpty)
                Text(
                  connection.username!,
                  style: TextStyle(
                    color: isOwn ? Colors.white : Colors.black,
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
              color: isOwn ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
