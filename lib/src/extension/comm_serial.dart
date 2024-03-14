import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CommSerial extends Disposable {
  SerialPort? _sp;
  SerialPortReader? _reader;

  bool get isOpen => _sp!.isOpen;

  void listenReader(void Function(Uint8List) dataFunc) {
    if (_sp!.isOpen) {
      if (_reader != null) _reader!.close();
      _reader = SerialPortReader(_sp!);
      final stream = _reader!.stream;
      stream.listen(dataFunc);
    }
  }

  bool openSerial(String port,
      {int? baudRate, int? bytesize, int? parity, int? stopbits}) {
    if (_sp != null) if (_sp!.isOpen) _sp!.close();
    _sp = SerialPort(port);
    _sp!.config.setFlowControl(SerialPortFlowControl.xonXoff);
    _sp!.config.xonXoff = SerialPortXonXoff.inOut;
    if (baudRate != null) {
      _sp!.config.baudRate = baudRate;
    }
    if (bytesize != null) {
      _sp!.config.bits = bytesize;
    }
    if (parity != null) {
      _sp!.config.parity = parity;
    }
    if (stopbits != null) {
      _sp!.config.stopBits = stopbits;
    }
    _sp!.openReadWrite();
    if (_sp!.isOpen) {
      _reader = SerialPortReader(_sp!);
      return true;
    }
    return false;
  }

  bool closeSerial() {
    if (_sp != null) {
      if (_sp!.isOpen) {
        _sp!.close();
        if (_reader != null) _reader!.close();
        return true;
      }
    }
    return false;
  }

  Uint8List readSerial() {
    if (_sp != null) {
      if (_sp!.isOpen) {
        return _sp!.read(_sp!.bytesAvailable);
      }
    }
    return Uint8List(0);
  }

  bool writeSerial(Uint8List write) {
    int tam = 0;
    if (_sp != null) {
      if (_sp!.isOpen) {
        if (write.isNotEmpty) {
          tam = _sp!.write(write, timeout: 0);
        }
        if (tam >= write.length) return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    closeSerial();
  }
}
