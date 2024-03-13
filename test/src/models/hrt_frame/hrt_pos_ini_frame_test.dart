import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  test('Dado a entrada "FFF0A3EA" ... em hrtFrameIni deve retornar 2', () {
    final frame = HrtFrame("FFF0A3EA");  
    expect(frame.posIniFrame, 2);
  });
    test('Dado a entrada FFFFF0A3EA ... em hrtFrameIni deve retornar 4', () {
    final frame = HrtFrame("FFFFF0A3EA");      
    expect(frame.posIniFrame, 4);
  });
    test('Dado a entrada FFFFA0A3EA ... em hrtFrameIni deve retornar 4', () {
    final frame = HrtFrame("FFFFA0A3EA");      
    expect(frame.posIniFrame, 4);
  });
    test('Dado a entrada FFFFFFF0A3EA ... em hrtFrameIni deve retornar 6', () {
    final frame = HrtFrame("FFFFFFF0A3EA");      
    expect(frame.posIniFrame, 6);
  });
}
