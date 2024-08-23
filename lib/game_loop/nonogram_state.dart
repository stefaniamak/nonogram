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
  final Function(int index) updateStepNumber;
  final Function(List<Map<int, NonoAxis>> line) pushStack;
  final Function(Map<int, NonoAxis> line) bumpToStack;
  final VoidCallback popStack;
  final DateTime? startDateTime;
  final DateTime? endingDateTime;
  final Function(DateTime dateTime) updateStartingDateTime;
  final Function(DateTime dateTime) updateEndingDateTime;
  final int linesChecked;
  final int boxesChecked;
  final int actualBoxesChecked;
  final int otherBoxesChecked;
  final Function() updateLinesChecked;
  final Function() updateBoxesChecked;
  final Function() updateActualBoxesChecked;
  final Function() updateOtherBoxesChecked;
  final Map<String, bool> cachedBoxSolutions;
  final Function(List<int> clues, int clueIndex, String solution, int solutionIndex, bool value) updateCachedBoxSolutions;

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
    required this.updateStepNumber,
    required this.pushStack,
    required this.bumpToStack,
    required this.popStack,
    required this.startDateTime,
    required this.endingDateTime,
    required this.updateStartingDateTime,
    required this.updateEndingDateTime,
    required this.linesChecked,
    required this.boxesChecked,
    required this.actualBoxesChecked,
    required this.otherBoxesChecked,
    required this.updateLinesChecked,
    required this.updateBoxesChecked,
    required this.updateActualBoxesChecked,
    required this.updateOtherBoxesChecked,
    required this.cachedBoxSolutions,
    required this.updateCachedBoxSolutions,
  });
}

String getUpdatedActiveSolution(String activeSol, int index, String char) => activeSol.replaceRange(index, index + 1, char);

NonogramState useNonogramState(Nonogram nonogram) {
  final activeSolution$ = useState(
    // Initialization code made inspired from https://stackoverflow.com/a/61929967
    Iterable.generate(nonogram.height * nonogram.width, (_) => '?').join(),
    // '123456789qwertyuiopasdfghjklzxcvbnmερτυθιοπασδφγηξκλζχψωβνμQWERTYUIOPASDFGHJKLZXCVBNM',
  );

  final stack$ = useState(
    initializeStepsList(nonogram.clues!),
  );

  final ValueNotifier<List<SolutionStep>> solutionSteps$ = useState(
    <SolutionStep>[SolutionStep(currentSolution: activeSolution$.value, explanation: 'Empty nonogram')],
  );

  final stepNumber$ = useState(0);
  final linesChecked$ = useState(0);
  final boxesChecked$ = useState(0);
  final actualBoxesChecked$ = useState(0);
  final otherBoxesChecked$ = useState(0);

  final setFilled = useCallback(
      (int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '1'),
      [activeSolution$.value]);
  final setCross = useCallback((int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '0'),
      [activeSolution$.value]);
  final serUnknown = useCallback(
      (int index) => activeSolution$.value = getUpdatedActiveSolution(activeSolution$.value, index, '?'),
      [activeSolution$.value]);

  final updateStepNumber = useCallback((int index) {
    stepNumber$.value = index;
  });
  final updateLinesChecked = useCallback(() {
    linesChecked$.value++;
  });
  final updateBoxesChecked = useCallback(() {
    boxesChecked$.value++;
  });
  final updateActualBoxesChecked = useCallback(() {
    actualBoxesChecked$.value++;
  });
  final updateOtherBoxesChecked = useCallback(() {
    otherBoxesChecked$.value++;
  });

  final startingDateTime$ = useState<DateTime?>(null);
  final endingDateTime$ = useState<DateTime?>(null);

  final updateStartingDateTime =
      useCallback((DateTime dateTime) => startingDateTime$.value = dateTime, [startingDateTime$.value]);
  final updateEndingDateTime = useCallback((DateTime dateTime) => endingDateTime$.value = dateTime, [endingDateTime$.value]);

  final addStep = useCallback((SolutionStep step) => solutionSteps$.value.add(step));
  final pushStack = useCallback((List<Map<int, NonoAxis>> lines) => stack$.value.addAll(lines));
  final bumpToStack = useCallback((Map<int, NonoAxis> line) {
    stack$.value.remove(line);
    stack$.value = [line, ...stack$.value];
  });
  final popStack = useCallback(() => stack$.value.removeAt(0));

  // Cache

  final ValueNotifier<Map<String, bool>> cachedBoxSolutions$ = useState<Map<String, bool>>({});
  final updateCachedBoxSolutions = useCallback((List<int> clues, int clueIndex, String solution, int solutionIndex, bool value) {
    // print('cachedBoxSolutions.value.length: ${cachedBoxSolutions$.value.length}');
    // if (cachedBoxSolutions$.value.length > 30000) {
    //   cachedBoxSolutions$.value = {};
    // }
    cachedBoxSolutions$.value['$clues,$clueIndex,$solution,$solutionIndex'] = value;
  });

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
    updateStepNumber: updateStepNumber,
    stepNumber: stepNumber$.value,
    stack: stack$.value,
    pushStack: pushStack,
    bumpToStack: bumpToStack,
    popStack: popStack,
    startDateTime: startingDateTime$.value,
    endingDateTime: endingDateTime$.value,
    updateStartingDateTime: updateStartingDateTime,
    updateEndingDateTime: updateEndingDateTime,
    linesChecked: linesChecked$.value,
    boxesChecked: boxesChecked$.value,
    actualBoxesChecked: actualBoxesChecked$.value,
    otherBoxesChecked: otherBoxesChecked$.value,
    updateLinesChecked: updateLinesChecked,
    updateBoxesChecked: updateBoxesChecked,
    updateActualBoxesChecked: updateActualBoxesChecked,
    updateOtherBoxesChecked: updateOtherBoxesChecked,
    cachedBoxSolutions: cachedBoxSolutions$.value,
    updateCachedBoxSolutions: updateCachedBoxSolutions,
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
