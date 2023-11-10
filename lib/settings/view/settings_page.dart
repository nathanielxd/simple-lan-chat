import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static CupertinoPageRoute<void> get route =>
      CupertinoPageRoute(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        lanChat: context.read<LanChatRepository>(),
        preferences: context.read<LanChatRepository>().preferences,
      ),
      child: const SettingsView(),
    );
  }
}
