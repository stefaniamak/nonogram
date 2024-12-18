import 'dart:convert';
import 'dart:developer';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/models/solver_settings.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_direction_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/solver/line_solver_helper.dart';

@isolateManagerCustomWorker
void lineSolverIsolate(dynamic params) {
  IsolateManagerFunction.customFunction<String, String>(
    params,
    onEvent: (IsolateManagerController<String, String> controller, String message) {
      final IsolateInput input = IsolateInput.fromJson(jsonDecode(message));
      final List<Map<int, NonoAxis>> stack = initializeStackList(input.nonogram.clues);
      List<SolutionStep> solutionSteps = input.solutionSteps;
      final Map<String, bool> cachedBoxSolutions = <String, bool>{};
      final List<int> linesCheckedList = <int>[0];
      final List<int> boxesChecked = <int>[0];
      final List<int> otherBoxesChecked = <int>[0];

      IsolateOutput progress = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
        cachedBoxSolutions: cachedBoxSolutions,
        linesCheckedList: linesCheckedList,
        boxesCheckedList: boxesChecked,
        otherBoxesCheckedList: otherBoxesChecked,
      );

      while (stack.isNotEmpty) {
        final Map<int, NonoAxis> line = stack.first;
        final List<int> clues = (line.values.first == NonoAxis.row ? input.nonogram.clues.rows : input.nonogram.clues.columns)
            .elementAt(line.keys.first);

        progress = loopSides(
          lineIndex: line.keys.first,
          clues: clues,
          lineType: line.values.first,
          nonogram: input.nonogram,
          output: IsolateOutput(
            stack: stack,
            cachedBoxSolutions: cachedBoxSolutions,
            linesCheckedList: linesCheckedList,
            boxesCheckedList: boxesChecked,
            solutionSteps: solutionSteps,
            otherBoxesCheckedList: otherBoxesChecked,
          ),
          settings: input.solverSettings,
        );

        controller.sendResult(
          jsonEncode(
            <String, Map<String, dynamic>>{
              'progress': progress.toJson(),
            },
          ),
        );

        if (progress.stack.isNotEmpty) stack.addAll(progress.stack);
        if (progress.solutionSteps.isNotEmpty) solutionSteps = progress.solutionSteps;

        stack.removeAt(0);
      }

      solutionSteps.add(
        SolutionStep(
          currentSolution: solutionSteps.last.currentSolution,
          explanation: solutionSteps.last.currentSolution.split('').contains('?') ? 'Nonogram not solved' : 'Nonogram solved',
          newFilledBoxes: <int>[],
        ),
      );

      final IsolateOutput results = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
        cachedBoxSolutions: cachedBoxSolutions,
        linesChecked: linesCheckedList.last,
        boxesChecked: boxesChecked.last,
        otherBoxesChecked: otherBoxesChecked.last,
        totalCacheData: cachedBoxSolutions.length,
      );
      // This is a final value.
      return jsonEncode(<String, IsolateOutput>{'result': results});
    },
  );
}

