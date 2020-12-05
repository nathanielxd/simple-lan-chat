import 'dart:typed_data';

import 'package:awesomelanchat/logic/data.dart';
import 'package:awesomelanchat/logic/entities/connection.dart';

const int textMessageIDENTIFIER = 48;
const int fileMessageIDENTIFIER = 49;

enum FileType {image, audio, file}

class Message {

  String address;
  DateTime dateTime;

  Message({this.address, this.dateTime});

  Connection get connection => Data.heartbeat.connections
    .firstWhere((element) => element.address.compareTo(address) == 0,
    orElse: () => Connection(address));
}

class TextMessage extends Message {

  String address;
  DateTime dateTime;
  List<String> messages = List();

  TextMessage({this.address, this.dateTime, this.messages});
}

class FileMessage extends Message {

  String address;
  DateTime dateTime;
  Uint8List data;
  String name;

  FileMessage({this.address, this.dateTime, this.data, this.name});

  FileType get type {
    final nsplit = name.split('.');
    if(nsplit.length < 2) {
      return FileType.file;
    }
    else {
      final ext = nsplit.last;
      switch(ext) {
        case "jpg":
        case "jpeg":
          return FileType.image;
        case "wav":
        case "mp4":
          return FileType.audio;
        default:
          return FileType.file;
      }
    }
  }
}