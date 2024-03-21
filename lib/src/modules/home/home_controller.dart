import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrtvirtual/src/models/hrt_comm.dart';
import 'package:hrtvirtual/src/models/hrt_response.dart';
import 'package:hrtvirtual/src/models/hrt_frame.dart';
import 'package:hrtvirtual/src/models/hrt_storage.dart';

class HomeController {
  final hrtComm = HrtComm();
  final hrtFrameWrite = HrtFrame();
  final hrtStorage = HrtStorage();
  final textController = TextEditingController();
  final valueChanged = ValueNotifier<(String, String)>(("", "")); // NAME, VALUE

  Future init() async {
    valueChanged.addListener(() {
      hrtStorage.setVariable(valueChanged.value.$1, valueChanged.value.$2);
    });
  }

  void readFrame(String frameRead) {
    final hrtFrameRead = HrtFrame(frameRead);
    if (hrtFrameRead.log.isEmpty) {
      final hrtResponse = HrtResponse(hrtFrameRead, hrtStorage);
      textController.text += '${hrtFrameRead.frame} -> ${hrtResponse.frame}\n';
      hrtComm.writeFrame(hrtResponse.frame);
    }
  }
}
