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
        stepNumber: 0,
        startDateTime: null,
        endingDateTime: null,
        output: state.output.copyWith(
          stack: initializeStackList(state.nonogram!.clues),
          linesCheckedList: [0],
          boxesChecked: 0,
          otherBoxesChecked: 0,
          cachedBoxSolutions: {},
          solutionSteps: [
            SolutionStep(
              currentSolution: state.nonogram!.emptySolution,
              explanation: 'Empty nonogram',
            ),
          ],
        ),
      ),
    );
  }

  void solvePuzzle() async {
    emit(state.copyWith(
      solverStatus: SolverStatus.solving,
      startDateTime: DateTime.now(),
      endingDateTime: null,
    ));

    final isolateManager = IsolateManager.createCustom(
      lineSolverIsolate,
      workerName: 'lineSolverIsolate',
      // isDebug: kDebugMode,
      concurrent: state.solverSettings.isolateConcurrent,
    );

    print('state.keepCacheData: ${state.solverSettings.keepCacheData}');

    // Get the result.
    final result = await isolateManager.compute(
      jsonEncode(IsolateInput(
        solutionSteps: state.output.solutionSteps,
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
          updateStepNumber(state.output.solutionSteps.length - 1);
          updateCachedBoxSolutions(progress.cachedBoxSolutions);
          updateLinesChecked(progress.linesCheckedList);
          return false;
        }

        // print('This is a final value: ${data['result']}');

        IsolateOutput result = IsolateOutput.fromJson(data['result']);

        addSolutionSteps([result.solutionSteps.last]);
        updateStepNumber(state.output.solutionSteps.length - 1);
        updateCachedBoxSolutions(result.cachedBoxSolutions);
        updateLinesChecked(result.linesCheckedList);

        // Return `true` to mark this value is the final.

        emit(state.copyWith(solverStatus: SolverStatus.solved));
        return true;
      },
    );

    updateStepNumber(state.output.solutionSteps.length - 1);
    print(result); // 100

    emit(state.copyWith(
      solverStatus: SolverStatus.solved,
      endingDateTime: DateTime.now(),
    ));
  }

  void updateNonogram(IsolateNonogram nonogram) {
    emit(state.copyWith(nonogram: nonogram));
  }

  void updateStepNumber(int index) {
    emit(state.copyWith(stepNumber: index));
  }

  void updateIsolateConcurrent(int index) {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(isolateConcurrent: index)));
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
    Map<String, bool> tempCache = state.output.cachedBoxSolutions;
    tempCache.addAll(cacheData);
    emit(state.copyWith(output: state.output.copyWith(cachedBoxSolutions: tempCache)));
  }

  void updateLinesChecked(List<int> linesChecked) {
    List<int> tempCache = state.output.linesCheckedList;
    tempCache.addAll(linesChecked);
    emit(state.copyWith(output: state.output.copyWith(linesCheckedList: tempCache)));
  }

  void addSolutionSteps(List<SolutionStep> solutionStep) {
    List<SolutionStep> tempStep = state.output.solutionSteps;
    tempStep.addAll(solutionStep);
    emit(state.copyWith(output: state.output.copyWith(solutionSteps: tempStep)));
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
