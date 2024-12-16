import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/models/solver_settings.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';
import 'package:nonogram/config/enums/solver_status.dart';
import 'package:nonogram/config/nullable.dart';
import 'package:nonogram/solver/line_solver_isolate.dart';

part 'nonogram_solver_state.dart';

/// A Cubit that manages the state of the Nonogram solver.
class NonogramSolverCubit extends Cubit<NonogramSolverState> {
  /// Creates an instance of [NonogramSolverCubit] with the initial state.
  NonogramSolverCubit() : super(const NonogramSolverState());

  /// Initializes the Nonogram solver with the given [nonogram].
  ///
  /// This method updates the Nonogram and resets the puzzle.
  ///
  /// [nonogram]: The Nonogram to be solved.
  Future<void> initialize({required Nonogram nonogram}) async {
    updateNonogram(nonogram);
    resetPuzzle();
  }

  /// Resets the puzzle to its initial state.
  ///
  /// This method emits a new state with the initial solver status and resets
  /// various parameters such as step number, start and end date times, and output.
  void resetPuzzle() {
    emit(
      state.copyWith(
        solverStatus: SolverStatus.initial,
        stepNumber: 0,
        startDateTime: Nullable<DateTime>(null),
        endDateTime: Nullable<DateTime>(null),
        output: state.output.copyWith(
          stack: initializeStackList(state.nonogram!.clues),
          linesCheckedList: <int>[0],
          boxesCheckedList: <int>[0],
          otherBoxesCheckedList: <int>[0],
          linesChecked: 0,
          boxesChecked: 0,
          otherBoxesChecked: 0,
          totalCacheData: 0,
          cachedBoxSolutions: <String, bool>{},
          solutionSteps: <SolutionStep>[
            SolutionStep(
              currentSolution: state.nonogram!.emptySolution,
              explanation: 'Empty nonogram',
              newFilledBoxes: <int>[],
            ),
          ],
        ),
      ),
    );
  }

