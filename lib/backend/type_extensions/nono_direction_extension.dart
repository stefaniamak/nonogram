enum NonoDirection { before, after }

extension NonoDirectionExtension on NonoDirection {
  bool hasOtherClues(int clueIndex, int clueListLength) {
    switch (this) {
      case NonoDirection.before:
        return clueIndex > 0;
      case NonoDirection.after:
        return clueIndex < clueListLength - 1;
    }
  }

  bool isSolutionValid(String solution, int charIndex, int clue) {
    switch (this) {
      case NonoDirection.before:
        if (charIndex == 0) {
          return true;
        }
        return !solution.substring(0, charIndex - 1).split('').toList().contains('1');
      case NonoDirection.after:
        if (charIndex + clue == solution.length) {
          return true;
        }
        return !solution.substring(charIndex + clue + 1).split('').toList().contains('1');
    }
  }

  bool hasBoxesLeft(int charIndex, int clue, int solutionListLength) {
  bool hasBoxesLeft(int charIndex, int clue, String solution, List<int> otherClues) {
    final int solutionListLength = solution.split('').length;
    switch (this) {
      case NonoDirection.before:
        return charIndex - 1 >= 0;
      case NonoDirection.after:
        return charIndex + clue + otherClues.reduce((int value, int element) => value + element) + otherClues.length <
            solutionListLength;
    }
  }

  String getSolutionSublist(String solution, int charIndex, int clue) {
    switch (this) {
      case NonoDirection.before:
        return '${solution.split('').sublist(0, charIndex - 1).join()}0';
      case NonoDirection.after:
        return solution.split('').sublist(charIndex + clue + 1).join();
    }
  }

  List<int> getCluesSublist(int clueIndex, List<int> clues) {
    switch (this) {
      case NonoDirection.before:
        return clues.getRange(0, clueIndex).toList();
      case NonoDirection.after:
        return clues.sublist(1 + clueIndex);
    }
  }
}
