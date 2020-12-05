library lan;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesomelanchat/logic/data.dart';
import 'package:awesomelanchat/logic/entities/connection.dart';
import 'package:awesomelanchat/logic/entities/lan_entities.dart';
import 'package:awesomelanchat/logic/user_preferences.dart';

part 'lan_chat.dart';
part 'lan_heartbeat.dart';

final _ia255 = InternetAddress('255.255.255.255');
final int _port = 1050;
final int _hbPort = 1051;

String ownAddress;