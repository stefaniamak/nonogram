import 'dart:math';
import 'dart:ui';

import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/pages/game/home_page.dart';

class NonogramState {
  final Nonogram nonogram;
  final Map<Point, PointState> activeSolution;

  final VoidCallback setFilled;

  NonogramState({
    required this.nonogram,
    required this.activeSolution,
    required this.setFilled,
  });
}

NonogramState useNonogramState(Nonogram nonogram) {
  return NonogramState(
    nonogram: nonogram,
    activeSolution: {
      Point(0, 0): PointState.cross,
      Point(0, 2): PointState.cross,
      Point(1, 1): PointState.filled,
      Point(2, 2): PointState.filled,
    },
    setFilled: () {},
  );
}
