import 'dart:io';

import 'package:flutter/material.dart';

import 'package:awesomelanchat/logic/ad_rewards.dart';
import 'package:awesomelanchat/logic/data.dart';
import 'package:awesomelanchat/logic/entities/connection.dart';
import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/user_preferences.dart';
import 'package:awesomelanchat/logic/lan/lan.dart';
import 'package:awesomelanchat/logic/storefront.dart';
import 'package:awesomelanchat/view/others/custom_page_routes.dart';
import 'package:awesomelanchat/view/pages/premium_page.dart';
import 'package:awesomelanchat/view/pages/settings_page.dart';
import 'package:awesomelanchat/view/widgets/file_message_widget.dart';
import 'package:awesomelanchat/view/widgets/image_message_widget.dart';
import 'package:awesomelanchat/view/widgets/message_widget.dart';
import 'package:awesomelanchat/view/others/no_scroll_glow.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:firebase_admob/firebase_admob.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  AnimationController connectionsAnimationController;
  Animation connectionsAnimation;

  AnimationController attachAnimationController;
  Animation attachAnimation;

  final sendTextController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initializeApp();
    initializeAnimations();
  }

  void initializeApp() async {
    await Data.chat.initialize();
    await Data.heartbeat.initialize();

    await FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2871262057902324~4312573899');
    
    await AdRewards.initialize();
    await Storefront.initialize();
    await UserPreferences.load();

    if(!UserPreferences.isPremium) {
      DynamicTheme.of(context).setBrightness(Brightness.light);
      UserPreferences.nickname = null;
      UserPreferences.isDarkmode = false;
    }
  }

  void initializeAnimations() {
    connectionsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    );

    connectionsAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: connectionsAnimationController
    );

    attachAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    attachAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: attachAnimationController
    );
  }

  void _sendMessage(String message) {
    if(message.isNotEmpty) {
      while(message.endsWith(' ')) {
        message = message.substring(0, message.length - 1);
      }
      Data.chat.sendMessage(message);

      sendTextController.clear();
    }
    else FocusScope.of(context).unfocus();
  }

  void _sendImage(ImageSource source) async {
    if(UserPreferences.isPremium) {
      final picker = ImagePicker();

      final result = await picker.getImage(
        source: source, 
        imageQuality: 50,
        maxHeight: 540,
        maxWidth: 900
      );

      if (result != null) {
        final file = File(result.path);
        final bytes = await file.readAsBytes();
        final fileName = file.path.split('/').last;
        Data.chat.sendFile(fileName, bytes);
      }
    }
    else Navigator.of(context).push(popPageRoute((context) => PremiumPage()));
  }

  void _sendFile() async {
    final result = await fp.FilePicker.platform.pickFiles();

    if(result != null) {
      final file = File(result.files.single.path);
      final bytes = await file.readAsBytes();
      final fileName = file.path.split('/').last;
      Data.chat.sendFile(fileName, bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Simple LAN Chat', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Manrope',
          color: Theme.of(context).accentColor
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              if(connectionsAnimationController.isDismissed) 
                connectionsAnimationController.forward();
              else if(connectionsAnimationController.isCompleted)
                connectionsAnimationController.reverse();
            }
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context)
                .push(customPageRoute((builder) => SettingsPage()));
            }
          )
        ]
      ),
      body: Column(
        children: [
          SizeTransition(
            sizeFactor: connectionsAnimation,
            child: StreamBuilder<List<Connection>>(
              stream: Data.heartbeat.stream,
              builder: (context, AsyncSnapshot<List<Connection>> snapshot) {
                if(snapshot.hasData) {
                  return _buildActiveConnections(context, snapshot);
                }
                return Container();
              }
            )
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoScrollGlowBehavoir(),
              child: StreamBuilder<List<Message>>(
                stream: LanChat.stream,
                builder: (context, snapshot) {
                  return ListView(
                    controller: scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(),
                    children: [
                      ...List.generate(Data.chat.messages.length, 
                        (index) {
                          final item = Data.chat.messages[index];
                          if(item is TextMessage)
                            return MessageWidget(item);
                          else if(item is FileMessage) {
                            switch(item.type) {
                              case FileType.image:
                                return ImageMessageWidget(item);
                              case FileType.audio:
                                break; //TODO This case
                              case FileType.file:
                                return FileMessageWidget(item);
                                break;
                            }
                          }
                          return Container();
                        }
                      ),
                      SizeTransition(
                        sizeFactor: attachAnimation,
                        axisAlignment: -1.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                          child: _buildAttachDialog(context)
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        child: _buildMessageComposer(context),
                      )
                    ].reversed.toList()
                  );
                }
              )
            ),
          ),
        ]
      )
    );
  }

  Material _buildAttachDialog(BuildContext context) 
  => Material(
    elevation: 0.5,
    color: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // File
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(256),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.contact_page, color: Theme.of(context).primaryColor),
                  )
                ),
                onTap: () {
                  _sendFile();
                  attachAnimationController.reverse();
                },
              ),
              Text('File', style: TextStyle(
                color: Colors.grey
              ))
            ]
          ),
          // Camera
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(256),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor),
                  )
                ),
                onTap: () {
                  _sendImage(ImageSource.camera);
                  attachAnimationController.reverse();
                },
                
              ),
              Text('Camera', style: TextStyle(
                color: Colors.grey
              ))
            ]
          ),
          // Gallery
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(256),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.photo, color: Theme.of(context).primaryColor),
                  )
                ),
                onTap: () {
                  _sendImage(ImageSource.gallery);
                  attachAnimationController.reverse();
                },
              ),
              Text('Gallery', style: TextStyle(
                color: Colors.grey
              ))
            ]
          )
        ]
      ),
    )
  );

  Widget _buildActiveConnections(BuildContext context, AsyncSnapshot<List<Connection>> snapshot) 
  => Padding(
    padding: const EdgeInsets.all(8),
    child: Material(
      elevation: 1,
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connected Devices'),
            ...snapshot.data.map((e) {
              return e.active ?
                Row(
                  children: [
                    Text(e.address, style: TextStyle(
                      fontSize: 16,
                    )),
                    SizedBox(width: 4),
                    if(e.nickname.isNotEmpty)
                    Text('(${e.nickname})', style: TextStyle(
                      fontSize: 16,
                    )),
                    if(e.isOwn)
                    SizedBox(width: 4),
                    if(e.isOwn)
                    Text('(You)', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ))
                  ]
                ) : Container();
            }).toList()
          ]
        )
      )
    ),
  );

  Widget _buildMessageComposer(BuildContext context) 
  => Material(
    elevation: 1,
    color: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(12),
    child: Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: sendTextController,
            cursorColor: Theme.of(context).accentColor,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: 'Enter your message',
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey[600] : Colors.grey[300]
              )
            ),
            textInputAction: TextInputAction.unspecified,
            onFieldSubmitted: (value) => _sendMessage(value)
          )
        ),
        IconButton(
          icon: Icon(Icons.attach_file),
          color: Theme.of(context).accentColor,
          onPressed: () {
            if(attachAnimationController.value == 0) {
              attachAnimationController.forward();
            }
            else attachAnimationController.animateTo(0, 
              duration: Duration(milliseconds: 250),
              curve: Curves.linear
            );
          },
        ),
        SizedBox(width: 12),
        IconButton(
          icon: Icon(Icons.send),
          color: Theme.of(context).accentColor,
          onPressed: () => _sendMessage(sendTextController.text),
        )
      ]
    )
  );
}