import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lan_chat/lan_chat.dart';

class ReceivedMessage extends Equatable {

  final String address;
  final DateTime sentAt;
  final MessageData data;
  
  ReceivedMessage({
    required this.address,
    required this.sentAt,
    required this.data
  });

  factory ReceivedMessage.fromDatagram(Datagram datagram) {
    final type = MessageType.values[datagram.data.first];
    MessageData messageData;

    switch(type) {
      case MessageType.heartbeat:
        messageData = MessageData.heartbeat(datagram.data.sublist(1));
        break;
      case MessageType.text:
        messageData = MessageData.text(datagram.data.sublist(1));
        break;
      case MessageType.file:
        final nameLength = datagram.data[1];
        messageData = MessageData.file(
          datagram.data.sublist(4, nameLength + 4), 
          datagram.data.sublist(nameLength + 4),
          index: datagram.data[2],
          size: datagram.data[3]
        );
        break;
    }

    return ReceivedMessage(
      address: datagram.address.address, 
      sentAt: DateTime.now(), 
      data: messageData
    );
  }

  ReceivedMessage copyWith({
    String? address,
    DateTime? sentAt,
    MessageData? data,
  }) => ReceivedMessage(
    address: address ?? this.address,
    sentAt: sentAt ?? this.sentAt,
    data: data ?? this.data,
  );
  
  @override
  List<Object> get props => [address, sentAt, data];
}
