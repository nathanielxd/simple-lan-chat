import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:lan_chat/lan_chat.dart';

class TextMessageWidget extends StatelessWidget {

  final ReceivedMessage message;
  final bool isOwn;
  final String username;

  const TextMessageWidget(this.message, { 
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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isOwn ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20)
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
                LinkWell(utf8.decode(message.data.data),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: isOwn ? Colors.white : Colors.black
                  ),
                  linkStyle: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline
                  ),
                )
              ]
            )
          )
        )
      )
    );
  }
}