import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hctvirtual/src/models/hrt_comm.dart';
import 'package:hctvirtual/src/models/hrt_command.dart';
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

  void tipoTransmitter() async {
    hrtFrameWrite.manufacterID =
        await hrtStorage.getVariable('manufacturer_id') ?? "";
    hrtFrameWrite.deviceType =
        await hrtStorage.getVariable('device_type') ?? "";
  }

  void readFrame(String frameRead) {
    final hrtFrameRead = HrtFrame(frameRead);
    if (hrtFrameRead.log.isEmpty) {
      final hrtWrite = HrtCommand(hrtFrameRead, hrtStorage);
      debugPrint('${hrtFrameRead.frame} -> ${hrtWrite.frame}');
      hrtComm.writeFrame(hrtWrite.frame);
    }
  }
}
