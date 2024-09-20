import 'dart:convert';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_direction_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';

// @isolateManagerWorker // Remove this annotation if you don't want to use the Worker
// int fibonacci(int n) {
//   if (n == 0) return 0;
//   if (n == 1) return 1;
//
//   return fibonacci(n - 1) + fibonacci(n - 2);
// }
//
// @isolateManagerWorker // Remove this annotation if you don't want to use the Worker
// int lineSolver(int n) {
//   return fibonacci(n);
// }
//
// // This is a progress function
// @isolateManagerCustomWorker // Add this anotation for a custom function
// void progressFunction(dynamic params) {
//   IsolateManagerFunction.customFunction<String, int>(
//     params,
//     onEvent: (controller, message) {
//       // This value is sent as the progress values.
//       for (int i = 0; i < message; i++) {
//         final progress = jsonEncode({'progress': i});
//         controller.sendResult(progress);
//       }
//
//       // This is a final value.
//       return jsonEncode({'result': message});
//     },
//   );
// }

@isolateManagerCustomWorker
void lineSolverIsolate(dynamic params) {
  IsolateManagerFunction.customFunction<String, String>(
    params,
    onEvent: (controller, message) {
      final IsolateInput input = IsolateInput.fromJson(jsonDecode(message));
      List<Map<int, NonoAxis>> stack = input.stack;
      List<SolutionStep> solutionSteps = input.solutionSteps;
      IsolateOutput? progress = IsolateOutput(
        stack: input.stack,
        solutionSteps: input.solutionSteps,
      );

      while (stack.isNotEmpty) {
        print('stack: $stack');
        Map<int, NonoAxis> line = stack.first;

        List<int> clues = (line.values.first == NonoAxis.row ? input.rows : input.columns).elementAt(line.keys.first);
        progress = loopSides(
          solutionSteps,
          line.keys.first,
          clues,
          line.values.first,
          input.nonogram,
          stack,
        );

        if (progress != null) {
          controller.sendResult(
            jsonEncode(
              {
                'progress': progress.toJson(),
              },
            ),
          );
          stack.addAll(progress.stack);
          solutionSteps = progress.solutionSteps;
        }
        stack.removeAt(0);
      }

      IsolateOutput? results = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
      );
      // This is a final value.
      return jsonEncode({'result': results});
    },
  );
}

