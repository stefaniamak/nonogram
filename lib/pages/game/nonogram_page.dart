import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';
import 'package:nonogram/solver/line_solver.dart';

class NonogramPage extends HookWidget {
  final Nonogram nonogram;

  const NonogramPage({
    required this.nonogram,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var nonogramState = useNonogramState(nonogram);
    final bool isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return AppPage(
      hasVerticalPadding: false,
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
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.9,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                children: [
                  NonogramTitle(nonogram: nonogram, showDescription: false),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            LineSolver().solve(nonogramState);
                          },
                          child: const Text('SOLVE'),
                        ),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
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
                  SizedBox(height: 50, child: Text(nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).explanation)),
                  const Text('--Stats--'),
                  if (nonogramState.startDateTime != null && nonogramState.endingDateTime != null)
                    Text('Puzzle duration: ${nonogramState.endingDateTime!.difference(nonogramState.startDateTime!)}'),
                  Switch(value: nonogramState.groupSteps, onChanged: (_) => nonogramState.updateGroupSteps()),
                  Switch(value: nonogramState.countCheckedBoxes, onChanged: (_) => nonogramState.updateCountCheckedBoxes()),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: nonogramState.countCheckedBoxes ? 1 : 0.4,
                    child: Column(children: [
                      Text('Lines checked: ${nonogramState.linesChecked}'),
                      Text(' Boxes checked: ${nonogramState.boxesChecked}'),
                      Text('Actual boxes checked: ${nonogramState.actualBoxesChecked}'),
                      Text('Other boxes checked: ${nonogramState.otherBoxesChecked}'),
                      Text('Total cache data: ${nonogramState.cachedBoxSolutions.length}'),
                    ]),
                  )
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
