part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.connections = const [],
    this.ownConnection = Connection.empty,
    this.username = const UsernameInput.pure(),
    this.showDonation = true,
  });

  final List<Connection> connections;
  final Connection ownConnection;
  final UsernameInput username;
  final bool showDonation;

  SettingsState copyWith({
    List<Connection>? connections,
    Connection? ownConnection,
    UsernameInput? username,
    bool? showDonation,
  }) =>
      SettingsState(
        connections: connections ?? this.connections,
        ownConnection: ownConnection ?? this.ownConnection,
        username: username ?? this.username,
        showDonation: showDonation ?? this.showDonation,
      );

  @override
  List<Object> get props =>
      [connections, ownConnection, username, showDonation];
}
