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
    return newStackElements;
  }

  List<Map<int, NonoAxis>> updateStack(List<Map<int, NonoAxis>> newStackElements) {
    // print('this: $this');
    // print('newStackElements: $newStackElements');

    for (final Map<int, NonoAxis> element in newStackElements) {
      // print('runn: $element');
      int duplicateIndex =
          indexWhere((Map<int, NonoAxis> e) => e.keys.first == element.keys.first && e.values.first == element.values.first);
      if (duplicateIndex >= 0) {
        print('front?');
        remove(element);
        insert((duplicateIndex / 2).ceil(), element);
      } else {
        add(element);
      }
    }
    return this;
  }
}
