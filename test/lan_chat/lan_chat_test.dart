import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lan_chat/lan_chat.dart';

import 'lan_chat_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {

  final random = Random();

  final mockPreferences = MockSharedPreferences();
  when(mockPreferences.getString('username')).thenReturn('nathan');

  late LanChatRepository lanChat;

  group('Lan chat', () {

    setUp(() async {
      lanChat = LanChatRepository(preferences: mockPreferences);
      await lanChat.initialize();
      await Future.delayed(Duration(seconds: 2));
    });

    tearDown(() async {
      await lanChat.close();
    });

    test('initializes', () {
      expect(lanChat.currentChat.messages.length, 0);
      expect(lanChat.currentChat.connections.length, 1);
    });

    test('sends and receives a text message', () async {
      lanChat.send(MessageData.text(utf8.encode('test')));
      await Future.delayed(Duration(seconds: 2));

      final messages = lanChat.currentChat.messages;
      expect(messages.length, 1);
      expect(messages.first.data.type, MessageType.text);
      expect(utf8.decode(messages[0].data.data), 'test');
    });

    test('sends and receives a single-part file message', () async {
      final fileData = List.generate(5000, (index) => 1);
      lanChat.send(MessageData.file(
        utf8.encode('test.jpg'), 
        fileData
      ));
      await Future.delayed(Duration(seconds: 2));

      final messages = lanChat.currentChat.messages;
      expect(messages.length, 1);
      expect(messages.first.data.type, MessageType.file);
      expect(messages.first.data.data, equals(fileData));
    });

    test('sends and receives a two-part file message', () async {
      final fileName = utf8.encode('test.jpg');
      final fileData1 = List.generate(5000, (index) => 1);
      final fileData2 = List.generate(5000, (index) => 2);

      lanChat.send(MessageData.file(fileName, fileData1,
        index: 1,
        size: 2
      ));

      lanChat.send(MessageData.file(fileName, fileData2, 
        index: 2, 
        size: 2
      ));

      await Future.delayed(Duration(seconds: 2));

      final messages = lanChat.currentChat.messages;
      expect(messages.length, 1);
      expect(messages.first.data.type, MessageType.file);
      expect(messages.first.data.data, equals(fileData1 + fileData2));
    });

    test('sends and receives a multi-part file message', () async {
      final fileName = utf8.encode('test.jpg');
      final fileData = List.generate(100000, 
        (index) => random.nextInt(50)
      );

      if(fileData.length > 8000) {
        int count = (fileData.length / 8000).ceil();

        for(int i = 0; i < count; i++) {
          var chop = fileData.sublist(
            (fileData.length * i / count).floor(),
            (fileData.length * (i + 1) / count).floor()
          );

          lanChat.send(MessageData.file(fileName, chop,
            index: i + 1,
            size: count
          ));
        }
      }

      await Future.delayed(Duration(seconds: 2));

      final messages = lanChat.currentChat.messages;
      expect(messages.length, 1);
      expect(messages.first.data.type, MessageType.file);
      expect(messages.first.data.data.length, 100000);
      expect(messages.first.data.data, equals(fileData));
    });
  });
}