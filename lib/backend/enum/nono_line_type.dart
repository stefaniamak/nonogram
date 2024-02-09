enum NonoLineType { row, column }

extension NonoLineTypeExtension on NonoLineType {
  int getSolutionPosition(int lineIndex, int charIndex, int nonoWidth) {
    switch (this) {
      case NonoLineType.row:
        return nonoWidth * lineIndex + charIndex;
      case NonoLineType.column:
        return nonoWidth * charIndex + lineIndex;
    }
  }
}
