import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/models/solution_type.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

enum PointState { unknown, filled, cross }

class NonogramState {
  final Nonogram nonogram;
  final Solution activeSolution;
  final List<SolutionStep> solutionSteps;
  final int stepNumber;
  final List<Map<int, NonoAxis>> stack;

  final Function(int index) setFilled;
  final Function(int index) setCross;
  final Function(int index) setUnknown;
  final Function(SolutionStep index) addStep;
  final Function(int index) increaseStepNumber;
  final Function(int index) decreaseStepNumber;
  final Function(Map<int, NonoAxis> line) pushStack;
  final VoidCallback popStack;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.solutionSteps,
    required this.stack,
    required this.setFilled,
    required this.setCross,
    required this.setUnknown,
    required this.addStep,
    required this.stepNumber,
    required this.increaseStepNumber,
    required this.decreaseStepNumber,
    required this.pushStack,
    required this.popStack,
  });
}

String getUpdatedActiveSolution(String activeSol, int index, String char) =>
    activeSol.replaceRange(index, index + 1, char);

NonogramState useNonogramState(Nonogram nonogram) {
  final activeSolution$ = useState(
    // Initialization code made inspired from https://stackoverflow.com/a/61929967
    Iterable.generate(nonogram.height * nonogram.width, (_) => '?').join(),
    // '123456789zxcvbnmasdfghjklqwertyuiop1234567890qwert',
  );

  final stack$ = useState(
    initializeStepsList(nonogram.clues!),
  );

  final ValueNotifier<List<SolutionStep>> solutionSteps$ = useState(
    <SolutionStep>[SolutionStep(currentSolution: activeSolution$.value, explanation: 'Initial nonogram')],
  );

  final stepNumber$ = useState(0);

  final setFilled = useCallback(
      (int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '1'),
      [activeSolution$.value]);
  final setCross = useCallback(
      (int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '0'),
      [activeSolution$.value]);
  final serUnknown = useCallback(
      (int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '?'),
      [activeSolution$.value]);

  final increaseStepNumber = useCallback((int index) {
    print('new value $index');
    stepNumber$.value = index;
    print('stepNumber.value: ${stepNumber$.value}');
  });
  final decreaseStepNumber = useCallback((int index) => stepNumber$.value--, [stepNumber$.value]);

  final addStep = useCallback((SolutionStep step) => solutionSteps$.value.add(step));
  final pushStack = useCallback((Map<int, NonoAxis> line) => stack$.value.add(line));
  final popStack = useCallback(() => stack$.value.removeAt(0));

  return NonogramState(
    nonogram: nonogram,
    activeSolution: Solution((s) => s
      ..type = SolutionType.saved
      ..solution = activeSolution$.value),
    solutionSteps: solutionSteps$.value,
    setFilled: setFilled,
    setCross: setCross,
    setUnknown: serUnknown,
    addStep: addStep,
    increaseStepNumber: increaseStepNumber,
    decreaseStepNumber: decreaseStepNumber,
    stepNumber: stepNumber$.value,
    stack: stack$.value,
    pushStack: pushStack,
    popStack: popStack,
  );
}

List<Map<int, NonoAxis>> initializeStepsList(Clues clues) {
  List<Map<int, NonoAxis>> lineStack = [];

  for (int i = 0; i < clues.rows.length; i++) {
    lineStack.add({i: NonoAxis.row});
  }

  for (int i = 0; i < clues.columns.length; i++) {
    lineStack.add({i: NonoAxis.column});
  }

  return lineStack;
}
