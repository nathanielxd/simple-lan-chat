import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_lan_chat/app/app.dart';

class App extends StatelessWidget {
  const App({required this.preferences, super.key});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => LanChatRepository(preferences: preferences),
      child: const AppView(),
    );
  }
}
