import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';
import 'package:hrtvirtual/src/models/hrt_build.dart';
import 'package:hrtvirtual/src/models/hrt_frame.dart';
import 'package:hrtvirtual/src/modules/home/home_controller.dart';

void main() {
  test('Test 01', () async {
    Hive.init("C:\\SourceCode\\");
    final controller = HomeController();    
    await controller.completer.future;
    controller.hrtComm.port = "COM4";
    controller.hrtComm.funcRead = (String data) {
      final hrtResponse = HrtFrame(data);
      final aux = '${hrtResponse.frame.splitByLength(2).join(" ")}\n';
      if (kDebugMode) {
        print(aux);
      }
    };
    //final hrtFrameRead = HrtFrame()..command = "00";
    //final hrtRequest = HrtBuild(controller.hrtStorage, hrtFrameRead);
    //final valueAux = hrtRequest.frame;    
    expect(controller.hrtComm.connect(), true);    
    //expect(controller.hrtComm.writeFrame(valueAux), true);
    expect(controller.hrtComm.writeFrame('FFFFFFFFFF0280000082'), true);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      //final aux1 = hrtComm0.readFrame();
      //expect(aux1, 'FFFFFFFFFF0680000E0000FE3E02050504300100001E6607');
    });
    controller.hrtComm.disconnect();
  });
}
