import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/backend/enum/nono_line_type.dart';
import 'package:nonogram/backend/enum/nono_solution_side.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

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

  void loopSides(NonogramState state, BuiltList<List<int>> lines, NonoLineType lineType) {
    for (var l = 0; l < lines.length; l++) {
      /// Gets [l] row's clues.
      List<int> clues = lines.elementAt(l);

      /// Gets current active solution of that [l] row.
      String activeSolLine = state.activeSolution.getLine(l, state.nonogram, lineType);

      /// Is row completed? Shall cross out it then and move on.
      int filledBoxes = activeSolLine
          .split('')
          .fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));
      bool isLineCompleted = filledBoxes == clues.fold(0, (previousValue, clue) => previousValue + clue);

      if (isLineCompleted) {
        for (int j = 0; j < activeSolLine.length; j++) {
          if (activeSolLine.characters.elementAt(j) == '?') {
            state.setCross(lineType.getSolutionPosition(l, j, state.nonogram.width));
          }
        }
      } else {
        List<List<String>> pos = getAllLinePossibleSolutions(clues, activeSolLine);

        /// Crosses out '0's
        for (int j = 0; j < activeSolLine.length; j++) {
          print('pos:: $pos');
          print('pos.elementAt(sInt): ${pos.elementAt(j)}');
          if (pos.elementAt(j).every((e) => e == '0')) {
            state.setCross(lineType.getSolutionPosition(l, j, state.nonogram.width));
          }
        }

        print('most solution -: $pos');

        /// Find overlaps
        var leftMostSol = getSideMostSol(pos, clues);
        print('most solution LEFT: $leftMostSol');

        /// Find overlaps
        var posRev = pos.reversed.toList();
        var cluesRev = clues.reversed.toList();
        var rightMostSol = getSideMostSol(posRev, cluesRev).reversed;

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
            updatedSol = updatedSol.replaceRange(j, j + 1, '1');
          }
        }
        print('updatedSol: $updatedSol');

        for (int j = 0; j < pos.length; j++) {
          var newSol = updatedSol.split('').elementAt(j);
          var asctiveSol = activeSolLine.split('').elementAt(j);
          if ((newSol != asctiveSol) && newSol == '1') {
            state.setFilled(lineType.getSolutionPosition(l, j, state.nonogram.width));
          }
        }
      }
    }
  }

  List<List<String>> getAllLinePossibleSolutions(List<int> clues, String line) {
    print('Line has at least one solved box! --------------');
    List<List<String>> pos = Iterable.generate(line.length, (_) => <String>[]).toList();
    for (int cl = 0; cl < clues.length; cl++) {
      for (int s = 0; s < line.length; s++) {
        String solNumb = canCluesFit(clues, line, s, cl) ? '${cl + 2}' : '0';
        if (solNumb == '0') {
          pos.elementAt(s).add(solNumb);
        } else {
          int clueNumb = clues[cl];
          for (int l = s; l < s + clueNumb; l++) {
            pos.elementAt(l).add(solNumb);
          }
        }
        print('pos till now: $pos');
      }
    }
    print('pos: ${pos}');
    return pos;
  }

  bool doOtherCluesFit(
      NonoSolutionSide solutionSide, List<int> clues, int clueIndex, String solution, int solutionIndex) {
    int clue = clues.elementAt(clueIndex);

    print('Does clue have clues ${solutionSide.name}?');
    if (!solutionSide.hasOtherClues(clueIndex, clues.length)) {
      print('It does not. Return `true`.');
      return true;
    }
    print('It does. Continue checking.');

    print('Does clue have boxes left for clues left?');
    if (!solutionSide.hasBoxesLeft(solutionIndex, clue, solution.split('').length)) {
      print('It does not. Return `false`.');
      return false;
    }
    print('It does. Continue checking.');

    String solutionSublist = solutionSide.getSolutionSublist(solution, solutionIndex, clue);
    List<int> cluesSublist = solutionSide.getCluesSublist(clueIndex, clues);
    print('Does solution sublist $solutionSublist fit clues $cluesSublist?');
    for (int solutionSublistIndex = 0; solutionSublistIndex < solutionSublist.length; solutionSublistIndex++) {
      if (canCluesFit(cluesSublist, solutionSublist, solutionSublistIndex, 0)) {
        print('It does fit. Return `true`.');
        return true;
      }
    }
    print('It does not fit. Return `false`.');
    return false;
  }

  bool canCluesFit(List<int> clues, String solution, int s, int cl) {
    List<String> solutionList = solution.split('');
    int clue = clues.elementAt(cl);
    bool canFit;

    print('Does clue $clue fit at $solutionList from position $s to position ${s + clue}?');
    if (clue > solutionList.getRange(s, solutionList.length).length) {
      print('false');
      return false;
    }
    print('true');

    List<String> fit = solutionList.getRange(s, s + clue).toList();
    String valueAfter = s + clue > solutionList.length ? '0' : solutionList.elementAtOrNull(s + clue) ?? '0';
    String valueBefore = s - 1 < 0 ? '0' : solutionList.elementAtOrNull(s - 1) ?? '0';
    canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';

    print('Can clue $clue fit at: $valueBefore $fit $valueAfter');
    if (!canFit) {
      print('false');
      return false;
    }
    print('true');

    bool cluesBeforeGood = doOtherCluesFit(NonoSolutionSide.before, clues, cl, solution, s);
    bool cluesAfterGood = doOtherCluesFit(NonoSolutionSide.after, clues, cl, solution, s);
    print('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
    return cluesBeforeGood && cluesAfterGood;
  }

  List<List<String>> getSideMostSol(List<List<String>> solution, List<int> clues) {
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
}
