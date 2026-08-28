class ArduinoService {
  bool connected = false;

  Future<bool> connect() async {
    // Arduino communication will be implemented here.
    connected = true;
    return connected;
  }

  void disconnect() {
    connected = false;
  }

  bool get isConnected => connected;
}
