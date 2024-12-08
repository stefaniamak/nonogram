import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

extension NonoStringListExtension on List<String> {
  bool get everyElementIsZero => every((String e) => e == '0');
}

extension NonoIntListExtension on List<int> {
  int get sum => fold<int>(0, (int previousValue, int element) => previousValue + element);
}

extension NonoMapListExtension on List<Map<int, NonoAxis>> {
  bool isInStack(int charIndex, NonoAxis lineType) {
    return contains(<int, NonoAxis>{charIndex: lineType});
  }

  List<Map<int, NonoAxis>> getNewStackElements(List<int> charIndexes, NonoAxis lineType) {
    final NonoAxis newAxis = lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row;
    final List<Map<int, NonoAxis>> newStackElements =
        charIndexes.map((int charIndex) => <int, NonoAxis>{charIndex: newAxis}).toList();
    List<Map<int, NonoAxis>> finalStackElements = newStackElements;

    if (finalStackElements.length > 1) {
      final List<Map<int, NonoAxis>> commonStackElements = newStackElements.toSet().intersection(toSet()).toList();
      finalStackElements = newStackElements;
      finalStackElements.removeWhere((Map<int, NonoAxis> element) => commonStackElements.contains(element));
    }
    return finalStackElements;
  }

  List<Map<int, NonoAxis>> updateStack(List<Map<int, NonoAxis>> newStackElements) {
    for (final Map<int, NonoAxis> element in newStackElements) {
      if (contains(element)) {
        remove(element);
        insert(0, element);
      } else {
        add(element);
      }
    }
    return this;
  }
}
