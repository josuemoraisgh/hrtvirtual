import 'dart:async';
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
    return box.get(idVariable);
  }

  Future<void> setVariable(String idVariable, String value) async {
    final box = await completer.future;
    return box.put(idVariable, value);
  }
}
