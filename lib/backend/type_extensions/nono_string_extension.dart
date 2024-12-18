import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

/// Extension on String to add utility methods for nonogram puzzles.
extension NonoStringExtension on String {
  /// Returns the character at the specified index.
  ///
  /// - [index]: The index of the character to return.
  ///
  /// Returns the character at the specified index.
  String characterAt(int index) => split('')[index];

  /// Calculates the sum of all filled boxes in the string.
  ///
  /// Returns the sum of all filled boxes.
  int get sumFilledBoxes => split('').fold(0, (int prev, String element) => prev + (element != '?' ? int.parse(element) : 0));

  /// Checks if the current string has the same clue index as the given element.
  /// All clue indexes are from 2 and up.
  ///
  /// - [element]: The element to compare with.
  ///
  /// Returns true if the current string has the same clue index as the given element.
  bool isSameClueIndexWith(String element) => this == element && this != '?' && element != '0';

  /// Isolates a row from the string based on the given line index and width.
  ///
  /// - [lineIndex]: The index of the line to isolate.
  /// - [width]: The width of the row.
  ///
  /// Returns the isolated row as a string.
  String getRowIsolate(int lineIndex, int width) =>
      split('').getRange(lineIndex * width, width * (lineIndex + 1)).join().replaceAll(RegExp(r'[ (),]'), '');

  /// Isolates a column from the string based on the given line index and width.
  ///
  /// - [lineIndex]: The index of the line to isolate.
  /// - [width]: The width of the column.
  ///
  /// Returns the isolated column as a string.
  String getColumnIsolate(int lineIndex, int width) {
    String columnSol = '';
    for (int solChar = lineIndex; solChar < length; solChar += width) {
      columnSol += this[solChar];
    }
    return columnSol;
  }

  /// Returns the solution line for a given line index and type (row or column) in a nonogram puzzle.
  ///
  /// - [lineIndex]: The index of the line to retrieve.
  /// - [nonogram]: The nonogram puzzle object containing the width of the puzzle.
  /// - [lineType]: The type of the line (row or column) to retrieve.
  ///
  /// Returns the solution line as a string.
  String getSolutionLine(int lineIndex, Nonogram nonogram, NonoAxis lineType) {
    switch (lineType) {
      case NonoAxis.row:
        // Split the string into a list of characters, get the range for the specified row, join them back into a string, and remove unwanted characters.
        return split('')
            .getRange(lineIndex * nonogram.width, nonogram.width * (lineIndex + 1))
            .join()
            .replaceAll(RegExp(r'[ (),]'), '');
      case NonoAxis.column:
        String columnSol = '';
        // Iterate through the string to collect the characters of the specified column.
        for (int solChar = lineIndex; solChar < length; solChar += nonogram.width) {
          columnSol += this[solChar];
        }
        return columnSol;
    }
  }
}
