import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kDancer = Nonogram(
  (n) => n
    ..id = "#1 (v.1)"
    ..info = NonogramInfo((i) => i
          ..title = "Demo Puzzle from Front Page"
          ..copyright = "(c) Copyright 2004 by Jan Wolter"
          ..author = "Jan Wolter"
          ..authorId = "jan"
          ..description =
              "A stick figure man, dancing his stickly little heart out.")
        .toBuilder()
    ..note = "published,definitely unique,definitely line/color solvable"
    ..clues = Clues(
      (c) => c
        ..columns = ListBuilder([
          [2, 1],
          [2, 1, 3],
          [7],
          [1, 3],
          [2, 1],
        ])
        ..rows = ListBuilder([
          [2],
          [2, 1],
          [1, 1],
          [3],
          [1, 1],
          [1, 1],
          [2],
          [1, 1],
          [1, 2],
          [2],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution((s) => s
        ..type = SolutionType.goal
        ..solution = "01100011010010101110101001010000110010100101111000"
        ..image = '''|.XX..|
|.XX.X|
|..X.X|
|.XXX.|
|X.X..|
|X.X..|
|..XX.|
|.X.X.|
|.X.XX|
|XX...|''')
    ]),
);
