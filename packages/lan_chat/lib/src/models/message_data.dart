import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:lan_chat/lan_chat.dart';

class MessageData extends Equatable {

  final MessageType type;
  final Uint8List data;
  final List<int>? fileName;
  final int? index;
  final int? size;

  MessageData._({
    required this.type,
    required this.data,
    this.fileName,
    this.index,
    this.size
  });

  factory MessageData.heartbeat(List<int> usernameData)
  => MessageData._(
    type: MessageType.heartbeat, 
    data: Uint8List.fromList(usernameData)
  );

  factory MessageData.text(List<int> textData)
  => MessageData._(
    type: MessageType.text, 
    data: Uint8List.fromList(textData)
  );

  factory MessageData.file(
    List<int> fileName, List<int> fileData, {
    int index = 1,
    int size = 1
  }) => MessageData._(
    type: MessageType.file, 
    data: Uint8List.fromList(fileData),
    fileName: fileName,
    index: index,
    size: size
  );

  bool get isImage => type.isFile && ['jpg', 'jpeg', 'png'].contains(utf8.decode(fileName!).split('.').last);

  MessageData copyWith({
    MessageType? type,
    Uint8List? data,
    List<int>? fileName,
    int? index,
    int? size,
  }) => MessageData._(
    type: type ?? this.type,
    data: data ?? this.data,
    fileName: fileName ?? this.fileName,
    index: index ?? this.index,
    size: size ?? this.size,
  );

  @override
  List<Object?> get props => [type, data, fileName, index, size];
}
