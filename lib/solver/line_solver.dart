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

      if (rowActiveSol.contains('1')) {
        print('Line has at least one solved box! --------------');
        List<List<String>> pos = Iterable.generate(rowActiveSol.length, (_) => <String>[]).toList();
        for (int cl = 0; cl < rowClues.length; cl++) {
          for (int s = 0; s < rowActiveSol.length; s++) {
            print('finished!');
            pos.elementAt(s).add(canCluesFit(rowClues, rowActiveSol, s, cl) ? '${cl + 2}' : '0');
            // pos[s][cl] = canCluesFit(rowClues, rowActiveSol, s, cl) ? '${cl + 2}' : '0';
            print('pos till now: $pos');
          }
        }
        print('pos: $pos');
      }

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
    if (reverse) sideMostSolution = sideMostSolution.split('').reversed.join();

    List<String> sideMostSolutionList = sideMostSolution.split('');

    print('sideMostSolution $sideMostSolution reverse $reverse and $sideMostSolutionList');

    // todo: change solNumb with letters then
    var solNumbs = List<int>.generate(cluesT.length, (i) => i + 1);
    if (reverse) solNumbs = solNumbs.reversed.toList();

    if (sideMostSolutionList.contains('1')) {
      // print('Line has at least one solved box! --------------');
      // List<List<String>> pos = Iterable.generate(sideMostSolutionList.length, (_) => <String>[]).toList();

      // for (int s = 0; s < sideMostSolutionList.length; s++) {
      //   print('sideMostSolutionList before = $sideMostSolutionList');
      //   List<String> tempSol = sideMostSolutionList.join().split('');
      //
      //   for (int cl = 0; cl < cluesT.length; cl++) {
      //     print('Can box at pos $s be of clue ${cluesT.elementAt(cl)}?');
      //
      //     // tempSol[s] = '${cl + 2}';
      //     print('Simple replacement from $sideMostSolutionList to $tempSol');
      //
      //     bool canFit;
      //
      //     if (s + cluesT.elementAt(cl) > tempSol.length) {
      //       canFit = false;
      //     } else {
      //       List<String> fit = tempSol.getRange(s, s + cluesT.elementAt(cl)).toList();
      //       String valueAfter =
      //           s + cluesT.elementAt(cl) > tempSol.length ? '0' : tempSol.elementAtOrNull(s + cluesT.elementAt(cl)) ?? '0';
      //       String valueBefore = s - 1 < 0 ? '0' : tempSol.elementAtOrNull(s - 1) ?? '0';
      //       canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';
      //       print('valueAfter: $valueAfter');
      //       print('valueBefore: $valueBefore');
      //
      //       print('Can clue fit here? :$valueBefore $fit $valueAfter, answer: ${canFit}');
      //     }
      //
      //     if (canFit) {
      //       List<String> tempSol2 = tempSol.join().split('');
      //       tempSol2.fillRange(s, s + cluesT.elementAt(cl), '${cl + 2}');
      //       if (s + cluesT.elementAt(cl) < tempSol.length) {
      //         tempSol2[s + cluesT.elementAt(cl)] = '0';
      //       }
      //       print('Solution with fit: $tempSol2');
      //
      //       // bool hasCluesBefore = cl > 0;
      //       // print('Does clue have clues before? $hasCluesBefore');
      //       //
      //       // if (hasCluesBefore) {
      //       //   print('Do clues before can fit?');
      //       // }
      //
      //       bool hasCluesAfter = cl == cluesT.length - 1;
      //       print('Does clue have clues after? $hasCluesAfter');
      //
      //       if (hasCluesAfter) {}
      //
      //       // print('')
      //     } else {
      //       pos[s].add('0');
      //     }
      //   }
      // }
    } else {
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
        print('charRange.charactersBefore.length: ${charRange?.charactersBefore.length}');

        if (charRange != null) {
          // can it be clue[clueIndex]'s black box?

          // check if previous clues fit before that clue

          int numberOfQBefore = 0;
          int numberOfOnesBefore = 0;

          for (int i = charRange.charactersBefore.length - 1; i >= 0; i--) {
            final String char = charRange.charactersBefore.elementAt(i);
            if (char == '?') {
              if (numberOfOnesBefore > 0) break;
              numberOfQBefore++;
            } else if (char == '1') {
              if (numberOfQBefore > 0) break;
              numberOfOnesBefore++;
            } else {
              break;
            }
          }

          print('numberOfQBefore: $numberOfQBefore');
          print('numberOfOnesBefore: $numberOfOnesBefore');

          // check if next clues fit after that clue

          int numberOfQAfter = 0;
          int numberOfOnesAfter = 0;

          for (int i = 0; i < charRange.charactersAfter.length; i++) {
            final String char = charRange.charactersAfter.elementAt(i);
            if (char == '?') {
              numberOfQAfter++;
            } else if (char == '1') {
              if (numberOfQAfter > 0) break;
              numberOfOnesAfter++;
            } else {
              break;
            }
          }

          print('numberOfQAfter: $numberOfQAfter');
          print('numberOfOnesAfter: $numberOfOnesAfter');

          // Above code finds the free spaces next to the found block.
          // We should then check

          // if both above true, then yes can be that clue's box
        }
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

  bool canCluesFit(List<int> clues, String solution, int s, int cl) {
    print('sideMostSolutionList before = $solution');
    List<String> tempSol = solution.split('');

    print('Can box at pos $s be of clue ${clues.elementAt(cl)}?');

    // tempSol[s] = '${cl + 2}';
    print('Simple replacement from $solution to $tempSol');

    bool canFit;

    if (s + clues.elementAt(cl) > tempSol.length) {
      canFit = false;
      return false;
    } else {
      List<String> fit = tempSol.getRange(s, s + clues.elementAt(cl)).toList();
      String valueAfter =
          s + clues.elementAt(cl) > tempSol.length ? '0' : tempSol.elementAtOrNull(s + clues.elementAt(cl)) ?? '0';
      String valueBefore = s - 1 < 0 ? '0' : tempSol.elementAtOrNull(s - 1) ?? '0';
      canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';
      print('valueAfter: $valueAfter');
      print('valueBefore: $valueBefore');

      print('Can clue fit here? :$valueBefore $fit $valueAfter, answer: ${canFit}');
    }

    if (canFit) {
      List<String> tempSol2 = tempSol.join().split('');
      tempSol2.fillRange(s, s + clues.elementAt(cl), '${cl + 2}');
      if (s + clues.elementAt(cl) < tempSol.length) {
        tempSol2[s + clues.elementAt(cl)] = '0';
      }
      print('Solution with fit: $tempSol2');

      bool hasCluesBefore = cl > 0;
      print('Does clue have clues before? $hasCluesBefore');

      if (hasCluesBefore) {
        print('Do clues before can fit?');

        bool hasBoxesLeftLeft = s + clues.elementAt(cl) + 1 >= tempSol.length;

        print('Does clue have boxes left after? $hasBoxesLeftLeft');
        if (hasBoxesLeftLeft) {
          // return canCluesFit(clues.sublist(1), solution.split('').sublist(s + clues.elementAt(cl) + 1).join(),0,0);
        } else {
          return false;
        }
      }

      bool hasCluesAfter = cl < clues.length - 1;
      print('Does clue have clues after? $hasCluesAfter');

      if (hasCluesAfter) {
        bool hasBoxesLeft = s + clues.elementAt(cl) + 1 < tempSol.length;

        print('Does clue have boxes left after? $hasBoxesLeft');
        if (hasBoxesLeft) {
          return canCluesFit(clues.sublist(1), solution.split('').sublist(s + clues.elementAt(cl) + 1).join(), 0, 0);
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }

    return false;
  }
}
