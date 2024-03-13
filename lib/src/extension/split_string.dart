extension StringSplit on String {
  List<String> splitByLength(int size) {
    return (length - size) > 0
        ? substring(0, length - size).splitByLength(size) +
            [substring(length - size)]
        : [this];
  }
}