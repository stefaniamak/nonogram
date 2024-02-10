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

  bool hasBoxesLeft(int solutionIndex, int clue, int solutionListLength) {
    switch (this) {
      case NonoSolutionSide.before:
        return solutionIndex - 1 >= 0;
      case NonoSolutionSide.after:
        return solutionIndex + clue + 1 < solutionListLength;
    }
  }

  String getSolutionSublist(String solution, int solutionIndex, int clue) {
    switch (this) {
      case NonoSolutionSide.before:
        return '${solution.split('').sublist(0, solutionIndex - 1).join()}0';
      case NonoSolutionSide.after:
        return solution.split('').sublist(solutionIndex + clue + 1).join();
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
