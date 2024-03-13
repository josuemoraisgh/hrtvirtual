import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class CommSerial {
  SerialPort? sp;

  bool openSerial(String port,
      {int? baudRate, int? bytesize, int? parity, int? stopbits}) {
    if (sp != null) if (sp!.isOpen) sp!.close();
    sp = SerialPort(port);
    sp!.config.setFlowControl(SerialPortFlowControl.xonXoff);
    sp!.config.xonXoff = SerialPortXonXoff.inOut;
    if (baudRate != null) {
      sp!.config.baudRate = baudRate;
    }
    if (bytesize != null) {
      sp!.config.bits = bytesize;
    }
    if (parity != null) {
      sp!.config.parity = parity;
    }
    if (stopbits != null) {
      sp!.config.stopBits = stopbits;
    }
    sp!.openReadWrite();
    if (sp!.isOpen) {
      return true;
    }
    return false;
  }

  bool closeSerial() {
    if (sp != null) {
      if (sp!.isOpen) {
        sp!.close();
        return true;
      }
    }
    return false;
  }

  Uint8List readSerial() {
    if (sp != null) {
      if (sp!.isOpen) {
        return sp!.read(sp!.bytesAvailable);
      }
    }
    return Uint8List(0);
  }

  bool writeSerial(Uint8List write) {
    int tam = 0;
    if (sp != null) {
      if (sp!.isOpen) {
        if (write.isNotEmpty) {
          tam = sp!.write(write);
        }
        if (tam >= write.length) return true;
      }
    }
    return false;
  }
}
