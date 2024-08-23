import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

import '../backend/type_extensions/nono_axis_extension.dart';
import '../backend/type_extensions/nono_direction_extension.dart';

class LineSolver {
  bool kPrintComments = false;
  bool activateReturnOnNotEnoughSolvedLines = false;
  bool countBoxes = false;
  bool countActualBoxes = false;
  bool countOtherBoxes = false;
  bool groupSteps = true;

  void solve(NonogramState state) async {
    state.updateStartingDateTime(DateTime.now());

    overlapping(state);

    state.addStep(
      SolutionStep(
        currentSolution: state.solutionSteps.last.currentSolution,
        explanation:
            'Nonogram is ${state.solutionSteps.last.currentSolution.characters.contains('?') ? 'not solved.' : 'solved!'}',
      ),
    );
    state.updateStepNumber(state.solutionSteps.length - 1);

    state.updateEndingDateTime(DateTime.now());
    // print('Puzzle duration: ${state.startDateTime!.compareTo(state.endingDateTime!)}');
    // print('state.startDateTime ${state.startDateTime}');
    // print('state.endingDateTime ${state.endingDateTime}');
    // print('state.cachedBoxSolutions: ${state.cachedBoxSolutions}');
  }

  void overlapping(NonogramState state) {
    state.addStep(SolutionStep(
      currentSolution: state.activeSolution.solution!,
      explanation: 'Starting overlapping loop.',
    ));

    while (state.stack.isNotEmpty) {
      if (kPrintComments && kDebugMode) print('stack.length from line solver: ${state.stack.length}');

      if (kPrintComments && kDebugMode) print('stack: ${state.stack}');
      Map<int, NonoAxis> line = state.stack.first;
      List<int> clues = (line.values.first == NonoAxis.row ? state.nonogram.clues!.rows : state.nonogram.clues!.columns)
          .elementAt(line.keys.first);
      loopSides(state, line.keys.first, clues, line.values.first);

      state.popStack();
    }

    state.addStep(SolutionStep(
      currentSolution: state.solutionSteps.last.currentSolution,
      explanation: 'Finished overlapping loop.',
    ));
  }

