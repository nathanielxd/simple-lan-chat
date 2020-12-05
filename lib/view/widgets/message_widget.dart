import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageWidget extends StatelessWidget {

  final TextMessage message;

  const MessageWidget(this.message);

  @override
  Widget build(BuildContext context) {
    final connection = message.connection;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: connection.isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: Text(connection.nickname != null 
                ? (connection.nickname + ' (${connection.address})') : connection.address, style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: UserPreferences.fontSize
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: connection.isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: message.messages.map((e) 
                    => InkWell(
                      borderRadius: BorderRadius.circular(4),
                      splashColor: Colors.transparent,
                      child: Text(e, style: TextStyle(
                        fontSize: UserPreferences.fontSize
                      )),
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: e));
                        Fluttertoast.showToast(msg: 'Text copied to clipboard.', toastLength: Toast.LENGTH_SHORT);
                      }
                    )
                  ).toList()
                )
              )
            ]
          )
        )
      )
    );
  }
}