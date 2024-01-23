import 'package:flutter/widgets.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class LineSolver {
  void lineSolver(NonogramState state) async {
    // left most solution

    overlapping(state);

    // return state.activeSolution.solution!;
  }

  // overlapping

  void overlapping(NonogramState state) {
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      /// Gets [i] row's clues.
      List<int> rowClues = state.nonogram.clues!.rows.elementAt(i);

      /// Gets current active solution of that [i] row.
      String rowActiveSol = state.activeSolution.getRow(i, state.nonogram);

      String sol = findOverlaps(rowClues, rowActiveSol);

      for (int j = 0; j < sol.length; j++) {
        var newSol = sol.split('').elementAt(j);
        var activeSol = rowActiveSol.split('').elementAt(j);
        if ((newSol != activeSol) && newSol == '1') {
          state.setFilled(i * state.nonogram.width + j);
        }
      }
    }

    for (var c = 0; c < state.nonogram.clues!.columns.length; c++) {
      /// Gets [i] column's clues.
      List<int> columnClues = state.nonogram.clues!.columns.elementAt(c);

      /// Gets current active solution of that [i] column.
      String columnActiveSol = state.activeSolution.getColumn(c, state.nonogram);

      String sol = findOverlaps(columnClues, columnActiveSol);

      for (int j = 0; j < sol.length; j++) {
        var newSol = sol.split('').elementAt(j);
        var activeSol = columnActiveSol.split('').elementAt(j);
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

  // cross out

  void crossOut(NonogramState state) {
    print('active soooool: ${state.activeSolution}');
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      List<int> clues = state.nonogram.clues!.rows.elementAt(i);
      String activeSol = state.activeSolution.getRow(i, state.nonogram);

      // find if clue is completed
      for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
        CharacterRange? charRange = activeSol.characters.findFirst('1'.characters);
        print('charRange: ${charRange}');

        // can it be clue[clueIndex]'s black box?

        // check if previous clues fit before that clue

        // check if next clues fit after that clue

        // if both above true, then yes can be that clue's box
      }

      // I now know a list of clues (or clue indexes) that this '1' can be

      // if that list has just one clue in, or same number clue, then

      // is that clue done? see chars after findFirst chat position

      // yes it is? put '0' before and after the '1's

      // is that clue first?

      // check how much left does it extend, and put '0' to boxes that wont be filled

      // is that clue last?

      // do same as for first
    }
  }
}