@isolateManagerCustomWorker
IsolateOutput? loopSides(List<SolutionStep> solutionSteps, int lineIndex, List<int> clues, NonoAxis lineType,
    IsolateNonogram nonogram, List<Map<int, NonoAxis>> stack,
    [bool printPrints = false]) {
  if (printPrints) print('Check ${lineType.name} with index $lineIndex.');
  if (printPrints) print('${lineType.name}\'s clues: $clues');
  String initialSolution; // = solutionSteps.last.currentSolution.getLine(lineIndex, nonogram, lineType);
  switch (lineType) {
    case NonoAxis.row:
      initialSolution = solutionSteps.last.currentSolution
          .split('')
          .toList()
          .getRange(lineIndex * nonogram.width, nonogram.width * (lineIndex + 1))
          .toString()
          .replaceAll(' ', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(',', '');
      break;
    case NonoAxis.column:
      String columnSol = '';
      for (var solChar = lineIndex;
          solChar < solutionSteps.last.currentSolution.split('').toList().length;
          solChar = solChar + nonogram.width) {
        columnSol = '$columnSol${solutionSteps.last.currentSolution.split('').toList().elementAt(solChar)}';
      }
      initialSolution = columnSol;
      break;
  }

  if (printPrints) print('${lineType.name}\'s initialSolution: $initialSolution');

  int filledBoxes = initialSolution.sumFilledBoxes;
  bool isLineCompleted = filledBoxes == clues.sum;
  if (printPrints) print('Are filled boxes ($filledBoxes) equal with clue\'s sum (${clues.sum})?');

  /// In the following 4 lines, we create a List<int> with all the index positions
  /// of question marks ("?") in a String. In our case, the String is the current line solution.
  ///
  /// We get the initialSolution of that line and create a list of characters with their indexes (`characters.indexed`).
  /// This indexed list includes the original characters matched with their positions in the String.
  /// e.g. String `0?1` has the result ((0, 0), (1, ?), (2, 1))
  ///
  /// We then convert this indexed list to a String using .toString() and use a RegEx search to get all
  /// the indexes of the `?` characters in the solution.
  ///
  /// The RegEx [charIndexesRegexp] pattern is:
  ///   [0-9]    -> Matches digits...
  ///   +        -> One or more of the previous case...
  ///   (?=, ?) -> That are followed by the String ", ?".
  ///
  /// After getting all the matches, we join them with commas (",") to form a single String.
  /// Then, we split this String by "," and parse its contents to integers.
  ///
  /// Now, we have a List<int> of all the indexes of the "?" characters in the solution.
  /// e.g. String "((0, 0), (1, ?), (2, 1))" results in [1].
  ///
  var initialSolutionIndexed = initialSolution.split('').indexed;

  final charIndexesRegexp = RegExp(r'[0-9]+(?=, \?)');
  // Find all matches
  Iterable<Match> matches = charIndexesRegexp.allMatches(initialSolutionIndexed.toList().toString());
  // Extract the matched parts and join them with commas
  String result = matches.map((match) => match.group(0)).join(',');
  List<int> charIndexesOfQMarks = result.isNotEmpty ? result.split(',').map((e) => int.parse(e)).toList() : <int>[];

  // print('initialSolution: $initialSolution');
  // print('initialSolutionIndexed: $initialSolutionIndexed');
  //
  // print('charIndexesOfQMarks2: $charIndexesOfQMarks2');

  // List<int> charIndexesOfQMarks = initialSolutionIndexed.where((element) => element.$2 == '?').map((e) => e.$1).toList();
  // print('charIndexesOfQMarks: $charIndexesOfQMarks');

  if (isLineCompleted) {
    if (printPrints) print('It is. Shall cross out remaining empty boxes if any left.');
    if (initialSolution.split('').toList().contains('?')) {
      if (false) {
        //!state.groupSteps) {
        for (int charIndex = 0; charIndex < initialSolution.length; charIndex++) {
          if (initialSolution.characterAt(charIndex) == '?') {
            int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            var fullUpdatedSolution = solutionSteps.last.getUpdatedSolution(indexSol, '0');
            if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
            // state.addStep(SolutionStep(
            //   currentSolution: fullUpdatedSolution,
            //   axis: lineType,
            //   lineIndex: lineIndex,
            //   explanation: 'Cross out remaining empty boxes of ${lineType.name} with index $lineIndex.',
            // ));
            // state.stack.updateStack([charIndex], lineType, state);
          }
        }
      } else {
        int charStart = initialSolution.split('').toList().indexWhere((String char) => char == '?');
        int charEnd = initialSolution.split('').toList().lastIndexWhere((String char) => char == '?') + 1;
        if (printPrints) {
          print('charStart: $charStart');
          print('charEnd: $charEnd');
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
        var fullUpdatedSolution = solutionSteps.last.currentSolution;

        // TODO(stef): add "useLookbehind" variable
        if (false) {
          String lookbehinds =
              charIndexesOfQMarks.map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
          final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

          fullUpdatedSolution = solutionSteps.last.currentSolution.replaceAllMapped(solutionIndexesRegexp, (match) => '0');
          if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
        } else {
          for (int charIndex in charIndexesOfQMarks) {
            var tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            fullUpdatedSolution = fullUpdatedSolution.substring(0, tempPos) + '0' + fullUpdatedSolution.substring(tempPos + 1);
          }
        }
        // here

        // TODO(stef): restore these two bellow
        return IsolateOutput(
          stack: stack.updateStack(charIndexesOfQMarks, lineType),
          solutionSteps: [
            SolutionStep(
              currentSolution: fullUpdatedSolution,
              axis: lineType,
              lineIndex: lineIndex,
              explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
            ),
          ],
        );

        // state.addStep(SolutionStep(
        //   currentSolution: fullUpdatedSolution,
        //   axis: lineType,
        //   lineIndex: lineIndex,
        //   explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
        // ));
        //
        // state.stack.updateStack(charIndexesOfQMarks, lineType, state);
      }
    }
  } else {
    // if (activateReturnOnNotEnoughSolvedLines && filledBoxes < (clues.sum / 4) && (state.nonogram.width / 4) > clues.sum) {
    //   return;
    // }
    if (printPrints) print('It is not. Starts to calculate all possible solutions...');
    // print('line type: $lineType + line index: $lineIndex');
    List<List<String>> allLineSolutions = getAllLinePossibleSolutions(clues, initialSolution);
    if (printPrints) print('All line solutions: $allLineSolutions');

    if (printPrints) print('Find starting solution of $allLineSolutions with clues $clues.');
    List<String> startingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.start);

    if (printPrints) print('Starting most solution: $startingMostSolution');

    if (printPrints) print('Find ending solution of $allLineSolutions with clues $clues.');
    List<String> endingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.end);

    if (printPrints) print('Ending most solution  : $endingMostSolution');

    String updatedSolution = '';

    if (true) {
      //state.groupSteps) {
      // Generate a regex pattern to match any number except those in the exclusion list
      String inclusionPattern = charIndexesOfQMarks.map((e) => e).join('|');
      // Precompile regex patterns
      RegExp regZeroFilledMatches = RegExp(r'\((' + inclusionPattern + r'), \[(0)\]\)');
      // Convert input lists to string once
      String inputZeros = allLineSolutions.indexed.toList().toString();
      // Find matches using precompiled regex patterns
      Iterable<RegExpMatch> matchesZeros = regZeroFilledMatches.allMatches(inputZeros);

      // Use a map to store the right number as keys and a set of left numbers as values for pairs that appear twice
      Map<int, Set<int>> matchMap = {};

      Set<(int, String)> inputNumbersStart = startingMostSolution.indexed.toSet();
      Set<(int, String)> inputNumbersEnd = endingMostSolution.indexed.toSet();
      var duplicateInputNumbers = inputNumbersStart.intersection(inputNumbersEnd);

      for (var match in duplicateInputNumbers) {
        (int, String) pair = match;
        int leftNumber = pair.$1;
        int rightNumber = int.parse(pair.$2);
        if (rightNumber != 0 && charIndexesOfQMarks.contains(leftNumber)) {
          matchMap.putIfAbsent(rightNumber, () => {});
          matchMap[rightNumber]!.add(leftNumber);
        }
      }

      if (matchesZeros.isNotEmpty) {
        matchMap.putIfAbsent(0, () => {});
        matchMap[0]!.addAll(matchesZeros.map((match) => int.parse(match.group(1)!)));
      }

      // Convert the sets to lists and print the final map
      Map<int, List<int>> result = matchMap.map((key, value) => MapEntry(key, value.toList()));

      for (int clueKey in result.keys) {
        List<int> charIndexes = result[clueKey]!;
        int clueIndex = clueKey == 0 ? 0 : clueKey - 2;

        var fullUpdatedSolution = solutionSteps.last.currentSolution;

        // TODO(stef): add "useLookbehind" variable
        if (false) {
          String lookbehinds =
              charIndexes.map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
          final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

          fullUpdatedSolution =
              solutionSteps.last.currentSolution.replaceAllMapped(solutionIndexesRegexp, (match) => clueKey == 0 ? '0' : '1');
        } else {
          for (int charIndex in charIndexes) {
            var tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            fullUpdatedSolution = fullUpdatedSolution.substring(0, tempPos) +
                (clueKey == 0 ? '0' : '1') +
                fullUpdatedSolution.substring(tempPos + 1);
          }
        }

        if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');

        if (result.isNotEmpty) {
          // TODO(stef): restore these two bellow
          return IsolateOutput(
            stack: stack.updateStack(charIndexes, lineType),
            solutionSteps: [
              SolutionStep(
                currentSolution: fullUpdatedSolution,
                axis: lineType,
                lineIndex: lineIndex,
                explanation:
                    '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
              ),
            ],
          );
          // state.addStep(SolutionStep(
          //   currentSolution: fullUpdatedSolution,
          //   axis: lineType,
          //   lineIndex: lineIndex,
          //   explanation:
          //       '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
          // ));
          // state.stack.updateStack(charIndexes, lineType, state);
        }
      }
    } else {
      // String updatedSolution = initialSolution;
      // for (int charIndex in charIndexesOfQMarks) {
      //   if (printPrints) print('Is box unknown and should be checked?');
      //   if (initialSolution.characters.characterAt(charIndex).toString() == '?') {
      //     if (printPrints) print('Yes it is.');
      //     if (printPrints)
      //       print(
      //           'Are all possible solutions (${allLineSolutions.elementAt(charIndex)}) of box at index $charIndex only zeros (0)?');
      //
      //     if (allLineSolutions.elementAt(charIndex).everyElementIsZero) {
      //       if (printPrints) print('Yes. Cross out this box.');
      //       updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '0');
      //
      //       int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width);
      //       var fullUpdatedSolution = solutionSteps.last.getUpdatedSolution(indexSol, '0');
      //       if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
      //       state.addStep(SolutionStep(
      //         currentSolution: fullUpdatedSolution,
      //         axis: lineType,
      //         lineIndex: lineIndex,
      //         explanation: 'Cross out box.',
      //       ));
      //       state.stack.updateStack([charIndex], lineType, state);
      //     } else {
      //       if (printPrints) print('No.');
      //       var startingSolutionIndex = startingMostSolution.elementAt(charIndex).toString();
      //       var endingSolutionIndex = endingMostSolution.elementAt(charIndex).toString();
      //       if (printPrints) print('Do both side solutions of box at index $charIndex contain the same clue index?');
      //
      //       if (printPrints) print('startingSolutionIndex: $startingSolutionIndex');
      //       if (printPrints) print('endingSolutionIndex  : $endingSolutionIndex');
      //       if (startingSolutionIndex.isSameClueIndexWith(endingSolutionIndex)) {
      //         if (printPrints) print('Yes. Fill in this box.');
      //         updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '1');
      //         int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
      //         // state.setFilled(lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width));
      //         var fullUpdatedSolution = solutionSteps.last.getUpdatedSolution(indexSol, '1');
      //         if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
      //         state.addStep(SolutionStep(
      //           currentSolution: fullUpdatedSolution,
      //           axis: lineType,
      //           lineIndex: lineIndex,
      //           explanation: 'Fill in box.',
      //         ));
      //         state.stack.updateStack([charIndex], lineType, state);
      //       } else {
      //         if (printPrints) print('No. It contains different indexes.');
      //       }
      //     }
      //   }
      //   if (printPrints) print('No it is not.');
      // }
    }
    if (printPrints) print('Overlapped solution: $updatedSolution');
    // TODO(stef): updateLinesChecked
    // state.updateLinesChecked();
  }
  return null;
}

