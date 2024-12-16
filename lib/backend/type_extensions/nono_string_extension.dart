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
}
