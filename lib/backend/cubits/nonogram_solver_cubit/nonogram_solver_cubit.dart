import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/isolate/solver_settings.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/solver/line_solver_isolate.dart';

part 'nonogram_solver_state.dart';

class NonogramSolverCubit extends Cubit<NonogramSolverState> {
  NonogramSolverCubit() : super(const NonogramSolverState());

  Future<void> initialize({required IsolateNonogram nonogram}) async {
    updateNonogram(nonogram);
    resetPuzzle();
  }

  void resetPuzzle() {
    emit(
      state.copyWith(
        solverStatus: SolverStatus.initial,
        solutionSteps: [
          SolutionStep(
            currentSolution: state.nonogram!.emptySolution,
            explanation: 'Empty nonogram',
          ),
        ],
        stack: initializeStackList(state.nonogram!.clues),
        stepNumber: 0,
        linesChecked: 0,
        boxesChecked: 0,
        otherBoxesChecked: 0,
        startDateTime: null,
        endingDateTime: null,
        cachedBoxSolutions: {},
      ),
    );
  }

  void solvePuzzle() async {
    emit(state.copyWith(solverStatus: SolverStatus.solving));

    final isolateManager = IsolateManager.createCustom(
      lineSolverIsolate,
      workerName: 'lineSolverIsolate',
      // isDebug: kDebugMode,
      // concurrent: 4,
    );

    print('state.keepCacheData: ${state.solverSettings.keepCacheData}');

    // Get the result.
    final result = await isolateManager.compute(
      jsonEncode(IsolateInput(
        solutionSteps: state.solutionSteps,
        nonogram: state.nonogram!,
        solverSettings: state.solverSettings,
      ).toJson()),
      callback: (value) {
        // Condition to recognize the progress value. Ex:
        final data = jsonDecode(value);

        if (data.containsKey('progress')) {
          // print('This is a progress value: ${data['progress']}');

          IsolateOutput progress = IsolateOutput.fromJson(data['progress']);

          // Return `false` to mark this value is not the final.a
          // print('progress.solutionSteps.last: ${progress.solutionSteps.last.currentSolution}');
          addSolutionSteps([progress.solutionSteps.last]);
          updateStepNumber(state.solutionSteps.length - 1);
          updateCachedBoxSolutions(progress.cachedBoxSolutions);
          return false;
        }

        // print('This is a final value: ${data['result']}');

        IsolateOutput result = IsolateOutput.fromJson(data['result']);

        addSolutionSteps([result.solutionSteps.last]);
        updateStepNumber(state.solutionSteps.length - 1);
        updateCachedBoxSolutions(result.cachedBoxSolutions);

        // Return `true` to mark this value is the final.

        emit(state.copyWith(solverStatus: SolverStatus.solved));
        return true;
      },
    );

    updateStepNumber(state.solutionSteps.length - 1);
    print(result); // 100
  }

  void updateNonogram(IsolateNonogram nonogram) {
    emit(state.copyWith(nonogram: nonogram));
  }

  void updateStepNumber(int index) {
    emit(state.copyWith(stepNumber: index));
  }

  void updateGroupSteps() {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(groupSteps: !state.solverSettings.groupSteps)));
  }

  void updateKeepCacheData() {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(keepCacheData: !state.solverSettings.keepCacheData)));
  }

  void updateCountCheckedBoxes() {
    emit(state.copyWith(
        solverSettings: state.solverSettings.copyWith(countCheckedBoxes: !state.solverSettings.countCheckedBoxes)));
  }

  void updateCachedBoxSolutions(Map<String, bool> cacheData) {
    Map<String, bool> tempCache = state.cachedBoxSolutions;
    tempCache.addAll(cacheData);
    emit(state.copyWith(cachedBoxSolutions: tempCache));
  }

  void addSolutionSteps(List<SolutionStep> solutionStep) {
    List<SolutionStep> tempStep = state.solutionSteps;
    tempStep.addAll(solutionStep);
    emit(state.copyWith(solutionSteps: tempStep));
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
}
