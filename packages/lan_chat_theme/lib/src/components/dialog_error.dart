import 'package:flutter/material.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';

class DialogError extends StatelessWidget {
  const DialogError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message),
      ),
    );
  }
}
