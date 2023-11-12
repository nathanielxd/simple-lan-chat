import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_lan_chat/settings/settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.lanChat,
    required this.preferences,
  }) : super(
          SettingsState(
            connections: lanChat.currentChat.connections,
            ownConnection: lanChat.ownConnection,
            username:
                UsernameInput.dirty(preferences.getString('username') ?? ''),
            showDonation: preferences.getBool('showDonation') ?? true,
          ),
        ) {
    lanChat.stream.listen((chat) {
      final connections = List<Connection>.from(chat.connections)
        ..sort((a, b) => a.address.compareTo(b.address));
      emit(state.copyWith(connections: connections));
    });
  }

  final ILanChat lanChat;
  final SharedPreferences preferences;

  Future<void> showDonationChanged() async {
    await preferences.setBool('showDonation', !state.showDonation);
    emit(state.copyWith(showDonation: !state.showDonation));
  }

  Future<void> usernameChanged(String value) async {
    final username = UsernameInput.dirty(value);
    emit(state.copyWith(username: username));
    if (!state.username.isNotValid) {
      await preferences.setString('username', username.value);
      await lanChat.changeUsername(username.value);
    }
  }
}
