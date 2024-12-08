/// An enumeration representing the axis of a Nonogram.
enum NonoAxis {
  /// Represents the horizontal/x/row axis.
  row,

  /// Represents the vertical/y/column axis.
  column
}

/// An extension on the [NonoAxis] enumeration to provide additional functionality.
extension NonoAxisExtension on NonoAxis {
  /// Calculates the solution position index based on the axis, line index, character index, and Nonogram width.
  ///
  /// Parameters:
  /// - [lineIndex]: The index of the line.
  /// - [charIndex]: The index of the character.
  /// - [nonoWidth]: The width of the Nonogram.
  ///
  /// Returns:
  /// The calculated solution position index.
  int getSolutionPosition(int lineIndex, int charIndex, int nonoWidth) {
    switch (this) {
      case NonoAxis.row:
        return nonoWidth * lineIndex + charIndex;
      case NonoAxis.column:
        return nonoWidth * charIndex + lineIndex;
    }
  }
}
