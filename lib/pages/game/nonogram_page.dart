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
                    solution: state.output.solutionSteps.elementAt(state.stepNumber).currentSolution,
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
                                onPressed: state.output.solutionSteps.length > 1
                                    ? null
                                    : () => context.read<NonogramSolverCubit>().solvePuzzle(),
                                child: const Text('SOLVE'),
                              ),
                            ),
                            IconButton(
                              onPressed: state.solverStatus.isCompleted ? context.read<NonogramSolverCubit>().resetPuzzle : null,
                              icon: const Icon(Icons.restart_alt),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: state.solverStatus.isCompleted && state.stepNumber > 0
                                  ? () {
                                      context.read<NonogramSolverCubit>().updateStepNumber(state.stepNumber - 1);
                                    }
                                  : null,
                              icon: const Icon(Icons.arrow_back_ios_new_sharp),
                            ),
                            Expanded(
                              child: Slider(
                                value: state.stepNumber + 0.0,
                                min: 0,
                                max: state.output.solutionSteps.length - 1,
                                divisions: state.output.solutionSteps.length,
                                onChanged: state.solverStatus.isCompleted
                                    ? (value) => context.read<NonogramSolverCubit>().updateStepNumber(value.ceil())
                                    : null,
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  state.solverStatus.isCompleted && state.stepNumber < state.output.solutionSteps.length - 1
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
                              Expanded(child: Text(state.output.solutionSteps.elementAt(state.stepNumber).explanation)),
                            ],
                          ),
                        ),
                        const Text('--Stats--'),
                        const SizedBox(height: 8),
                        Text(
                          'Puzzle duration: ${state.startDateTime != null ? ((state.endingDateTime ?? DateTime.now()).difference(state.startDateTime!)) : '-'}',
                        ),
                        Text('Total steps: ${state.output.solutionSteps.length}'),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: state.solverSettings.keepCacheData ? 1 : 0.4,
                          child: Text('Total cache data: ${state.output.cachedBoxSolutions.length}'),
                        ),
                        Text('Lines checked: ${state.output.linesChecked}'),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: state.solverSettings.countCheckedBoxes ? 1 : 0.4,
                          child: Column(children: [
                            Text('Boxes checked: ${state.output.boxesChecked}'),
                            // Text('Actual boxes checked: ${state.output.actualBoxesChecked}'),
                            Text('Other boxes checked: ${state.output.otherBoxesChecked}'),
                          ]),
                        ),
                        const SizedBox(height: 24),
                        const Text('--Settings--'),
                        // Row(
                        //   children: [
                        //     Switch(
                        //       value: state.solverSettings.groupSteps,
                        //       onChanged: state.solverStatus.canEdit
                        //           ? (_) => context.read<NonogramSolverCubit>().updateGroupSteps()
                        //           : null,
                        //     ),
                        //     const Text('Group steps via clues'),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Switch(
                              value: state.solverSettings.keepCacheData,
                              onChanged: state.solverStatus.canEdit
                                  ? (_) => context.read<NonogramSolverCubit>().updateKeepCacheData()
                                  : null,
                            ),
                            const Text('Keep cache data of box solutions'),
                          ],
                        ),
                        Row(
                          children: [
                            Switch(
                              value: state.solverSettings.countCheckedBoxes,
                              onChanged: state.solverStatus.canEdit
                                  ? (_) => context.read<NonogramSolverCubit>().updateCountCheckedBoxes()
                                  : null,
                            ),
                            const Text('Count box checks'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Isolate concurrent: '),
                            IconButton(
                              onPressed: state.solverSettings.isolateConcurrent == 1
                                  ? null
                                  : () {
                                      context
                                          .read<NonogramSolverCubit>()
                                          .updateIsolateConcurrent(state.solverSettings.isolateConcurrent - 1);
                                    },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(state.solverSettings.isolateConcurrent.toString()),
                            IconButton(
                                onPressed: state.solverStatus.canEdit
                                    ? () {
                                        context
                                            .read<NonogramSolverCubit>()
                                            .updateIsolateConcurrent(state.solverSettings.isolateConcurrent + 1);
                                      }
                                    : null,
                                icon: const Icon(Icons.add)),
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
