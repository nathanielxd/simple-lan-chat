import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'file_message_state.dart';

class FileMessageCubit extends Cubit<FileMessageStatus> {

  final ReceivedMessage message;
  FileMessageCubit(this.message) : super(FileMessageStatus.undownloaded);
  
  Future<void> openFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File('${docsDir.path}/${utf8.decode(message.data.fileName!)}');

    if(file.existsSync()) {
      await OpenFile.open(file.path);
      emit(FileMessageStatus.downloaded);
    }
    else {
      emit(FileMessageStatus.loading);
      await file.writeAsBytes(message.data.data);
      await Fluttertoast.showToast(msg: 'File saved successfully.');
      await OpenFile.open(file.path);
      emit(FileMessageStatus.downloaded);
    }
  }
}