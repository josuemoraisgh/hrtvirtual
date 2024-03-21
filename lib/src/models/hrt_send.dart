import 'package:hrtvirtual/src/models/hrt_frame.dart';
import 'package:hrtvirtual/src/models/hrt_storage.dart';

class HrtSend {
  final _hrtFrameWrite = HrtFrame();
  final HrtFrame _hrtFrameRead;
  final HrtStorage _hrtStorage;
  HrtSend(this._hrtStorage, this._hrtFrameRead) {
    init();
  }

  String get frame => _hrtFrameWrite.frame;

  init() async {
    _hrtFrameWrite.addressType =
        (await _hrtStorage.getVariable('address_type')) == "0" ? false : true;
    _hrtFrameWrite.frameType = (await _hrtStorage.getVariable('frame_type'));
    if (_hrtFrameWrite.addressType) {
      _hrtFrameWrite.manufacterId =
          await _hrtStorage.getVariable('manufacturer_id');
      _hrtFrameWrite.deviceType = await _hrtStorage.getVariable('device_type');
      _hrtFrameWrite.masterAddress =
          (await _hrtStorage.getVariable('master_address')) == "0"
              ? false
              : true;
      _hrtFrameWrite.manufacterId =
          await _hrtStorage.getVariable('manufacter_id');
      _hrtFrameWrite.deviceType = await _hrtStorage.getVariable('device_type');
      _hrtFrameWrite.deviceId = await _hrtStorage.getVariable('device_id');
    } else {
      _hrtFrameWrite.address = "";
    }
    if (_hrtFrameWrite.frameType == "06") {
      request();
    } else {
      response();
    }
  }

  request() async {
    switch (_hrtFrameRead.command) {
      case '00': //Identity Command
        _hrtFrameWrite.body = "";
        break;
      case '01': //Read Primary Variable
        _hrtFrameWrite.body = "";
        break;
      case '02': //Read Loop Current And Percent Of Range
        _hrtFrameWrite.body = "";
        break;
      case '03': //Read Dynamic Variables And Loop Current
        _hrtFrameWrite.body = "";
        break;
      case '06': //Write Polling Address
        _hrtFrameWrite.body = "${_hrtStorage.getVariable('polling_address')}"
            "${_hrtStorage.getVariable('loop_current_mode')}";
        break;
      case '07': //Read Loop Configuration
        _hrtFrameWrite.body = "";
        break;
      case '08': //Read Dynamic Variable Classifications
        _hrtFrameWrite.body = "";
        break;
      case '09': //Read Device Variables with Status
        _hrtFrameWrite.body = "";
        break;
      case '11': //Read Unique Identifier Associated With Tag
        _hrtFrameWrite.body = await _hrtStorage.getVariable('tag');
        break;
      case '0C': //Read Message (12)
        _hrtFrameWrite.body = "";
        break;
      case '0D': //Read Tag, Descriptor, Date (13)
        _hrtFrameWrite.body = "";
        break;
      case '21': //Read Device Variables (33)
        _hrtFrameWrite.body = "";
    }
  }

  response() async {
    switch (_hrtFrameRead.command) {
      case '00': //Identity Command
        _hrtFrameWrite.body = "00" //error_code
            "FE"
            "${await _hrtStorage.getVariable('master_slave', 'manufacturer_id')}"
            "${await _hrtStorage.getVariable('device_type')}"
            "${await _hrtStorage.getVariable('request_preambles')}"
            "${await _hrtStorage.getVariable('hart_revision')}"
            "${await _hrtStorage.getVariable('software_revision')}"
            "${await _hrtStorage.getVariable('transmitter_revision')}"
            "${await _hrtStorage.getVariable('hardware_revision')}"
            "${await _hrtStorage.getVariable('device_flags')}"
            "${await _hrtStorage.getVariable('device_id')}";
        break;
      case '01': //Read Primary Variable
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}";
        break;
      case '02': //Read Loop Current And Percent Of Range
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('loop_current')}"
            "${await _hrtStorage.getVariable('percent_of_range')}";
        break;
      case '03': //Read Dynamic Variables And Loop Current
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('loop_current')}"
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}"
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}"
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}"
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}";
        break;
      case '06': //Write Polling Address
        final pollingAddress = _hrtFrameRead.body.substring(0, 2);
        final loopCurrentMode = _hrtFrameRead.body.substring(2);
        _hrtStorage.setVariable('polling_address', pollingAddress);
        _hrtStorage.setVariable('loop_current_mode', loopCurrentMode);
        _hrtFrameWrite.body = "00" //error_code
            "$pollingAddress"
            "$loopCurrentMode";
        break;
      case '07': //Read Loop Configuration
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('polling_address')}"
            "${await _hrtStorage.getVariable('loop_current_mode')}";
        break;
      case '08': //Read Dynamic Variable Classifications
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('primary_variable_classification')}"
            "${await _hrtStorage.getVariable('secondary_variable_classification')}"
            "${await _hrtStorage.getVariable('tertiary_variable_classification')}"
            "${await _hrtStorage.getVariable('quaternary_variable_classification')}";
        break;
      case '09': //Read Device Variables with Status
        _hrtFrameWrite.body = "";
        break;
      case '11': //Read Unique Identifier Associated With Tag
        _hrtFrameWrite.body =
            "${(_hrtFrameRead.body == await _hrtStorage.getVariable('tag')) ? '00' : '01'}" //error_code 00 - ok | 01 - undefined
            "FE"
            "${await _hrtStorage.getVariable('master_slave', 'manufacturer_id')}"
            "${await _hrtStorage.getVariable('device_type')}"
            "${await _hrtStorage.getVariable('request_preambles')}"
            "${await _hrtStorage.getVariable('hart_revision')}"
            "${await _hrtStorage.getVariable('software_revision')}"
            "${await _hrtStorage.getVariable('transmitter_revision')}"
            "${await _hrtStorage.getVariable('hardware_revision')}"
            "${await _hrtStorage.getVariable('device_flags')}"
            "${await _hrtStorage.getVariable('device_id')}";

        break;
      case '0C': //Read Message (12)
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('Message')}";
        break;
      case '0D': //Read Tag, Descriptor, Date (13)
        _hrtFrameWrite.body = "00" //error_code
            "${await _hrtStorage.getVariable('tag')}"
            "${await _hrtStorage.getVariable('descriptor')}"
            "${await _hrtStorage.getVariable('date')}";
        break;
      case '21': //Read Device Variables (33)
        _hrtFrameWrite.body = switch (_hrtFrameRead.body) {
          '00' => '08 00 00 00 27 40 EE 2D 42',
          '01' => '08 00 00 01 39 41 AC 26 AA',
          '02' => '08 00 00 02 20 41 CF 95 40',
          '03' => '08 00 00 03 20 41 C8 D9 90',
          '04' => '08 00 00 04 39 41 AC 26 21',
          '05' => '08 00 00 05 39 00 00 00 00',
          '0C' => '08 00 00 0C 33 3F 80 00 00',
          '19' => '08 00 40 19 00 42 DD 26 1B',
          _ => '08 00 00 00 00 7F A0 00 00',
        };
    }
  }
}
