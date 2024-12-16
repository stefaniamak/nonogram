/// An enumeration representing the direction from a clue in a [NonoAxis] in a Nonogram.
enum NonoDirection {
  /// Represents the direction before.
  before,

  /// Represents the direction after.
  after
}

/// An extension on the [NonoDirection] enumeration to provide additional functionality.
extension NonoDirectionExtension on NonoDirection {
  /// Determines if [NonoAxis] list of clues have other clues based on the direction asked about.
  ///
  /// Parameters:
  /// - [clueIndex]: The index of the clue in the list.
  /// - [clueListLength]: The total number of clues in the list.
  ///
  /// Returns true if there are other clues.
  bool hasOtherClues(int clueIndex, int clueListLength) {
    switch (this) {
      case NonoDirection.before:
        return clueIndex > 0;
      case NonoDirection.after:
        return clueIndex < clueListLength - 1;
    }
  }

  /// Validates partly completed solutions if they have all their clues filled in,
  /// based on the direction, character index, and clue.
  ///
  /// Parameters:
  /// - [solution]: The whole current solution string.
  /// - [charIndex]: The index on the solution of the the last filled in clue.
  /// - [clue]: The clue value.
  ///
  /// Returns true if rest of solution does not include a filled box.
  bool isSolutionValid(String solution, int charIndex, int clue) {
    switch (this) {
      case NonoDirection.before:
        if (charIndex == 0) return true;
        return !solution.substring(0, charIndex - 1).split('').toList().contains('1');
      case NonoDirection.after:
        if (charIndex + clue == solution.length) return true;
        return !solution.substring(charIndex + clue + 1).split('').toList().contains('1');
    }
  }

  /// Checks if there are remaining boxes  on the line for clues that are remaining,
  /// based on the direction, character index, and clue.
  ///
  /// Parameters:
  /// - [charIndex]: The last filled in index of the clue on the solution.
  /// - [clue]: The clue value.
  /// - [solution]: The solution string.
  ///
  /// Returns true if there are enough remaining boxes, at least as many as the clues
  /// sum plus their in between spaces.
  bool hasBoxesLeft(int charIndex, int clue, String solution, List<int> otherClues) {
    final int solutionListLength = solution.split('').length;
    switch (this) {
      case NonoDirection.before:
        return charIndex - 1 >= 0;
      case NonoDirection.after:
        return charIndex + clue + otherClues.reduce((int value, int element) => value + element) + otherClues.length - 1 <
            solutionListLength;
    }
  }

  /// Gets a sublist of the solution either before or after a filled in clue,
  /// based on the direction, character index, and clue.
  ///
  /// Parameters:
  /// - [solution]: The solution string.
  /// - [charIndex]: The index of the character.
  /// - [clue]: The clue value.
  ///
  /// Returns the sublist of the solution, minus the clue's boxes and the empty needed
  /// box between the clues.
  String getSolutionSublist(String solution, int charIndex, int clue) {
    switch (this) {
      case NonoDirection.before:
        return solution.split('').sublist(0, charIndex - 1).join();
      case NonoDirection.after:
        return solution.split('').sublist(charIndex + clue + 1).join();
    }
  }

  /// Gets a sublist of clues based on the direction and clue index.
  ///
  /// Parameters:
  /// - [clueIndex]: The index of the current clue.
  /// - [clues]: The list of clues.
  ///
  /// Returns the sublist of clues before of after the given clue.
  List<int> getCluesSublist(int clueIndex, List<int> clues) {
    switch (this) {
      case NonoDirection.before:
        return clues.sublist(0, clueIndex);
      case NonoDirection.after:
        return clues.sublist(clueIndex + 1);
    }
  }
}
