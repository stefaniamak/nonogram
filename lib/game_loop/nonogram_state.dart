import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

enum PointState { empty, filled, cross }

class NonogramState {
  final Nonogram nonogram;
  final String activeSolution;

  final VoidCallback setFilled;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.setFilled,
  });
}

NonogramState useNonogramState(Nonogram nonogram) {
  final activeSolution$ = useState(
    // Initialization code made inspired from https://stackoverflow.com/a/61929967
    Iterable.generate(nonogram.height * nonogram.width, (_) => '?').join(),
  );

  return NonogramState(
    nonogram: nonogram,
    activeSolution: activeSolution$.value,
    setFilled: () {},
  );
}
