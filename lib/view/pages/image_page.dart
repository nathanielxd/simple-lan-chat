import 'dart:io';

import 'package:awesomelanchat/logic/data.dart';
import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImagePage extends StatelessWidget {

  final FileMessage message;

  ImagePage(this.message);

  void saveImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${message.dateTime.toString()}.jpg');
      final newFile = await file.writeAsBytes(message.data);
      await GallerySaver.saveImage(newFile.path, albumName: 'LAN Chat');
      Fluttertoast.showToast(msg: 'Image saved successfully.', toastLength: Toast.LENGTH_SHORT);
    }
    catch(e) {
      Fluttertoast.showToast(msg: 'Error saving image.', toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).accentColor),
          onPressed: () => Navigator.of(context).pop()
        ),
        title: Text('${message.name}',
          style: TextStyle(
            color: Theme.of(context).accentColor
          )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveImage();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[700]),
            onPressed: () {
              Data.chat.messages.remove(message);
              Navigator.of(context).pop();
            }
          )
        ]
      ),
      body: Hero(
        tag: message.address + message.data.length.toString(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(message.data)
            )
          )
        )
      )
    );
  }
}