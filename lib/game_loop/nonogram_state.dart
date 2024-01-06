import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

enum PointState { empty, filled, cross }

class NonogramState {
  final Nonogram nonogram;
  final String activeSolution;

  final Function(int row, int col) setFilled;
  final Function(int row, int col) setBlank;
  final Function(int row, int col) setEmpty;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.setFilled,
    required this.setBlank,
    required this.setEmpty,
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
    activeSolution$.value = activeSolution$.value.replaceRange(1, 2, '1');
    // print('activeSolution\$.value after : ${activeSolution$.value}');
  }, []);
  final setBlank = useCallback(
      (int row, int col) => activeSolution$.value.replaceRange(1, 1, '0'));
  final setEmpty = useCallback(
      (int row, int col) => activeSolution$.value.replaceRange(1, 1, '?'));

  return NonogramState(
    nonogram: nonogram,
    activeSolution: activeSolution$.value,
    setFilled: setFilled,
    setBlank: setBlank,
    setEmpty: setEmpty,
  );
}
