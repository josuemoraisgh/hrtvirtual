import 'dart:async';
import 'package:flutter/material.dart';

class HomeController {
  final doadorCount = ValueNotifier<int>(0);
  final answer = ValueNotifier<List<String>>([]);
  final answerAux = ValueNotifier<List<ValueNotifier<String>>>([]);
  final ValueNotifier<String> activeTagButtom = ValueNotifier<String>('');
  final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

  HomeController();

  Future init() async {}
}