  /// Solves the Nonogram puzzle.
  ///
  /// This method emits a new state indicating the solver is in progress,
  /// initializes an isolate manager, and processes the solution steps.
  Future<void> solvePuzzle() async {
    emit(state.copyWith(
      solverStatus: SolverStatus.solving,
      startDateTime: Nullable<DateTime>(DateTime.now()),
    ));

    final IsolateManager<dynamic, dynamic> isolateManager = IsolateManager<dynamic, dynamic>.createCustom(
      lineSolverIsolate,
      workerName: 'lineSolverIsolate',
      concurrent: state.solverSettings.isolateConcurrent,
    );

    await isolateManager.compute(
      jsonEncode(IsolateInput(
        solutionSteps: state.output.solutionSteps,
        nonogram: state.nonogram!,
        solverSettings: state.solverSettings,
      ).toJson()),
      callback: (dynamic value) {
        final Map<String, dynamic> data = jsonDecode(value);

        if (data.containsKey('progress')) {
          final IsolateOutput progress = IsolateOutput.fromJson(data['progress']);
          updateSolutionOutput(progress);
          updateStepNumber(state.output.solutionSteps.length - 1);
          // Return `false` to mark this value is not the final.
          return false;
        }

        final IsolateOutput result = IsolateOutput.fromJson(data['result']);
        updateSolutionOutput(result);
        updateStepNumber(state.output.solutionSteps.length - 1);
        emit(state.copyWith(solverStatus: SolverStatus.solved));
        // Return `true` to mark this value is the final.
        return true;
      },
    );

    updateStepNumber(state.output.solutionSteps.length - 1);
    emit(
      state.copyWith(
        solverStatus: SolverStatus.solved,
        endDateTime: Nullable<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Updates the solution output with the given [output].
  ///
  /// [output]: The new solution output to be updated.
  void updateSolutionOutput(IsolateOutput output) {
    emit(state.copyWith(
      output: state.output.copyWith(
        stack: output.stack,
        solutionSteps: state.output.solutionSteps + output.solutionSteps,
        cachedBoxSolutions: output.cachedBoxSolutions,
        linesChecked: output.linesChecked,
        boxesChecked: output.boxesChecked,
        otherBoxesChecked: output.otherBoxesChecked,
        totalCacheData: output.totalCacheData,
      ),
    ));
  }

  /// Updates the Nonogram with the given [nonogram].
  ///
  /// [nonogram]: The new Nonogram to be updated.
  void updateNonogram(Nonogram nonogram) {
    emit(state.copyWith(nonogram: nonogram));
  }

  /// Updates the step number with the given [index].
  ///
  /// [index]: The new step number to be updated.
  void updateStepNumber(int index) {
    emit(state.copyWith(stepNumber: index));
  }

  /// Updates the isolate concurrency setting with the given [index].
  ///
  /// [index]: The new concurrency setting to be updated.
  void updateIsolateConcurrent(int index) {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(isolateConcurrent: index)));
  }

  /// Toggles the group steps setting.
  void updateGroupSteps() {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(groupSteps: !state.solverSettings.groupSteps)));
  }

  /// Toggles the highlight new filled boxes setting.
  void updateHighlightNewFilledBoxes() {
    emit(
      state.copyWith(
        solverSettings: state.solverSettings.copyWith(highlightNewFilledBoxes: !state.solverSettings.highlightNewFilledBoxes),
      ),
    );
  }

  /// Toggles the keep cache data setting.
  void updateKeepCacheData() {
    emit(state.copyWith(solverSettings: state.solverSettings.copyWith(keepCacheData: !state.solverSettings.keepCacheData)));
  }

  /// Toggles the count checked boxes setting.
  void updateCountCheckedBoxes() {
    emit(
      state.copyWith(
        solverSettings: state.solverSettings.copyWith(countCheckedBoxes: !state.solverSettings.countCheckedBoxes),
      ),
    );
  }

  /// Updates the cached box solutions with the given [cacheData].
  ///
  /// [cacheData]: The new cache data to be added.
  void updateCachedBoxSolutions(Map<String, bool> cacheData) {
    final Map<String, bool> tempCache = state.output.cachedBoxSolutions..addAll(cacheData);
    emit(state.copyWith(output: state.output.copyWith(cachedBoxSolutions: tempCache)));
  }

  /// Updates the lines checked list with the given [linesChecked].
  ///
  /// [linesChecked]: The new lines checked to be added.
  void updateLinesChecked(List<int> linesChecked) {
    final List<int> tempCache = state.output.linesCheckedList..addAll(linesChecked);
    emit(state.copyWith(output: state.output.copyWith(linesCheckedList: tempCache)));
  }

  /// Updates the boxes checked list with the given [boxesChecked].
  ///
  /// [boxesChecked]: The new boxes checked to be added.
  void updateBoxesChecked(List<int> boxesChecked) {
    final List<int> tempCache = state.output.boxesCheckedList..addAll(boxesChecked);
    emit(state.copyWith(output: state.output.copyWith(boxesCheckedList: tempCache)));
  }

  /// Updates the other boxes checked list with the given [otherBoxesChecked].
  ///
  /// [otherBoxesChecked]: The new other boxes checked to be added.
  void updateOtherBoxesChecked(List<int> otherBoxesChecked) {
    final List<int> tempCache = state.output.otherBoxesCheckedList..addAll(otherBoxesChecked);
    emit(state.copyWith(output: state.output.copyWith(otherBoxesCheckedList: tempCache)));
  }

  /// Adds the given solution steps to the current solution steps.
  ///
  /// [solutionSteps]: The new solution steps to be added.
  void addSolutionSteps(List<SolutionStep> solutionSteps) {
    final List<SolutionStep> tempStep = state.output.solutionSteps..addAll(solutionSteps);
    emit(state.copyWith(output: state.output.copyWith(solutionSteps: tempStep)));
  }

  /// Initializes the stack list with the given [clues].
  ///
  /// [clues]: The clues to initialize the stack list.
  ///
  /// Returns a list of maps representing the stack list.
  List<Map<int, NonoAxis>> initializeStackList(Clues clues) {
    final List<Map<int, NonoAxis>> lineStack = <Map<int, NonoAxis>>[];

    for (int i = 0; i < clues.rows.length; i++) {
      lineStack.add(<int, NonoAxis>{i: NonoAxis.row});
    }

    for (int i = 0; i < clues.columns.length; i++) {
      lineStack.add(<int, NonoAxis>{i: NonoAxis.column});
    }

    return lineStack;
  }
}
