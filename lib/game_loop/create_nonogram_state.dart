import 'package:built_collection/built_collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';

import 'nonogram_state.dart';

class CreateNonogramState {
  final Nonogram nonogram;
  final int width;
  final int height;
  final List<List<int>> horizontalClues;
  final List<List<int>> verticalClues;
  final Function(int width) updateWidth;
  final Function(int height) updateHeight;
  final Function(int index, PointState pointState) updateSolution;
  // final Function(Clues clues) updateClues;
  final String solution;

  CreateNonogramState({
    required this.nonogram,
    required this.width,
    required this.height,
    required this.horizontalClues,
    required this.verticalClues,
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
    horizontalClues$.value = List<List<int>>.generate(width$.value, (_) => <int>[0]);
  });

  final updateHeight = useCallback((int index) {
    height$.value = index;
    verticalClues$.value = List<List<int>>.generate(height$.value, (_) => <int>[0]);
  });

  final updateSolution = useCallback((int index, PointState pointState) {
    height$.value = index;
  });

  final updateNonogram = useCallback(() {
    nonogram$.value = Nonogram((n) => n
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
      ).toBuilder());

    //     .rebuild(
    //   (p0) => p0
    //     ..id = "test"
    //     // ..info = NonogramInfo((i) => i
    //     //   ..title = "Dancer"
    //     //   ..copyright = "(c) Copyright 2004 by Jan Wolter"
    //     //   ..author = "Jan Wolter"
    //     //   ..authorId = "jan"
    //     //   ..description = "A stick figure man, dancing his stickly little heart out.").toBuilder()
    //     // ..note = "published,definitely unique,definitely line/color solvable"
    //     ..clues = Clues(
    //       (c) => c
    //         ..columns = ListBuilder(verticalClues$.value)
    //         ..rows = ListBuilder(horizontalClues$.value),
    //     ).toBuilder(),
    // );
  }, [width$.value, height$.value, verticalClues$.value, horizontalClues$.value]);

  // final updateClues = useCallback((NonoAxis axis, int index, List<>) {
  //   height$.value = index;
  // });

  return CreateNonogramState(
    nonogram: nonogram$.value,
    width: width$.value,
    height: height$.value,
    horizontalClues: horizontalClues$.value,
    verticalClues: verticalClues$.value,
    updateWidth: updateWidth,
    updateHeight: updateHeight,
    updateSolution: updateSolution,
    // updateClues: updateClues,
    solution: solution$.value,
  );
}
