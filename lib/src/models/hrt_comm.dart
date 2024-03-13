import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class HrtComm {
  late SerialPort _port;
  late Uint8List _data;
  String _device = "";
  HrtComm([SerialPort? client]) {
    if (client != null) {
      _port = client;
    }
  }

  List<String> get getDevices => SerialPort.availablePorts;
  Stream<Uint8List> get onRead => SerialPortReader(_port).stream;

  bool get hasData {
    _data.addAll(_port.read(_port.bytesAvailable));
    return true;
  }

  String readFrame() {
    return _port
        .read(_port.bytesAvailable)
        .map((e) => e.toRadixString(16))
        .reduce((value, element) => '$value $element');
  }

  int write(String data) {
    return _port.write(Uint8List.fromList(data.codeUnits));
  }

  Future<bool> connectTo(String device) async {
    if (_device != device) {
      if (_port.isOpen) _port.close();
      _device = device;
      _port = SerialPort(device);
      if (!_port.openReadWrite()) {
        //print(SerialPort.lastError);
        return false;
      }
    }
    return true;
  }

  void disconnect() {
    _port.close();
  }
}
