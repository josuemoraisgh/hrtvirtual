//NAME:(BYTE_SIZE, TYPE, DEFAULT_VALUE | @FUNCTION)
const Map<String, (int, String, String)> hrtSettings = {
  'frame_type': (1, 'UNSIGNED', '06'),
  'address_type': (1, 'UNSIGNED', '00'),
  'error_code': (2, 'ENUM00', '0040'),
  'response_code': (1, 'ENUM27', '30'),
  'device_status': (1, 'BIT_ENUM02', '20'),
  'comm_status': (1, 'BIT_ENUM03', '00'),
  'master_address': (1, 'BIT_ENUM01', '00'),
  'manufacturer_id': (1, 'ENUM08', '3E'),
  'device_type': (1, 'ENUM01', '02'),
  'request_preambles': (1, 'UNSIGNED', '05'),
  'hart_revision': (1, 'UNSIGNED', '05'),
  'transmitter_revision': (1, 'UNSIGNED', '30'),
  'software_revision': (1, 'UNSIGNED', '04'),
  'hardware_revision': (1, 'UNSIGNED', '01'),
  'device_flags': (1, 'BIT_ENUM04', '00'),
  'device_id': (3, 'UNSIGNED', '001E66'),
  'polling_address': (1, 'UNSIGNED', '80'),
  'tag': (8, 'PACKED_ASCII', '514CF0C60820'), //TT301
  'message': (
    32,
    'PACKED_ASCII',
    '34510910F4A010581414D405481515481820820820820820'
  ), //MEDIDOR DE TEMPERATURA
  'descriptor': (
    16,
    'PACKED_ASCII',
    '505350152054552060820820'
  ), //TEMPERATURA
  'date': (3, 'DATE', '130879'), //19/08/2021
  'upper_range_value': (4, 'FLOAT', '44548000'), //850
  'lower_range_value': (4, 'FLOAT', 'C3480000'), //-200
  'PROCESS_VARIABLE': (4, 'FLOAT', '42480000'), //50
  'percent_of_range': (
    4,
    'FLOAT',
    '@100 * (PROCESS_VARIABLE - lower_range_value) / (upper_range_value - lower_range_value)'
  ),
  'loop_current': (4, 'FLOAT', '@(percent_of_range*0.16)+4'),
  'write_protect': (1, 'ENUM00', '00'),
  'private_label_distributor': (1, 'ENUM00', '00'),
  'final_assembly_number': (3, 'UNSIGNED', '00'),
  'physical_signaling_code': (1, 'ENUM10', '00'), //(Bell  202  Current)
  'units_code': (1, 'ENUM02', '20'), //(32 - Degrees Celsius)
  'transfer_function_code': (1, 'ENUM03', '00'), //(0 - Linear)
  'alarm_selection_code': (1, 'ENUM06', 'FB'), //(None)
  'material_code': (1, 'ENUM04', '02'), //(Stainless Steel 316)
  'write_protect_code': (1, 'ENUM07', 'FB'), //(None)
  'burst_mode_control_code': (1, 'ENUM09', 'FB'), //(None)
  'flag_assignment': (1, 'ENUM11', '01'), // (Multi-Sensor Field Device)
  'operating_mode_code': (1, 'ENUM14', '00'), //(None)
  'analog_output_numbers_code': (1, 'ENUM15', '00'), //(Analog Channel 0)
  'burst_command_number': (1, 'ENUM00', '00'),
  'burst_mode_select': (1, 'ENUM00', '00'),
  'meter_installation': (1, 'ENUM00', '00'),
  'digital_units': (1, 'ENUM00', '00'),
  'sensor_type': (1, 'ENUM00', '00'),
  'analog_output_transfer_function': (1, 'ENUM00', '00'),
  'ma_analog_output_1_value': (4, 'FLOAT', '00000000'),
  'ma_analog_output_1_alarm_select': (1, 'ENUM00', '00'),
  'sensor1_serial_number': (3, 'UNSIGNED', '000000'),
  'DEVICE_MODE': (1, 'ENUM00', '00'),
  'number_wires': (1, 'ENUM00', '00'),
  'device_code': (1, 'UNSIGNED', '00'),
  'lin_mode': (1, 'ENUM00', '00'),
  'SETPOINT': (4, 'FLOAT', '00000000'),
  'MANIPULATED_VARIABLE': (4, 'FLOAT', '00'),
  'CONTROLLER_TYPE': (1, 'ENUM00', '00'),
  'POWER_UP_MODE': (1, 'ENUM00', '00'),
  'CONTROLLER_ACTION': (1, 'ENUM00', '00'),
  'unit_code': (1, 'ENUM00', '00'),
  'SETPOINT_TRACKING_MODE': (1, 'ENUM00', '00'),
  'pid_mode': (1, 'ENUM00', '00'),
  'ERROR_PERCENT_RANGE': (4, 'FLOAT', '00'),
  'PROPORTIONAL_GAIN': (4, 'FLOAT', '00000000'),
  'INTEGRAL_TIME': (4, 'FLOAT', '00000000'),
  'DERIVATIVE_TIME': (4, 'FLOAT', '00000000'),
  'MV_HIGH_LIMIT': (4, 'FLOAT', '00000000'),
  'MV_LOW_LIMIT': (4, 'FLOAT', '00000000'),
  'MV_ROC_LIMIT': (4, 'FLOAT', '00000000'),
  'POWER_UP_SETPOINT_PERCENT_RANGE': (4, 'FLOAT', '00000000'),
  'POWER_UP_OUTPUT': (4, 'FLOAT', '00000000'),
  'set_point_time': (4, 'FLOAT', '00000000'),
  'set_point_generator_mode': (1, 'ENUM00', '00'),
  'set_point_time_generator_mode': (1, 'ENUM00', '00'),
  'range_units': (1, 'UNSIGNED', '00'),
  'pv_display_code': (1, 'ENUM00', '00'),
  'sv_display_code': (1, 'ENUM00', '00'),
  'communication_write_protection_mode': (1, 'ENUM00', '00'),
  'local_adjust_protection_mode': (1, 'ENUM00', '00'),
  'local_adjust_mode': (1, 'ENUM00', '00'),
  'input_unit_code': (1, 'ENUM00', '00'),
  'output_variable': (4, 'FLOAT', '00000000'),
  'mv_ohms': (4, 'FLOAT', '00000000'),
  'cal_point_limits_unit': (1, 'ENUM00', '00'),
  'upper_cal_point_value': (4, 'FLOAT', '00000000'),
  'lower_cal_point_value': (4, 'FLOAT', '00000000'),
  'CONTROLLER_MODE': (1, 'ENUM00', '00'),
  'fail_safe_mode': (1, 'ENUM00', '00'),
  'sensor_range': (1, 'ENUM00', '00'),
};
