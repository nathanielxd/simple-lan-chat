import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/settings/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  
  static PageRoute get route => CupertinoPageRoute(builder: (_) => SettingsPage());

  @override
  Widget build(BuildContext context) {
		return BlocProvider(
      create: (_) => SettingsCubit(
        lanChat: context.read<LanChatRepository>(),
        preferences: context.read<LanChatRepository>().preferences
      ),
      child: SettingsView()
    );
  }
}
  