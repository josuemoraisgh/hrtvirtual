import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hctvirtual/src/models/hrt_comm.dart';
import 'package:hctvirtual/src/models/hrt_frame.dart';
import 'package:hctvirtual/src/models/hrt_storage.dart';

class HomeController {
  final hrtFrame = HrtFrame();
  final hrtComm = HrtComm();
  final hrtStorage = HrtStorage();
  final valueChanged = ValueNotifier<(String, String)>(("", ""));// NAME, VALUE
  
  HomeController();

  Future init() async {
    valueChanged.addListener(() {
      hrtStorage.setVariable(valueChanged.value.$1, valueChanged.value.$2); 
    });
  }
}