@isolateManagerCustomWorker
List<List<String>> getAllLinePossibleSolutions(List<int> clues, String line,
    [bool printPrints = false, bool keepCacheData = false]) {
  if (printPrints) print('Get all possible solutions of line $line with clues $clues');
  List<List<String>> possibleSolutions = Iterable.generate(line.length, (_) => <String>[]).toList();
  for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
    int minStartingPoint = clueIndex == 0 ? 0 : clues.take(clueIndex).reduce((int value, int element) => value + element + 1);
    int maxStartingPoint = clueIndex == clues.length - 1
        ? line.length
        : line.length - clues.sublist(clueIndex + 1).reduce((int value, int element) => value + element + 1) - clues[clueIndex];
    for (int charIndex = minStartingPoint; charIndex < maxStartingPoint; charIndex++) {
      bool? cache = null; // keepCacheData ? state.cachedBoxSolutions['$clues,$clueIndex,$line,$charIndex'] : null;
      bool isInCache = cache != null;
      bool result;
      if (isInCache) {
        result = cache;
      } else {
        result = canCluesFit(clues, line, charIndex, clueIndex);
        // if (keepCacheData) state.updateCachedBoxSolutions(clues, clueIndex, line, charIndex, result);
        if (result == false) {}
        // if (state.countCheckedBoxes) state.updateBoxesChecked();
      }
      String solutionNumb = result ? '${clueIndex + 2}' : '0';
      // print('can fit: $result');

      int loops = solutionNumb == '0' ? 1 : clues[clueIndex];
      for (int i = charIndex; i < charIndex + loops; i++) {
        if (!possibleSolutions.elementAt(i).contains(solutionNumb)) {
          possibleSolutions.elementAt(i).add(solutionNumb);
        }
      }

      if (printPrints) print('possibleSolutions of charIndex $charIndex and clueIndex $clueIndex are: $possibleSolutions');
    }
  }
  if (printPrints) print('Final possibleSolutions of line $line with clues $clues is: ${possibleSolutions}');
  return possibleSolutions;
}

