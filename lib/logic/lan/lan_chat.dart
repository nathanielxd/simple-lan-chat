part of lan;

class LanChat {

  static final _streamController = StreamController<List<Message>>.broadcast();
  RawDatagramSocket _socket;

  List<Message> messages = List();

  static Stream<List<Message>> get stream => _streamController.stream;
  
  Future<void> initialize() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _port);
    _socket.broadcastEnabled = true;

    // Start listening to packets.
    _socket.listen((RawSocketEvent event) async {
      final datagram = _socket.receive();

      if(datagram != null) {
        final address = datagram.address.address;
        // Handle text message.
        if(datagram.data[0] == textMessageIDENTIFIER) {
          final data = utf8.decode(datagram.data.sublist(1));

          if(messages.isEmpty ||
          messages.last.address.compareTo(address) != 0 || 
          messages.last is FileMessage) {
            final message = TextMessage(
              address: address,
              dateTime: DateTime.now(),
              messages: [data]
            );
            messages.add(message);
          }
          else {
            (messages.last as TextMessage).messages.add(data);
          }
          _streamController.add(messages);
        }
        // Handle file message.
        else if(datagram.data[0] == fileMessageIDENTIFIER) {
            final data = datagram.data;
            final nameLength = data[2];
            final name = utf8.decode(data.sublist(3, nameLength + 3));
          // Single-part file.
          if(datagram.data[1] == fileMessageIDENTIFIER) {
            final file = data.sublist(nameLength + 3);

            final fileMessage = FileMessage(
              address: address,
              dateTime: DateTime.now(),
              name: name,
              data: file
            );

            messages.add(fileMessage);
            _streamController.add(messages);
          }
          // Multi-part file.
          else {
            // Get first chop of file.
            var file = List<int>.from(datagram.data.sublist(nameLength + 3));
            for(int i = datagram.data[0]; i < datagram.data[1]; i++) {
              final newData = _socket.receive().data.sublist(nameLength + 3);
              file.addAll(newData);
            }

            final fileMessage = FileMessage(
              address: address,
              dateTime: DateTime.now(),
              name: name,
              data: Uint8List.fromList(file)
            );
            messages.add(fileMessage);
            _streamController.add(messages);
          }
        }
      }
    });
  }

  void sendMessage(String message) {
    var data = List<int>.from(utf8.encode(message));
    data.insert(0, textMessageIDENTIFIER);
    _socket.send(data, _ia255, _port);
  }

  Future<void> sendFile(String fileName, Uint8List file) async {
    var data = List<int>.from(file);

    // If the image is bigger than 50000 bytes, chop it up and send it by parts.
    if(data.length > 50000) {
      // In how many parts we need to chop our image? [count] is minimum 2.
      int count = (data.length / 50000).ceil();

      for(int i = 0; i < count; i++) {
        var chop = data.sublist(
          (data.length * i / count).floor(),
          (data.length * (i + 1) / count).floor()
        );

        final bytes = List<int>();
        // Add identifiers.
        bytes.add(fileMessageIDENTIFIER + i);
        bytes.add(fileMessageIDENTIFIER + count - 1);
        // Add file name length and file name.
        bytes.add(fileName.length);
        bytes.addAll(utf8.encode(fileName));
        bytes.addAll(chop);

        _sendToConnections(bytes, _port);
      }
    }
    else {
      final bytes = List<int>();
      // Add identifiers.
      bytes.add(fileMessageIDENTIFIER);
      bytes.add(fileMessageIDENTIFIER);
      // Add file name length and file name.
      bytes.add(fileName.length);
      bytes.addAll(utf8.encode(fileName));
      bytes.addAll(data);
      
      _sendToConnections(bytes, _port);
    }
  }

  void _sendToConnections(List<int> data, int port) {
    Data.heartbeat.connections.forEach((con) {
      _socket.send(data, InternetAddress.tryParse(con.address), _port);
    });
  }

  void dispose() {
    _streamController.close();
    _socket.close();
  }
}