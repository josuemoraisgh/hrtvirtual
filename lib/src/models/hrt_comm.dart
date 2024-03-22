import 'dart:typed_data';
import 'package:hrtvirtual/src/extension/comm_serial.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';

class HrtComm {
  String? port;
  void Function(String)? funcRead;
  final _commSerial = CommSerial();
  HrtComm([this.port, this.funcRead]) {
    connect(port, funcRead);
  }

  List<String> get availablePorts => _commSerial.availablePorts;

  String readFrame() {
    final resp = _commSerial.readSerial();
    return resp
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  bool get isConnected => _commSerial.isOpen;

  bool writeFrame(String data) {
    final resp =
        data.splitByLength(2).map((e) => int.parse(e, radix: 16)).toList();
    return _commSerial.writeSerial(Uint8List.fromList(resp));
  }

  bool connect([
    String? port,
    void Function(String)? funcRead,
  ]) {
    final funcReadAux = funcRead ?? this.funcRead;
    return (port ?? this.port) != null
        ? _commSerial.openSerial(
            port ?? this.port!,
            baudRate: 19200,
            bytesize: 8,
            parity: 0,
            stopbits: 1,
            funcRead: funcReadAux != null
                ? (data) {
                    funcReadAux(
                      data
                          .map((e) => e.toRadixString(16).padLeft(2, '0'))
                          .join()
                          .toUpperCase(),
                    );
                  }
                : null,
          )
        : false;
  }

  bool disconnect() {
    return _commSerial.closeSerial();
  }
}
