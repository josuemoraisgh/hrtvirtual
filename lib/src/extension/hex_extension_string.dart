extension HexExtension on String {
  List<String> splitByLength(int size) {
    return (length - size) > 0
        ? substring(0, length - size).splitByLength(size) +
            [substring(length - size)]
        : [this];
  }

  String operator &(String aux) {
    return (int.parse(this, radix: 16) & int.parse(this, radix: 16))
        .toRadixString(16);
  }
}
