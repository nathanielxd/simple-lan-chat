import 'dart:async';

import 'package:awesomelanchat/logic/lan/lan.dart';

class Connection {

  final String address;

  DateTime lastSeen;
  String nickname;
  bool active = false;

  Timer _timer;

  Connection(this.address, {this.nickname});

  void beat() {
    active = true;
    lastSeen = DateTime.now();
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 2), () { 
      active = false;
    });
  }

  bool get isOwn => ownAddress != null && ownAddress.compareTo(address) == 0;
}