// @isolateManagerCustomWorker
IsolateOutput loopSides({
  required int lineIndex,
  required List<int> clues,
  required NonoAxis lineType,
  required Nonogram nonogram,
  required IsolateOutput output,
  required SolverSettings settings,
  bool printLogs = false,
}) {
  output.linesCheckedList.add(output.linesCheckedList.last + 1);
  output.linesCheckedList.removeAt(0);

  if (printLogs) log('Check ${lineType.name} with index $lineIndex.');
  if (printLogs) log("${lineType.name}'s clues: $clues");
  final String initialSolution = LineSolverHelper.instance.getSolutionLine(
    output.solutionSteps.last.currentSolution,
    nonogram.width,
    lineIndex,
    lineType,
  );

  final List<int> charIndexesOfQMarks = LineSolverHelper.instance.getCharIndexesOfQuestionMarks(initialSolution);

  if (printLogs) log("${lineType.name}'s initialSolution: $initialSolution");
  int filledBoxes = initialSolution.sumFilledBoxes;
  bool isLineCompleted = filledBoxes == clues.sum;

  if (printLogs) log("Are filled boxes ($filledBoxes) equal with clue's sum (${clues.sum})?");
  if (isLineCompleted) {
    if (printLogs) log('It is. Shall cross out remaining empty boxes if any left.');
    if (initialSolution.split('').toList().contains('?')) {
      // TODO(stef): restore groupSteps
      final int charStart = initialSolution.split('').toList().indexWhere((String char) => char == '?');
      final int charEnd = initialSolution.split('').toList().lastIndexWhere((String char) => char == '?') + 1;
      if (printLogs) {
        log('charStart: $charStart');
        log('charEnd: $charEnd');
      }

      /// The following 3 lines use the list of indexes of "?" in the line solution to find and replace them
      /// with "0"s in the entire puzzle solution String.
      ///
      /// We use RegEx for this task because the positions of a column in the solution String are spread out,
      /// unlike those of a row, which are contiguous.
      ///
      /// To find the global positions of each column index in the entire puzzle solution, we convert the local
      /// indexes from the line solution String to global indexes, taking into account the line we are searching.
      ///
      /// We create a RegEx to find and replace the specific characters in the global solution with "0".
      ///
      /// The RegEx searches for single character Strings with a specific number of characters before them.
      /// We generate the required number of characters based on the list of indexes from the local solution,
      /// and the RegEx matches Strings with exactly that many characters before them.
      ///
      /// The RegEx is `(?<=lookbehinds).` where [lookbehinds] is another RegEx String, generated from the local positions list.
      /// This String consists of multiple RegEx patterns like `(?<=^.{7}).` (where "7" is any number 0 or above),
      /// grouped and separated by "|". Let's break down the parts of the RegEx:
      ///
      /// Explaining `(?<=lookbehinds).`:
      ///   (?<=lookbehinds): Matches where [lookbehinds] is true.
      ///   .               : Matches the next character after the lookbehind condition.
      ///
      /// Explaining `lookbehinds`, e.g. ((?<=^.{7}).)|(?<=^.{10}).):
      ///   (?<=^.{7}).    :
      ///     (?<= : Lookbehind assertion to ensure what precedes the match...
      ///     ^    : Is the start of the String...
      ///     .    : Followed by any single character...
      ///     {7}  : Previous case repeated exactly 7 times (where "7" is any number 0 or above)...
      ///     .    : Matches the character immediately following this sequence.
      ///   |    : Or (alternates between the above generated number conditions).
      ///
      /// e.g. RegEx `((?<=^.{7}).)|(?<=^.{10}).)` applied to a String will return the 8th and 11th
      /// characters, as they have exactly 7 and 10 characters before them, respectively.
      ///
      /// We use this regex with replaceAllMapped to change the "?" characters to "0".
      ///
      String fullUpdatedSolution = output.solutionSteps.last.currentSolution;
      final List<int> newFilledBoxes = <int>[];

      // TODO(stef): add "useLookbehind" variable
      if (false) {
        final String lookbehinds =
            charIndexesOfQMarks.map((int pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
        final RegExp solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

        fullUpdatedSolution =
            output.solutionSteps.last.currentSolution.replaceAllMapped(solutionIndexesRegexp, (Match match) => '0');
        if (printLogs) log('fullUpdatedSolution: $fullUpdatedSolution');
      } else {
        for (final int charIndex in charIndexesOfQMarks) {
          final int tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
          newFilledBoxes.add(tempPos);
          fullUpdatedSolution = '${fullUpdatedSolution.substring(0, tempPos)}0${fullUpdatedSolution.substring(tempPos + 1)}';
        }
      }
      // here

      // TODO(stef): restore these two bellow
      return IsolateOutput(
        stack: output.stack.getNewStackElements(charIndexesOfQMarks, lineType),
        solutionSteps: <SolutionStep>[
          SolutionStep(
            currentSolution: fullUpdatedSolution,
            axis: lineType,
            lineIndex: lineIndex,
            explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
            newFilledBoxes: newFilledBoxes,
          ),
        ],
        linesChecked: output.linesCheckedList.last,
        boxesChecked: output.boxesCheckedList.last,
        otherBoxesChecked: output.otherBoxesCheckedList.last,
        totalCacheData: output.cachedBoxSolutions.length,
        // linesCheckedList: output.linesCheckedList,
        // cachedBoxSolutions: output.cachedBoxSolutions,
        // boxesCheckedList: output.boxesCheckedList,
        // otherBoxesCheckedList: output.otherBoxesCheckedList,
      );
    }
  } else {
    // if (activateReturnOnNotEnoughSolvedLines && filledBoxes < (clues.sum / 4) && (state.nonogram.width / 4) > clues.sum) {
    //   return;
    // }
    if (printLogs) log('It is not. Starts to calculate all possible solutions...');
    // log('line type: $lineType + line index: $lineIndex');
    final List<List<String>> allLineSolutions = getAllLinePossibleSolutions(clues, initialSolution, output, settings);
    if (printLogs) log('All line solutions: $allLineSolutions');

    if (printLogs) log('Find starting solution of $allLineSolutions with clues $clues.');
    final List<String> startingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.start);

    if (printLogs) log('Starting most solution: $startingMostSolution');

    if (printLogs) log('Find ending solution of $allLineSolutions with clues $clues.');
    final List<String> endingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.end);

    if (printLogs) log('Ending most solution  : $endingMostSolution');

    const String updatedSolution = '';

    // TODO(stef): restore groupSteps
    // Generate a regex pattern to match any number except those in the exclusion list
    final String inclusionPattern = charIndexesOfQMarks.map((int e) => e).join('|');
    // Precompile regex patterns
    final RegExp regZeroFilledMatches = RegExp(r'\((' + inclusionPattern + r'), \[(0)\]\)');
    // Convert input lists to string once
    final String inputZeros = allLineSolutions.indexed.toList().toString();
    // Find matches using precompiled regex patterns
    final Iterable<RegExpMatch> matchesZeros = regZeroFilledMatches.allMatches(inputZeros);

    // Use a map to store the right number as keys and a set of left numbers as values for pairs that appear twice
    final Map<int, Set<int>> matchMap = <int, Set<int>>{};

    final Set<(int, String)> inputNumbersStart = startingMostSolution.indexed.toSet();
    final Set<(int, String)> inputNumbersEnd = endingMostSolution.indexed.toSet();
    final Set<(int, String)> duplicateInputNumbers = inputNumbersStart.intersection(inputNumbersEnd);
    // log('duplicateInputNumbers: $duplicateInputNumbers');

    for (final (int, String) match in duplicateInputNumbers) {
      (int, String) pair = match;
      final int leftNumber = pair.$1;
      final int rightNumber = int.parse(pair.$2);
      if (rightNumber != 0 && charIndexesOfQMarks.contains(leftNumber)) {
        matchMap.putIfAbsent(rightNumber, () => <int>{});
        matchMap[rightNumber]!.add(leftNumber);
      }
    }

    if (matchesZeros.isNotEmpty) {
      matchMap.putIfAbsent(0, () => <int>{});
      matchMap[0]!.addAll(matchesZeros.map((RegExpMatch match) => int.parse(match.group(1)!)));
    }

    // Convert the sets to lists and print the final map
    final Map<int, List<int>> result = matchMap.map((int key, Set<int> value) => MapEntry(key, value.toList()));
    // log('result: $result');

    final List<Map<int, NonoAxis>> finalStack = []; //output.stack; // List.from(output.stack);
    List<int> newFilledBoxes = <int>[];
    final List<SolutionStep> newSolutionSteps = <SolutionStep>[];
    String fullUpdatedSolution = output.solutionSteps.last.currentSolution;

    // here 2
    if (result.isNotEmpty) {
      for (final int clueKey in result.keys) {
        final List<int> charIndexes = result[clueKey]!;
        final int clueIndex = clueKey == 0 ? 0 : clueKey - 2;

        // TODO(stef): add "useLookbehind" variable
        if (false) {
          final String lookbehinds =
              charIndexes.map((int pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
          final RegExp solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

          fullUpdatedSolution = output.solutionSteps.last.currentSolution
              .replaceAllMapped(solutionIndexesRegexp, (Match match) => clueKey == 0 ? '0' : '1');
        } else {
          for (final int charIndex in charIndexes) {
            final int tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            newFilledBoxes.add(tempPos);
            fullUpdatedSolution = fullUpdatedSolution.substring(0, tempPos) +
                (clueKey == 0 ? '0' : '1') +
                fullUpdatedSolution.substring(tempPos + 1);
          }
        }

        if (printLogs) log('fullUpdatedSolution: $fullUpdatedSolution');

        // TODO(stef): restore these two bellow
        if (newFilledBoxes.isNotEmpty) {
          String initialSolution2; // = solutionSteps.last.currentSolution.getLine(lineIndex, nonogram, lineType);
          switch (lineType) {
            case NonoAxis.row:
              initialSolution2 = fullUpdatedSolution
                  .split('')
                  .toList()
                  .getRange(lineIndex * nonogram.width, nonogram.width * (lineIndex + 1))
                  .join()
                  .replaceAll(' ', '')
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .replaceAll(',', '');
            case NonoAxis.column:
              String columnSol = '';
              for (int solChar = lineIndex;
                  solChar < output.solutionSteps.last.currentSolution.split('').toList().length;
                  solChar = solChar + nonogram.width) {
                columnSol = '$columnSol${output.solutionSteps.last.currentSolution.split('').toList().elementAt(solChar)}';
              }
              initialSolution2 = columnSol;
          }

          filledBoxes = initialSolution2.sumFilledBoxes;
          isLineCompleted = filledBoxes == clues.sum;
          // finalStack = finalStack.updateStack(charIndexes, lineType);
          // if (clues.elementAt(clueIndex) == 14 && clueIndex == 1 && lineIndex == 18) {
          //   log('initialSolution2.sumFilledBoxes: ${initialSolution2.sumFilledBoxes} and clues.sum: ${clues.sum}');
          //   log('isLineCompleted: $isLineCompleted && initialSolution2: $initialSolution2');
          //   log(
          //       'isLineCompleted && fullUpdatedSolution.split(\'\').contains(\'?\'): ${isLineCompleted && fullUpdatedSolution.split('').contains('?')}');
          // }
          if (isLineCompleted && fullUpdatedSolution.split('').contains('?')) {
            final List<Map<int, NonoAxis>> tempStack = finalStack;
            // log('runs..????');
            // log('finalStack before: ${tempStack.length} - $tempStack');
            finalStack.addAll(
                tempStack.getNewStackElements(<int>[lineIndex], lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row));
            // log('finalStack after: ${finalStack.length} - $finalStack');
          }

          finalStack.addAll(finalStack.getNewStackElements(charIndexes, lineType));
          final SolutionStep solutionStep = SolutionStep(
            currentSolution: fullUpdatedSolution,
            axis: lineType,
            lineIndex: lineIndex,
            explanation:
                '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
            newFilledBoxes: newFilledBoxes,
          );
          // if (!newSolutionSteps.contains(solutionStep))
          newSolutionSteps.add(solutionStep);
          newFilledBoxes = <int>[];

          // return IsolateOutput(
          //   stack: finalStack.updateStack(charIndexes, lineType),
          //   solutionSteps: [
          //     SolutionStep(
          //       currentSolution: fullUpdatedSolution,
          //       axis: lineType,
          //       lineIndex: lineIndex,
          //       explanation:
          //           '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
          //       newFilledBoxes: newFilledBoxes,
          //     ),
          //   ],
          // );
        }
      }
      // if (newSolutionSteps.isNotEmpty || finalStack != output.stack) {
      // log('newSolutionSteps: ${newSolutionSteps.firstOrNull?.explanation} - ${newSolutionSteps.lastOrNull?.explanation}');
      return IsolateOutput(
        stack: finalStack != output.stack ? finalStack : <Map<int, NonoAxis>>[],
        solutionSteps: newSolutionSteps,
        linesChecked: output.linesCheckedList.last,
        boxesChecked: output.boxesCheckedList.last,
        otherBoxesChecked: output.otherBoxesCheckedList.last,
        totalCacheData: output.cachedBoxSolutions.length,
        // linesCheckedList: output.linesCheckedList,
        // cachedBoxSolutions: output.cachedBoxSolutions,
        // boxesCheckedList: output.boxesCheckedList,
        // otherBoxesCheckedList: output.otherBoxesCheckedList,
      );
      // }
    }
    // state.addStep(SolutionStep(
    //   currentSolution: fullUpdatedSolution,
    //   axis: lineType,
    //   lineIndex: lineIndex,
    //   explanation:
    //       '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
    // ));
    // state.stack.updateStack(charIndexes, lineType, state);
    if (printLogs) log('Overlapped solution: $updatedSolution');
  }
  // TODO(stef): updateLinesChecked
  // output = output.copyWith(linesChecked: output.linesChecked + 1);
  // output.linesCheckedList.add(output.linesChecked + 1);
  // output.linesCheckedList['linesChecked'] = output.linesCheckedList['linesChecked']! + 1;
  // int temp = output.linesCheckedList.values.last ?? 0;
  // output.linesCheckedList.remove('linesChecked');
  // output.linesCheckedList.addAll({'linesChecked': output.linesCheckedList['linesChecked']! + 1});
  // if (settings.countCheckedBoxes) {
  // }
  // log('output.linesCheckedList: ${output.linesCheckedList}');
  return IsolateOutput(
    linesChecked: output.linesCheckedList.last,
    boxesChecked: output.boxesCheckedList.last,
    otherBoxesChecked: output.otherBoxesCheckedList.last,
    totalCacheData: output.cachedBoxSolutions.length,
    // linesCheckedList: output.linesCheckedList,
    // cachedBoxSolutions: output.cachedBoxSolutions,
    // boxesCheckedList: output.boxesCheckedList,
    // otherBoxesCheckedList: output.otherBoxesCheckedList,
  );
  // return null;
}

// @isolateManagerCustomWorker
List<List<String>> getAllLinePossibleSolutions(
  List<int> clues,
  String line,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  if (printLogs) log('Get all possible solutions of line $line with clues $clues');
  final List<List<String>> possibleSolutions = Iterable.generate(line.length, (_) => <String>[]).toList();
  for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
    final int minStartingPoint =
        clueIndex == 0 ? 0 : clues.take(clueIndex).reduce((int value, int element) => value + element + 1);
    final int maxStartingPoint = clueIndex == clues.length - 1
        ? line.length
        : line.length - clues.sublist(clueIndex + 1).reduce((int value, int element) => value + element + 1) - clues[clueIndex];
    for (int charIndex = minStartingPoint; charIndex < maxStartingPoint; charIndex++) {
      final bool? cache = settings.keepCacheData ? output.cachedBoxSolutions['$clues,$clueIndex,$line,$charIndex'] : null;
      final bool isInCache = cache != null;
      bool result;
      if (isInCache) {
        result = cache;
      } else {
        result = canCluesFit(clues, line, charIndex, clueIndex, output, settings);
        if (settings.keepCacheData) {
          output.cachedBoxSolutions.addAll(updateCachedBoxSolutions(clues, clueIndex, line, charIndex, result));
        }
        if (!result) {}
        // if (state.countCheckedBoxes)
        if (settings.countCheckedBoxes) {
          output.boxesCheckedList.add(output.boxesCheckedList.last + 1);
          output.boxesCheckedList.removeAt(0);
        }
      }
      final String solutionNumb = result ? '${clueIndex + 2}' : '0';
      // log('can fit: $result');

      final int loops = solutionNumb == '0' ? 1 : clues[clueIndex];
      for (int i = charIndex; i < charIndex + loops; i++) {
        if (!possibleSolutions.elementAt(i).contains(solutionNumb)) {
          possibleSolutions.elementAt(i).add(solutionNumb);
        }
      }

      if (printLogs) log('possibleSolutions of charIndex $charIndex and clueIndex $clueIndex are: $possibleSolutions');
    }
  }
  if (printLogs) log('Final possibleSolutions of line $line with clues $clues is: $possibleSolutions');
  return possibleSolutions;
}

// @isolateManagerCustomWorker
bool doOtherCluesFit(
  NonoDirection solutionSide,
  List<int> clues,
  int clueIndex,
  String solution,
  int solutionIndex,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  final int clue = clues.elementAt(clueIndex);

  // if (state.countCheckedBoxes) state.updateOtherBoxesChecked();
  if (settings.countCheckedBoxes) {
    output.otherBoxesCheckedList.add(output.otherBoxesCheckedList.last + 1);
    output.otherBoxesCheckedList.removeAt(0);
  }

  if (printLogs) log('Does clue have clues ${solutionSide.name}?');
  if (!solutionSide.hasOtherClues(clueIndex, clues.length)) {
    if (printLogs) log('It does not.');
    if (printLogs) log('Check if there are any filled boxes which match to no clue.');
    // if (solution.substring(clueIndex).characters.contains('1')) {
    //   return false;
    // }
    // if (printLogs) log('Return `true`.');
    return solutionSide.isSolutionValid(solution, solutionIndex, clues[clueIndex]);
  }
  if (printLogs) log('It does. Continue checking.');

  final List<int> cluesSublist = solutionSide.getCluesSublist(clueIndex, clues);

  if (printLogs) log('Does clue have boxes left for clues left?');
  if (!solutionSide.hasBoxesLeft(solutionIndex, clue, solution, cluesSublist)) {
    if (printLogs) log('It does not. Return `false`.');
    return false;
  }
  if (printLogs) log('It does. Continue checking.');

  final String solutionSublist = solutionSide.getSolutionSublist(solution, solutionIndex, clue);
  if (printLogs) log('Does solution sublist $solutionSublist fit clues $cluesSublist?');
  for (int solutionSublistIndex = 0; solutionSublistIndex < solutionSublist.length; solutionSublistIndex++) {
    if (canCluesFit(cluesSublist, solutionSublist, solutionSublistIndex, 0, output, settings)) {
      if (printLogs) log('It does fit. Return `true`.');

      // return solutionSide.isSolutionValid(solution, solutionIndex);
      // TODO(stef): restore cache data here
      if (settings.keepCacheData) {
        output.cachedBoxSolutions.addAll(updateCachedBoxSolutions(cluesSublist, 0, solutionSublist, solutionSublistIndex, true));
      }

      return true;
    }
  }
  if (printLogs) log('It does not fit. Return `false`.');
  return false;
}

// @isolateManagerCustomWorker
bool canCluesFit(
  List<int> clues,
  String solution,
  int s,
  int cl,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  final List<String> solutionList = solution.split('');
  final int clue = clues.elementAt(cl);
  bool canFit;

  // log('clues: $clues , clue: $cl , position $s , solution $solution , line $solution');

  if (printLogs) log('Does clue $clue fit at $solutionList from position $s to position ${s + clue}?');
  if (clue > solutionList.getRange(s, solutionList.length).length) {
    if (printLogs) log('false');
    return false;
  }
  if (printLogs) log('true');

  final List<String> fit = solutionList.getRange(s, s + clue).toList();
  final String valueAfter = s + clue > solutionList.length ? '0' : solutionList.elementAtOrNull(s + clue) ?? '0';
  final String valueBefore = s - 1 < 0 ? '0' : solutionList.elementAtOrNull(s - 1) ?? '0';
  canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';

  if (printLogs) log('Can clue $clue fit at: $valueBefore $fit $valueAfter');
  if (!canFit) {
    if (printLogs) log('false');
    return false;
  }
  if (printLogs) log('true');

  final bool cluesBeforeGood = doOtherCluesFit(NonoDirection.before, clues, cl, solution, s, output, settings);
  final bool cluesAfterGood = doOtherCluesFit(NonoDirection.after, clues, cl, solution, s, output, settings);

  if (printLogs) log('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
  // if (state.countCheckedBoxes) state.updateActualBoxesChecked();
  return cluesBeforeGood && cluesAfterGood;
}

// @isolateManagerCustomWorker
List<String> getSideMostSolution(
  List<List<String>> solution,
  List<int> clues,
  NonoAxisAlignment axis, [
  bool printLogs = false,
]) {
  if (printLogs) log('Get ${axis.name}ing most solution of solution $solution with clues $clues');

  List<int> clueIndexes = Iterable<int>.generate(clues.length, (int c) => c + 2).toList();
  if (axis == NonoAxisAlignment.end) {
    if (printLogs) log('All values should reverse');
    solution = solution.reversed.toList();
    clues = clues.reversed.toList();
    clueIndexes = clueIndexes.reversed.toList();
  }

  final List<String> sideMostSolution = <String>[];
  List<List<String>> remainingSolution = solution;

  if (printLogs) {
    log('Start checking clues one by one. sideMostSolution list is empty, remainingSolution is $remainingSolution');
  }
  for (int i = 0; i < clues.length; i++) {
    final int clue = clues[i];
    final int clueIndex = clueIndexes.elementAt(i);
    final int cluePos = remainingSolution.indexWhere((List<String> list) => list.contains('$clueIndex'));
    if (printLogs) log('Clue $i with value $clue is found at position $cluePos of remainingSolution $remainingSolution');

    if (printLogs) log('Is cluePos $cluePos larger than 0?');
    if (printLogs) log(cluePos > 0 ? 'Yes, it is. Add $cluePos "0"s to sideMostSolution list' : "No, it isn't. Move on");
    if (cluePos > 0) sideMostSolution.addAll(Iterable.generate(cluePos, (_) => '0').toList());
    if (printLogs) log('Add $clue times clueIndex $clueIndex of clue $clue at sideMostSolution list');
    sideMostSolution.addAll(Iterable.generate(clue, (_) => '$clueIndex').toList());

    if (printLogs) log('Is solution completed?');
    if (printLogs) {
      log(
        sideMostSolution.length < solution.length
            ? 'No, not finished. Add "0" for space at sideMostSolution list and create a new sublist after clue added'
            : 'Yes it is. Move on',
      );
    }
    if (sideMostSolution.length < solution.length) {
      sideMostSolution.add('0');
      remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
    }

    if (printLogs) log('Current sideMostSolution: $sideMostSolution');
  }

  if (printLogs) log('Finished checking all clues. Is sideMostSolution completed?');
  if (printLogs) log(sideMostSolution.length < solution.length ? 'No. Complete solution with "0"s' : 'Yes. Move on');
  if (sideMostSolution.length < solution.length) {
    sideMostSolution.addAll(Iterable.generate(remainingSolution.length, (_) => '0').toList());
  }
  if (printLogs) log('Final sideMostSolution: $sideMostSolution');
  return axis == NonoAxisAlignment.end ? sideMostSolution.reversed.toList() : sideMostSolution;
}

List<Map<int, NonoAxis>> initializeStackList(Clues clues) {
  final List<Map<int, NonoAxis>> lineStack = <Map<int, NonoAxis>>[];

  for (int i = 0; i < clues.rows.length; i++) {
    lineStack.add(<int, NonoAxis>{i: NonoAxis.row});
  }

  for (int i = 0; i < clues.columns.length; i++) {
    lineStack.add(<int, NonoAxis>{i: NonoAxis.column});
  }

  return lineStack;
}

Map<String, bool> updateCachedBoxSolutions(List<int> clues, int clueIndex, String solution, int solutionIndex, bool value) {
  return <String, bool>{'$clues,$clueIndex,$solution,$solutionIndex': value};
}
