import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';
import 'package:nonogram/solver/line_solver_simpler.dart';

class NonogramPage extends HookWidget {
  final Nonogram nonogram;

  const NonogramPage({
    required this.nonogram,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    NonogramState nonogramState = useNonogramState(nonogram);
    final bool isLargeScreen = MediaQuery.of(context).size.width > 1200;
    const double infoMaxWidth = 460;

    return AppPage(
      hasVerticalPadding: false,
      hasMaxCrossAxisExtend: false,
      children: [
        Flex(
          direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
          // verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NonogramGridAndClues(
              // nonogram: nonogram,
              clues: nonogram.clues!,
              solution: nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).currentSolution,
              padding: const EdgeInsets.all(32),
              maxSize: Size(
                MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width - infoMaxWidth - 50 > 0 ? infoMaxWidth + 50 : 48),
                MediaQuery.of(context).size.height * 0.9,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  NonogramTitle(nonogram: nonogram, showDescription: false),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: nonogramState.solutionSteps.length > 1
                              ? null
                              : () async {
                                  // Test 1: Compute. Failed on both Web and Mobile because it contained unsoported types.
                                  // compute(LineSolver().solve, nonogramState);
                                  // LineSolver().solve(nonogramState);

                                  // Test 2: Cancelable. Run on web, but without using another thread. Failed on mobile
                                  // Cancelable<String> cancelable = workerManager.execute<String>(
                                  //   () async {
                                  //     // Your CPU-intensive function here
                                  //     LineSolver().solve(nonogramState);
                                  //     return 'success cancelable';
                                  //   },
                                  //   priority: WorkPriority.immediately,
                                  // );
                                  //
                                  // print('cancelable: ${cancelable}');

                                  // Test 3: Starting slow with fibonacci algorithm to test the isolates

                                  // print('fibonacci started');
                                  // String result = '';

                                  // Test 3.1: Simple call
                                  // var result = await fibonacci(40);

                                  // final isolate = IsolateManager.create(
                                  //   fibonacci,
                                  //
                                  //   // And the name of the function if you want to use the Worker.
                                  //   // Otherwise, you can ignore this parameter.
                                  //   workerName: 'fibonacci',
                                  //   concurrent: 2,
                                  // );
                                  //
                                  // isolate.stream.listen((value) {
                                  //   print('value from isolate.stream.listen: $value');
                                  // });
                                  //
                                  // final fibo = await isolate(40);
                                  //
                                  // print('fibonacci result: $result');
                                  // print('fibonacci fibo: $fibo');

                                  // Test 4: Slowly building the solver
                                  // final solverIsolate = IsolateManager.create(
                                  //   lineSolver,
                                  //
                                  //   // And the name of the function if you want to use the Worker.
                                  //   // Otherwise, you can ignore this parameter.
                                  //   workerName: 'lineSolver',
                                  //   concurrent: 2,
                                  // );
                                  //
                                  // solverIsolate.stream.listen((value) {
                                  //   print('solution from isolate.stream.listen: $value');
                                  // });
                                  //
                                  // final solution = await solverIsolate(40);
                                  //
                                  // print('solution: $solution');

                                  // Test 5: Custom functions with progress message
                                  // Create an IsolateManager instance.
                                  // final isolateManager =
                                  //     IsolateManager.createCustom(progressFunction, workerName: 'progressFunction');
                                  //
                                  // // Get the result.
                                  // final result = await isolateManager.compute(nonogram.toJson(), callback: (value) {
                                  //   // Condition to recognize the progress value. Ex:
                                  //   final data = jsonDecode(value);
                                  //
                                  //   if (data.containsKey('progress')) {
                                  //     print('This is a progress value: ${data['progress']}');
                                  //
                                  //     // Return `false` to mark this value is not the final.
                                  //     return false;
                                  //   }
                                  //
                                  //   print('This is a final value: ${data['result']}');
                                  //
                                  //   // Return `true` to mark this value is the final.
                                  //   return true;
                                  // });
                                  //
                                  // print(result); // 100

                                  // Test 6: Line solver
                                  // Create an IsolateManager instance.
                                  final isolateManager = IsolateManager.createCustom(
                                    lineSolverIsolate,
                                    workerName: 'lineSolverIsolate',
                                  );

                                  // Get the result.
                                  final result = await isolateManager.compute(
                                    {
                                      'rows': [...nonogram.clues!.rows],
                                      'columns': [...nonogram.clues!.columns],
                                      'stack': nonogramState.stack,
                                    },
                                    callback: (value) {
                                      // Condition to recognize the progress value. Ex:
                                      final data = jsonDecode(value);

                                      if (data.containsKey('progress')) {
                                        print('This is a progress value: ${data['progress']}');

                                        // Return `false` to mark this value is not the final.
                                        return false;
                                      }

                                      print('This is a final value: ${data['result']}');

                                      // Return `true` to mark this value is the final.
                                      return true;
                                    },
                                  );

                                  print(result); // 100
                                },
                          child: const Text('SOLVE'),
                        ),
                      ),
                      IconButton(
                        onPressed: nonogramState.solutionSteps.length > 1
                            ? () {
                                nonogramState.resetPuzzle();
                              }
                            : null,
                        icon: const Icon(Icons.restart_alt),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: nonogramState.solutionSteps.length > 1 && nonogramState.stepNumber > 0
                            ? () {
                                nonogramState.updateStepNumber(nonogramState.stepNumber - 1);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios_new_sharp),
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: nonogramState.solutionSteps.length <= 1 ? 0.5 : 1,
                          child: Slider(
                            value: nonogramState.stepNumber + 0.0,
                            min: 0,
                            max: nonogramState.solutionSteps.length - 1,
                            divisions: nonogramState.solutionSteps.length,
                            onChanged: (value) {
                              nonogramState.updateStepNumber(value.ceil());
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: nonogramState.solutionSteps.length > 1 &&
                                nonogramState.stepNumber < nonogramState.solutionSteps.length - 1
                            ? () {
                                nonogramState.updateStepNumber(nonogramState.stepNumber + 1);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Step #${nonogramState.stepNumber + 1}:'),
                        const SizedBox(width: 4),
                        Expanded(child: Text(nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).explanation)),
                      ],
                    ),
                  ),
                  const Text('--Stats--'),
                  const SizedBox(height: 8),
                  Text(
                    'Puzzle duration: ${nonogramState.startDateTime != null && nonogramState.endingDateTime != null ? (nonogramState.endingDateTime!.difference(nonogramState.startDateTime!)) : '-'}',
                  ),
                  Text('Total steps: ${nonogramState.solutionSteps.length}'),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: nonogramState.keepCacheData ? 1 : 0.4,
                    child: Text('Total cache data: ${nonogramState.cachedBoxSolutions.length}'),
                  ),
                  Text('Lines checked: ${nonogramState.linesChecked}'),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: nonogramState.countCheckedBoxes ? 1 : 0.4,
                    child: Column(children: [
                      Text('Boxes checked: ${nonogramState.boxesChecked}'),
                      Text('Actual boxes checked: ${nonogramState.actualBoxesChecked}'),
                      Text('Other boxes checked: ${nonogramState.otherBoxesChecked}'),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  const Text('--Settings--'),
                  Row(
                    children: [
                      Switch(value: nonogramState.groupSteps, onChanged: (_) => nonogramState.updateGroupSteps()),
                      const Text('Group steps via clues'),
                    ],
                  ),
                  Row(
                    children: [
                      Switch(value: nonogramState.keepCacheData, onChanged: (_) => nonogramState.updateKeepCacheData()),
                      const Text('Keep cache data of box solutions'),
                    ],
                  ),
                  Row(
                    children: [
                      Switch(value: nonogramState.countCheckedBoxes, onChanged: (_) => nonogramState.updateCountCheckedBoxes()),
                      const Text('Count boxes checked in recursive algorithm'),
                    ],
                  ),
                ],
              ),
            ),
            // Text('nonogramState.solutionSteps.length: ${nonogramState.solutionSteps.length}'),
            // Text('nonogramState.stepNumber: ${nonogramState.stepNumber}'),
          ],
        ),
      ],
    );
  }
}
