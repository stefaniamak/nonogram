import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

/// Extension on List<String> to add utility methods.
extension NonoStringListExtension on List<String> {
  /// Checks if every element in the list is '0'.
  bool get everyElementIsZero => every((String e) => e == '0');
}

/// Extension on List<int> to add utility methods.
extension NonoIntListExtension on List<int> {
  /// Calculates the sum of all elements in the list.
  int get sum => fold<int>(0, (int previousValue, int element) => previousValue + element);

  /// Calculates the minimum starting point for a given index.
  /// To find the minimum starting point, the sum of all elements up to the index is calculated.
  ///
  /// - [index]: The index to calculate the minimum starting point for.
  ///
  /// Returns the minimum starting point as an integer.
  int minStartingPoint(int index) => index == 0 ? 0 : take(index).reduce((int value, int element) => value + element + 1);

  /// Calculates the maximum starting point for a given index and total length.
  /// To find the maximum starting point, the sum of all elements after the index is calculated.
  ///
  /// - [index]: The index to calculate the maximum starting point for.
  /// - [totalLength]: The total length to consider for the calculation.
  ///
  /// Returns the maximum starting point as an integer.
  int maxStartingPoint(int index, int totalLength) => index == length - 1
      ? totalLength
      : totalLength - sublist(index + 1).reduce((int value, int element) => value + element + 1) - this[index];
}

/// Extension on List<Map<int, NonoAxis>> to add utility methods.
extension NonoMapListExtension on List<Map<int, NonoAxis>> {
  /// Checks if a map with the given charIndex and lineType exists in the list.
  ///
  /// - [charIndex]: The character index to check.
  /// - [lineType]: The line type to check.
  ///
  /// Returns True if the map exists in the list, false otherwise.
  bool isInStack(int charIndex, NonoAxis lineType) {
    return contains(<int, NonoAxis>{charIndex: lineType});
  }

  /// Creates a list of new stack elements with the opposite axis of the given lineType.
  ///
  /// - [charIndexes]: The list of character indexes.
  /// - [lineType]: The line type to determine the new axis.
  ///
  /// Returns A list of maps with the new axis.
  List<Map<int, NonoAxis>> getNewStackElements(List<int> charIndexes, NonoAxis lineType) {
    final NonoAxis newAxis = lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row;
    return charIndexes.map((int charIndex) => <int, NonoAxis>{charIndex: newAxis}).toList();
  }

  /// Updates the stack with the new stack elements.
  ///
  /// If an element already exists in the list, it is removed and then inserted at the middle.
  /// If an element does not exist, it is added to the list.
  ///
  /// - [newStackElements]: The list of new stack elements to update.
  ///
  /// Returns The updated list.
  List<Map<int, NonoAxis>> updateStack(List<Map<int, NonoAxis>> newStackElements) {
    for (final Map<int, NonoAxis> element in newStackElements) {
      final int duplicateIndex =
          indexWhere((Map<int, NonoAxis> e) => e.keys.first == element.keys.first && e.values.first == element.values.first);
      if (duplicateIndex >= 0) {
        remove(element);
        insert((duplicateIndex / 2).ceil(), element);
      } else {
        add(element);
      }
    }
    return this;
  }
}