  void loopSides(NonogramState state, int lineIndex, List<int> clues, NonoAxis lineType) {
    if (kPrintComments && kDebugMode) print('Check ${lineType.name} with index $lineIndex.');
    if (kPrintComments && kDebugMode) print('${lineType.name}\'s clues: $clues');
    String initialSolution = state.solutionSteps.last.currentSolution.getLine(lineIndex, state.nonogram, lineType);
    if (kPrintComments && kDebugMode) print('${lineType.name}\'s initialSolution: $initialSolution');

    int filledBoxes = initialSolution.sumFilledBoxes;
    bool isLineCompleted = filledBoxes == clues.sum;
    if (kPrintComments && kDebugMode) print('Are filled boxes ($filledBoxes) equal with clue\'s sum (${clues.sum})?');

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
    final charIndexesRegexp = RegExp(r'[0-9]+(?=, \?)');
    // Find all matches
    Iterable<Match> matches = charIndexesRegexp.allMatches(initialSolution.characters.indexed.toList().toString());
    // Extract the matched parts and join them with commas
    String result = matches.map((match) => match.group(0)).join(',');
    List<int> charIndexesOfQMarks = result.isNotEmpty ? result.split(',').map((e) => int.parse(e)).toList() : <int>[];

    if (isLineCompleted) {
      if (kPrintComments && kDebugMode) print('It is. Shall cross out remaining empty boxes if any left.');
      if (initialSolution.characters.contains('?')) {
        int charStart = initialSolution.characters.findFirst(Characters('?'))!.stringBeforeLength;
        int charEnd = initialSolution.characters.findLast(Characters('?'))!.stringBeforeLength + 1;
        if (kPrintComments && kDebugMode) {
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
        String lookbehinds = charIndexesOfQMarks
            .map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, state.nonogram.width)}}')
            .join('|');
        final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

        var fullUpdatedSolution =
            state.solutionSteps.last.currentSolution.replaceAllMapped(solutionIndexesRegexp, (match) => '0');
        if (kPrintComments && kDebugMode) print('fullUpdatedSolution: $fullUpdatedSolution');

        state.addStep(SolutionStep(
          currentSolution: fullUpdatedSolution,
          axis: lineType,
          lineIndex: lineIndex,
          explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
        ));

        state.stack.updateStack(charIndexesOfQMarks, lineType, state);
      }
    } else {
      if (activateReturnOnNotEnoughSolvedLines && filledBoxes < (clues.sum / 4) && (state.nonogram.width / 4) > clues.sum) {
        return;
      }
      if (kPrintComments && kDebugMode) print('It is not. Starts to calculate all possible solutions...');
      // print('line type: $lineType + line index: $lineIndex');
      List<List<String>> allLineSolutions = getAllLinePossibleSolutions(state, clues, initialSolution);
      if (kPrintComments && kDebugMode) print('All line solutions: $allLineSolutions');

      if (kPrintComments && kDebugMode) print('Find starting solution of $allLineSolutions with clues $clues.');
      List<String> startingMostSolution = getSideMostSolution(state, allLineSolutions, clues, NonoAxisAlignment.start);
      // state.addStep(SolutionStep(
      //   currentSolution: initialSolution,
      //   lineSolution: startingMostSolution,
      //   axis: lineType,
      //   lineIndex: lineIndex,
      //   explanation: '${NonoAxisAlignment.start.name}ing solution of ${lineType.name} number ${lineIndex + 1}.',
      // ));
      if (kPrintComments && kDebugMode) print('Starting most solution: $startingMostSolution');

      if (kPrintComments && kDebugMode) print('Find ending solution of $allLineSolutions with clues $clues.');
      List<String> endingMostSolution = getSideMostSolution(state, allLineSolutions, clues, NonoAxisAlignment.end);
      // state.addStep(SolutionStep(
      //   currentSolution: initialSolution,
      //   lineSolution: endingMostSolution,
      //   axis: lineType,
      //   lineIndex: lineIndex,
      //   explanation: '${NonoAxisAlignment.start.name}ing solution of ${lineType.name} number ${lineIndex + 1}.',
      // ));
      if (kPrintComments && kDebugMode) print('Ending most solution  : $endingMostSolution');

      String updatedSolution = '';

      if (groupSteps) {
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

          String lookbehinds =
              charIndexes.map((pos) => '^.{${lineType.getSolutionPosition(lineIndex, pos, state.nonogram.width)}}').join('|');
          final solutionIndexesRegexp = RegExp(r'(?<=' + lookbehinds + r').');

          var fullUpdatedSolution = state.solutionSteps.last.currentSolution
              .replaceAllMapped(solutionIndexesRegexp, (match) => clueKey == 0 ? '0' : '1');
          if (kPrintComments && kDebugMode) print('fullUpdatedSolution: $fullUpdatedSolution');

          if (result.isNotEmpty) {
            state.addStep(SolutionStep(
              currentSolution: fullUpdatedSolution,
              axis: lineType,
              lineIndex: lineIndex,
              explanation:
                  '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
            ));
            state.stack.updateStack(charIndexes, lineType, state);
          }
        }
      } else {
        String updatedSolution = initialSolution;
        for (int charIndex in charIndexesOfQMarks) {
          if (kPrintComments && kDebugMode) print('Is box unknown and should be checked?');
          if (initialSolution.characters.characterAt(charIndex).toString() == '?') {
            if (kPrintComments && kDebugMode) print('Yes it is.');
            if (kPrintComments && kDebugMode)
              print(
                  'Are all possible solutions (${allLineSolutions.elementAt(charIndex)}) of box at index $charIndex only zeros (0)?');

            if (allLineSolutions.elementAt(charIndex).everyElementIsZero) {
              if (kPrintComments && kDebugMode) print('Yes. Cross out this box.');
              updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '0');

              int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width);
              var fullUpdatedSolution = state.solutionSteps.last.getUpdatedSolution(indexSol, '0');
              if (kPrintComments && kDebugMode) print('fullUpdatedSolution: $fullUpdatedSolution');
              state.addStep(SolutionStep(
                currentSolution: fullUpdatedSolution,
                axis: lineType,
                lineIndex: lineIndex,
                explanation: 'Cross out box.',
              ));
              state.stack.updateStack([charIndex], lineType, state);
            } else {
              if (kPrintComments && kDebugMode) print('No.');
              var startingSolutionIndex = startingMostSolution.elementAt(charIndex).toString();
              var endingSolutionIndex = endingMostSolution.elementAt(charIndex).toString();
              if (kPrintComments && kDebugMode)
                print('Do both side solutions of box at index $charIndex contain the same clue index?');

              if (kPrintComments && kDebugMode) print('startingSolutionIndex: $startingSolutionIndex');
              if (kPrintComments && kDebugMode) print('endingSolutionIndex  : $endingSolutionIndex');
              if (startingSolutionIndex.isSameClueIndexWith(endingSolutionIndex)) {
                if (kPrintComments && kDebugMode) print('Yes. Fill in this box.');
                updatedSolution = updatedSolution.replaceRange(charIndex, charIndex + 1, '1');
                int indexSol = lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width);
                state.setFilled(lineType.getSolutionPosition(lineIndex, charIndex, state.nonogram.width));
                var fullUpdatedSolution = state.solutionSteps.last.getUpdatedSolution(indexSol, '1');
                if (kPrintComments && kDebugMode) print('fullUpdatedSolution: $fullUpdatedSolution');
                state.addStep(SolutionStep(
                  currentSolution: fullUpdatedSolution,
                  axis: lineType,
                  lineIndex: lineIndex,
                  explanation: 'Fill in box.',
                ));
                state.stack.updateStack([charIndex], lineType, state);
              } else {
                if (kPrintComments && kDebugMode) print('No. It contains different indexes.');
              }
            }
          }
          if (kPrintComments && kDebugMode) print('No it is not.');
        }
      }
      if (kPrintComments && kDebugMode) print('Overlapped solution: $updatedSolution');
      state.updateLinesChecked();
    }
  }

  List<List<String>> getAllLinePossibleSolutions(NonogramState state, List<int> clues, String line) {
    if (kPrintComments && kDebugMode) print('Get all possible solutions of line $line with clues $clues');
    List<List<String>> possibleSolutions = Iterable.generate(line.length, (_) => <String>[]).toList();
    for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
      int minStartingPoint = clueIndex == 0 ? 0 : clues.take(clueIndex).reduce((int value, int element) => value + element + 1);
      int maxStartingPoint = clueIndex == clues.length - 1
          ? line.length
          : line.length - clues.sublist(clueIndex + 1).reduce((int value, int element) => value + element + 1) - clues[clueIndex];
      for (int charIndex = minStartingPoint; charIndex < maxStartingPoint; charIndex++) {
        bool? cache = state.cachedBoxSolutions['$clues,$clueIndex,$line,$charIndex'];
        bool isInCache = cache != null;
        bool result;
        if (isInCache) {
          result = cache;
        } else {
          result = canCluesFit(state, clues, line, charIndex, clueIndex);
          state.updateCachedBoxSolutions(clues, clueIndex, line, charIndex, result);
          if (result == false) {}
          if (countBoxes) state.updateBoxesChecked();
        }
        String solutionNumb = result ? '${clueIndex + 2}' : '0';
        // print('can fit: $result');

        int loops = solutionNumb == '0' ? 1 : clues[clueIndex];
        for (int i = charIndex; i < charIndex + loops; i++) {
          if (!possibleSolutions.elementAt(i).contains(solutionNumb)) {
            possibleSolutions.elementAt(i).add(solutionNumb);
          }
        }

        if (kPrintComments && kDebugMode)
          print('possibleSolutions of charIndex $charIndex and clueIndex $clueIndex are: $possibleSolutions');
      }
    }
    if (kPrintComments && kDebugMode) print('Final possibleSolutions of line $line with clues $clues is: ${possibleSolutions}');
    return possibleSolutions;
  }

  bool doOtherCluesFit(
      NonogramState state, NonoDirection solutionSide, List<int> clues, int clueIndex, String solution, int solutionIndex) {
    int clue = clues.elementAt(clueIndex);

    if (countOtherBoxes) state.updateOtherBoxesChecked();

    if (kPrintComments && kDebugMode) print('Does clue have clues ${solutionSide.name}?');
    if (!solutionSide.hasOtherClues(clueIndex, clues.length)) {
      if (kPrintComments && kDebugMode) print('It does not.');
      if (kPrintComments && kDebugMode) print('Check if there are any filled boxes which match to no clue.');
      // if (solution.substring(clueIndex).characters.contains('1')) {
      //   return false;
      // }
      // if (kPrintComments && kDebugMode) print('Return `true`.');
      return solutionSide.isSolutionValid(solution, solutionIndex, clues[clueIndex]);
    }
    if (kPrintComments && kDebugMode) print('It does. Continue checking.');

    if (kPrintComments && kDebugMode) print('Does clue have boxes left for clues left?');
    if (!solutionSide.hasBoxesLeft(solutionIndex, clue, solution.split('').length)) {
      if (kPrintComments && kDebugMode) print('It does not. Return `false`.');
      return false;
    }
    if (kPrintComments && kDebugMode) print('It does. Continue checking.');

    String solutionSublist = solutionSide.getSolutionSublist(solution, solutionIndex, clue);
    List<int> cluesSublist = solutionSide.getCluesSublist(clueIndex, clues);
    if (kPrintComments && kDebugMode) print('Does solution sublist $solutionSublist fit clues $cluesSublist?');
    for (int solutionSublistIndex = 0; solutionSublistIndex < solutionSublist.length; solutionSublistIndex++) {
      if (canCluesFit(state, cluesSublist, solutionSublist, solutionSublistIndex, 0)) {
        if (kPrintComments && kDebugMode) print('It does fit. Return `true`.');

        // return solutionSide.isSolutionValid(solution, solutionIndex);
        state.updateCachedBoxSolutions(cluesSublist, 0, solutionSublist, solutionSublistIndex, true);
        return true;
      }
    }
    if (kPrintComments && kDebugMode) print('It does not fit. Return `false`.');
    return false;
  }

  bool canCluesFit(NonogramState state, List<int> clues, String solution, int s, int cl) {
    List<String> solutionList = solution.split('');
    int clue = clues.elementAt(cl);
    bool canFit;

    // print('clues: $clues , clue: $cl , position $s , solution $solution , line $solution');

    if (kPrintComments && kDebugMode) print('Does clue $clue fit at $solutionList from position $s to position ${s + clue}?');
    if (clue > solutionList.getRange(s, solutionList.length).length) {
      if (kPrintComments && kDebugMode) print('false');
      return false;
    }
    if (kPrintComments && kDebugMode) print('true');

    List<String> fit = solutionList.getRange(s, s + clue).toList();
    String valueAfter = s + clue > solutionList.length ? '0' : solutionList.elementAtOrNull(s + clue) ?? '0';
    String valueBefore = s - 1 < 0 ? '0' : solutionList.elementAtOrNull(s - 1) ?? '0';
    canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';

    if (kPrintComments && kDebugMode) print('Can clue $clue fit at: $valueBefore $fit $valueAfter');
    if (!canFit) {
      if (kPrintComments && kDebugMode) print('false');
      return false;
    }
    if (kPrintComments && kDebugMode) print('true');

    bool cluesBeforeGood = doOtherCluesFit(state, NonoDirection.before, clues, cl, solution, s);
    bool cluesAfterGood = doOtherCluesFit(state, NonoDirection.after, clues, cl, solution, s);

    if (kPrintComments && kDebugMode)
      print('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
    if (countActualBoxes) state.updateActualBoxesChecked();
    return cluesBeforeGood && cluesAfterGood;
  }

  List<String> getSideMostSolution(NonogramState state, List<List<String>> solution, List<int> clues, NonoAxisAlignment axis) {
    if (kPrintComments && kDebugMode) print('Get ${axis.name}ing most solution of solution $solution with clues $clues');

    List<int> clueIndexes = Iterable<int>.generate(clues.length, (c) => c + 2).toList();
    if (axis == NonoAxisAlignment.end) {
      if (kPrintComments && kDebugMode) print('All values should reverse');
      solution = solution.reversed.toList();
      clues = clues.reversed.toList();
      clueIndexes = clueIndexes.reversed.toList();
    }

    List<String> sideMostSolution = [];
    List<List<String>> remainingSolution = solution;

    if (kPrintComments && kDebugMode)
      print('Start checking clues one by one. sideMostSolution list is empty, remainingSolution is $remainingSolution');
    for (int i = 0; i < clues.length; i++) {
      int clue = clues[i];
      int clueIndex = clueIndexes.elementAt(i);
      int cluePos = remainingSolution.indexWhere((list) => list.contains('$clueIndex'));
      if (kPrintComments && kDebugMode)
        print('Clue $i with value $clue is found at position $cluePos of remainingSolution $remainingSolution');

      if (kPrintComments && kDebugMode) print('Is cluePos $cluePos larger than 0?');
      if (kPrintComments && kDebugMode)
        print(cluePos > 0 ? 'Yes, it is. Add $cluePos "0"s to sideMostSolution list' : 'No, it isn\'t. Move on');
      if (cluePos > 0) sideMostSolution.addAll(Iterable.generate(cluePos, (_) => '0').toList());
      if (kPrintComments && kDebugMode) print('Add $clue times clueIndex $clueIndex of clue $clue at sideMostSolution list');
      sideMostSolution.addAll(Iterable.generate(clue, (_) => '$clueIndex').toList());

      if (kPrintComments && kDebugMode) print('Is solution completed?');
      if (kPrintComments && kDebugMode)
        print(sideMostSolution.length < solution.length
            ? 'No, not finished. Add "0" for space at sideMostSolution list and create a new sublist after clue added'
            : 'Yes it is. Move on');
      if (sideMostSolution.length < solution.length) {
        sideMostSolution.add('0');
        remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
      }

      if (kPrintComments && kDebugMode) print('Current sideMostSolution: $sideMostSolution');
    }

    if (kPrintComments && kDebugMode) print('Finished checking all clues. Is sideMostSolution completed?');
    if (kPrintComments && kDebugMode)
      print(sideMostSolution.length < solution.length ? 'No. Complete solution with "0"s' : 'Yes. Move on');
    if (sideMostSolution.length < solution.length) {
      sideMostSolution.addAll(Iterable.generate(remainingSolution.length, (_) => '0').toList());
    }
    if (kPrintComments && kDebugMode) print('Final sideMostSolution: $sideMostSolution');
    return axis == NonoAxisAlignment.end ? sideMostSolution.reversed.toList() : sideMostSolution;
  }
}
