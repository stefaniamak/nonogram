import 'dart:convert';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/isolate/solver_settings.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_direction_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';

@isolateManagerCustomWorker
void lineSolverIsolate(dynamic params) {
  IsolateManagerFunction.customFunction<String, String>(
    params,
    onEvent: (controller, message) {
      final IsolateInput input = IsolateInput.fromJson(jsonDecode(message));
      List<Map<int, NonoAxis>> stack = initializeStackList(input.nonogram.clues);
      List<SolutionStep> solutionSteps = input.solutionSteps;
      Map<String, bool> cachedBoxSolutions = {};
      // Map<String, int> linesCheckedList = {'linesChecked': 0};
      List<int> linesCheckedList = [0];
      List<int> boxesChecked = [0];
      List<int> otherBoxesChecked = [0];

      IsolateOutput? progress = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
        cachedBoxSolutions: cachedBoxSolutions,
        linesCheckedList: linesCheckedList,
        boxesCheckedList: boxesChecked,
        otherBoxesCheckedList: otherBoxesChecked,
      );

      while (stack.isNotEmpty) {
        // print('stack: $stack');
        Map<int, NonoAxis> line = stack.first;

        List<int> clues = (line.values.first == NonoAxis.row ? input.nonogram.clues.rows : input.nonogram.clues.columns)
            .elementAt(line.keys.first);
        progress = loopSides(
          line.keys.first,
          clues,
          line.values.first,
          input.nonogram,
          IsolateOutput(
            stack: stack,
            cachedBoxSolutions: cachedBoxSolutions,
            linesCheckedList: linesCheckedList,
            boxesCheckedList: boxesChecked,
            solutionSteps: solutionSteps,
            otherBoxesCheckedList: otherBoxesChecked,
          ),
          input.solverSettings,
        );

        if (progress != null) {
          controller.sendResult(
            jsonEncode(
              {
                'progress': progress.toJson(),
              },
            ),
          );
          // print('stackstack: $stack');
          // print('progress.stack: ${progress.stack}');
          // stack.addAll(progress.stack.where((e) => !stack.contains(e)));
          if (progress.stack.isNotEmpty) stack.addAll(progress.stack);
          // stack = progress.stack;
          if (progress.solutionSteps.isNotEmpty) solutionSteps = progress.solutionSteps;
        }
        stack.removeAt(0);
      }

      solutionSteps.add(
        SolutionStep(
          currentSolution: solutionSteps.last.currentSolution,
          explanation: solutionSteps.last.currentSolution.split('').contains('?') ? 'Nonogram not solved' : 'Nonogram solved',
          newFilledBoxes: [],
        ),
      );

      IsolateOutput? results = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
        cachedBoxSolutions: cachedBoxSolutions,
        linesCheckedList: linesCheckedList,
        boxesCheckedList: boxesChecked,
        otherBoxesCheckedList: otherBoxesChecked,
      );
      // This is a final value.
      return jsonEncode({'result': results});
    },
  );
}

