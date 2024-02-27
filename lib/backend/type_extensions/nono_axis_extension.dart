enum NonoAxis { row, column }

extension NonoAxisExtension on NonoAxis {
  int getSolutionPosition(int lineIndex, int charIndex, int nonoWidth) {
    switch (this) {
      case NonoAxis.row:
        return nonoWidth * lineIndex + charIndex;
      case NonoAxis.column:
        return nonoWidth * charIndex + lineIndex;
    }
  }
}
