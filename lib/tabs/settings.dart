import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:simple_lan_chat/data.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatefulWidget {

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  TextEditingController changePortController = TextEditingController();

  void saveSettings() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', Data.isDarkMode);
    prefs.setBool('isDefaultPort', Data.isDefaultPort);
    prefs.setBool('isPortChangerEnabled', Data.isPortChangerEnabled);
    prefs.setBool('isChatReversed', Data.isChatReversed);
    prefs.setBool('isNotifications', Data.isNotifications);

    prefs.setDouble('font', Data.font);
    prefs.setInt('port', Data.port);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      resizeToAvoidBottomPadding: false,
      body: ListView(
        children: <Widget>[
          _header('General Settings'),
          _switchListTile('Dark Mode', Data.isDarkMode, onChanged: ((value){
            setState(() {
              Data.isDarkMode = value;
              if(value == true) {
                DynamicTheme.of(context).setBrightness(Brightness.dark);
              } else {
                DynamicTheme.of(context).setBrightness(Brightness.light);
              }
              saveSettings();
            });
          })),
          _switchListTile('Reverse Chat', Data.isChatReversed, onChanged: ((value){
            setState(() {
              Data.isChatReversed = value;
              Data.chat = Data.chat.reversed.toList();
              saveSettings();
            });
          })),
          _sliderListTile('Font Size', Data.font, 10, 20, onChanged: ((value){
            setState(() {
              Data.font = value;
            });
          }), onChangeEnd: ((value){
            saveSettings();
          })),
          _switchListTile('Notifications', Data.isNotifications, onChanged: ((value){
            setState(() {
              Data.isNotifications = value;
              if(value == true) Toast.show('The app will send notifications when is minimized.', context, duration: 6);
              saveSettings();
            });
          })),
          Divider(height: 1),
          _header('Network Settings'),
          _switchListTile('Use default port (1050)', Data.isDefaultPort, onChanged: ((value){
            setState(() {
              Data.isDefaultPort = value;
              if(value == false) {
                Data.isPortChangerEnabled = true;
              }
              else {
                Data.isPortChangerEnabled = false;
                Data.port = 1050;
              }
              Data.portStream.sink.add(1050);
              saveSettings();
            });
          })),
          _listTile('Change port', 'Change the chat\'s port. Current: ' + Data.port.toString(), 
            enabled: Data.isPortChangerEnabled,
            onTap: (){
              showDialog(
                context: context,
                builder: (context) => _changePortDialog()
              );
            }
          ),
          Divider(height: 1),
          _header('Extras'),
          _listTile('About', null, onTap: (){
            showAboutDialog(
              context: context,
              applicationName: 'Simple LAN Chat',
              applicationVersion: '0.9.2',
              children: [
                Text('This app was made to act like a simple chat connected to your LAN. \n' +
                'It listens to all UDP packets and broadcasts messages to all local addresses. \n' +
                'It can also be used to listen to packets on a certain port. \n' + 
                'To chat, all users need to be connected to the same network and port \n', style: TextStyle(fontSize: 13)),
                Text('If you like my app, please visit my Github and leave a feedback! Thank you!')
              ]
            );
          }),
          _listTile('GitHub', null, onTap: (){
            _launchUrl('https://github.com/nathanielxd/simple-lan-chat');
          }),
        ],
      )
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: TextStyle(
        color: Colors.blueGrey
      )),
    );
  }

  Widget _switchListTile(String title, bool value, {void Function(bool) onChanged}) {
    return SwitchListTile(
      title: Text(title),
      activeColor: Colors.blue,
      value: value,
      onChanged: onChanged
    );
  }

  Widget _listTile(String title, String subtitle, {bool enabled = true, void Function() onTap}) {
    if(subtitle != null) {
      return ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        enabled: enabled,
        onTap: onTap,
      );
    }
    else {
      return ListTile(
        title: Text(title),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        enabled: enabled,
        onTap: onTap,
      );
    }
  }

  Widget _sliderListTile(String title, double value, double min, double max,
  {void Function(double) onChanged, void Function(double) onChangeEnd}) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        width: 220,
        child: Row(
          children: [
            Text(Data.font.toInt().toString()),
            Slider(
              min: min, max: max,
              value: value,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ]
        ),
      ),
    );
  }

  AlertDialog _changePortDialog() {
    return AlertDialog(
      title: Text('Change Port'),
      content: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Text('You\'re going to change the port this app is listening on the LAN.', style: TextStyle(fontSize: 14)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: Text('Please RESTART THE APP after you change the port. Keep in mind it might break the app.', style: TextStyle(fontSize: 14, color: Colors.red)),
            ),
            Text('Make sure not to change it in an official or reserved port.', style: TextStyle(fontSize: 12)),
            TextField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              controller: changePortController,
              decoration: InputDecoration(
                hintText: 'Port',
                hintStyle: TextStyle(
                  fontSize: 18
                )
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('ACCEPT'),
          onPressed: (){
            int port = int.parse(changePortController.text);
            Data.port = port;
            Data.portStream.sink.add(port);

            saveSettings();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void _launchUrl(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show('Could not connect.', context);
    }
  }
}