// @isolateManagerCustomWorker
IsolateOutput? loopSides(
    int lineIndex, List<int> clues, NonoAxis lineType, IsolateNonogram nonogram, IsolateOutput output, SolverSettings settings,
    [bool printPrints = false]) {
  output.linesCheckedList.add(output.linesCheckedList.last + 1);
  output.linesCheckedList.removeAt(0);

  if (printPrints) print('Check ${lineType.name} with index $lineIndex.');
  if (printPrints) print('${lineType.name}\'s clues: $clues');
  String initialSolution; // = solutionSteps.last.currentSolution.getLine(lineIndex, nonogram, lineType);
  switch (lineType) {
    case NonoAxis.row:
      initialSolution = output.solutionSteps.last.currentSolution
          .split('')
          .toList()
          .getRange(lineIndex * nonogram.width, nonogram.width * (lineIndex + 1))
          .join()
          .replaceAll(' ', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(',', '');
      break;
    case NonoAxis.column:
      String columnSol = '';
      for (var solChar = lineIndex;
          solChar < output.solutionSteps.last.currentSolution.split('').toList().length;
          solChar = solChar + nonogram.width) {
        columnSol = '$columnSol${output.solutionSteps.last.currentSolution.split('').toList().elementAt(solChar)}';
      }
      initialSolution = columnSol;
      break;
  }

  // print('solutionSteps.last.currentSolution: ${solutionSteps.last.currentSolution}');

  if (printPrints) print('${lineType.name}\'s initialSolution: $initialSolution');

  // print('initialSolution: $initialSolution');
  int filledBoxes = initialSolution.sumFilledBoxes;
  bool isLineCompleted = filledBoxes == clues.sum;

  // if (lineIndex == 18) {
  //   print('filledBoxes: $filledBoxes k clues.sum: ${clues.sum}');
  // }

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
  // print('matches: $matches');
  // Extract the matched parts and join them with commas
  String result = matches.map((match) => match.group(0)).join(',');
  // print('initialSolutionIndexed: $initialSolutionIndexed');
  // print('result: $result');
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
      // TODO(stef): restore groupSteps
      if (!settings.groupSteps) {
        List<Map<int, NonoAxis>> tempStack = output.stack;
        List<SolutionStep> newSolutionSteps = [];
        for (int charIndex = 0; charIndex < initialSolution.length; charIndex++) {
          if (initialSolution.characterAt(charIndex) == '?') {
            int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            var fullUpdatedSolution = output.solutionSteps.last.getUpdatedSolution(indexSol, '0');
            if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');

            // List<Map<int, NonoAxis>> finalStack = output.stack;
            // var tempStack = finalStack;
            // output.stack.addAll(tempStack.updateStack([charIndex], lineType));

            tempStack = tempStack.updateStack([charIndex], lineType);
            newSolutionSteps.add(
              SolutionStep(
                currentSolution: fullUpdatedSolution,
                axis: lineType,
                lineIndex: lineIndex,
                explanation: 'Cross out remaining empty boxes of ${lineType.name} with index $lineIndex.',
                newFilledBoxes: [charIndex],
              ),
            );

            // return IsolateOutput(
            //   stack: output.stack.updateStack([charIndex], lineType),
            //   solutionSteps: [
            //     SolutionStep(
            //       currentSolution: fullUpdatedSolution,
            //       axis: lineType,
            //       lineIndex: lineIndex,
            //       explanation: 'Cross out remaining empty boxes of ${lineType.name} with index $lineIndex.',
            //     ),
            //   ],
            // );

            // state.addStep(SolutionStep(
            //   currentSolution: fullUpdatedSolution,
            //   axis: lineType,
            //   lineIndex: lineIndex,
            //   explanation: 'Cross out remaining empty boxes of ${lineType.name} with index $lineIndex.',
            // ));
            // state.stack.updateStack([charIndex], lineType, state);
          }
        }
        // print('newSolutionSteps: $newSolutionSteps');
        return IsolateOutput(
          stack: tempStack,
          solutionSteps: newSolutionSteps,
        );
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
        var fullUpdatedSolution = output.solutionSteps.last.currentSolution;
        List<int> newFilledBoxes = [];

        // TODO(stef): add "useLookbehind" variable
        if (false) {
          String lookbehinds =
              charIndexesOfQMarks.map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
          final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

          fullUpdatedSolution = output.solutionSteps.last.currentSolution.replaceAllMapped(solutionIndexesRegexp, (match) => '0');
          if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
        } else {
          for (int charIndex in charIndexesOfQMarks) {
            var tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            newFilledBoxes.add(tempPos);
            fullUpdatedSolution = fullUpdatedSolution.substring(0, tempPos) + '0' + fullUpdatedSolution.substring(tempPos + 1);
          }
        }
        // here

        // TODO(stef): restore these two bellow
        return IsolateOutput(
          stack: output.stack.updateStack(charIndexesOfQMarks, lineType),
          solutionSteps: [
            SolutionStep(
              currentSolution: fullUpdatedSolution,
              axis: lineType,
              lineIndex: lineIndex,
              explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
              newFilledBoxes: newFilledBoxes,
            ),
          ],
        );
      }
    }
  } else {
    // if (activateReturnOnNotEnoughSolvedLines && filledBoxes < (clues.sum / 4) && (state.nonogram.width / 4) > clues.sum) {
    //   return;
    // }
    if (printPrints) print('It is not. Starts to calculate all possible solutions...');
    // print('line type: $lineType + line index: $lineIndex');
    List<List<String>> allLineSolutions = getAllLinePossibleSolutions(clues, initialSolution, output, settings);
    if (printPrints) print('All line solutions: $allLineSolutions');

    if (printPrints) print('Find starting solution of $allLineSolutions with clues $clues.');
    List<String> startingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.start);

    if (printPrints) print('Starting most solution: $startingMostSolution');

    if (printPrints) print('Find ending solution of $allLineSolutions with clues $clues.');
    List<String> endingMostSolution = getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.end);

    if (printPrints) print('Ending most solution  : $endingMostSolution');

    String updatedSolution = '';

    // TODO(stef): restore groupSteps
    if (settings.groupSteps) {
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
      // print('duplicateInputNumbers: $duplicateInputNumbers');

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
      print('result: $result');

      List<Map<int, NonoAxis>> finalStack = output.stack; // List.from(output.stack);
      List<int> newFilledBoxes = [];
      List<SolutionStep> newSolutionSteps = [];
      String fullUpdatedSolution = output.solutionSteps.last.currentSolution;

      // here 2
      if (result.isNotEmpty) {
        for (int clueKey in result.keys) {
          List<int> charIndexes = result[clueKey]!;
          int clueIndex = clueKey == 0 ? 0 : clueKey - 2;

          // TODO(stef): add "useLookbehind" variable
          if (false) {
            String lookbehinds =
                charIndexes.map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, nonogram.width)}}').join('|');
            final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

            fullUpdatedSolution = output.solutionSteps.last.currentSolution
                .replaceAllMapped(solutionIndexesRegexp, (match) => clueKey == 0 ? '0' : '1');
          } else {
            for (int charIndex in charIndexes) {
              var tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
              newFilledBoxes.add(tempPos);
              fullUpdatedSolution = fullUpdatedSolution.substring(0, tempPos) +
                  (clueKey == 0 ? '0' : '1') +
                  fullUpdatedSolution.substring(tempPos + 1);
            }
          }

          if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');

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
                break;
              case NonoAxis.column:
                String columnSol = '';
                for (var solChar = lineIndex;
                    solChar < output.solutionSteps.last.currentSolution.split('').toList().length;
                    solChar = solChar + nonogram.width) {
                  columnSol = '$columnSol${output.solutionSteps.last.currentSolution.split('').toList().elementAt(solChar)}';
                }
                initialSolution2 = columnSol;
                break;
            }

            filledBoxes = initialSolution2.sumFilledBoxes;
            isLineCompleted = filledBoxes == clues.sum;
            // finalStack = finalStack.updateStack(charIndexes, lineType);
            // if (clues.elementAt(clueIndex) == 14 && clueIndex == 1 && lineIndex == 18) {
            //   print('initialSolution2.sumFilledBoxes: ${initialSolution2.sumFilledBoxes} and clues.sum: ${clues.sum}');
            //   print('isLineCompleted: $isLineCompleted && initialSolution2: $initialSolution2');
            //   print(
            //       'isLineCompleted && fullUpdatedSolution.split(\'\').contains(\'?\'): ${isLineCompleted && fullUpdatedSolution.split('').contains('?')}');
            // }
            if (isLineCompleted && fullUpdatedSolution.split('').contains('?')) {
              var tempStack = finalStack;
              // print('runs..????');
              // print('finalStack before: ${tempStack.length} - $tempStack');
              finalStack.addAll(tempStack.updateStack([lineIndex], lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row));
              // print('finalStack after: ${finalStack.length} - $finalStack');
            }

            finalStack.addAll(finalStack.updateStack(charIndexes, lineType));
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
            newFilledBoxes = [];

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
        print('newSolutionSteps: ${newSolutionSteps.firstOrNull?.explanation} - ${newSolutionSteps.lastOrNull?.explanation}');
        return IsolateOutput(
          stack: finalStack != output.stack ? finalStack : [],
          solutionSteps: newSolutionSteps,
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
    } else {
      String updatedSolution = initialSolution;

      List<Map<int, NonoAxis>> finalStack = output.stack;
      List<Map<int, NonoAxis>> tempStack = finalStack;
      List<SolutionStep> newSolutionSteps = [];

      for (int charIndex in charIndexesOfQMarks) {
        if (printPrints) print('Is box unknown and should be checked?');
        // TODO check if characters update works as expected
        if (initialSolution.split('').elementAt(charIndex).toString() == '?') {
          if (printPrints) print('Yes it is.');
          if (printPrints) {
            print(
                'Are all possible solutions (${allLineSolutions.elementAt(charIndex)}) of box at index $charIndex only zeros (0)?');
          }

          if (allLineSolutions.elementAt(charIndex).everyElementIsZero) {
            if (printPrints) print('Yes. Cross out this box.');
            updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '0');

            int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
            var fullUpdatedSolution = output.solutionSteps.last.getUpdatedSolution(indexSol, '0');
            if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
            // output.solutionSteps.add(
            //   SolutionStep(
            //     currentSolution: fullUpdatedSolution,
            //     axis: lineType,
            //     lineIndex: lineIndex,
            //     explanation: 'Cross out box.',
            //   ),
            // );

            // List<Map<int, NonoAxis>> finalStack = output.stack;
            // var tempStack = finalStack;
            // output.stack.addAll(tempStack.updateStack([charIndex], lineType));
            // output.stack.updateStack([charIndex], lineType);
            //
            // output.stack.addAll(output.stack.updateStack([charIndex], lineType));
            // state.stack.updateStack([charIndex], lineType, state);
            tempStack = tempStack.updateStack([charIndex], lineType);
            newSolutionSteps.add(
              SolutionStep(
                currentSolution: fullUpdatedSolution,
                axis: lineType,
                lineIndex: lineIndex,
                explanation: 'Cross out box.',
                newFilledBoxes: [charIndex],
              ),
            );
            // return IsolateOutput(
            //   stack: output.stack.updateStack([charIndex], lineType),
            //   solutionSteps: [
            //     SolutionStep(
            //       currentSolution: fullUpdatedSolution,
            //       axis: lineType,
            //       lineIndex: lineIndex,
            //       explanation: 'Cross out box.',
            //     ),
            //   ],
            // );
          } else {
            if (printPrints) print('No.');
            var startingSolutionIndex = startingMostSolution.elementAt(charIndex).toString();
            var endingSolutionIndex = endingMostSolution.elementAt(charIndex).toString();
            if (printPrints) print('Do both side solutions of box at index $charIndex contain the same clue index?');

            if (printPrints) print('startingSolutionIndex: $startingSolutionIndex');
            if (printPrints) print('endingSolutionIndex  : $endingSolutionIndex');
            if (startingSolutionIndex.isSameClueIndexWith(endingSolutionIndex)) {
              if (printPrints) print('Yes. Fill in this box.');
              updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '1');
              int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width);
              // state.setFilled(lineType.getSolutionPosition(lineIndex, charIndex, nonogram.width));
              var fullUpdatedSolution = output.solutionSteps.last.getUpdatedSolution(indexSol, '1');
              if (printPrints) print('fullUpdatedSolution: $fullUpdatedSolution');
              // state.addStep(SolutionStep(
              //   currentSolution: fullUpdatedSolution,
              //   axis: lineType,
              //   lineIndex: lineIndex,
              //   explanation: 'Fill in box.',
              // ));
              // state.stack.updateStack([charIndex], lineType, state);

              finalStack.addAll(tempStack.updateStack([charIndex], lineType));
              finalStack.updateStack([charIndex], lineType);
              // tempStack = tempStack.updateStack([charIndex], lineType);
              newSolutionSteps.add(
                SolutionStep(
                  currentSolution: fullUpdatedSolution,
                  axis: lineType,
                  lineIndex: lineIndex,
                  explanation: 'Fill in box.',
                  newFilledBoxes: [charIndex],
                ),
              );
              // output.solutionSteps.add(
              //   SolutionStep(
              //     currentSolution: fullUpdatedSolution,
              //     axis: lineType,
              //     lineIndex: lineIndex,
              //     explanation: 'Fill in box.',
              //   ),
              // );

              // List<Map<int, NonoAxis>> finalStack = output.stack;
              // var tempStack = finalStack;
              // output.stack.addAll(tempStack.updateStack([charIndex], lineType));

              // List<Map<int, NonoAxis>> finalStack = output.stack;
              // var tempStack = finalStack;
              // finalStack
              // output.stack.addAll(output.stack.updateStack([charIndex], lineType));
              // output.stack.updateStack([charIndex], lineType);
            } else {
              if (printPrints) print('No. It contains different indexes.');
            }
          }
        }
        if (printPrints) print('No it is not.');
      }

      return IsolateOutput(
        stack: finalStack,
        solutionSteps: newSolutionSteps,
      );
    }
    if (printPrints) print('Overlapped solution: $updatedSolution');
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
  // print('output.linesCheckedList: ${output.linesCheckedList}');
  return null;
}

