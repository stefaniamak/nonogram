import 'dart:convert';
import 'dart:developer';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/models/solver_settings.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_alignment_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_direction_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_list_extension.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/solver/line_solver_helper.dart';

/// The `lineSolverIsolate` function is an entry point for an isolate that processes nonogram puzzle solving tasks.
/// It manages a stack of rows and columns, iteratively solving each line and updating the solution state.
///
/// The function receives a [params] object containing the [IsolateInput] data as a JSON-encoded string.
/// It enters a loop to process each line in the stack, solving the line and updating the solution state.
/// It then sends the updated solution state to the main isolate for further processing.
///
/// When the stack of lines is empty, the function adds a final solution step to the solution state, indicating
/// whether the nonogram was solved or not.
/// The function returns a JSON-encoded string containing the final solution state.
@isolateManagerCustomWorker
void lineSolverIsolate(dynamic params) {
  IsolateManagerFunction.customFunction<String, String>(
    params,
    onEvent: (IsolateManagerController<String, String> controller, String message) {
      // Decode the input parameters to an IsolateInput object.
      final IsolateInput input = IsolateInput.fromJson(jsonDecode(message));
      // Initialize the stack list with the nonogram clues.
      final List<Map<int, NonoAxis>> stack = LineSolverHelper.instance.initializeStackList(
        input.nonogram.clues,
        input.solverSettings.sortInitialLinesStackViaClues,
      );
      // Set up initial values for solution steps, cached box solutions, and lists to track checked lines and boxes.
      List<SolutionStep> solutionSteps = input.solutionSteps;
      final Map<String, bool> cachedBoxSolutions = <String, bool>{};
      final List<int> linesCheckedList = <int>[0];
      final List<int> boxesChecked = <int>[0];
      final List<int> otherBoxesChecked = <int>[0];

      // Create an initial IsolateOutput object to track progress.
      IsolateOutput progress = IsolateOutput(
        stack: stack,
        solutionSteps: solutionSteps,
        cachedBoxSolutions: cachedBoxSolutions,
        linesCheckedList: linesCheckedList,
        boxesCheckedList: boxesChecked,
        otherBoxesCheckedList: otherBoxesChecked,
      );

      // Enter a loop to process each line in the stack.
      while (stack.isNotEmpty) {
        // Retrieve the line index and type (row or column).
        final Map<int, NonoAxis> line = stack.first;
        // Retrieve the clues for the current line.
        final List<int> clues = (line.values.first == NonoAxis.row ? input.nonogram.clues.rows : input.nonogram.clues.columns)
            .elementAt(line.keys.first);

        // Call the loopSides function to process the line and update the solution.
        progress = _loopSides(
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

        // Send the progress back to the main isolate.
        controller.sendResult(
          jsonEncode(
            <String, Map<String, dynamic>>{
              'progress': progress.toJson(),
            },
          ),
        );

        // Update the stack and solution steps based on the progress.
        if (progress.stack.isNotEmpty) stack.addAll(progress.stack);
        if (progress.solutionSteps.isNotEmpty) solutionSteps = progress.solutionSteps;

        // Remove the processed line from the stack.
        stack.removeAt(0);
      }

      // Add a final solution step indicating whether the nonogram is solved.
      solutionSteps.add(
        SolutionStep(
          currentSolution: solutionSteps.last.currentSolution,
          explanation: solutionSteps.last.currentSolution.split('').contains('?') ? 'Nonogram not solved' : 'Nonogram solved',
          newFilledBoxes: <int>[],
        ),
      );

      // Return the final results, including the stack, solution steps, cached box solutions, and checked lines and boxes.
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

/// The `_loopSides` function processes a single line (row or column) of a nonogram puzzle, updating the solution state.
/// It checks if the line is already completed, and if not, it calculates all possible solutions
/// for the line and updates the solution state accordingly.
///
/// The function receives the following parameters:
/// - [lineIndex]: The index of the line to process.
/// - [clues]: The clues for the current line.
/// - [lineType]: The type of the line (row or column) to process.
/// - [nonogram]: The nonogram puzzle object containing the width of the puzzle.
/// - [output]: The current state of the solution, including the stack, solution steps, and cached box solutions.
/// - [settings]: The solver settings to use during processing.
/// - [printLogs]: A boolean flag to enable or disable logging (default is false).
///
/// The function firstly identifies the positions of question marks in the initial solution.
/// With these positions, it checks if the line is already completed by comparing
/// the number of filled boxes with the sum of the clues.
///
/// If the line is completed, it crosses out any remaining empty boxes.
/// ELSE
/// If the line is not completed, it calculates all possible solutions for the line.
/// Then, it matches the starting and ending solutions to identify sure boxes to fill or cross out.
///
/// After any of the above paths, it updates the solution state with the new filled boxes
/// and adds new stack elements for further processing - these data create the final solution state.
///
/// The function returns an [IsolateOutput] object containing the updated solution state.
IsolateOutput _loopSides({
  required int lineIndex,
  required List<int> clues,
  required NonoAxis lineType,
  required Nonogram nonogram,
  required IsolateOutput output,
  required SolverSettings settings,
  bool printLogs = false,
}) {
  // Update the count of checked lines.
  output.linesCheckedList.add(output.linesCheckedList.last + 1);
  output.linesCheckedList.removeAt(0);

  if (printLogs) log('Check ${lineType.name} with index $lineIndex.');
  if (printLogs) log("${lineType.name}'s clues: $clues");

  // Retrieve the initial solution for the line.
  final String initialSolution = LineSolverHelper.instance.getSolutionLine(
    output.solutionSteps.last.currentSolution,
    nonogram.width,
    lineIndex,
    lineType,
  );

  // Identify the positions of question marks in the initial solution.
  final List<int> charIndexesOfQMarks = LineSolverHelper.instance.getCharIndexesOfQuestionMarks(initialSolution);

  if (printLogs) log("${lineType.name}'s initialSolution: $initialSolution");

  // Check if the line is already completed by comparing the number of filled boxes with the sum of the clues.
  int filledBoxes = initialSolution.sumFilledBoxes;
  bool isLineCompleted = filledBoxes == clues.sum;

  if (printLogs) log("Are filled boxes ($filledBoxes) equal with clue's sum (${clues.sum})?");
  if (isLineCompleted) {
    // If the line is completed, cross out any remaining empty boxes.
    if (printLogs) log('It is. Shall cross out remaining empty boxes if any left.');
    if (initialSolution.split('').toList().contains('?')) {
      final Map<String, dynamic> crossedOutSolution = LineSolverHelper.instance.getFilledInSolution(
        output.solutionSteps.last.currentSolution,
        lineIndex,
        lineType,
        nonogram.width,
        charIndexesOfQMarks,
      );

      // Return the updated solution state with the crossed-out boxes.
      return IsolateOutput(
        stack: output.stack.getNewStackElements(charIndexesOfQMarks, lineType),
        solutionSteps: <SolutionStep>[
          SolutionStep(
            currentSolution: crossedOutSolution['fullUpdatedSolution'],
            axis: lineType,
            lineIndex: lineIndex,
            explanation: 'Cross out all remaining empty boxes of ${lineType.name} with index $lineIndex.',
            newFilledBoxes: crossedOutSolution['newFilledBoxes'],
          ),
        ],
        linesChecked: output.linesCheckedList.last,
        boxesChecked: output.boxesCheckedList.last,
        otherBoxesChecked: output.otherBoxesCheckedList.last,
        totalCacheData: output.cachedBoxSolutions.length,
      );
    }
  } else {
    // If the line is not completed, calculate all possible solutions for the line.
    if (printLogs) log('It is not. Starts to calculate all possible solutions...');
    final List<List<String>> allLineSolutions = _getAllLinePossibleSolutions(clues, initialSolution, output, settings);
    if (printLogs) log('All line solutions: $allLineSolutions');

    // Find the starting most solutions for the line.
    if (printLogs) log('Find starting solution of $allLineSolutions with clues $clues.');
    final List<String> startingMostSolution = _getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.start);
    if (printLogs) log('Starting most solution: $startingMostSolution');

    // Find the ending most solutions for the line.
    if (printLogs) log('Find ending solution of $allLineSolutions with clues $clues.');
    final List<String> endingMostSolution = _getSideMostSolution(allLineSolutions, clues, NonoAxisAlignment.end);
    if (printLogs) log('Ending most solution  : $endingMostSolution');

    // Find the positions of sure boxes to fill or cross out by comparing the starting and ending
    // most solutions for the line.
    final Map<int, List<int>> result = _getSideMostSolutionsMatches(
      allLineSolutions,
      startingMostSolution,
      endingMostSolution,
      charIndexesOfQMarks,
    );

    if (result.isNotEmpty) {
      final List<Map<int, NonoAxis>> finalStack = <Map<int, NonoAxis>>[];
      List<int> newFilledBoxes = <int>[];
      final List<SolutionStep> newSolutionSteps = <SolutionStep>[];
      String fullUpdatedSolution = output.solutionSteps.last.currentSolution;

      // Iterate over the matched solutions to update the solution state.
      for (final int clueKey in result.keys) {
        // Retrieve the character indexes for the matched solutions.
        final List<int> charIndexes = result[clueKey]!;
        // Retrieve the clue index based on the clue key.
        final int clueIndex = clueKey == 0 ? 0 : clueKey - 2;

        // Fill in the solution for the line based on the matched solutions.
        final Map<String, dynamic> filledInSolution = LineSolverHelper.instance.getFilledInSolution(
          fullUpdatedSolution,
          lineIndex,
          lineType,
          nonogram.width,
          charIndexes,
          clueKey,
        );
        newFilledBoxes = filledInSolution['newFilledBoxes'];
        fullUpdatedSolution = filledInSolution['fullUpdatedSolution'];

        if (printLogs) log('fullUpdatedSolution: $fullUpdatedSolution');

        // Check if there are any new filled boxes to update the solution state.
        if (newFilledBoxes.isNotEmpty) {
          final String solutionLine = LineSolverHelper.instance.getSolutionLine(
            output.solutionSteps.last.currentSolution,
            nonogram.width,
            lineIndex,
            lineType,
          );

          // Update the count of checked boxes.
          filledBoxes = solutionLine.sumFilledBoxes;
          // Check if the line is completed after filling in the new boxes.
          isLineCompleted = filledBoxes == clues.sum;

          // If the line is completed and there are still empty boxes, add current line to stack,
          // so it can be checked again to cross out the remaining empty boxes.
          if (isLineCompleted && fullUpdatedSolution.split('').contains('?')) {
            finalStack.addAll(
              finalStack.getNewStackElements(<int>[lineIndex], lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row),
            );
          }

          // Update the stack with the new stack elements based on influenced lines.
          finalStack.addAll(finalStack.getNewStackElements(charIndexes, lineType));
          // Add a new solution step to the solution state.
          final SolutionStep solutionStep = SolutionStep(
            currentSolution: fullUpdatedSolution,
            axis: lineType,
            lineIndex: lineIndex,
            explanation:
                '${clueKey == 0 ? 'Cross out' : 'Fill in'} sure boxes for clue ${clues.elementAt(clueIndex)} with index $clueIndex of ${lineType.name} with index $lineIndex.',
            newFilledBoxes: newFilledBoxes,
          );

          // Add the new solution step to the solution steps list.
          newSolutionSteps.add(solutionStep);
        }
      }
      // Return the updated solution state with the new filled boxes and stack elements.
      return IsolateOutput(
        stack: finalStack != output.stack ? finalStack : <Map<int, NonoAxis>>[],
        solutionSteps: newSolutionSteps,
        linesChecked: output.linesCheckedList.last,
        boxesChecked: output.boxesCheckedList.last,
        otherBoxesChecked: output.otherBoxesCheckedList.last,
        totalCacheData: output.cachedBoxSolutions.length,
      );
    }
  }
  // Return the current solution state if no changes were made, but with updated checked lines and boxes.
  return IsolateOutput(
    linesChecked: output.linesCheckedList.last,
    boxesChecked: output.boxesCheckedList.last,
    otherBoxesChecked: output.otherBoxesCheckedList.last,
    totalCacheData: output.cachedBoxSolutions.length,
  );
}

/// The `getAllLinePossibleSolutions` function calculates all possible solutions for a given line (row or column)
/// of a nonogram puzzle based on the provided clues and the current state of the solution.
///
/// The function receives the following parameters:
/// - [clues]: A list of integers representing the clues for the current line.
/// - [line]: A string representing the current state of the line to be processed.
/// - [output]: An [IsolateOutput] object containing the current state of the solution.
/// - [settings]: A [SolverSettings] object containing the solver settings to use during processing.
/// - [printLogs]: A boolean flag to enable or disable logging (default is false).
///
/// The function iterates over each clue and checks if the clue can fit in the line at that position.
///
/// Firstly, it checks if the solution is already in the cache. If it is, it uses the cached result.
/// If it is not, it calculates the result and updates the cache.
///
/// Then, it updates the possible solutions for the characters in the line based on the clue.
///
/// The function returns a list of lists of strings, where each inner list represents the possible
/// solutions for a character in the line.
List<List<String>> _getAllLinePossibleSolutions(
  List<int> clues,
  String line,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  if (printLogs) log('Get all possible solutions of line $line with clues $clues');
  // Initialize an empty list of possible solutions for each character in the line.
  final List<List<String>> possibleSolutions = Iterable<List<String>>.generate(line.length, (_) => <String>[]).toList();

  // Iterate over each clue.
  for (int clueIndex = 0; clueIndex < clues.length; clueIndex++) {
    // Calculate the minimum and maximum starting points for the clue, to minimize the number of iterations.
    final int minStartingPoint = clues.minStartingPoint(clueIndex);
    final int maxStartingPoint = clues.maxStartingPoint(clueIndex, line.length);
    // Iterate over each starting point.
    for (int charIndex = minStartingPoint; charIndex < maxStartingPoint; charIndex++) {
      // Check if the clue can fit in the line at the current position.

      // Firstly, check if the solution is already in the cache.
      final bool? cache = settings.keepCacheData ? output.cachedBoxSolutions['$clues,$clueIndex,$line,$charIndex'] : null;
      final bool isInCache = cache != null;
      bool result;
      if (isInCache) {
        // If it is, use the cached result.
        result = cache;
      } else {
        // If it is not, calculate the result and update the cache.
        result = _canCluesFit(clues, line, charIndex, clueIndex, output, settings);
        if (settings.keepCacheData) {
          output.cachedBoxSolutions
              .addAll(LineSolverHelper.instance.updateCachedBoxSolutions(clues, clueIndex, line, charIndex, result));
        }
        // Update the count of checked boxes.
        if (settings.countCheckedBoxes) {
          output.boxesCheckedList.add(output.boxesCheckedList.last + 1);
          output.boxesCheckedList.removeAt(0);
        }
      }
      // Update the possible solutions for the characters in the line based on the clue.
      final String solutionNumb = result ? '${clueIndex + 2}' : '0';
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

  // Return the list of possible solutions for the line.
  return possibleSolutions;
}

/// The `getSideMostSolution` function calculates the most extreme solution (either starting or ending) for a given line (row or column)
/// of a nonogram puzzle based on the provided clues and the current state of the solution.
///
/// The function receives the following parameters:
/// - [initialSolution]: A list of lists of strings representing the possible solutions for each character in the line.
/// - [initialClues]: A list of integers representing the clues for the current line.
/// - [axis]: An enum value of type [NonoAxisAlignment] indicating whether to calculate the starting or ending most solution.
/// - [printLogs]: A boolean flag to enable or disable logging (default is false).
///
/// The function iterates over each clue and finds the position where the clue can fit in the remaining solution.
/// Adds the clue to the side most solution and updates the remaining solution.
/// If there are any remaining characters in the solution, fills them with '0'.
///
/// The functions has a small modification to the original code to reverse the solution and clues
/// if the axis is `NonoAxisAlignment.end`.
///
/// The function returns a list of strings representing the side most solution for the line.
List<String> _getSideMostSolution(
  List<List<String>> initialSolution,
  List<int> initialClues,
  NonoAxisAlignment axis, [
  bool printLogs = false,
]) {
  if (printLogs) log('Get ${axis.name}ing most solution of solution $initialSolution with clues $initialClues');

  // Reverse the initial solution and clues if the axis is `NonoAxisAlignment.end`.
  List<List<String>> solution = initialSolution;
  List<int> clues = initialClues;
  List<int> clueIndexes = Iterable<int>.generate(clues.length, (int c) => c + 2).toList();
  if (axis == NonoAxisAlignment.end) {
    if (printLogs) log('All values should reverse');
    solution = initialSolution.reversed.toList();
    clues = clues.reversed.toList();
    clueIndexes = clueIndexes.reversed.toList();
  }

  // Initialize an empty list to store the side most solution and set the remaining solution to the initial solution.
  final List<String> sideMostSolution = <String>[];
  List<List<String>> remainingSolution = solution;

  if (printLogs) {
    log('Start checking clues one by one. sideMostSolution list is empty, remainingSolution is $remainingSolution');
  }

  // Iterate over each clue.
  for (int i = 0; i < clues.length; i++) {
    final int clue = clues[i];
    final int clueIndex = clueIndexes.elementAt(i);
    final int cluePos = remainingSolution.indexWhere((List<String> list) => list.contains('$clueIndex'));
    if (printLogs) log('Clue $i with value $clue is found at position $cluePos of remainingSolution $remainingSolution');

    // Add '0's to the side most solution if there are any gaps before the clue.
    if (printLogs) log('Is cluePos $cluePos larger than 0?');
    if (printLogs) log(cluePos > 0 ? 'Yes, it is. Add $cluePos "0"s to sideMostSolution list' : "No, it isn't. Move on");
    if (cluePos > 0) sideMostSolution.addAll(Iterable<String>.generate(cluePos, (_) => '0').toList());

    // Add the clue to the side most solution list.
    if (printLogs) log('Add $clue times clueIndex $clueIndex of clue $clue at sideMostSolution list');
    sideMostSolution.addAll(Iterable<String>.generate(clue, (_) => '$clueIndex').toList());

    // If the solution is not completed, add a '0' for space and update the remaining solution.
    if (printLogs) log('Is solution completed?');
    if (printLogs) {
      log(
        sideMostSolution.length < solution.length
            ? 'No, not finished. Add "0" for space at sideMostSolution list and create a new sublist after clue added'
            : 'Yes it is. Move on',
      );
    }

    // Add '0's to the side most solution if there are any gaps after the clue.
    if (sideMostSolution.length < solution.length) {
      sideMostSolution.add('0');
      remainingSolution = remainingSolution.sublist(cluePos + clue + 1);
    }

    if (printLogs) log('Current sideMostSolution: $sideMostSolution');
  }

  // Fill the remaining characters in the solution with '0' if the solution is not completed.
  if (printLogs) log('Finished checking all clues. Is sideMostSolution completed?');
  if (printLogs) log(sideMostSolution.length < solution.length ? 'No. Complete solution with "0"s' : 'Yes. Move on');
  if (sideMostSolution.length < solution.length) {
    sideMostSolution.addAll(Iterable<String>.generate(remainingSolution.length, (_) => '0').toList());
  }
  if (printLogs) log('Final sideMostSolution: $sideMostSolution');

  // Reverse the side most solution back to the original order if the axis is `NonoAxisAlignment.end`.
  return axis == NonoAxisAlignment.end ? sideMostSolution.reversed.toList() : sideMostSolution;
}

/// The `getSideMostSolutionsMatches` function identifies the positions of sure boxes to fill or cross out
/// by comparing the starting and ending most solutions for a given line (row or column) of a nonogram puzzle.
///
/// The function receives the following parameters:
/// - [allLineSolutions]: A list of lists of strings representing all possible solutions for each character in the line.
/// - [startingMostSolution]: A list of strings representing the starting most solution for the line.
/// - [endingMostSolution]: A list of strings representing the ending most solution for the line.
/// - [charIndexesOfQMarks]: A list of integers representing the positions of question marks in the initial solution.
///
/// The function finds the clues that have the same positions at both starting and ending most solutions.
/// It then adds the positions of the sure boxes to fill or cross out to a map, which is returned as the result.
///
/// The function returns a map where the keys are the clue indexes and the values are lists of character indexes
/// representing the positions of sure boxes to fill or cross out.
Map<int, List<int>> _getSideMostSolutionsMatches(
  List<List<String>> allLineSolutions,
  List<String> startingMostSolution,
  List<String> endingMostSolution,
  List<int> charIndexesOfQMarks,
) {
  // Initialize a map to store the matched positions.
  //
  // The key is the character index of the clue on the whole solution.
  // The value is the clue value plus the number 2 (which is used throughout the
  // whole solver, to separate the clue numbers from the 0 and 1 filled identifiers).
  final Map<int, Set<int>> matchMap = <int, Set<int>>{};

  // Find all matches between the starting and ending most solutions.
  // If a clue number is located at the same character index in both solutions,
  // add it to the match map.
  final Set<(int, String)> inputNumbersStart = startingMostSolution.indexed.toSet();
  final Set<(int, String)> inputNumbersEnd = endingMostSolution.indexed.toSet();
  final Set<(int, String)> duplicateInputNumbers = inputNumbersStart.intersection(inputNumbersEnd);

  // Iterate over the matched positions and add only the non-zero values ([rightNumber] != 0)
  // that are missing from the current solution (their position, [leftNumber], is
  // included in the charIndexesOfQMarks list), to the match map.
  for (final (int, String) match in duplicateInputNumbers) {
    final int leftNumber = match.$1;
    final int rightNumber = int.parse(match.$2);
    if (rightNumber != 0 && charIndexesOfQMarks.contains(leftNumber)) {
      matchMap.putIfAbsent(rightNumber, () => <int>{});
      matchMap[rightNumber]!.add(leftNumber);
    }
  }

  // Find all matches for the always zero-filled boxes from all possible solutions.
  final String inclusionPattern = charIndexesOfQMarks.map((int e) => e).join('|');
  final RegExp regZeroFilledMatches = RegExp(r'\((' + inclusionPattern + r'), \[(0)\]\)');
  final String inputZeros = allLineSolutions.indexed.toList().toString();
  final Iterable<RegExpMatch> matchesZeros = regZeroFilledMatches.allMatches(inputZeros);

  // Iterate over the matched positions and add the zero values to the match map.
  if (matchesZeros.isNotEmpty) {
    matchMap.putIfAbsent(0, () => <int>{});
    matchMap[0]!.addAll(matchesZeros.map((RegExpMatch match) => int.parse(match.group(1)!)));
  }

  // Convert the match map to a map with integer keys and list values.
  // The key is the clue value + 2, and the value is a list of character indexes that this clue
  // exists on its own in both side-most solutions.
  return matchMap.map((int key, Set<int> value) => MapEntry<int, List<int>>(key, value.toList()));
}

/// The `_canCluesFit` function checks if a given clue can fit into a specified position in the solution line of a nonogram puzzle.
///
/// The function receives the following parameters:
/// - [clues]: A list of integers representing the clues for the current line.
/// - [solution]: A string representing the current state of the solution line.
/// - [solutionPosition]: An integer representing the starting position in the solution line to check the clue.
/// - [cluePosition]: An integer representing the position of the clue in the clues list.
/// - [output]: An [IsolateOutput] object containing the current state of the solution.
/// - [settings]: A [SolverSettings] object containing the solver settings to use during processing.
/// - [printLogs]: An optional boolean flag to enable or disable logging (default is false).
///
/// The function performs the following checks:
/// 1. Checks if the clue can fit within the remaining length of the solution line.
/// 2. Verifies that the clue can fit without conflicting with existing filled or empty boxes.
/// 3. Checks if the clues before and after the current clue fit correctly.
///
/// The function returns a boolean value indicating whether the clue can fit at the specified position.
bool _canCluesFit(
  List<int> clues,
  String solution,
  int solutionPosition,
  int cluePosition,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  // Split the solution string into a list of characters.
  final List<String> solutionList = solution.split('');
  final int clue = clues[cluePosition];

  // Check if the clue can fit within the remaining length of the solution line.
  if (printLogs) {
    log('Does clue $clue fit at $solutionList from position $solutionPosition to position ${solutionPosition + clue}?');
  }
  if (clue > solutionList.getRange(solutionPosition, solutionList.length).length) {
    if (printLogs) log('false');
    return false;
  }
  if (printLogs) log('true');

  // Verify that the clue can fit without conflicting with existing filled or empty boxes.
  final List<String> fit = solutionList.sublist(solutionPosition, solutionPosition + clue);
  final String valueAfter = solutionPosition + clue >= solutionList.length ? '0' : solutionList[solutionPosition + clue];
  final String valueBefore = solutionPosition <= 0 ? '0' : solutionList[solutionPosition - 1];
  final bool canFit = !fit.contains('0') && valueAfter != '1' && valueBefore != '1';

  if (printLogs) log('Can clue $clue fit at: $valueBefore $fit $valueAfter');
  if (!canFit) {
    if (printLogs) log('false');
    return false;
  }
  if (printLogs) log('true');

  // Check if the clues before and after the current clue fit correctly.
  final bool cluesBeforeGood =
      _doOtherCluesFit(NonoDirection.before, clues, cluePosition, solution, solutionPosition, output, settings);
  final bool cluesAfterGood =
      _doOtherCluesFit(NonoDirection.after, clues, cluePosition, solution, solutionPosition, output, settings);

  // Return true if both the clues before and after fit correctly.
  if (printLogs) log('Do both clues before and clues after fit? Answer: ${cluesBeforeGood && cluesAfterGood}');
  return cluesBeforeGood && cluesAfterGood;
}

/// The `doOtherCluesFit` function checks if the clues before or after the current clue fit correctly in the solution line of a nonogram puzzle.
///
/// The function receives the following parameters:
/// - [solutionSide]: A [NonoDirection] enum value indicating whether to check the clues before or after the current clue.
/// - [clues]: A list of integers representing the clues for the current line.
/// - [clueIndex]: An integer representing the position of the current clue in the clues list.
/// - [solution]: A string representing the current state of the solution line.
/// - [solutionIndex]: An integer representing the starting position in the solution line to check the clue.
/// - [output]: An [IsolateOutput] object containing the current state of the solution.
/// - [settings]: A [SolverSettings] object containing the solver settings to use during processing.
/// - [printLogs]: An optional boolean flag to enable or disable logging (default is false).
///
/// The function performs the following steps:
/// 1. Checks if there are any other clues left before or after the current clue (based on the [NonoDirection]).
/// 2. If there are no other clues, it validates the solution for the current clue by checking that there are no filled boxes which match to no clue.
/// 3. If there are other clues, it checks if there are enough boxes left for the clues.
/// 4. If there are more clues in the list, it iterates over the solution sublist to check if these clues fit correctly.
///
/// The function returns a boolean value indicating whether the clues before or after the current clue fit correctly.
bool _doOtherCluesFit(
  NonoDirection solutionSide,
  List<int> clues,
  int clueIndex,
  String solution,
  int solutionIndex,
  IsolateOutput output,
  SolverSettings settings, [
  bool printLogs = false,
]) {
  final int clue = clues[clueIndex];

  // Update the count of checked boxes if the setting is enabled.
  if (settings.countCheckedBoxes) {
    output.otherBoxesCheckedList
      ..add(output.otherBoxesCheckedList.last + 1)
      ..removeAt(0);
  }

  // Check if the current clue has other clues before or after it.
  if (printLogs) log('Does clue have clues ${solutionSide.name}?');
  if (!solutionSide.hasOtherClues(clueIndex, clues.length)) {
    // If not, check if there are any filled boxes which match to no clue.
    if (printLogs) log('It does not.');
    if (printLogs) log('Check if there are any filled boxes which match to no clue.');
    return solutionSide.isSolutionValid(solution, solutionIndex, clues[clueIndex]);
  }
  if (printLogs) log('It does. Continue checking.');

  // Get the sublist of clues either before or after the main clue, based on the given direction.
  final List<int> cluesSublist = solutionSide.getCluesSublist(clueIndex, clues);

  // Check if there are enough boxes left for the clues.
  if (printLogs) log('Does clue have boxes left for clues left?');
  if (!solutionSide.hasBoxesLeft(solutionIndex, clue, solution, cluesSublist)) {
    if (printLogs) log('It does not. Return `false`.');
    return false;
  }
  if (printLogs) log('It does. Continue checking.');

  // Check if the solution sublist fits the clues sublist by calling the again `canCluesFit` function,
  // creating a recursive loop. The function keeps calling itself until it reaches the end of the clues list.
  // If every other clue fits, that means that the main clue fits.
  final String solutionSublist = solutionSide.getSolutionSublist(solution, solutionIndex, clue);
  if (printLogs) log('Does solution sublist $solutionSublist fit clues $cluesSublist?');
  for (int solutionSublistIndex = 0; solutionSublistIndex < solutionSublist.length; solutionSublistIndex++) {
    if (_canCluesFit(cluesSublist, solutionSublist, solutionSublistIndex, 0, output, settings)) {
      if (printLogs) log('It does fit. Return `true`.');

      if (settings.keepCacheData) {
        output.cachedBoxSolutions.addAll(
          LineSolverHelper.instance.updateCachedBoxSolutions(cluesSublist, 0, solutionSublist, solutionSublistIndex, true),
        );
      }

      // Return true if the solution sublist fits the clues sublist.
      return true;
    }
  }
  if (printLogs) log('It does not fit. Return `false`.');
  // Return false if the solution sublist does not fit the clues sublist.
  return false;
}
