part of 'settings_cubit.dart';

class SettingsState extends Equatable {

  final List<Connection> connections;
  final Connection ownConnection;
  final UsernameInput username;

  const SettingsState({
    this.connections = const[],
    this.ownConnection = Connection.empty,
    this.username = const UsernameInput.pure()
  });

  SettingsState copyWith({
    List<Connection>? connections,
    Connection? ownConnection,
    UsernameInput? username
  }) => SettingsState(
    connections: connections ?? this.connections,
    ownConnection: ownConnection ?? this.ownConnection,
    username: username ?? this.username
  );

  @override
  List<Object> get props => [connections, ownConnection, username];
}
