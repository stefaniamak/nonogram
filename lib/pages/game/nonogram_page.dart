import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/config/enums/solver_status.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';
import 'package:nonogram/painters/grid_painter.dart';

/// The screen where you can view and solve a nonogram puzzle.
class NonogramPage extends StatelessWidget {
  /// Creates a NonogramPage widget.
  ///
  /// The [nonogram] parameter is required to provide the Nonogram puzzle data that will
  /// be viewed and solved by the algorithm.
  const NonogramPage({required this.nonogram, super.key});

  /// The Nonogram puzzle data.
  final Nonogram nonogram;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NonogramSolverCubit, NonogramSolverState>(
      listener: (_, __) {},
      builder: (_, NonogramSolverState state) {
        return AppPage(
          hasVerticalPadding: false,
          hasMaxCrossAxisExtend: false,
          children: <Widget>[
            Flex(
              direction: AppTheme.hasReachedMaxWidth(context) ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IgnorePointer(
                  child: buildNonogram(context, state),
                ),
                buildInfoBox(context, state),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the Nonogram grid and clues widget.
  ///
  /// The [context] parameter is used to get the [MediaQueryData].
  /// The [state] parameter provides the current state of the Nonogram solver.
  NonogramGridAndClues buildNonogram(BuildContext context, NonogramSolverState state) {
    final MediaQueryData md = MediaQuery.of(context);
    final double infoMaxWidth = AppTheme.maxInfoBoxWidth;
    return NonogramGridAndClues(
      clues: state.nonogram!.clues,
      padding: const EdgeInsets.all(32),
      maxSize: Size(
        md.size.width - (md.size.width - infoMaxWidth - 50 > 0 ? infoMaxWidth + 50 : 48),
        max(1, md.size.height - md.padding.vertical - 180 - kToolbarHeight),
      ),
      gridStateParams: GridStateParams(
        solution: state.output.solutionSteps.elementAt(state.stepNumber).currentSolution,
        highlightedBoxes: state.solverSettings.highlightNewFilledBoxes
            ? state.output.solutionSteps.elementAt(state.stepNumber).newFilledBoxes
            : <int>[],
      ),
    );
  }

  /// Builds the information box widget.
  ///
  /// The [context] parameter is used to get the [NonogramSolverCubit].
  /// The [state] parameter provides the current state of the Nonogram solver.
  ConstrainedBox buildInfoBox(BuildContext context, NonogramSolverState state) {
    final NonogramSolverCubit nonogramSolverCubit = context.read<NonogramSolverCubit>();
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: AppTheme.maxInfoBoxWidth),
      child: Column(
        children: <Widget>[
          NonogramTitle(nonogram: nonogram, showDescription: false),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: state.solverStatus.isSolving || state.output.solutionSteps.length > 1
                      ? null
                      : () => nonogramSolverCubit.solvePuzzle(),
                  child: const Text('SOLVE'),
                ),
              ),
              IconButton(
                onPressed: state.solverStatus.isCompleted ? nonogramSolverCubit.resetPuzzle : null,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: state.solverStatus.isCompleted && state.stepNumber > 0
                    ? () => nonogramSolverCubit.updateStepNumber(state.stepNumber - 1)
                    : null,
                icon: const Icon(Icons.arrow_back_ios_new_sharp),
              ),
              Expanded(
                child: Slider(
                  value: state.stepNumber + 0.0,
                  max: state.output.solutionSteps.length - 1,
                  divisions: state.output.solutionSteps.length,
                  onChanged: state.solverStatus.isCompleted
                      ? (double value) => nonogramSolverCubit.updateStepNumber(value.ceil())
                      : null,
                ),
              ),
              IconButton(
                onPressed: state.solverStatus.isCompleted && state.stepNumber < state.output.solutionSteps.length - 1
                    ? () => nonogramSolverCubit.updateStepNumber(state.stepNumber + 1)
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
          Text('Puzzle duration: ${state.dateTimeDifference}'),
          Text('Total steps: ${state.output.solutionSteps.length}'),
          Text('Lines checked: ${state.output.linesChecked}'),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: state.solverSettings.countCheckedBoxes ? 1 : 0.4,
            child: Column(
              children: <Widget>[
                Text('Boxes checked: ${state.output.boxesChecked}'),
                Text('Other boxes checked: ${state.output.otherBoxesChecked}'),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: state.solverSettings.keepCacheData ? 1 : 0.4,
            child: Text('Total cache data: ${state.output.totalCacheData}'),
          ),
          const SizedBox(height: 24),
          const Text('--Settings--'),
          Row(
            children: <Widget>[
              Switch(
                value: state.solverSettings.keepCacheData,
                onChanged: state.solverStatus.canEdit ? (_) => nonogramSolverCubit.updateKeepCacheData() : null,
              ),
              const Text('Keep cache data of box solutions'),
            ],
          ),
          Row(
            children: <Widget>[
              Switch(
                value: state.solverSettings.countCheckedBoxes,
                onChanged: state.solverStatus.canEdit ? (_) => nonogramSolverCubit.updateCountCheckedBoxes() : null,
              ),
              const Text('Count box checks'),
            ],
          ),
          Row(
            children: <Widget>[
              const Text('Isolate concurrent: '),
              IconButton(
                onPressed: state.solverSettings.isolateConcurrent == 1
                    ? null
                    : () => nonogramSolverCubit.updateIsolateConcurrent(state.solverSettings.isolateConcurrent - 1),
                icon: const Icon(Icons.remove),
              ),
              Text(state.solverSettings.isolateConcurrent.toString()),
              IconButton(
                onPressed: state.solverStatus.canEdit
                    ? () => nonogramSolverCubit.updateIsolateConcurrent(state.solverSettings.isolateConcurrent + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('--Graphics--'),
          Row(
            children: <Widget>[
              Switch(
                value: state.solverSettings.highlightNewFilledBoxes,
                onChanged: (_) => nonogramSolverCubit.updateHighlightNewFilledBoxes(),
              ),
              const Text('Show new values with highlighted color'),
            ],
          ),
        ],
      ),
    );
  }
}
