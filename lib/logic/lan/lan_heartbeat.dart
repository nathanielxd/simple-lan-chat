part of lan;

class LanHeartbeat {
  
  final _streamController = StreamController<List<Connection>>();
  RawDatagramSocket _socket;
  Timer _sendTimer;

  List<Connection> connections = List();

  Stream<List<Connection>> get stream => _streamController.stream;

  Future<void> initialize() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _hbPort);
    _socket.broadcastEnabled = true;

    // Recognize the current device.
    _socket.send(utf8.encode('own'), _ia255, _hbPort);
    ownAddress = _socket.receive().address.address;

    startSendingHeartbeats();

    _socket.listen((event) async { 
      final datagram = _socket.receive();

      if(datagram != null) {
        final data = utf8.decode(datagram.data);
        if(data.substring(0, 2).compareTo('hb') == 0) {
          final address = datagram.address.address;
          final nickname = data.substring(2);

          // Find connection by address. 
          // If the address is not found, create a new one and add it to connections.
          final connection = connections.firstWhere((element) 
            => element.address.compareTo(address) == 0, 
            orElse: () {
              final c = Connection(address);
              connections.add(c);
              return c;
            }
          );

          connection.nickname = nickname;
          connection.beat();
          _streamController.add(connections);
        }
      }
    });
  }

  void startSendingHeartbeats() {
    _sendTimer = Timer.periodic(Duration(seconds: 1), (t) {
      var beat = 'hb';
      if(UserPreferences.nickname != null)
        beat += UserPreferences.nickname;

      final data = utf8.encode(beat);
      _socket.send(data, _ia255, _hbPort);
    });
  }

  void stopSendingHeartbeats() {
    _sendTimer.cancel();
  }

  void dispose() {
    _streamController.close();
    _sendTimer.cancel();
    _socket.close();
  }
}