import 'package:hctvirtual/src/models/hrt_frame.dart';
import 'package:hctvirtual/src/models/hrt_storage.dart';

class HrtCommand {
  final HrtFrame _hrtFrame;
  final HrtStorage _hrtStorage;
  HrtCommand(this._hrtFrame, this._hrtStorage) {
    init();
  }

  String get frame => _hrtFrame.frame;

  init() async {
    switch (_hrtFrame.command) {
      case '00': //Identity Command
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
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
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('unit_code')}"
            "${await _hrtStorage.getVariable('PROCESS_VARIABLE')}";
        break;
      case '02': //Read Loop Current And Percent Of Range
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('loop_current')}"
            "${await _hrtStorage.getVariable('percent_of_range')}";
        break;
      case '03': //Read Dynamic Variables And Loop Current
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
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
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "$pollingAddress"
            "$loopCurrentMode";
        break;
      case '07': //Read Loop Configuration
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('polling_address')}"
            "${await _hrtStorage.getVariable('loop_current_mode')}";
        break;
      case '08': //Read Loop Configuration
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('primary_variable_classification')}"
            "${await _hrtStorage.getVariable('secondary_variable_classification')}"
            "${await _hrtStorage.getVariable('tertiary_variable_classification')}"
            "${await _hrtStorage.getVariable('quaternary_variable_classification')}";
        break;
      case '0C': //Read Message (12)
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('Message')}";
        break;
      case '0D': //Read Tag, Descriptor, Date (13)
        _hrtFrame.body = "${await _hrtStorage.getVariable('error_code')}"
            "${await _hrtStorage.getVariable('tag')}"
            "${await _hrtStorage.getVariable('descriptor')}"
            "${await _hrtStorage.getVariable('date')}";                        
        break;      
      case '0E':
      case '0F':
    }
  }
}
