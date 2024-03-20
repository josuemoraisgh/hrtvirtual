import 'package:hctvirtual/src/models/hrt_frame.dart';
import 'package:hctvirtual/src/models/hrt_storage.dart';

class HrtRequest {
  final HrtFrame _hrtFrame;
  final HrtStorage _hrtStorage;
  HrtRequest(this._hrtFrame, this._hrtStorage) {
    init();
  }

  String get frame => _hrtFrame.frame;

  init() async {
    switch (_hrtFrame.command) {
      case '00': //Identity Command
        _hrtFrame.body = "00" //error_code
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
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}";
        break;
      case '02': //Read Loop Current And Percent Of Range
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('loop_current')}"
            "${await _hrtStorage.getVariable('percent_of_range')}";
        break;
      case '03': //Read Dynamic Variables And Loop Current
        _hrtFrame.body = "00" //error_code
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
        final pollingAddress = _hrtFrame.body.substring(0, 2);
        final loopCurrentMode = _hrtFrame.body.substring(2);
        _hrtStorage.setVariable('polling_address', pollingAddress);
        _hrtStorage.setVariable('loop_current_mode', loopCurrentMode);
        _hrtFrame.body = "00" //error_code
            "$pollingAddress"
            "$loopCurrentMode";
        break;
      case '07': //Read Loop Configuration
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('polling_address')}"
            "${await _hrtStorage.getVariable('loop_current_mode')}";
        break;
      case '08': //Read Dynamic Variable Classifications
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('primary_variable_classification')}"
            "${await _hrtStorage.getVariable('secondary_variable_classification')}"
            "${await _hrtStorage.getVariable('tertiary_variable_classification')}"
            "${await _hrtStorage.getVariable('quaternary_variable_classification')}";
        break;
      case '09': //Read Device Variables with Status
        _hrtFrame.body = "";
        break;
      case '11': //Read Unique Identifier Associated With Tag
        _hrtFrame.body =
            "${(_hrtFrame.body == await _hrtStorage.getVariable('tag')) ? '00' : '01'}" //error_code 00 - ok | 01 - undefined
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
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('Message')}";
        break;
      case '0D': //Read Tag, Descriptor, Date (13)
        _hrtFrame.body = "00" //error_code
            "${await _hrtStorage.getVariable('tag')}"
            "${await _hrtStorage.getVariable('descriptor')}"
            "${await _hrtStorage.getVariable('date')}";
        break;
      case '21': //Read Device Variables (33)
        _hrtFrame.body = switch (_hrtFrame.body) {
          '00' => '08 00 00 00 27 40 EE 2D 42',
          '01' => '08 00 00 01 39 41 AC 26 AA',
          '02' => '08 00 00 02 20 41 CF 95 40',
          '03' => '08 00 00 03 20 41 C8 D9 90',
          '04' => '08 00 00 04 39 41 AC 26 21',
          '05' => '08 00 00 05 39 00 00 00 00',
          '0C' => '08 00 00 0C 33 3F 80 00 00',
          '19' => '08 00 40 19 00 42 DD 26 1B',
          _    => '08 00 00 00 00 7F A0 00 00',
        };
    }
  }
}