@isolateManagerCustomWorker
bool doOtherCluesFit(NonoDirection solutionSide, List<int> clues, int clueIndex, String solution, int solutionIndex,
    [bool printPrints = false, bool keepCacheData = false]) {
  int clue = clues.elementAt(clueIndex);

  // if (state.countCheckedBoxes) state.updateOtherBoxesChecked();

  if (printPrints) print('Does clue have clues ${solutionSide.name}?');
  if (!solutionSide.hasOtherClues(clueIndex, clues.length)) {
    if (printPrints) print('It does not.');
    if (printPrints) print('Check if there are any filled boxes which match to no clue.');
    // if (solution.substring(clueIndex).characters.contains('1')) {
    //   return false;
    // }
    // if (printPrints) print('Return `true`.');
    return solutionSide.isSolutionValid(solution, solutionIndex, clues[clueIndex]);
  }
  if (printPrints) print('It does. Continue checking.');

  if (printPrints) print('Does clue have boxes left for clues left?');
  if (!solutionSide.hasBoxesLeft(solutionIndex, clue, solution.split('').length)) {
    if (printPrints) print('It does not. Return `false`.');
    return false;
  }
  if (printPrints) print('It does. Continue checking.');

  String solutionSublist = solutionSide.getSolutionSublist(solution, solutionIndex, clue);
  List<int> cluesSublist = solutionSide.getCluesSublist(clueIndex, clues);
  if (printPrints) print('Does solution sublist $solutionSublist fit clues $cluesSublist?');
  for (int solutionSublistIndex = 0; solutionSublistIndex < solutionSublist.length; solutionSublistIndex++) {
    if (canCluesFit(cluesSublist, solutionSublist, solutionSublistIndex, 0)) {
      if (printPrints) print('It does fit. Return `true`.');

      // return solutionSide.isSolutionValid(solution, solutionIndex);
      // TODO(stef): restore cache data here
      // if (keepCacheData) state.updateCachedBoxSolutions(cluesSublist, 0, solutionSublist, solutionSublistIndex, true);
      return true;
    }
  }
  if (printPrints) print('It does not fit. Return `false`.');
  return false;
}

