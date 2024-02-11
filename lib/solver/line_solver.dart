import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

import '../backend/type_extensions/nono_line_type_extension.dart';
import '../backend/type_extensions/nono_solution_side_extension.dart';

class LineSolver {
  void solve(NonogramState state) async {
    overlapping(state);
    // return state.activeSolution.solution!;
  }

  void overlapping(NonogramState state) {
    loopSides(state, state.nonogram.clues!.rows, NonoLineType.row);
    loopSides(state, state.nonogram.clues!.columns, NonoLineType.column);
  }

  void loopSides(NonogramState state, BuiltList<List<int>> clueLineLists, NonoLineType lineType) {
    for (int lineIndex = 0; lineIndex < clueLineLists.length; lineIndex++) {
      print('Check ${lineType.name} with index $lineIndex.');

      List<int> clues = clueLineLists.elementAt(lineIndex);
      print('${lineType.name}\'s clues: $clues');

      String initialSolution = state.activeSolution.getLine(lineIndex, state.nonogram, lineType);
      print('${lineType.name}\'s initialSolution: $initialSolution');

      int filledBoxes = initialSolution.sumFilledBoxes;
      bool isLineCompleted = filledBoxes == clues.sum;
      print('Are filled boxes ($filledBoxes) equal with clue\'s sum (${clues.sum})?');

      if (isLineCompleted) {
        print('It is. Shall cross out remaining empty boxes if any left.');
        if (initialSolution.characters.contains('?')) {
          for (int charIndex = 0; charIndex < initialSolution.length; charIndex++) {
            if (initialSolution.characterAt(charIndex) == '?') {
              state.setCross(lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width));
            }
          }
        }
      } else {
        print('It is not. Starts to calculate all possible solutions...');
        List<List<String>> allLineSolutions = getAllLinePossibleSolutions(clues, initialSolution);
        print('All line solutions: $allLineSolutions');

        var startingMostSolution = getSideMostSolution(allLineSolutions, clues);
        print('Starting most solution: $startingMostSolution');

        var allLineSolutionsReversed = allLineSolutions.reversed.toList();
        var cluesReversed = clues.reversed.toList();
        var endingMostSolution = getSideMostSolution(allLineSolutionsReversed, cluesReversed).reversed;
        print('Ending most solution: $endingMostSolution');

        String updatedSolution = initialSolution;
        for (int charIndex = 0; charIndex < allLineSolutions.length; charIndex++) {
          print('Does list contains only zeros (0)?');
          if (allLineSolutions.elementAt(charIndex).everyElementIsZero) {
            print('Yes. Cross out this box.');
            updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '0');
            state.setCross(lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width));
          } else {
            print('No.');
            var startingSolutionElement = startingMostSolution.elementAt(charIndex).first.toString();
            var endingSolutionElement = endingMostSolution.elementAt(charIndex).first.toString();
            print('Do both lists contain the same clue index? ');
            if (startingSolutionElement.isSameClueIndexWith(endingSolutionElement)) {
              print('Yes. Fill in this box.');
              updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '1');
              state.setFilled(lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width));
            } else {
              print('No. It contains different indexes.');
            }
          }
        }
        print('Overlapped solution: $updatedSolution');
      }
    }
  }

  @override
  String toString() {
    return 'LineSolver{}';
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

  List<List<String>> getSideMostSolution(List<List<String>> solution, List<int> clues) {
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
