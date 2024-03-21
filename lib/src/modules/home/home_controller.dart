import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrtvirtual/src/models/hrt_comm.dart';
import 'package:hrtvirtual/src/models/hrt_send.dart';
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
  final valueChanged = ValueNotifier<(String, String)>(("", "")); // NAME, VALUE

  Future init() async {
    valueChanged.addListener(() {
      hrtStorage.setVariable(valueChanged.value.$1, valueChanged.value.$2);
    });
  }

  void masterMode(String commandWrite) {
    hrtStorage.setVariable('master_address','01');
    final hrtFrameRead = HrtFrame()..command = commandWrite;
    if (hrtFrameRead.log.isEmpty) {
      final hrtRequest = HrtSend(hrtStorage, hrtFrameRead);
      hrtComm.writeFrame(hrtRequest.frame);
      Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          final hrtResponse = HrtFrame(hrtComm.readFrame());
          textController.text +=
              '${hrtRequest.frame} -> ${hrtResponse.frame}\n';
        },
      );
    }
  }

  void slaveMode(String frameRead) {
    hrtStorage.setVariable('master_address','00');    
    final hrtFrameRead = HrtFrame(frameRead);
    if (hrtFrameRead.log.isEmpty) {
      final hrtResponse = HrtSend(hrtStorage, hrtFrameRead);
      textController.text += '${hrtFrameRead.frame} -> ${hrtResponse.frame}\n';
      hrtComm.writeFrame(hrtResponse.frame);
    }
  }
}
