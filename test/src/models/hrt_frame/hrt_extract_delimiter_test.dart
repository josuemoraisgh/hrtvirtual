import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  test('Dado o frame "FFF0A3EA" o DELIMITER é F0', () {
    final frame = HrtFrame("FFF0A3EA");    
    expect(frame.delimiter,'F0');
  });
  test('Dado o frame "FFA0A3EA" o DELIMITER é A0', () {
    final frame = HrtFrame("FFA0A3EA");    
    expect(frame.delimiter,'A0');
  });  
}
