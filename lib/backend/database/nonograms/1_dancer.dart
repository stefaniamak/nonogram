import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kDancer = Nonogram(
  (NonogramBuilder n) => n
    ..id = "1"
    ..info = NonogramInfo(
      (NonogramInfoBuilder i) => i
        ..title = "Dancer"
        ..copyright = "(c) Copyright 2004 by Jan Wolter"
        ..author = "Jan Wolter"
        ..authorId = "jan"
        ..description = "A stick figure man, dancing his stickly little heart out.",
    ).toBuilder()
    ..note = "published,definitely unique,definitely line/color solvable"
    ..clues = Clues(
      (CluesBuilder c) => c
        ..columns = ListBuilder([
          <int>[2, 1],
          <int>[2, 1, 3],
          <int>[7],
          <int>[1, 3],
          <int>[2, 1],
        ])
        ..rows = ListBuilder([
          <int>[2],
          <int>[2, 1],
          <int>[1, 1],
          <int>[3],
          <int>[1, 1],
          <int>[1, 1],
          <int>[2],
          <int>[1, 1],
          <int>[1, 2],
          <int>[2],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution(
        (SolutionBuilder s) => s
          ..type = SolutionType.goal
          ..solution = "01100011010010101110101001010000110010100101111000"
          ..image = '''
|.XX..|
|.XX.X|
|..X.X|
|.XXX.|
|X.X..|
|X.X..|
|..XX.|
|.X.X.|
|.X.XX|
|XX...|''',
      ),
    ]),
);
