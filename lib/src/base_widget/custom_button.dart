import 'dart:core';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String? titleOff;
  final Color? color;
  final String initialValue;
  final ValueNotifier<String> groupValue;
  final Function(String?)? onChanged;

  const CustomButton({
    super.key,
    required this.title,
    this.titleOff,
    required this.initialValue,
    required this.groupValue,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: groupValue,
        builder: (context, groupValueNotifier, _) => Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: initialValue == groupValueNotifier ||
                      groupValueNotifier == ""
                  ? MaterialStateProperty.all<Color>(color ?? Colors.black54)
                  : MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all(8),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(width: 0.2, color: color ?? Colors.black54),
                ),
              ),
            ),
            onPressed: (onChanged != null)
                ? () {
                    if (groupValue.value == (titleOff ?? "") ||
                        groupValue.value == "") {
                      groupValue.value = title;
                    } else {
                      groupValue.value = titleOff ?? "";
                    }
                    onChanged!(groupValue.value);
                  }
                : null,
            child: Text(
              titleOff != null
                  ? groupValueNotifier == ""
                      ? initialValue
                      : groupValueNotifier
                  : title,
              style: TextStyle(
                fontSize: 18,
                color: initialValue == groupValueNotifier
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      );
}
