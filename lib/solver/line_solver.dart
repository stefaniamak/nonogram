import 'package:flutter/cupertino.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class LineSolver {
  String lineSolver(NonogramState state) {
    // left most solution

    // overlapping(state);
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      /// Gets [i] row's clues.
      List<int> rowClue = state.nonogram.clues!.rows.elementAt(i);

      /// Gets current active solution of that [i] row.
      String row = state.activeSolution.characters
          .getRange(i * state.nonogram.width, state.nonogram.width * (i + 1))
          .string;

      String sol = findOverlaps(rowClue, row);

      for (int j = 0; j < sol.length; j++) {
        var newSol = sol.split('').elementAt(j);
        var activeSol = row.split('').elementAt(j);
        if ((newSol != activeSol) && newSol == '1') {
          state.setFilled(i * state.nonogram.width + j);
        }
      }
    }
    for (var c = 0; c < state.nonogram.clues!.columns.length; c++) {
      /// Gets [i] column's clues.
      List<int> columnClue = state.nonogram.clues!.columns.elementAt(c);

      /// Gets current active solution of that [i] column.
      String columnSol = '';
      for (var solChar = 0;
          solChar < state.nonogram.width * state.nonogram.height;
          solChar = solChar + state.nonogram.width) {
        columnSol =
            '${columnSol}${state.activeSolution.characters.characterAt(solChar)}';
      }

      String sol = findOverlaps(columnClue, columnSol);

      for (int j = 0; j < sol.length; j++) {
        var newSol = sol.split('').elementAt(j);
        var activeSol = columnSol.split('').elementAt(j);
        if ((newSol != activeSol) && newSol == '1') {
          state.setFilled(c + j * state.nonogram.width);
        }
      }
    }

    return state.activeSolution;
  }

  String findOverlaps(List<int> clues, String currentSol) {
    /// Finds leftmost solution.
    String leftSolution = currentSol;
    for (int a = 0; a < clues.length; a++) {
      int clue = clues.elementAt(a);

      /// Replaces all next "?" clue times with the clue's index.
      leftSolution = leftSolution.replaceFirstMapped(
        Iterable.generate(clue, (_) => '?').join(),
        (m) => Iterable.generate(clue, (_) => (a + 1).toString()).join(),
      );

      /// Adds an "0" as the next character after the clue solution.
      leftSolution = leftSolution.replaceFirstMapped(
        Iterable.generate(1, (_) => '?').join(),
        (m) => Iterable.generate(1, (_) => '0').join(),
      );
    }

    /// Finds rightMost solution.
    String rightSolution = currentSol;
    for (int b = clues.length - 1; b >= 0; b--) {
      int clue = clues.elementAt(b);

      /// Replaces all next "?" clue times with the clue's index.
      rightSolution = rightSolution.replaceFirstMapped(
        Iterable.generate(clue, (_) => '?').join(),
        (m) => Iterable.generate(clue, (_) => (b + 1).toString()).join(),
      );

      /// Adds an "0" as the next character after the clue solution.
      rightSolution = rightSolution.replaceFirstMapped(
        Iterable.generate(1, (_) => '?').join(),
        (m) => Iterable.generate(1, (_) => '0').join(),
      );
      rightSolution = rightSolution;
    }

    /// Reverses the solution to be accurate.
    rightSolution = rightSolution.split('').reversed.join();

    /// Loop [i] row's fields, and find matches in between the leftMost
    /// and rightMost solutions.
    String updatedSol = currentSol;
    for (int j = 0; j < currentSol.length; j++) {
      var leftSolutionElement = leftSolution.split('').elementAt(j);
      var rightSolutionElement = rightSolution.split('').elementAt(j);
      if ((leftSolutionElement == rightSolutionElement) &&
          leftSolutionElement != '?' &&
          leftSolutionElement != '0' &&
          rightSolutionElement != '?' &&
          rightSolutionElement != '0') {
        updatedSol = updatedSol.replaceRange(j, j + 1, '1');
      }
    }
    return updatedSol;
  }
}
