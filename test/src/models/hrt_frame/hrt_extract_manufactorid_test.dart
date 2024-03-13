import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  test('Dado o frame "FFF0A3EA" o MANUFACTERID é A3', () {
    final frame = HrtFrame("FFF0A3EA");    
    expect(frame.manufacterID,'A3');
  }); 
    test('Dado o frame "FF40A3EA" o MANUFACTERID é error', () {
    final frame = HrtFrame("FF40A3EA");      
    expect(() => frame.manufacterID,throwsA(const TypeMatcher<ArgumentError>()));
  }); 
}
