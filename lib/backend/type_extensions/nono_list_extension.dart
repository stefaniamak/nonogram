extension NonoListExtension on List {
  int get sum => fold<int>(0, (previousValue, element) => previousValue + (element as int));

  bool get everyElementIsZero => every((e) => e.toString() == '0');
}
