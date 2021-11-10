import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:lan_chat/lan_chat.dart';

class Connection extends Equatable {

  final String address;
  final String? username;
  final DateTime? lastSeen;

  const Connection({
    required this.address,
    this.username,
    this.lastSeen,
  });

  static const empty = Connection(address: '');
  bool get isEmpty => this == empty;

  factory Connection.fromMessage(ReceivedMessage message)
  => Connection(
    address: message.address,
    lastSeen: message.sentAt,
    username: utf8.decode(message.data.data)
  );

  Connection copyWith({
    String? address,
    String? username,
    DateTime? lastSeen,
  }) => Connection(
    address: address ?? this.address,
    username: username ?? this.username,
    lastSeen: lastSeen ?? this.lastSeen,
  );

  @override
  List<Object?> get props => [address, username, lastSeen];
}