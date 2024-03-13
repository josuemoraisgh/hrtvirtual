import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';

void main() {
  test('Dado a entrada "FF80A3EA" em hrtIsLongFrame deve retornar true', () {
    final frame = HrtFrame("FF80A3EA");  
    expect(frame.isLongFrame,true);
  });
  test('Dado a entrada "FF00A3EA" em hrtIsLongFrame deve retornar false', () {
    final frame = HrtFrame("FF00A3EA"); 
    expect(frame.isLongFrame,false);
  });  
}
