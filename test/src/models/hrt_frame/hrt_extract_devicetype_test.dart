import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  test('Dado o frame "FFF0A3EA" o DEVICETYPE é EA', () {
    final frame = HrtFrame("FFF0A3EA");       
    expect(frame.deviceType, 'EA');
  });

  test('Dado o frame "FF40A3EA" o DEVICETYPE é ERROR', () {
    final frame = HrtFrame("FF40A3EA");       
    expect(() => frame.deviceType,
        throwsA(const TypeMatcher<ArgumentError>()));
  });
}
