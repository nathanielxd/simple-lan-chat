import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:simple_lan_chat/settings/settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {

  final ILanChat lanChat;
  final SharedPreferences preferences;

  SettingsCubit({
    required this.lanChat,
    required this.preferences
  }) : super(SettingsState(
    connections: lanChat.currentChat.connections,
    ownConnection: lanChat.ownConnection,
    username: UsernameInput.dirty(preferences.getString('username') ?? '')
  )) {
    lanChat.stream.listen((chat) {
      final connections = List<Connection>.from(chat.connections);
      connections.sort((a, b) => a.address.compareTo(b.address));
      emit(state.copyWith(connections: connections));
    });
  }

  void usernameChanged(String value) async {
    final username = UsernameInput.dirty(value);
    emit(state.copyWith(username: username));
    if(!state.username.invalid) {
      preferences.setString('username', username.value);
      lanChat.changeUsername(username.value);
    }
  }
}