import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanChatRepository extends ILanChat {

  final SharedPreferences preferences;

  LanChatRepository({
    required this.preferences
  });

  static const _port = 1050;
  static final _ia255 = InternetAddress('255.255.255.255');

  RawDatagramSocket? _socket;

  final _controller = StreamController<Chat>.broadcast()..add(Chat.empty);
  Chat _cachedChat = Chat.empty;
  Connection _ownConnection = Connection.empty;
  List<ReceivedMessage> _incompletedFiles = [];

  @override
  Future<void> initialize() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _port);
    _socket!.broadcastEnabled = true;

    final ownAddressIdentifier = Random().nextInt(100);
    final ownAddressData = [4, ...List.generate(10, (index) => ownAddressIdentifier)];
    
    // Start listening to and reading packets.
    _socket!.listen((RawSocketEvent event) {
      if(event != RawSocketEvent.read) {
        return;
      }

      final datagram = _socket!.receive();
      if(datagram == null) {
        return;
      }

      // Case of: Own address identifier.
      if(datagram.data.first == 4 && listEquals(datagram.data, ownAddressData)) {
        final address = datagram.address.address;
        final nickname = preferences.getString('username');
        _ownConnection = _ownConnection.copyWith(
          address: address,
          username: nickname
        );
        return;
      }

      final message = ReceivedMessage.fromDatagram(datagram);
        
      // Case of: heartbeats.
      if(message.data.type.isHeartbeat) {
        var connections = List<Connection>.from(_cachedChat.connections);

        final existingConnection = connections.singleWhere(
          (element) => element.address == message.address, 
          orElse: () => Connection.empty
        );

        if(!existingConnection.isEmpty) {
          connections.remove(existingConnection);
        }

        connections.add(Connection.fromMessage(message));
        _controller.add(_cachedChat = _cachedChat.copyWith(connections: connections));

        return;
      }
      // Case of: NOT heartbeat message.
      if(message.data.type.isFile && message.data.size! > 1) {
        print('Received file part of index ' + message.data.index.toString());
        // Case of: MULTI file messages.
        var incompletedMessage = _incompletedFiles.firstWhere(
          (element) => listEquals(element.data.fileName, message.data.fileName),
          orElse: () {
            // Case of: first chop
            _incompletedFiles.add(message);
            return message;
          }
        );

        final incompletedIndex = _incompletedFiles.indexOf(incompletedMessage);

        // Case of: NOT first chop.
        if(message.data.index != 1) {
          var newData = List<int>.from(incompletedMessage.data.data);
          newData.addAll(message.data.data);

          incompletedMessage = incompletedMessage.copyWith(
            data: incompletedMessage.data.copyWith(
              data: Uint8List.fromList(newData)
            )
          );

          _incompletedFiles.removeAt(incompletedIndex);
          _incompletedFiles.add(incompletedMessage);

          // Case of: LAST chop.
          if(message.data.index == message.data.size) {
            var messages =  List<ReceivedMessage>.from(_cachedChat.messages);
            messages.insert(0, incompletedMessage);
            _incompletedFiles.removeAt(incompletedIndex);
            _controller.add(_cachedChat = _cachedChat.copyWith(messages: messages));
          }
        }
        return;
      }
      else {
        var messages =  List<ReceivedMessage>.from(_cachedChat.messages);
        messages.insert(0, message);
        _controller.add(_cachedChat = _cachedChat.copyWith(messages: messages));
      }
    });

    // Send own address identifier to recognise own address.
    _socket!.send(ownAddressData, _ia255, _port);

    // Send initial hearbeat.
    _socket!.send([
      0, 
      ..._ownConnection.username == null ? [] : utf8.encode(_ownConnection.username!)
    ], _ia255, _port);

    
    // Heartbeat every 5 seconds.
    Timer.periodic(Duration(seconds: 5), (timer) {
      _socket!.send([
        0, 
        ..._ownConnection.username == null ? [] : utf8.encode(_ownConnection.username!)
      ], _ia255, _port);
    });
  }

  @override
  Stream<Chat> get stream => _controller.stream;

  @override
  Chat get currentChat => _cachedChat;

  @override
  Connection get ownConnection => _ownConnection;

  @override
  void send(MessageData message) async {
    if(_socket == null) {
      throw LanChatException.uninitialized();
    }

    var data = List<int>.from(message.data);

    if(message.type.isText) {
      data.insert(0, MessageType.text.index);
      _socket!.send(data, _ia255, _port);
    }
    else if(message.type.isFile) {
      var data = <int>[];
      // Add identifier.
      data.add(MessageType.file.index);
      // Add file name length.
      data.add(message.fileName!.length);
      // Add file index and file size.
      data.add(message.index!);
      data.add(message.size!);
      // Add file name.
      data.addAll(message.fileName!);
      // Add the data.
      data.addAll(message.data);

      _socket!.send(data, _ia255, _port);
    }
  }

  @override
  Future<void> changeUsername(String username) async { 
    await preferences.setString('username', username);
    _ownConnection = _ownConnection.copyWith(
      username: username
    );
  }

  @override
  Future<void> close() async {
    await _controller.close();
    _socket?.close();
  }
}