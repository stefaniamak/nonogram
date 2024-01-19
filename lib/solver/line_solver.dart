import 'package:flutter/cupertino.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class LineSolver {
  String lineSolver(NonogramState state) {
    // left most solution

    overlapping(state);

    return state.activeSolution;
  }

  void overlapping(NonogramState state) {
    print('leeeeeft');
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      /// Gets [i] row's clues.
      List<int> rowClue = state.nonogram.clues!.rows.elementAt(i);

      /// Gets current active solution of that [i] row.
      String row =
          state.activeSolution.characters.getRange(i * state.nonogram.width, state.nonogram.width * (i + 1)).string;

      String sol = findOverlaps(rowClue, row);

      for (int j = 0; j < sol.length; j++) {
        var newSol = sol.split('').elementAt(j);
        var activeSol = row.split('').elementAt(j);
        if ((newSol != activeSol) && newSol == '1') {
          state.setFilled(i * state.nonogram.width + j);
        }
      }
    }
    print('riiiiight');
    for (var c = 0; c < state.nonogram.clues!.columns.length; c++) {
      /// Gets [i] column's clues.
      List<int> columnClue = state.nonogram.clues!.columns.elementAt(c);

      /// Gets current active solution of that [i] column.
      String columnSol = '';
      for (var solChar = 0;
          solChar < state.activeSolution.characters.length;
          solChar = solChar + state.nonogram.width) {
        columnSol = '$columnSol${state.activeSolution.characters.characterAt(solChar)}';
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
  }

  String findOverlaps(List<int> clues, String currentSol) {
    print('---');

    /// Finds leftmost solution.
    String leftSolution = findSideMostSolution(currentSol, clues);
    print('leftSolution:  $leftSolution');

    /// Finds rightMost solution.
    String rightSolution = findSideMostSolution(currentSol, clues, true);
    print('rightSolution: $rightSolution');

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

  /// Call revers=true for rightmost sol.
  String findSideMostSolution(String currentSol, List<int> clues, [bool reverse = false]) {
    /// Finds leftmost solution.
    String sideMostSolution = currentSol;
    List<int> cluesT = clues;
    // print('reverse: $reverse');
    print('cluesT before: $cluesT');
    if (reverse) cluesT = clues.reversed.toList();
    print('cluesluesT after: $cluesT}');

    // todo: change solNumb with letters then
    var solNumbs = List<int>.generate(cluesT.length, (i) => i + 1);
    if (reverse) solNumbs = solNumbs.reversed.toList();

    for (int a = 0; a < cluesT.length; a++) {
      int clue = cluesT.elementAt(a);

      /// Replaces all next "?" clue times with the clue's index.
      sideMostSolution = sideMostSolution.replaceFirstMapped(
        Iterable.generate(clue, (_) => '?').join(),
        (m) => Iterable.generate(clue, (_) => (solNumbs.elementAt(a) + 1).toString()).join(),
      );

      /// Adds an "0" as the next character after the clue solution.
      sideMostSolution = sideMostSolution.replaceFirstMapped(
        Iterable.generate(1, (_) => '?').join(),
        (m) => Iterable.generate(1, (_) => '0').join(),
      );
    }

    /// Reverses the solution to be accurate.
    if (reverse) sideMostSolution = sideMostSolution.split('').reversed.join();
    // print('reverse: $reverse');
    // print('sideMostSolution: $sideMostSolution');

    return sideMostSolution;
  }
}
