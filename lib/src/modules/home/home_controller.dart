import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';
import 'package:hrtvirtual/src/models/hrt_comm.dart';
import 'package:hrtvirtual/src/models/hrt_build.dart';
import 'package:hrtvirtual/src/models/hrt_frame.dart';
import 'package:hrtvirtual/src/models/hrt_storage.dart';

class HomeController {
  final hrtComm = HrtComm();
  final connectNotifier = ValueNotifier<String>("");
  final sendNotifier = ValueNotifier<String>("");
  final hrtFrameWrite = HrtFrame();
  final hrtStorage = HrtStorage();
  final textController = TextEditingController();
  final commandController = TextEditingController();

  void readHrtFrame(String data) {
    final hrtResponse = HrtFrame(data);
    textController.text += '${hrtResponse.frame.splitByLength(2).join(" ")}\n';
  }

  void masterMode(String commandWrite) async {
    hrtStorage.setVariable('master_address', '01'); //Seta para primario master
    hrtStorage.setVariable('frame_type', "02"); //Do master para o device
    final hrtFrameRead = HrtFrame()..command = commandWrite;
    if (hrtFrameRead.log.isEmpty) {
      final hrtRequest = HrtBuild(hrtStorage, hrtFrameRead);
      final valueAux = await hrtRequest.frame;
      hrtComm.writeFrame(valueAux);
      textController.text += '${valueAux.splitByLength(2).join(" ")} -> ';
    }
  }

  void slaveMode(String frameRead) async {
    hrtStorage.setVariable('master_address', '00'); //quando Slave deve ser 0
    hrtStorage.setVariable('frame_type', "06"); //Do device para o master
    final hrtFrameRead = HrtFrame(frameRead);
    if (hrtFrameRead.log.isEmpty) {
      final hrtResponse = HrtBuild(hrtStorage, hrtFrameRead);
      textController.text +=
          '${hrtFrameRead.frame.splitByLength(2).join(" ")} -> ${(await hrtResponse.frame).splitByLength(2).join(" ")}\n';
      hrtComm.writeFrame(await hrtResponse.frame);
    }
  }
}
