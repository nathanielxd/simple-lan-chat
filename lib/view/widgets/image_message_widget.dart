import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/user_preferences.dart';
import 'package:awesomelanchat/view/others/custom_page_routes.dart';
import 'package:awesomelanchat/view/pages/image_page.dart';
import 'package:flutter/material.dart';

class ImageMessageWidget extends StatelessWidget {

  final FileMessage message;

  ImageMessageWidget(this.message);

  @override
  Widget build(BuildContext context) {
    final connection = message.connection;
    return Align(
      alignment: connection.isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: connection.isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: Text(connection.nickname != null 
                  ? (connection.nickname + ' (${connection.address})') : connection.address, 
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: (UserPreferences.fontSize - 2).toDouble()
                  ))
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context)
                        .push(popPageRoute((context) => ImagePage(message)));
                    },
                    child: Hero(
                      tag: message.address + message.data.length.toString(),
                      child: Image.memory(message.data, 
                        width: MediaQuery.of(context).size.width / 1.6
                      )
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}