//Retorna a posição que termina o preamble
//PREAMBLE  DELIMITER  ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes    1bytes     1bytes   1bytes   1byte   xbytes 1byte
//                                         OU
// PREAMBLE DELIMITER MANUFACTERID DEVICETYPE ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes   1bytes    1bytes       1bytes     3bytes   1bytes   1byte   xbytes 1byte
import 'package:hrtvirtual/src/extension/bit_field_int.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';

class HrtFrame {
  String log = "";
  int posIniFrame = 0;
  String preamble = "FFFFFFFF";
  String _delimiter = "00";
  bool _addressType = false;
  String _frameType = "02";
  bool _masterAddress = true;
  bool _burstMode = false;
  String _manufacterId = "00";
  String _deviceType = "00";
  String _address = "00";
  String _deviceId = "00";
  String _pollingAddress = "00";
  String command = "00";
  int _nBBody = 0;
  String _body = "";
  String checkSum = "00";

  HrtFrame([String? frame]) {
    if (frame != null) {
      extractFrame(frame);
    }
  }

  String calcCheckSum() {
    final listFrame =
        (_delimiter + address + command + _nBBody.toRadixString(16) + _body)
            .splitByLength(2);
    return listFrame
        .reduce((value, element) =>
            (int.parse(value, radix: 16) ^ int.parse(element, radix: 16))
                .toRadixString(16))
        .toUpperCase()
        .padLeft(2, '0');
  }

  String get frame {
    String resp = "";
    try {
      log = "";

      resp = preamble +
          _delimiter +
          address +
          command +
          _nBBody.toRadixString(16).padLeft(2, '0') +
          _body +
          calcCheckSum();
    } catch (e) {
      log = "Incorrect Value form Frame";
    }
    return resp;
  }

  set frame(String hrtFrame) {
    log = "";
    extractFrame(hrtFrame);
  }

  void extractFrame(String strFrame) {
    try {
      //Calcula a posIniFrame
      final listFrame = strFrame.splitByLength(2).join(" ");
      int iniFrameAux =
          listFrame.indexOf(RegExp(r'FF ([^F][A-F0-9]|[A-F0-9][^F])'));
      if (iniFrameAux == -1) {
        log = "Don't find Preamble in Frame";
        return;
      } else {
        posIniFrame = (2 * iniFrameAux + 6) ~/ 3;
      }
      ////////////////// Preamble ////////////////////////
      preamble = strFrame.substring(0, posIniFrame);

      ////////////////// Delimiter ////////////////////////
      delimiter = strFrame.substring(posIniFrame, posIniFrame + 2);

      if (addressType == false) {
        ////////////////// Address ////////////////////////
        address = strFrame.substring(posIniFrame + 2, posIniFrame + 4);
        ////////////////// Command ////////////////////////
        command = strFrame.substring(posIniFrame + 4, posIniFrame + 6);
        ////////////////// Nbbody e o Body ////////////////////////
        //Extrai o numero de bytes do body [nbbody] e o body
        _nBBody = int.parse(
            strFrame.substring(posIniFrame + 6, posIniFrame + 8),
            radix: 16);
        _body =
            strFrame.substring(posIniFrame + 8, posIniFrame + 8 + 2 * _nBBody);
      } else {
        ////////////////// Address ////////////////////////
        address = strFrame.substring(posIniFrame + 2, posIniFrame + 12);
        ////////////////// Command ////////////////////////
        command = strFrame.substring(posIniFrame + 12, posIniFrame + 14);
        ////////////////// Nbbody e o Body ////////////////////////
        //Extrai o numero de bytes do body [nbbody] e o body
        _nBBody = int.parse(
            strFrame.substring(posIniFrame + 14, posIniFrame + 16),
            radix: 16);
        _body = strFrame.substring(
            posIniFrame + 16, posIniFrame + 16 + 2 * _nBBody);
      }

      ////////////////// CheckSum ////////////////////////
      //Extrai o CheckSum e checa se ele esta correto.
      checkSum = strFrame.substring(strFrame.length - 2);
      if (calcCheckSum() != checkSum) {
        log = "Incorrect CheckSum";
      }
    } catch (e) {
      log = "Incorrect hart Frame size";
    }
  }

  //O nBBody só pode ser lido não escrito
  int get nBBody => _nBBody;

  //Setando o body ja seta o nBBody
  String get body => _body;
  set body(String newBody) {
    _nBBody = newBody.length ~/ 2;
    _body = newBody;
  }

  //Alterando o frameType altera o delimiter
  String get frameType => _frameType;
  set frameType(String newFrameType) {
    _frameType = newFrameType;
    final value = int.parse(_delimiter, radix: 16);
    value.setBits(0, 3, int.parse(_frameType, radix: 16));
    _delimiter = value.toRadixString(16).padLeft(2, '0');
  }

