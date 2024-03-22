import 'dart:async';
import 'package:expressions/expressions.dart';
import 'package:hrtvirtual/src/models/hrt_settings.dart';
import 'package:hrtvirtual/src/models/hrt_type.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrtvirtual/src/extension/hex_extension_string.dart';

class HrtStorage {
  final evaluator = const ExpressionEvaluator();
  Completer<Box<String>> completer = Completer<Box<String>>();

  HrtStorage() {
    if (!completer.isCompleted) {
      completer.complete(Hive.openBox<String>('HRTSTORAGE'));
    }
  }

  Future<String> getVariable(String idVariable1, [String? idVariable2]) async {
    String? resp1;
    final box = await completer.future;
    resp1 = box.get(idVariable1);
    if (resp1 == null) {
      if (hrtSettings[idVariable1] != null) {
        resp1 = hrtSettings[idVariable1]!.$3;
      }
    }
    if (idVariable2 != null) {
      String? resp2 = box.get(idVariable2);
      if (resp2 == null) {
        if (hrtSettings[idVariable2] != null) {
          resp2 = hrtSettings[idVariable2]!.$3;
        }
      }
      return (await hrtTranslator(resp1!)).padLeft(hrtSettings[idVariable1]!.$1, '0') & (await hrtTranslator(resp2!)).padLeft(hrtSettings[idVariable2]!.$1, '0');
    }
    return (await hrtTranslator(resp1!)).padLeft(hrtSettings[idVariable1]!.$1, '0');
  }

  Future<void> setVariable(String idVariable, String value) async {
    final box = await completer.future;
    return box.put(idVariable, value);
  }

  Future<String> hrtTranslator(String value) async {
    if (value.substring(0, 1) != '@') return value;
    final iReg = RegExp(r'[A-Z_a-z]+');
    final matches = iReg.allMatches(value);
    Map<String, double> context = {};
    for (var e in matches) {
      if (e.group(0) != null) {
        final variableHex = await getVariable(e.group(0)!);
        context[e.group(0)!] =
            hrtTypeHexTo(variableHex, hrtSettings[e.group(0)!]!.$2);
      }
    }
    Expression expression = Expression.parse(value.substring(1));
    return (evaluator.eval(expression, context) as double)
        .toInt()
        .toRadixString(16)
        .toUpperCase();
  }
}
