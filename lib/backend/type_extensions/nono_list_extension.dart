import 'nono_axis_extension.dart';

extension NonoListExtension on List {
  int get sum => fold<int>(0, (previousValue, element) => previousValue + (element as int));

  bool get everyElementIsZero => every((e) => e.toString() == '0');

  bool isInStack(int charIndex, NonoAxis lineType) {
    return contains({charIndex: lineType});
  }

  List<Map<int, NonoAxis>> updateStack(List<int> charIndexes, NonoAxis lineType) {
    NonoAxis newAxis = lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row;
    List<Map<int, NonoAxis>> newStackElements = charIndexes.map((charIndex) => {charIndex: newAxis}).toList();
    List<Map<int, NonoAxis>> finalStackElements = newStackElements;

    if (finalStackElements.length > 1) {
      List<Map<int, NonoAxis>> commonStackElements = newStackElements.toSet().intersection(toSet()).toList();
      finalStackElements = newStackElements;
      finalStackElements.removeWhere((element) => commonStackElements.contains(element));
    }

    // if (finalStackElements.isNotEmpty) {
    //   if (state != null) {
    //     state.pushStack(newStackElements);
    //   }
    // }

    return newStackElements;

    // if (!isInStack(charIndexes, newAxis)) {
    //   state.pushStack({charIndexes: newAxis});
    // } else {
    //   // print('bumped');
    //   // print('stack before ${state.stack}');
    //   // state.bumpToStack({charIndex: newAxis});
    //   // print('stack after ${state.stack}');
    // }
  }
}
