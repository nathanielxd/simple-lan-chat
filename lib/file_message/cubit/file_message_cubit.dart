import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lan_chat/lan_chat.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'file_message_state.dart';

class FileMessageCubit extends Cubit<FileMessageStatus> {
  FileMessageCubit(this.message) : super(FileMessageStatus.undownloaded);

  final ReceivedMessage message;

  Future<void> openFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File('${docsDir.path}/${utf8.decode(message.data.fileName!)}');

    if (file.existsSync()) {
      await OpenFile.open(file.path);
      emit(FileMessageStatus.downloaded);
    } else {
      emit(FileMessageStatus.loading);
      await file.writeAsBytes(message.data.data);
      await Fluttertoast.showToast(msg: 'File saved successfully.');
      await OpenFile.open(file.path);
      emit(FileMessageStatus.downloaded);
    }
  }
}
