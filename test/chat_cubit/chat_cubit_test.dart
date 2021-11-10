import 'dart:math';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_lan_chat/chat/chat.dart';
import 'package:test/test.dart';

import '../lan_chat/lan_chat_test.mocks.dart';
import 'chat_cubit_test.mocks.dart';

@GenerateMocks([FilePicker])
void main() {

  final random = Random();
  
  final mockPreferences = MockSharedPreferences();
  when(mockPreferences.getString('username')).thenReturn('nathan');

  final mockData = List.generate(
    10000 + random.nextInt(100000), 
    (index) => random.nextInt(200)
  );

  final mockFilePicker = MockFilePicker();
  when(mockFilePicker.pickFiles()).thenAnswer(
    (realInvocation) {
      return Future.value(FilePickerResult([
        PlatformFile(
          name: 'test${random.nextInt(200)}.jpg', 
          size: mockData.length,
          bytes: Uint8List.fromList(mockData)
        )
      ]));
    }
  );

  final lanChat = LanChatRepository(preferences: mockPreferences);

  group('Chat cubit', () {


    blocTest<ChatCubit, ChatState>(
      'emits [MyState] when MyEvent is added.',
      build: () => ChatCubit(lanChat: lanChat, filePicker: mockFilePicker),
      act: (cubit) => cubit.sendFile(FileType.any),
      expect: () => ChatState(), // TODO finish this
    );
  });
}