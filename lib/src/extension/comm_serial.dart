import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CommSerial extends Disposable {
  SerialPort? _sp;
  SerialPortReader? _reader;

  List<String> get availablePorts => SerialPort.availablePorts;

  bool get isOpen => _sp!.isOpen;

  void listenReader(void Function(Uint8List) dataFunc) {
    if (_reader != null) {
      _reader!.stream.listen(dataFunc);
    }
  }

  // baudrate The baudrate to set.
  // bits The number of data bits to use (5, 6, 7 or 8).
  // parity The parity setting to use (0 = none, 1 = even, 2 = odd).
  // stopbits The number of stop bits to use (1 or 2).
  // flowcontrol The flow control settings to use (0 = none,
  // rts Status of RTS line (0 or 1; required by some interfaces).
  // dtr Status of DTR line (0 or 1; required by some interfaces).
  bool openSerial(String port,
      {int? baudRate,
      int? bytesize,
      int? parity,
      int? stopbits,
      void Function(Uint8List)? funcRead}) {
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
      if (funcRead != null) {
        _reader = SerialPortReader(_sp!);
        if (_reader != null) {
          _reader!.stream.listen(funcRead);
        }
      }
      return true;
    }
    return false;
  }

  bool closeSerial() {
    bool resp = false;
    if (_sp != null) {
      if (_sp!.isOpen) {
        resp = _sp!.close();
        if (_reader != null) _reader!.close();
      }
    }
    return resp;
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
          tam = _sp!.write(write);
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
