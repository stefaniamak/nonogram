import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

import '../backend/models/nonogram_info.dart';
import 'nonogram_state.dart';

class CreateNonogramState {
  final Nonogram nonogram;
  final Function(int width) updateWidth;
  final Function(int height) updateHeight;
  final Function(int index, PointState pointState) updateSolution;
  // final Function(Clues clues) updateClues;
  final String solution;

  CreateNonogramState({
    required this.nonogram,
    required this.updateWidth,
    required this.updateHeight,
    required this.updateSolution,
    // required this.updateClues,
    required this.solution,
  });
}

CreateNonogramState useCreateNonogramState() {
  final width$ = useState(5);
  final height$ = useState(5);
  final verticalClues$ = useState([
    ...List<List<int>>.generate(height$.value, (_) => <int>[0]),
  ]);
  final horizontalClues$ = useState([
    ...List<List<int>>.generate(width$.value, (_) => <int>[0]),
  ]);
  final solution$ = useState(
    Iterable.generate(width$.value * height$.value, (_) => '?').join(),
  );
  final nonogram$ = useState(
    Nonogram((n) => n
      ..id = "test"
      // ..info = NonogramInfo((i) => i
      //   ..title = "Dancer"
      //   ..copyright = "(c) Copyright 2004 by Jan Wolter"
      //   ..author = "Jan Wolter"
      //   ..authorId = "jan"
      //   ..description = "A stick figure man, dancing his stickly little heart out.").toBuilder()
      // ..note = "published,definitely unique,definitely line/color solvable"
      ..clues = Clues(
        (c) => c
          ..columns = ListBuilder(verticalClues$.value)
          ..rows = ListBuilder(horizontalClues$.value),
      ).toBuilder()),
  );

  final updateWidth = useCallback((int index) {
    width$.value = index;
  });

  final updateHeight = useCallback((int index) {
    height$.value = index;
  });

  final updateSolution = useCallback((int index, PointState pointState) {
    height$.value = index;
  });

  // final updateClues = useCallback((NonoAxis axis, int index, List<>) {
  //   height$.value = index;
  // });

  return CreateNonogramState(
    nonogram: nonogram$.value,
    updateWidth: updateWidth,
    updateHeight: updateHeight,
    updateSolution: updateSolution,
    // updateClues: updateClues,
    solution: solution$.value,
  );
}
