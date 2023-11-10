import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:theme/theme.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themeCollection: ThemeCollection(
        themes: {
          0: ChatThemes.light,
        },
      ),
      builder: (context, theme) {
        return MaterialApp(
          title: 'Simple LAN Chat',
          theme: theme,
          home: const ChatPage(),
        );
      },
    );
  }
}