// @isolateManagerCustomWorker
List<List<String>> getAllLinePossibleSolutions(List<int> clues, String line, IsolateOutput output, SolverSettings settings,
    [bool printPrints = false]) {
  if (printPrints) print('Get all possible solutions of line $line with clues $clues');
  List<List<String>> possibleSolutions = Iterable.generate(line.length, (_) => <String>[]).toList();
  for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
    int minStartingPoint = clueIndex == 0 ? 0 : clues.take(clueIndex).reduce((int value, int element) => value + element + 1);
    int maxStartingPoint = clueIndex == clues.length - 1
        ? line.length
        : line.length - clues.sublist(clueIndex + 1).reduce((int value, int element) => value + element + 1) - clues[clueIndex];
    for (int charIndex = minStartingPoint; charIndex < maxStartingPoint; charIndex++) {
      bool? cache = settings.keepCacheData ? output.cachedBoxSolutions['$clues,$clueIndex,$line,$charIndex'] : null;
      bool isInCache = cache != null;
      bool result;
      if (isInCache) {
        result = cache;
      } else {
        result = canCluesFit(clues, line, charIndex, clueIndex, output, settings);
        if (settings.keepCacheData) {
          output.cachedBoxSolutions.addAll(updateCachedBoxSolutions(clues, clueIndex, line, charIndex, result));
        }
        if (result == false) {}
        // if (state.countCheckedBoxes)
        if (settings.countCheckedBoxes) {
          output.boxesCheckedList.add(output.boxesCheckedList.last + 1);
          output.boxesCheckedList.removeAt(0);
        }
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

// @isolateManagerCustomWorker
bool doOtherCluesFit(NonoDirection solutionSide, List<int> clues, int clueIndex, String solution, int solutionIndex,
    IsolateOutput output, SolverSettings settings,
    [bool printPrints = false]) {
  int clue = clues.elementAt(clueIndex);

  // if (state.countCheckedBoxes) state.updateOtherBoxesChecked();
  if (settings.countCheckedBoxes) {
    output.otherBoxesCheckedList.add(output.otherBoxesCheckedList.last + 1);
    output.otherBoxesCheckedList.removeAt(0);
  }

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
    if (canCluesFit(cluesSublist, solutionSublist, solutionSublistIndex, 0, output, settings)) {
      if (printPrints) print('It does fit. Return `true`.');

      // return solutionSide.isSolutionValid(solution, solutionIndex);
      // TODO(stef): restore cache data here
      if (settings.keepCacheData) {
        output.cachedBoxSolutions.addAll(updateCachedBoxSolutions(cluesSublist, 0, solutionSublist, solutionSublistIndex, true));
      }

      return true;
    }
  }
  if (printPrints) print('It does not fit. Return `false`.');
  return false;
}

// @isolateManagerCustomWorker
bool canCluesFit(List<int> clues, String solution, int s, int cl, IsolateOutput output, SolverSettings settings,
    [bool printPrints = false]) {
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

  bool cluesBeforeGood = doOtherCluesFit(NonoDirection.before, clues, cl, solution, s, output, settings);
  bool cluesAfterGood = doOtherCluesFit(NonoDirection.after, clues, cl, solution, s, output, settings);

  if (printPrints) print('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
  // if (state.countCheckedBoxes) state.updateActualBoxesChecked();
  return cluesBeforeGood && cluesAfterGood;
}

// @isolateManagerCustomWorker
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

List<Map<int, NonoAxis>> initializeStackList(IsolateClues clues) {
  List<Map<int, NonoAxis>> lineStack = [];

  for (int i = 0; i < clues.rows.length; i++) {
    lineStack.add({i: NonoAxis.row});
  }

  for (int i = 0; i < clues.columns.length; i++) {
    lineStack.add({i: NonoAxis.column});
  }

  return lineStack;
}

Map<String, bool> updateCachedBoxSolutions(List<int> clues, int clueIndex, String solution, int solutionIndex, bool value) {
  return {'$clues,$clueIndex,$solution,$solutionIndex': value};
}
