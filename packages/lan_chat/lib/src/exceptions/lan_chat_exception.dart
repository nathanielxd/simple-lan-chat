class LanChatException implements Exception {

  final String message;
  const LanChatException(this.message);

  factory LanChatException.uninitialized() 
  => LanChatException('Lan Chat is uninitialized and socket is not open.');

  factory LanChatException.failedToProcessFile()
  => LanChatException('Failed to process multi-part file.');

  factory LanChatException.socket()
  => LanChatException('There was a problem with the socket. Please restart and try again.');

  @override
  String toString() => message;
}