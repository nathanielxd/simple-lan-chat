import 'package:flutter/material.dart';

class LanChatErrorDialog extends StatelessWidget {

  final String message;
  const LanChatErrorDialog(this.message, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(message),
      )
    );
  }
}