import 'package:flutter_test/flutter_test.dart';
import 'package:hctvirtual/src/models/hrt_comm.dart';

void main() {
  test('Write Frame in COM3 and read the same data in COM4', () {
    final hrtComm0 = HrtComm('COM3');
    final hrtComm1 = HrtComm('COM4');
    expect(hrtComm0.writeFrame('FFF0A3EAF3DCAB970100AB'), true);
    expect(hrtComm1.readFrame(), 'FFF0A3EAF3DCAB970100AB');
    hrtComm0.disconnect();
    hrtComm1.disconnect();    
  });
}
