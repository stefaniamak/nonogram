import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
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

    return Flex(
      direction: MediaQuery.of(context).size.width > 400 ? Axis.horizontal : Axis.vertical,
      children: [
        Column(
          children: [
            Text('${nonogramState.nonogram.info?.title} #${nonogramState.nonogram.id}'),
            // Text('nonogramState.activeSolution from page:'),
            // Text('${nonogramState.activeSolution.solution}'),
            // Text('solutionSteps.last.currentSolution from page:'),
            // Text('${nonogramState.solutionSteps.last.currentSolution}'),
            // Text('solutionSteps.length from page:'),
            // Text('${nonogramState.solutionSteps.length}'),
            // Text('stack.length from page:'),
            // Text('${nonogramState.stack.length}'),
            InkWell(
              onTap: () {
                LineSolver().solve(nonogramState);
                // todo: build draft/empty solver structure #17 https://github.com/stefaniamak/nonogram/issues/17
                // var solution = Solver().solve(nonogramState);
              },
              child: const SizedBox(
                height: 50,
                width: 80,
                child: Center(child: Text('SOLVE')),
              ),
            ),
            // Slider(value: value, onChanged: onChanged);
          ],
        ),
        // Text('nonogramState.solutionSteps.length: ${nonogramState.solutionSteps.length}'),
        // Text('nonogramState.stepNumber: ${nonogramState.stepNumber}'),
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
        Text(nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).explanation),
        NonogramGridAndClues(
          nonogram: nonogram,
          nonogramState: nonogramState,
          padding: const EdgeInsets.all(32),
          maxSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.8,
          ),
        ),
      ],
    );
  }
}
