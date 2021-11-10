import 'package:flutter/material.dart';
import 'package:lan_chat/lan_chat.dart';

class ImageMessageWidget extends StatelessWidget {

  final ReceivedMessage message;
  final bool isOwn;
  final String username;

  const ImageMessageWidget(this.message, { 
    Key? key,
    this.isOwn = false,
    this.username = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.4
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            padding: !isOwn ? EdgeInsets.all(15) : const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOwn ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                width: 2.5
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!isOwn)
                Text(username.isNotEmpty ? username : message.address, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  )
                ),
                if(!isOwn)
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(message.data.data)
                ),
              ],
            )
          )
        )
      )
    );
  }
}