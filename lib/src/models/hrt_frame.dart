//Retorna a posição que termina o preamble
//PREAMBLE  DELIMITER  ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes    1bytes     1bytes   1bytes   1byte   xbytes 1byte
//                                         OU
// PREAMBLE DELIMITER MANUFACTERID DEVICETYPE ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes   1bytes    1bytes       1bytes     3bytes   1bytes   1byte   xbytes 1byte
import 'package:hctvirtual/src/extension/dec_bin.dart';
import 'package:hctvirtual/src/extension/split_string.dart';

class HrtFrame {
  String log = "";
  int posIniFrame = 0;
  String preamble = "";
  String _delimiter = "";
  bool _isLongFrame = false;
  String manufacterID = "";
  String deviceType = "";
  String address = "";
  String command = "";
  int _nBBody = 0;
  String _body = "";
  String checkSum = "";

  HrtFrame([String? frame]) {
    if (frame != null) {
      extractFrame(frame);
    }
  }

  String calcCheckSum() {
    final listFrame = (_delimiter +
            manufacterID +
            deviceType +
            address +
            command +
            _nBBody.toRadixString(16) +
            _body)
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
          manufacterID +
          deviceType +
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
      //Extrai o preamble
      preamble = strFrame.substring(0, posIniFrame);
      //Extrai o delimiter
      _delimiter = strFrame.substring(posIniFrame, posIniFrame + 2);
      //Extrai o type frame
      final value = int.parse(strFrame.substring(posIniFrame, posIniFrame + 1),
          radix: 16);
      _isLongFrame = value.getBits(3, 1) == 1 ? true : false;
      //Extrai o ManufacterID se houver
      if (_isLongFrame == false) {
        manufacterID = "";
      } else {
        manufacterID = strFrame.substring(posIniFrame + 2, posIniFrame + 4);
      }
      //Extrai o Device Type se houver
      if (_isLongFrame == false) {
        deviceType = "";
      } else {
        deviceType = strFrame.substring(posIniFrame + 4, posIniFrame + 6);
      }
      //Extrai o Address que pode ser de um byte ou tres bytes.
      if (_isLongFrame == false) {
        address = strFrame.substring(posIniFrame + 2, posIniFrame + 4);
      } else {
        address = strFrame.substring(posIniFrame + 6, posIniFrame + 12);
      }
      //Extrai o Command
      if (_isLongFrame == false) {
        command = strFrame.substring(posIniFrame + 4, posIniFrame + 6);
      } else {
        command = strFrame.substring(posIniFrame + 12, posIniFrame + 14);
      }
      //Extrai o numero de bytes do body [nbbody] e o body
      if (_isLongFrame == false) {
        _nBBody = int.parse(
            strFrame.substring(posIniFrame + 6, posIniFrame + 8),
            radix: 16);
        _body =
            strFrame.substring(posIniFrame + 8, posIniFrame + 8 + 2 * _nBBody);
      } else {
        _nBBody = int.parse(
            strFrame.substring(posIniFrame + 14, posIniFrame + 16),
            radix: 16);
        _body = strFrame.substring(
            posIniFrame + 16, posIniFrame + 16 + 2 * _nBBody);
      }
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

  //Alterando o isLongFrame altera o delimiter
  bool get isLongFrame => _isLongFrame;
  set isLongFrame(bool newIsLongFrame) {
    _isLongFrame = newIsLongFrame;
    final value = int.parse(_delimiter, radix: 16);
    value.setBits(7, 1, _isLongFrame == true ? 1 : 0);
    _delimiter = value.toRadixString(16).padLeft(2, '0');
  }

  //Alterando o delimiter tem que alterar o isLongFrame
  String get delimiter => _delimiter;
  set delimiter(String newDelimiter) {
    _delimiter = newDelimiter;
    final value = int.parse(_delimiter, radix: 16);
    _isLongFrame = value.getBits(7, 1) == 1 ? true : false;
  }
}
