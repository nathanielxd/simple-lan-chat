import 'package:flutter/material.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';

class ButtonBasic extends StatelessWidget {
  const ButtonBasic({
    required this.label,
    required this.onPressed,
    this.filled = true,
    super.key,
  });

  final Widget label;
  final void Function() onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
        side: BorderSide(
            color: context.colorScheme.onPrimaryContainer, width: 2.5),
      ),
      color:
          filled ? context.colorScheme.onPrimaryContainer : Colors.transparent,
      child: InkWell(
        borderRadius: kBorderRadius,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 15,
              color: filled
                  ? context.colorScheme.primaryContainer
                  : context.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            child: label,
          ),
        ),
      ),
    );
  }
}
