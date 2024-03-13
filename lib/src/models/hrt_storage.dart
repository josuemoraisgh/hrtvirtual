import 'dart:async';
import 'package:hctvirtual/src/models/hrt_settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HrtStorage {
  Completer<Box<String>> completer = Completer<Box<String>>();

  HrtStorage() {
    _init();
  }

  Future<void> _init() async {
    if (!completer.isCompleted) {
      completer.complete(await Hive.openBox<String>('HRTSTORAGE'));
    }
  }

  Future<String?> getVariable(String idVariable) async {
    final box = await completer.future;
    final resp = box.get(idVariable);
    if (resp == null) {
      if (hrtSettings[idVariable] != null) {
        return hrtSettings[idVariable]!.$3;
      }
    }
    return resp;
  }

  Future<void> setVariable(String idVariable, String value) async {
    final box = await completer.future;
    return box.put(idVariable, value);
  }
}
