import 'package:bloc/bloc.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'nonogram_solver_state.dart';

class NonogramSolverCubit extends Cubit<NonogramSolverState> {
  NonogramSolverCubit() : super(const NonogramSolverState());

  Future<void> initialize({required IsolateNonogram nonogram}) async {
    updateNonogram(nonogram);
    resetPuzzle();
  }

  void resetPuzzle() {
    initializeStackList(state.nonogram!.clues);
    _resetSolutionSteps();
    // addSolutionSteps([SolutionStep(currentSolution: state.nonogram!.emptySolution, explanation: 'Empty nonogram')]);
    addSolutionSteps([
      SolutionStep(
        currentSolution: Iterable.generate(state.nonogram!.height * state.nonogram!.width, (_) => '?').join(),
        explanation: 'Empty nonogram',
      )
    ]);
    _resetStepNumber();
    _resetLinesChecked();
    _resetBoxesChecked();
    _resetOtherBoxesChecked();
    _resetStartDateTime();
    _resetEndingDateTime();
    _resetCachedBoxSolutions();
  }

  void updateNonogram(IsolateNonogram nonogram) {
    emit(state.copyWith(nonogram: nonogram));
  }

  void updateStepNumber(int index) {
    emit(state.copyWith(stepNumber: index));
  }

  void updateGroupSteps() {
    emit(state.copyWith(groupSteps: !state.groupSteps));
  }

  void updateKeepCacheData() {
    emit(state.copyWith(keepCacheData: !state.keepCacheData));
  }

  void updateCountCheckedBoxes() {
    emit(state.copyWith(countCheckedBoxes: !state.countCheckedBoxes));
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

  void _resetSolutionSteps() {
    emit(state.copyWith(solutionSteps: []));
  }

  void _resetStepNumber() {
    emit(state.copyWith(stepNumber: 0));
  }

  void _resetLinesChecked() {
    emit(state.copyWith(linesChecked: 0));
  }

  void _resetBoxesChecked() {
    emit(state.copyWith(boxesChecked: 0));
  }

  void _resetOtherBoxesChecked() {
    emit(state.copyWith(otherBoxesChecked: 0));
  }

  void _resetStartDateTime() {
    emit(state.copyWith(startDateTime: null));
  }

  void _resetEndingDateTime() {
    emit(state.copyWith(endingDateTime: null));
  }

  void _resetCachedBoxSolutions() {
    emit(state.copyWith(cachedBoxSolutions: {}));
  }
}
