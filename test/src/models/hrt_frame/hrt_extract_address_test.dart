import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  //For a long Frame 3 bytes
  test('Dado o frame "FFF0A3EAF3DCAB97" o ADDRESS é F3DCAB', () {
    final frame = HrtFrame("FFF0A3EAF3DCAB97");
    expect(frame.address, 'F3DCAB');
  });
  //For a short Frame 1 byte
  test('Dado o frame "FF40A3EA" o ADDRESS é A3', () {
    final frame = HrtFrame("FF40A3EA");    
    expect(frame.address, 'A3');
  });
}
