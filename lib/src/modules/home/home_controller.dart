import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hctvirtual/src/models/hrt_comm.dart';
import 'package:hctvirtual/src/models/hrt_response.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';
import 'package:hctvirtual/src/models/hrt_storage.dart';

class HomeController {
  final hrtComm = HrtComm();
  final hrtFrameWrite = HrtFrame();
  final hrtStorage = HrtStorage();
  final valueChanged = ValueNotifier<(String, String)>(("", "")); // NAME, VALUE

  HomeController();

  Future init() async {
    valueChanged.addListener(() {
      hrtStorage.setVariable(valueChanged.value.$1, valueChanged.value.$2);
    });
  }

  void readFrame(String frameRead) {
    final hrtFrameRead = HrtFrame(frameRead);
    if (hrtFrameRead.log.isEmpty) {
      final hrtResponse = HrtResponse(hrtFrameRead, hrtStorage);
      debugPrint('${hrtFrameRead.frame} -> ${hrtResponse.frame}');
      hrtComm.writeFrame(hrtResponse.frame);
    }
  }
}
