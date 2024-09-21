import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';

class NonogramPage extends StatelessWidget {
  final IsolateNonogram nonogram;

  const NonogramPage({
    required this.nonogram,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // NonogramState nonogramState = useNonogramState(nonogram);
    final bool isLargeScreen = MediaQuery.of(context).size.width > 1200;
    const double infoMaxWidth = 460;

    return BlocConsumer<NonogramSolverCubit, NonogramSolverState>(
        // bloc: NonogramSolverCubit()..initialize(nonogram: nonogram),
        listener: (BuildContext context, NonogramSolverState state) {},
        builder: (_, NonogramSolverState state) {
          // print('state: ${state.solutionSteps.length}');
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
                    clues: state.nonogram!.clues,
                    solution: state.solutionSteps.elementAt(state.stepNumber).currentSolution,
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
                                onPressed: state.solutionSteps.length > 1
                                    ? null
                                    : () => context.read<NonogramSolverCubit>().solvePuzzle(),
                                child: const Text('SOLVE'),
                              ),
                            ),
                            IconButton(
                              onPressed: state.solutionSteps.length > 1
                                  ? () {
                                      context.read<NonogramSolverCubit>().resetPuzzle();
                                    }
                                  : null,
                              icon: const Icon(Icons.restart_alt),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: state.solutionSteps.length > 1 && state.stepNumber > 0
                                  ? () {
                                      context.read<NonogramSolverCubit>().updateStepNumber(state.stepNumber - 1);
                                    }
                                  : null,
                              icon: const Icon(Icons.arrow_back_ios_new_sharp),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: state.solutionSteps.length <= 1 ? 0.5 : 1,
                                child: Slider(
                                  value: state.stepNumber + 0.0,
                                  min: 0,
                                  max: state.solutionSteps.length - 1,
                                  divisions: state.solutionSteps.length,
                                  onChanged: (value) {
                                    context.read<NonogramSolverCubit>().updateStepNumber(value.ceil());
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: state.solutionSteps.length > 1 && state.stepNumber < state.solutionSteps.length - 1
                                  ? () {
                                      context.read<NonogramSolverCubit>().updateStepNumber(state.stepNumber + 1);
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
                              Text('Step #${state.stepNumber + 1}:'),
                              const SizedBox(width: 4),
                              Expanded(child: Text(state.solutionSteps.elementAt(state.stepNumber).explanation)),
                            ],
                          ),
                        ),
                        const Text('--Stats--'),
                        const SizedBox(height: 8),
                        Text(
                          'Puzzle duration: ${state.startDateTime != null && state.endingDateTime != null ? (state.endingDateTime!.difference(state.startDateTime!)) : '-'}',
                        ),
                        Text('Total steps: ${state.solutionSteps.length}'),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: state.keepCacheData ? 1 : 0.4,
                          child: Text('Total cache data: ${state.cachedBoxSolutions.length}'),
                        ),
                        Text('Lines checked: ${state.linesChecked}'),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: state.countCheckedBoxes ? 1 : 0.4,
                          child: Column(children: [
                            Text('Boxes checked: ${state.boxesChecked}'),
                            Text('Actual boxes checked: ${state.actualBoxesChecked}'),
                            Text('Other boxes checked: ${state.otherBoxesChecked}'),
                          ]),
                        ),
                        const SizedBox(height: 24),
                        const Text('--Settings--'),
                        Row(
                          children: [
                            Switch(
                                value: state.groupSteps,
                                onChanged: (_) => context.read<NonogramSolverCubit>().updateGroupSteps()),
                            const Text('Group steps via clues'),
                          ],
                        ),
                        Row(
                          children: [
                            Switch(
                                value: state.keepCacheData,
                                onChanged: (_) => context.read<NonogramSolverCubit>().updateKeepCacheData()),
                            const Text('Keep cache data of box solutions'),
                          ],
                        ),
                        Row(
                          children: [
                            Switch(
                                value: state.countCheckedBoxes,
                                onChanged: (_) => context.read<NonogramSolverCubit>().updateCountCheckedBoxes()),
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
        });
  }
}
