import 'dart:typed_data';
import 'package:hrtvirtual/src/extension/comm_serial.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';

class HrtComm {
  String? port;
  final _commSerial = CommSerial();
  HrtComm([this.port, void Function(String)? dataFunc]) {
    if (port != null) {
      connect(port!, dataFunc);
    }
  }

  List<String> get availablePorts => _commSerial.availablePorts;

  String readFrame() {
    final resp = _commSerial.readSerial();
    return resp
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  bool writeFrame(String data) {
    final resp =
        data.splitByLength(2).map((e) => int.parse(e, radix: 16)).toList();
    return _commSerial.writeSerial(Uint8List.fromList(resp));
  }

  void connect([
    String? port,
    void Function(String)? dataFunc,
  ]) {
    _commSerial.openSerial(port ?? (this.port ?? availablePorts[0]),
        baudRate: 19200, bytesize: 8, parity: 0, stopbits: 1);
    if (dataFunc != null) {
      _commSerial.listenReader(
        (data) {
          dataFunc(
            data
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join()
                .toUpperCase(),
          );
        },
      );
    }
  }

  void disconnect() {
    _commSerial.closeSerial();
  }
}
