enum NonoSolutionSide { before, after }

extension NonoSolutionSideExtension on NonoSolutionSide {
  bool hasOtherClues(int clueIndex, int clueListLength) {
    switch (this) {
      case NonoSolutionSide.before:
        return clueIndex > 0;
      case NonoSolutionSide.after:
        return clueIndex < clueListLength - 1;
    }
  }

  bool hasBoxesLeft(int charIndex, int clue, int solutionListLength) {
    switch (this) {
      case NonoSolutionSide.before:
        return charIndex - 1 >= 0;
      case NonoSolutionSide.after:
        return charIndex + clue + 1 < solutionListLength;
    }
  }

  String getSolutionSublist(String solution, int charIndex, int clue) {
    switch (this) {
      case NonoSolutionSide.before:
        return '${solution.split('').sublist(0, charIndex - 1).join()}0';
      case NonoSolutionSide.after:
        return solution.split('').sublist(charIndex + clue + 1).join();
    }
  }

  List<int> getCluesSublist(int clueIndex, List<int> clues) {
    switch (this) {
      case NonoSolutionSide.before:
        return clues.getRange(0, clueIndex).toList();
      case NonoSolutionSide.after:
        return clues.sublist(1 + clueIndex);
    }
  }
}
