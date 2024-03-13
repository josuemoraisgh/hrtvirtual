//Retorna a posição que termina o preamble
//PREAMBLE  DELIMITER  ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes    1bytes     1bytes   1bytes   1byte   xbytes 1byte
//                                         OU
// PREAMBLE DELIMITER MANUFACTERID DEVICETYPE ADDRESS  COMMAND  NBBody  BODY   CheckSum
// xbytes   1bytes    1bytes       1bytes     3bytes   1bytes   1byte   xbytes 1byte
import 'package:hctvirtual/src/extension/dec_bin.dart';
import 'package:hctvirtual/src/extension/split_string.dart';

class HrtFrame {
  List<String> log = [];
  int posIniFrame = 0;
  String preamble = "";
  String delimiter = "";
  bool isLongFrame = false;
  String manufacterID = "";
  String deviceType = "";
  String address = "";
  String command = "";
  int nBBody = 0;
  String _body = "";
  String checkSum = "";

  HrtFrame({String? hrtFrame}) {
    if (hrtFrame != null) {
      extractFrame(hrtFrame);
    }
  }

  String calculedCheckSum() {
    final listFrame =
        (delimiter + address + command + nBBody.toRadixString(16) + _body)
            .splitByLength(2);
    return listFrame.reduce((value, element) =>
        (int.parse(value, radix: 16) ^ int.parse(element, radix: 16))
            .toRadixString(16));
  }

  String get frame {
    if (isLongFrame == false) {
      //PREAMBLE  DELIMITER  ADDRESS  COMMAND  NBBody  BODY   CheckSum
      // xbytes    1bytes     1bytes   1bytes   1byte   xbytes 1byte
      return preamble +
          delimiter +
          address +
          command +
          nBBody.toRadixString(16) +
          _body +
          calculedCheckSum();
    } else {
      // PREAMBLE DELIMITER MANUFACTERID DEVICETYPE ADDRESS  COMMAND  NBBody  BODY   CheckSum
      // xbytes   1bytes    1bytes       1bytes     3bytes   1bytes   1byte   xbytes 1byte
      return preamble +
          delimiter +
          manufacterID +
          deviceType +
          address +
          command +
          nBBody.toRadixString(16) +
          _body +
          calculedCheckSum();
    }
  }

  set frame(String hrtFrame) {
    extractFrame(hrtFrame);
  }

  void extractFrame(String strFrame) {
    //Calcula a posIniFrame
    final listFrame = strFrame.splitByLength(2).join(" ");
    int iniFrameAux =
        listFrame.indexOf(RegExp(r'FF ([^F][A-F0-9]|[A-F0-9][^F])'));
    if (iniFrameAux == -1) {
      posIniFrame = 0;
      log += ["Don't find Preamble in Frame"];
    } else {
      posIniFrame = (2 * iniFrameAux + 6) ~/ 3;
    }
    //Extrai o preamble
    preamble = strFrame.substring(0, posIniFrame);
    //Extrai o delimiter
    delimiter = strFrame.substring(posIniFrame, posIniFrame + 2);
    //Extrai o type frame
    final value =
        int.parse(strFrame.substring(posIniFrame, posIniFrame + 1), radix: 16);
    isLongFrame = value.getBits(3, 1) == 1 ? true : false;
    //Extrai o ManufacterID se houver
    if (isLongFrame == false) {
      manufacterID = "";
      log += ["Short frame don't have a ManufacterID"];
    } else {
      manufacterID = strFrame.substring(posIniFrame + 2, posIniFrame + 4);
    }
    //Extrai o Device Type se houver
    if (isLongFrame == false) {
      deviceType = "";
      log += ["Short frame don't have a DeviceType"];
    } else {
      deviceType = strFrame.substring(posIniFrame + 4, posIniFrame + 6);
    }
    //Extrai o Address que pode ser de um byte ou tres bytes.
    if (isLongFrame == false) {
      address = strFrame.substring(posIniFrame + 2, posIniFrame + 4);
    } else {
      address = strFrame.substring(posIniFrame + 6, posIniFrame + 12);
    }
    //Extrai o Command
    if (isLongFrame == false) {
      command = strFrame.substring(posIniFrame + 4, posIniFrame + 6);
    } else {
      command = strFrame.substring(posIniFrame + 12, posIniFrame + 14);
    }
    //Extrai o numero de bytes do body [nbbody] e o body
    if (isLongFrame == false) {
      nBBody = int.parse(strFrame.substring(posIniFrame + 6, posIniFrame + 8),
          radix: 16);
      _body = strFrame.substring(posIniFrame + 8, posIniFrame + 8 + 2 * nBBody);
    } else {
      nBBody = int.parse(strFrame.substring(posIniFrame + 14, posIniFrame + 16),
          radix: 16);
      _body =
          strFrame.substring(posIniFrame + 16, posIniFrame + 16 + 2 * nBBody);
    }
    //Extrai o CheckSum e checa se ele esta correto.
    checkSum = strFrame.substring(strFrame.length - 2);
    if (calculedCheckSum() != checkSum) {
      log += ["Incorrect CheckSum"];
    }
  }

  String get body => _body;
  set body(String newBody) {
    nBBody = newBody.length ~/ 2;
    _body = newBody;
  }
}