@isolateManagerCustomWorker
bool canCluesFit(List<int> clues, String solution, int s, int cl, [bool printPrints = false]) {
  List<String> solutionList = solution.split('');
  int clue = clues.elementAt(cl);
  bool canFit;

  // print('clues: $clues , clue: $cl , position $s , solution $solution , line $solution');

  if (printPrints) print('Does clue $clue fit at $solutionList from position $s to position ${s + clue}?');
  if (clue > solutionList.getRange(s, solutionList.length).length) {
    if (printPrints) print('false');
    return false;
  }
  if (printPrints) print('true');

  List<String> fit = solutionList.getRange(s, s + clue).toList();
  String valueAfter = s + clue > solutionList.length ? '0' : solutionList.elementAtOrNull(s + clue) ?? '0';
  String valueBefore = s - 1 < 0 ? '0' : solutionList.elementAtOrNull(s - 1) ?? '0';
  canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';

  if (printPrints) print('Can clue $clue fit at: $valueBefore $fit $valueAfter');
  if (!canFit) {
    if (printPrints) print('false');
    return false;
  }
  if (printPrints) print('true');

  bool cluesBeforeGood = doOtherCluesFit(NonoDirection.before, clues, cl, solution, s);
  bool cluesAfterGood = doOtherCluesFit(NonoDirection.after, clues, cl, solution, s);

  if (printPrints) print('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
  // if (state.countCheckedBoxes) state.updateActualBoxesChecked();
  return cluesBeforeGood && cluesAfterGood;
}

@isolateManagerCustomWorker
List<String> getSideMostSolution(List<List<String>> solution, List<int> clues, NonoAxisAlignment axis,
    [bool printPrints = false]) {
  if (printPrints) print('Get ${axis.name}ing most solution of solution $solution with clues $clues');

  List<int> clueIndexes = Iterable<int>.generate(clues.length, (c) => c + 2).toList();
  if (axis == NonoAxisAlignment.end) {
    if (printPrints) print('All values should reverse');
    solution = solution.reversed.toList();
    clues = clues.reversed.toList();
    clueIndexes = clueIndexes.reversed.toList();
  }

  List<String> sideMostSolution = [];
  List<List<String>> remainingSolution = solution;

  if (printPrints)
    print('Start checking clues one by one. sideMostSolution list is empty, remainingSolution is $remainingSolution');
  for (int i = 0; i < clues.length; i++) {
    int clue = clues[i];
    int clueIndex = clueIndexes.elementAt(i);
    int cluePos = remainingSolution.indexWhere((list) => list.contains('$clueIndex'));
    if (printPrints) print('Clue $i with value $clue is found at position $cluePos of remainingSolution $remainingSolution');

    if (printPrints) print('Is cluePos $cluePos larger than 0?');
    if (printPrints) print(cluePos > 0 ? 'Yes, it is. Add $cluePos "0"s to sideMostSolution list' : 'No, it isn\'t. Move on');
    if (cluePos > 0) sideMostSolution.addAll(Iterable.generate(cluePos, (_) => '0').toList());
    if (printPrints) print('Add $clue times clueIndex $clueIndex of clue $clue at sideMostSolution list');
    sideMostSolution.addAll(Iterable.generate(clue, (_) => '$clueIndex').toList());

    if (printPrints) print('Is solution completed?');
    if (printPrints)
      print(sideMostSolution.length < solution.length
          ? 'No, not finished. Add "0" for space at sideMostSolution list and create a new sublist after clue added'
          : 'Yes it is. Move on');
    if (sideMostSolution.length < solution.length) {
      sideMostSolution.add('0');
      remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
    }

    if (printPrints) print('Current sideMostSolution: $sideMostSolution');
  }

  if (printPrints) print('Finished checking all clues. Is sideMostSolution completed?');
  if (printPrints) print(sideMostSolution.length < solution.length ? 'No. Complete solution with "0"s' : 'Yes. Move on');
  if (sideMostSolution.length < solution.length) {
    sideMostSolution.addAll(Iterable.generate(remainingSolution.length, (_) => '0').toList());
  }
  if (printPrints) print('Final sideMostSolution: $sideMostSolution');
  return axis == NonoAxisAlignment.end ? sideMostSolution.reversed.toList() : sideMostSolution;
}
