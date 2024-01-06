import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

enum PointState { unknown, filled, cross }

class NonogramState {
  final Nonogram nonogram;
  final String activeSolution;

  final Function(int row, int col) setFilled;
  final Function(int row, int col) setCross;
  final Function(int row, int col) setUnknown;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.setFilled,
    required this.setCross,
    required this.setUnknown,
  });
}

NonogramState useNonogramState(Nonogram nonogram) {
  final activeSolution$ = useState(
    // Initialization code made inspired from https://stackoverflow.com/a/61929967
    Iterable.generate(nonogram.height * nonogram.width, (_) => '?').join(),
    // '123456789',
  );

  final setFilled = useCallback((int row, int col) {
    // print('activeSolution\$.value before: ${activeSolution$.value}');
    activeSolution$.value =
        activeSolution$.value.replaceRange(row, row + 1, '1');
    // print('activeSolution\$.value after : ${activeSolution$.value}');
  }, []);
  final setCross = useCallback(
      (int row, int col) => activeSolution$.value.replaceRange(1, 1, '0'));
  final serUnknown = useCallback(
      (int row, int col) => activeSolution$.value.replaceRange(1, 1, '?'));

  return NonogramState(
    nonogram: nonogram,
    activeSolution: activeSolution$.value,
    setFilled: setFilled,
    setCross: setCross,
    setUnknown: serUnknown,
  );
}
