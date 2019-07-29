import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:simple_lan_chat/message.dart';
import 'package:simple_lan_chat/tabs/settings.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as n;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: ((brightness) {
        if(brightness == Brightness.light)
          return ThemeData(
            primaryColor: Colors.white,
            brightness: brightness
          );
        else
          return ThemeData(
            primaryColor: Colors.black,
            brightness: brightness
          );
      }),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple LAN Chat',
          theme: theme,
          home: MyHomePage()
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final _MyHomePageState _homePageState = _MyHomePageState();

  @override
  _MyHomePageState createState() => _homePageState;
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  AppLifecycleState appState = AppLifecycleState.resumed;

  n.FlutterLocalNotificationsPlugin notificationsPlugin = n.FlutterLocalNotificationsPlugin();
  n.NotificationDetails specifics;

  StreamSubscription subscription;

  TextEditingController textController = TextEditingController();
  TextEditingController chatController = TextEditingController();

  RawDatagramSocket socket;
  InternetAddress ia255 = InternetAddress('255.255.255.255');
  int port;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      appState = state;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    initNotifications();
    initSettingsAndSocket();

    checkConnection();
    openPortStream();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    textController.dispose();
    chatController.dispose();
    subscription.cancel();
    Data.closeStream();
  }

  void initSettingsAndSocket() async {

    await loadSettings();
    await openSocket();
  }

  void _globalMessage(String content) {

    Message msg = Message('', content, true);
    
    setState(() {
      if(Data.isChatReversed == true) {
        Data.chat.insert(0, msg);
      } else {
        Data.chat.add(msg);
      }
    });
  }

  Future<void> loadSettings() async {

    await SharedPreferences.getInstance().then((prefs){
      Data.isDarkMode = prefs.getBool('isDarkMode') ?? true;
      Data.isDefaultPort = prefs.getBool('isDefaultPort') ?? true;
      Data.isPortChangerEnabled = prefs.getBool('isPortChangerEnabled') ?? false;
      Data.isChatReversed = prefs.getBool('isChatReversed') ?? true;
      Data.isNotifications = prefs.getBool('isNotifications') ?? true;

      Data.font = prefs.getDouble('font') ?? 14;
      Data.port = prefs.getInt('port') ?? 1050;
    });
  }

  void initNotifications() {

    var initSettingsAndroid = n.AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettingsIOS = n.IOSInitializationSettings();
    var initSettings = n.InitializationSettings(initSettingsAndroid, initSettingsIOS);
    notificationsPlugin.initialize(initSettings, onSelectNotification: onNotification);

    var androidSpecifics = n.AndroidNotificationDetails('1', 'LAN Chat Message', 'You received a message!',
     importance: n.Importance.High,
     priority: n.Priority.Low,
     ticker: 'ticker'
    );
    var iOSspecifics = n.IOSNotificationDetails();
    specifics = n.NotificationDetails(androidSpecifics, iOSspecifics);
  }

  Future onNotification(String payload) async {

    appState = AppLifecycleState.resumed;
  }

  Future showNotification(String notificationMessage) async {

    await notificationsPlugin.show(0, 'New Message', notificationMessage, specifics, payload: 'item x');
  }

  // Checks what type of connection you have
  void checkConnection() async {
    
    await Connectivity().checkConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      
    switch(result) {
      case ConnectivityResult.mobile:
        Toast.show('You must be connected to a WiFi', context, duration: 4);
        break;
      case ConnectivityResult.none:
        Toast.show('You\'re not connected to a wifi', context, duration: 4);
        break;
      case ConnectivityResult.wifi:
        Toast.show('You\'re properly connected', context, duration: 2);
      }
    });
  }

  // Opens a Stream for when the port is changed
  void openPortStream() async {

    Data.portStream.stream.listen((data){

      _globalMessage('Connected to port ' + data.toString());
    });
  }

  // Opens socket to the LAN
  Future<void> openSocket() async {

    port = Data.port;

    await RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then((soc){

      socket = soc;

      socket.broadcastEnabled = true;

      socket.listen((data) async {

        Datagram datagram = socket.receive();

        Message message = Message(datagram.address.address, utf8.decode(datagram.data), false);

        setState(() {
          
          if(Data.isChatReversed == true) {
            Data.chat.insert(0, message);
          } else {
            Data.chat.add(message);
          }
        });

        if(Data.isNotifications == true && appState != AppLifecycleState.resumed) {
          showNotification(message.content);
        }
      });
    });

    _globalMessage('Connected to port ' + Data.port.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: Data.isChatReversed,
              itemCount: Data.chat.length,
              itemBuilder: (context, index) {
                final message = Data.chat[index];
                if(message.global == true) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 8, 0),
                    child: Text(message.content, style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text('(' + message.ip + ')  ' + message.content, style: TextStyle(fontSize: Data.font)),
                  );
                }
              },
            )
          ),
          Divider(height: 1),
          Container(
            child: _messageComposer()
          )
        ],
      )
    );
  }

  // Message Composer of the Chat
  Widget _messageComposer() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              controller: textController,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter your message'
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: (){
              List<int> message = utf8.encode(textController.text);
              socket.send(message, ia255, port);
              textController.clear();
            },
          ),
        )
      ],
    );
  }

  // AppBar
  AppBar _appBar() {
    return AppBar(
      title: Text('LAN Chat'),
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          onSelected: _popUpAction,
          itemBuilder: (context) => <PopupMenuItem<int>>[
            PopupMenuItem<int>(
              child: Text('Clear chat'),
              value: 1,
            ),
            PopupMenuItem<int>(
              child: Text('More...'),
              value: 3
            )
          ]
        )
      ],
    );
  }

  // Actions of the Appbar's Popup Button
  void _popUpAction(int i) {
    switch(i) {
      case 1:
        setState(() {
          Data.chat.clear();
        });
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsTab()));
    }
  }
}
