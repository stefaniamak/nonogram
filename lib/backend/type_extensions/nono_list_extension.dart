import 'nono_axis_extension.dart';

extension NonoListExtension on List {
  int get sum => fold<int>(0, (previousValue, element) => previousValue + (element as int));

  bool get everyElementIsZero => every((e) => e.toString() == '0');

  bool isInStack(int charIndex, NonoAxis lineType) {
    for (var line in this) {
      print('line.keys.first: ${line.keys.first} & charIndex $charIndex');
      print('line.values.first: ${line.values.first} & lineType $lineType');
      if (line.keys.first == charIndex && line.values.first != lineType) {
        return true;
      }
    }
    return false;
  }
}
