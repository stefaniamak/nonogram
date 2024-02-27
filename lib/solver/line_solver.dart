import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

import '../backend/type_extensions/nono_axis_extension.dart';
import '../backend/type_extensions/nono_direction_extension.dart';

class LineSolver {
  void solve(NonogramState state) async {
    overlapping(state);
    // return state.activeSolution.solution!;
  }

  void overlapping(NonogramState state) {
    loopSides(state, state.nonogram.clues!.rows, NonoAxis.row);
    loopSides(state, state.nonogram.clues!.columns, NonoAxis.column);
  }

  void loopSides(NonogramState state, BuiltList<List<int>> clueLineLists, NonoAxis lineType) {
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

        print('Find starting solution of $allLineSolutions with clues $clues.');
        var startingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.start);
        print('Starting most solution: $startingMostSolution');

        print('Find ending solution of $allLineSolutions with clues $clues.');
        var endingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.end);
        print('Ending most solution: $endingMostSolution');

        String updatedSolution = initialSolution;
        for (int charIndex = 0; charIndex < allLineSolutions.length; charIndex++) {
          print(
              'Are all possible solutions (${allLineSolutions.elementAt(charIndex)}) of box at index $charIndex only zeros (0)?');
          if (allLineSolutions.elementAt(charIndex).everyElementIsZero) {
            print('Yes. Cross out this box.');
            updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '0');
            state.setCross(lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width));
          } else {
            print('No.');
            var startingSolutionIndex = startingMostSolution.elementAt(charIndex).first.toString();
            var endingSolutionIndex = endingMostSolution.elementAt(charIndex).first.toString();
            print('Do both side solutions of box at index $charIndex contain the same clue index?');
            print('startingSolutionIndex: $startingSolutionIndex');
            print('endingSolutionIndex  : $endingSolutionIndex');
            if (startingSolutionIndex.isSameClueIndexWith(endingSolutionIndex)) {
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

  List<List<String>> getAllLinePossibleSolutions(List<int> clues, String line) {
    print('Get all possible solutions of line $line with clues $clues');
    List<List<String>> possibleSolutions = Iterable.generate(line.length, (_) => <String>[]).toList();
    for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
      for (int charIndex = 0; charIndex < line.length; charIndex++) {
        String solutionNumb = canCluesFit(clues, line, charIndex, clueIndex) ? '${clueIndex + 2}' : '0';

        int loops = solutionNumb == '0' ? 1 : clues[clueIndex];
        for (int i = charIndex; i < charIndex + loops; i++) {
          if (!possibleSolutions.elementAt(i).contains(solutionNumb)) {
            possibleSolutions.elementAt(i).add(solutionNumb);
          }
        }

        print('possibleSolutions of charIndex $charIndex and clueIndex $clueIndex are: $possibleSolutions');
      }
    }
    print('Final possibleSolutions of line $line with clues $clues is: ${possibleSolutions}');
    return possibleSolutions;
  }

  bool doOtherCluesFit(NonoDirection solutionSide, List<int> clues, int clueIndex, String solution, int solutionIndex) {
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

    bool cluesBeforeGood = doOtherCluesFit(NonoDirection.before, clues, cl, solution, s);
    bool cluesAfterGood = doOtherCluesFit(NonoDirection.after, clues, cl, solution, s);
    print('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
    return cluesBeforeGood && cluesAfterGood;
  }

  List<List<String>> getSideMostSolution(List<List<String>> solution, List<int> clues, NonoAxisAlignment axis) {
    print('Get ${axis.name}ing most solution of solution $solution with clues $clues');

    List<int> clueIndexes = Iterable<int>.generate(clues.length, (c) => c + 2).toList();
    if (axis == NonoAxisAlignment.end) {
      print('All values should reverse');
      solution = solution.reversed.toList();
      clues = clues.reversed.toList();
      clueIndexes = clueIndexes.reversed.toList();
    }

    List<List<String>> sideMostSolution = [];
    List<List<String>> remainingSolution = solution;

    print('Start checking clues one by one. sideMostSolution list is empty, remainingSolution is $remainingSolution');
    for (int i = 0; i < clues.length; i++) {
      int clue = clues[i];
      int clueIndex = clueIndexes.elementAt(i);
      int cluePos = remainingSolution.indexWhere((list) => list.contains('$clueIndex'));
      print('Clue $i with value $clue is found at position $cluePos of remainingSolution $remainingSolution');

      print('Is cluePos $cluePos larger than 0?');
      print(cluePos > 0 ? 'Yes, it is. Add $cluePos "0"s to sideMostSolution list' : 'No, it isn\'t. Move on');
      if (cluePos > 0) sideMostSolution.addAll(Iterable.generate(cluePos, (_) => ['0']).toList());
      print('Add $clue times clueIndex $clueIndex of clue $clue at sideMostSolution list');
      sideMostSolution.addAll(Iterable.generate(clue, (_) => ['$clueIndex']).toList());

      print('Is solution completed?');
      print(sideMostSolution.length < solution.length
          ? 'No, not finished. Add "0" for space at sideMostSolution list and create a new sublist after clue added'
          : 'Yes it is. Move on');
      if (sideMostSolution.length < solution.length) {
        sideMostSolution.add(['0']);
        remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
      }

      print('Current sideMostSolution: $sideMostSolution');
    }

    print('Finished checking all clues. Is sideMostSolution completed?');
    print(sideMostSolution.length < solution.length ? 'No. Complete solution with "0"s' : 'Yes. Move on');
    if (sideMostSolution.length < solution.length) {
      sideMostSolution.addAll(Iterable.generate(remainingSolution.length, (_) => ['0']).toList());
    }
    print('Final sideMostSolution: $sideMostSolution');
    return axis == NonoAxisAlignment.end ? sideMostSolution.reversed.toList() : sideMostSolution;
  }
}
