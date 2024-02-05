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

      /// Is row completed? Shall cross out it then and move on.
      int filledBoxes =
          rowActiveSol.split('').fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));
      bool isRowCompleted = filledBoxes == rowClues.fold(0, (previousValue, clue) => previousValue + clue);

      if (isRowCompleted) {
        for (int j = 0; j < rowActiveSol.length; j++) {
          if (rowActiveSol.characters.elementAt(j) == '?') {
            state.setCross(i * state.nonogram.width + j);
          }
        }
      } else {
        List<List<String>> pos = getAllLinePossibleSolutions(rowClues, rowActiveSol);

        /// Crosses out '0's
        for (int j = 0; j < rowActiveSol.length; j++) {
          print('pos:: $pos');
          print('pos.elementAt(sInt): ${pos.elementAt(j)}');
          if (pos.elementAt(j).every((e) => e == '0')) {
            state.setCross(i * state.nonogram.width + j);
          }
        }

        print('most solution -: $pos');

        /// Find overlaps
        var leftMostSol = getNewSideMostSol(pos, rowClues);
        print('most solution LEFT: $leftMostSol');

        /// Find overlaps
        var posRev = pos.reversed.toList();
        var rowCluesRev = rowClues.reversed.toList();
        var rightMostSol = getNewSideMostSol(posRev, rowCluesRev).reversed;

        print('most solution RIGHT: $rightMostSol');

        String updatedSol = rowActiveSol;
        for (int j = 0; j < pos.length; j++) {
          var leftSolutionElement = leftMostSol.elementAt(j);
          var rightSolutionElement = rightMostSol.elementAt(j);

          if ((leftSolutionElement.first.toString() == rightSolutionElement.first.toString()) &&
              leftSolutionElement.first != '?' &&
              leftSolutionElement.first != '0' &&
              rightSolutionElement.first != '?' &&
              rightSolutionElement.first != '0') {
            updatedSol = updatedSol.replaceRange(j, j + 1, '1');
          }
        }

        for (int j = 0; j < pos.length; j++) {
          var newSol = updatedSol.split('').elementAt(j);
          var activeSol = rowActiveSol.split('').elementAt(j);
          if ((newSol != activeSol) && newSol == '1') {
            state.setFilled(i * state.nonogram.width + j);
          }
        }
      }
    }

    for (var c = 0; c < state.nonogram.clues!.columns.length; c++) {
      /// Gets [i] column's clues.
      List<int> columnClues = state.nonogram.clues!.columns.elementAt(c);

      /// Gets current active solution of that [i] column.
      String columnActiveSol = state.activeSolution.getColumn(c, state.nonogram);

      /// Is row completed? Shall cross out it then and move on.
      int filledBoxes = columnActiveSol
          .split('')
          .fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));
      bool isRowCompleted = filledBoxes == columnClues.fold(0, (previousValue, clue) => previousValue + clue);

      if (isRowCompleted) {
        for (int j = 0; j < columnActiveSol.length; j++) {
          if (columnActiveSol.characters.elementAt(j) == '?') {
            state.setCross(c + j * state.nonogram.width);
          }
        }
      } else {
        List<List<String>> pos = getAllLinePossibleSolutions(columnClues, columnActiveSol);

        for (int j = 0; j < columnActiveSol.length; j++) {
          print('pos $pos');
          print('pos.elementAt(sInt): ${pos.elementAt(j)}');
          if (pos.elementAt(j).every((e) => e == '0')) {
            state.setCross(c + j * state.nonogram.width);
          }
        }

        print('most solution -: $pos');

        /// Find overlaps
        var leftMostSol = getNewSideMostSol(pos, columnClues);
        print('most solution LEFT: $leftMostSol');

        /// Find overlaps
        var posRev = pos.reversed.toList();
        var columnCluesRev = columnClues.reversed.toList();
        var rightMostSol = getNewSideMostSol(posRev, columnCluesRev).reversed;
        print('most solution RIGHT: $rightMostSol');

        String updatedSol = columnActiveSol;
        for (int j = 0; j < pos.length; j++) {
          var leftSolutionElement = leftMostSol.elementAt(j);
          var rightSolutionElement = rightMostSol.elementAt(j);
          if ((leftSolutionElement.first.toString() == rightSolutionElement.first.toString()) &&
              leftSolutionElement.first != '?' &&
              leftSolutionElement.first != '0' &&
              rightSolutionElement.first != '?' &&
              rightSolutionElement.first != '0') {
            updatedSol = updatedSol.replaceRange(j, j + 1, '1');
          }
        }

        for (int j = 0; j < leftMostSol.length; j++) {
          var newSol = updatedSol.split('').elementAt(j);
          var activeSol = columnActiveSol.split('').elementAt(j);
          if ((newSol != activeSol) && newSol == '1') {
            state.setFilled(c + j * state.nonogram.width);
          }
        }
      }
    }
  }

  List<List<String>> getNewSideMostSol(List<List<String>> solution, List<int> clues) {
    print('///// getNewSideMostSol starts');
    print('solution: $solution , clues: $clues');
    List<int> clueIndexes = Iterable<int>.generate(clues.length, (c) => c + 2).toList();
    String firstClueIndex = solution
        .firstWhere((list) => list.contains('2') || list.contains('${clues.length + 1}'))
        .firstWhere((item) => item != '0' && item != '1' && item != '?');
    print('clueIndexes: $clueIndexes');
    print('firstClueIndex: $firstClueIndex');
    if (firstClueIndex != '2') clueIndexes = clueIndexes.reversed.toList();
    print('clueIndexes AFTER: $clueIndexes');

    List<List<String>> sideMostSol = [];
    List<List<String>> remainingSolution = solution;
    print('starting remainingSolution: $remainingSolution');
    print('starting sideMostSol: $sideMostSol');

    for (int i = 0; i < clues.length; i++) {
      int clue = clues[i];
      int clueIndex = clueIndexes.elementAt(i);
      int cluePos = remainingSolution.indexWhere((list) => list.contains('$clueIndex'));
      print('- pos $i , clue $clue , cluePos $cluePos');
      print('remainingSolution before: $remainingSolution');
      print('sideMostSol before: $sideMostSol');

      if (cluePos > 0) sideMostSol.addAll(Iterable.generate(cluePos, (_) => ['0']).toList());
      sideMostSol.addAll(Iterable.generate(clue, (_) => ['$clueIndex']).toList());
      if (sideMostSol.length < solution.length) {
        sideMostSol.add(['0']);
        remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
      }

      print('remainingSolution after: $remainingSolution');
      print('sideMostSol after: $sideMostSol');
    }
    if (sideMostSol.length < solution.length) {
      sideMostSol.addAll(Iterable.generate(remainingSolution.length, (_) => ['0']).toList());
    }
    print('final sidemost solution: $sideMostSol');
    return sideMostSol;
  }

  /// Second Algorithm.

  List<List<String>> getAllLinePossibleSolutions(List<int> clues, String line) {
    print('Line has at least one solved box! --------------');
    List<List<String>> pos = Iterable.generate(line.length, (_) => <String>[]).toList();
    for (int cl = 0; cl < clues.length; cl++) {
      int s = 0;
      while (s < line.length) {
        print('started!');
        String solNumb = canCluesFit(clues, line, s, cl) ? '${cl + 2}' : '0';
        print('finished!');

        if (solNumb == '0') {
          pos.elementAt(s).add(solNumb);
          s++;
        } else {
          int clueNumb = clues[cl];
          for (int l = s; l < s + clueNumb; l++) {
            pos.elementAt(l).add(solNumb);
          }
          s++;
        }
        print('pos till now: $pos');
      }
    }
    print('pos: ${pos}');
    return pos;
  }

  bool canCluesFit(List<int> clues, String solution, int s, int cl) {
    print('sideMostSolutionList before = $solution');
    List<String> tempSol = solution.split('');

    print('Can box at pos $s be of clue ${clues.elementAt(cl)}?');

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

      bool cluesBeforeGood;

      if (hasCluesBefore) {
        print('Do clues before can fit?');

        bool hasBoxesLeftLeft = s - 1 >= 0;

        print('Does clue have boxes left before? $hasBoxesLeftLeft');
        if (hasBoxesLeftLeft) {
          print('we at box $s');
          print('clues $clues and range ${clues.getRange(0, cl)}');
          print('solution $solution and range ...');
          print('                             ... ${solution.split('').sublist(0, s - 1).join()}0');

          cluesBeforeGood = false;
          String solSub = '${solution.split('').sublist(0, s - 1).join()}0';
          var clll = clues.getRange(0, cl).toList();
          for (int p = 0; p < solSub.length; p++) {
            if (canCluesFit(clll, solSub, p, 0)) {
              cluesBeforeGood = true;
              break;
            }
          }
        } else {
          cluesBeforeGood = false;
        }
      } else {
        print('we at box $s');
        print('clues $clues and range ${clues.getRange(0, cl)}');
        cluesBeforeGood = true;
      }

      bool hasCluesAfter = cl < clues.length - 1;
      print('Does clue have clues after? $hasCluesAfter');

      bool cluesAfterGood;

      if (hasCluesAfter) {
        bool hasBoxesLeft = s + clues.elementAt(cl) + 1 < tempSol.length;

        print('Does clue have boxes left after? $hasBoxesLeft');
        if (hasBoxesLeft) {
          var ccl = clues.sublist(1 + cl);
          String solSub = solution.split('').sublist(s + clues.elementAt(cl) + 1).join();
          cluesAfterGood = false;
          for (int p = 0; p < solSub.length; p++) {
            if (canCluesFit(ccl, solSub, p, 0)) {
              cluesAfterGood = true;
              break;
            }
          }
        } else {
          cluesAfterGood = false;
        }
      } else {
        cluesAfterGood = true;
      }

      return cluesBeforeGood && cluesAfterGood;
    } else {
      return false;
    }
  }
}
