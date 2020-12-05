import 'dart:io';

import 'package:flutter/material.dart';

import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/user_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileMessageWidget extends StatelessWidget {

  final FileMessage message;
  FileMessageWidget(this.message);

  Future<void> openFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File('${docsDir.path}/${message.name}');

    if(file.existsSync()) {
      await OpenFile.open(file.path);
    }
    else {
      await file.writeAsBytes(message.data);
      await Fluttertoast.showToast(msg: 'File saved successfully.');
      await OpenFile.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final connection = message.connection;
    return Align(
      alignment: connection.isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: GestureDetector(
          onTap: openFile,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: connection.isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: Text(connection.nickname != null 
                    ? (connection.nickname + ' (${connection.address})') : connection.address, 
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: UserPreferences.fontSize
                    ))
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(message.name, style: TextStyle(
                              fontSize: UserPreferences.fontSize,
                            )),
                          ),
                          Icon(Icons.file_present,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ]
                      )
                    )
                  )
                ]
              )
            )
          ),
        )
      )
    );
  }
}