  //Alterando o addressType altera o delimiter
  bool get addressType => _addressType;
  set addressType(bool newAddressType) {
    _addressType = newAddressType;
    final value = int.parse(_delimiter, radix: 16);
    value.setBits(7, 1, _addressType == true ? 1 : 0);
    _delimiter = value.toRadixString(16).padLeft(2, '0');
  }

  //Alterando o delimiter tem que alterar o addressType e o frameType
  String get delimiter => _delimiter;
  set delimiter(String newDelimiter) {
    _delimiter = newDelimiter;
    final valueAux = int.parse(_delimiter, radix: 16);
    //Extrai o address type
    _addressType = valueAux.getBits(7, 1) == 1 ? true : false;
    //Extrai o frame type
    _frameType = valueAux.getBits(0, 3).toRadixString(16).padLeft(2, '0');
  }

  //Alterando o adress tem que alterar: _masterAddress, _burstMode, _pollingAddress, manufacterId, deviceType, deviceId
  String get address => _address;
  set address(String newAddress) {
    _address = newAddress;
    final id = _address.substring(posIniFrame, posIniFrame + 2);
    final valueAux = int.parse(id, radix: 16);
    //Extrai o master_slave
    _masterAddress = valueAux.getBits(7, 1) == 1 ? true : false;
    //Extrai o Burst Mode
    _burstMode = valueAux.getBits(6, 1) == 1 ? true : false;
    if (_addressType == false) {
      //Extrai o polling_address
      _pollingAddress =
          valueAux.getBits(0, 6).toRadixString(16).padLeft(2, '0');
      manufacterId = "";
      deviceType = "";
      deviceId = "";
    } else {
      //Extrai o manufacter_id
      _pollingAddress = "";
      manufacterId = valueAux.getBits(0, 6).toRadixString(16).padLeft(2, '0');
      deviceType = _address.substring(posIniFrame + 2, posIniFrame + 4);
      deviceId = _address.substring(posIniFrame + 4, posIniFrame + 10);
    }
  }

  bool get masterAddress => _masterAddress;
  set masterAddress(bool newMasterAddress) {
    // 1 - primary master; 0 - secondary master
    _masterAddress = newMasterAddress;
    final valueAux = int.parse(_address.substring(0, 2), radix: 16);
    _address = valueAux
            .setBits(7, 1, _masterAddress ? 1 : 0)
            .toRadixString(16)
            .padLeft(2, '0') +
        _address.substring(2);
  }

  bool get burstMode => _burstMode;
  set burstMode(bool newBurstMode) {
    // 1 - in Burst Mode; 0 - not Burst Mode or Slave
    _burstMode = newBurstMode;
    final valueAux = int.parse(_address.substring(0, 2), radix: 16);
    _address = valueAux
            .setBits(6, 1, newBurstMode ? 1 : 0)
            .toRadixString(16)
            .padLeft(2, '0') +
        _address.substring(2);
  }

  String get pollingAddress => _pollingAddress;
  set pollingAddress(String newPollingAddress) {
    if (_addressType == false) {
      _pollingAddress = newPollingAddress;
      final valueAux = int.parse(_address.substring(0, 2), radix: 16);
      _address = valueAux
              .setBits(0, 6, int.parse(_pollingAddress, radix: 16))
              .toRadixString(16)
              .padLeft(2, '0') +
          _address.substring(2);
    } else {
      log = "pollingAddress incoerent with addressType";
    }
  }

  String get manufacterId => _manufacterId;
  set manufacterId(String newManufacterId) {
    if (_addressType == true) {
      _manufacterId = newManufacterId;
      final valueAux = int.parse(_address.substring(0, 2), radix: 16);
      _address = valueAux
              .setBits(0, 6, int.parse(_manufacterId, radix: 16))
              .toRadixString(16)
              .padLeft(2, '0') +
          _address.substring(2);
    } else {
      log = "manufacterId incoerent with addressType";
    }
  }

  String get deviceType => _deviceType;
  set deviceType(String newDeviceType) {
    if (_addressType == true && deviceType.length == 2) {
      _deviceType = newDeviceType;
      _address = _address.substring(0, 2) + _deviceType + _address.substring(4);
    } else {
      log = "deviceType incoerent with addressType";
    }
  }

  String get deviceId => _deviceId;
  set deviceId(String newDeviceId) {
    if (_addressType == true && newDeviceId.length == 6) {
      _deviceId = newDeviceId;
      _address = _address.substring(0, 4) + _deviceId;
    } else {
      log = "deviceId incoerent with addressType";
    }
  }
}
