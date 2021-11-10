import 'package:flutter/material.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:theme/theme.dart';

class AppView extends StatelessWidget {

  AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultThemeId: 0,
      themeCollection: ThemeCollection(
        themes: {
          0: ChatThemes.light
        }
      ),
      builder: (context, theme) {
        return MaterialApp(
          title: 'Simple LAN Chat',
          theme: theme,
          home: ChatPage()
        );
      }
    );
  }
}