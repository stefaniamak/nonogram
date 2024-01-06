import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

enum PointState { unknown, filled, cross }

class NonogramState {
  final Nonogram nonogram;
  final String activeSolution;

  final Function(int index) setFilled;
  final Function(int index) setCross;
  final Function(int index) setUnknown;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.setFilled,
    required this.setCross,
    required this.setUnknown,
  });
}

String getUpdatedActiveSolution(String activeSol, int index, String char) =>
    activeSol.replaceRange(index, index + 1, char);

NonogramState useNonogramState(Nonogram nonogram) {
  final activeSolution$ = useState(
    // Initialization code made inspired from https://stackoverflow.com/a/61929967
    Iterable.generate(nonogram.height * nonogram.width, (_) => '?').join(),
    // '123456789',
  );

  final setFilled = useCallback((int index) => activeSolution$.value =
      getUpdatedActiveSolution(activeSolution$.value, index, '1'));
  final setCross = useCallback((int index) => activeSolution$.value =
      getUpdatedActiveSolution(activeSolution$.value, index, '0'));
  final serUnknown = useCallback((int index) => activeSolution$.value =
      getUpdatedActiveSolution(activeSolution$.value, index, '?'));

  return NonogramState(
    nonogram: nonogram,
    activeSolution: activeSolution$.value,
    setFilled: setFilled,
    setCross: setCross,
    setUnknown: serUnknown,
  );
}
