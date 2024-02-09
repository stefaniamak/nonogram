import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

enum NonoLineType { row, column }

class LineSolver {
  void lineSolver(NonogramState state) async {
    // left most solution

    overlapping(state);

    // return state.activeSolution.solution!;
  }

  // overlapping

  void overlapping(NonogramState state) {
    loopSides(state, state.nonogram.clues!.rows, NonoLineType.row);
    loopSides(state, state.nonogram.clues!.columns, NonoLineType.column);
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

  void loopSides(NonogramState state, BuiltList<List<int>> lines, NonoLineType lineType) {
    for (var i = 0; i < lines.length; i++) {
      /// Gets [i] row's clues.
      List<int> clues = lines.elementAt(i);

      /// Gets current active solution of that [i] row.
      String activeSolLine;
      switch (lineType) {
        case NonoLineType.row:
          activeSolLine = state.activeSolution.getRow(i, state.nonogram);
          break;
        case NonoLineType.column:
          activeSolLine = state.activeSolution.getColumn(i, state.nonogram);
      }

      /// Is row completed? Shall cross out it then and move on.
      int filledBoxes = activeSolLine
          .split('')
          .fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));
      bool isLineCompleted = filledBoxes == clues.fold(0, (previousValue, clue) => previousValue + clue);

      if (isLineCompleted) {
        for (int j = 0; j < activeSolLine.length; j++) {
          if (activeSolLine.characters.elementAt(j) == '?') {
            switch (lineType) {
              case NonoLineType.row:
                state.setCross(i * state.nonogram.width + j);
                break;
              case NonoLineType.column:
                state.setCross(i + j * state.nonogram.width);
            }
          }
        }
      } else {
        List<List<String>> pos = getAllLinePossibleSolutions(clues, activeSolLine);

        /// Crosses out '0's
        for (int j = 0; j < activeSolLine.length; j++) {
          print('pos:: $pos');
          print('pos.elementAt(sInt): ${pos.elementAt(j)}');
          if (pos.elementAt(j).every((e) => e == '0')) {
            switch (lineType) {
              case NonoLineType.row:
                state.setCross(i * state.nonogram.width + j);
                break;
              case NonoLineType.column:
                state.setCross(i + j * state.nonogram.width);
            }
          }
        }

        print('most solution -: $pos');

        /// Find overlaps
        var leftMostSol = getNewSideMostSol(pos, clues);
        print('most solution LEFT: $leftMostSol');

        /// Find overlaps
        var posRev = pos.reversed.toList();
        var cluesRev = clues.reversed.toList();
        var rightMostSol = getNewSideMostSol(posRev, cluesRev).reversed;

        print('most solution RIGHT: $rightMostSol');

        String updatedSol = activeSolLine;
        for (int j = 0; j < pos.length; j++) {
          var leftSolutionElement = leftMostSol.elementAt(j);
          print('leftSolutionElement: $leftSolutionElement');
          var rightSolutionElement = rightMostSol.elementAt(j);
          print('rightSolutionElement: $rightSolutionElement');
          print(
              'leftSolutionElement == rightSolutionElement: ${leftSolutionElement.first == rightSolutionElement.first}');
          if ((leftSolutionElement.first.toString() == rightSolutionElement.first.toString()) &&
              leftSolutionElement.first != '?' &&
              leftSolutionElement.first != '0' &&
              rightSolutionElement.first != '?' &&
              rightSolutionElement.first != '0') {
            switch (lineType) {
              case NonoLineType.row:
                updatedSol = updatedSol.replaceRange(j, j + 1, '1');
                break;
              case NonoLineType.column:
                updatedSol = updatedSol.replaceRange(j, j + 1, '1');
            }
          }
        }
        print('updatedSol: $updatedSol');

        for (int j = 0; j < pos.length; j++) {
          var newSol = updatedSol.split('').elementAt(j);
          var asctiveSol = activeSolLine.split('').elementAt(j);
          if ((newSol != asctiveSol) && newSol == '1') {
            switch (lineType) {
              case NonoLineType.row:
                state.setFilled(i * state.nonogram.width + j);
                break;
              case NonoLineType.column:
                state.setFilled(i + j * state.nonogram.width);
            }
          }
        }
      }
    }
  }
}
