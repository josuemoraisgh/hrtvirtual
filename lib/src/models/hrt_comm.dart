import 'dart:typed_data';
import 'package:hctvirtual/src/extension/comm_serial.dart';

class HrtComm {
  final commSerial = CommSerial();
  HrtComm(String? port) {
    if (port != null) {
      connect(port);
    }
  }

  String readFrame() {
    final resp =
        commSerial.readSerial().map((e) => e.toRadixString(16)).toString();
    return resp;
  }

  bool writeFrame(String data) {
    final resp = data.split('').map((e) => int.parse(e, radix: 16)).toList();
    return commSerial.writeSerial(Uint8List.fromList(resp));
  }

  void connect(String port) {
    commSerial.openSerial(port,
        baudRate: 19200, bytesize: 8, parity: 0, stopbits: 1);
  }

  void disconnect() {
    commSerial.closeSerial();
  }
}
