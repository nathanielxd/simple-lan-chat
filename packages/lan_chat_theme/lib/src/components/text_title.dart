import 'package:flutter/material.dart';
import 'package:lan_chat_theme/lan_chat_theme.dart';

enum TextShade { light, dark }

class TextTitle extends StatelessWidget {
  const TextTitle(
    this.data, {
    this.shade = TextShade.dark,
    this.style,
    super.key,
  });

  final String data;
  final TextShade shade;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: context.textTheme.titleLarge!
          .copyWith(
            color: shade == TextShade.light
                ? context.colorScheme.primaryContainer
                : context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          )
          .merge(style),
    );
  }
}
