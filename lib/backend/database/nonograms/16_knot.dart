import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kKnot = Nonogram(
  (n) => n
    ..id = "3"
    ..info = NonogramInfo((i) => i
      ..title = "Probably Not"
      ..copyright = "(c) Copyright 2004 by Jan Wolter"
      ..author = "Jan Wolter"
      ..authorId = "jan"
      ..description = "A classic two loop Celtic Knot design.").toBuilder()
    ..note = "published,definitely unique,definitely line/color solvable"
    ..clues = Clues(
      (c) => c
        ..columns = ListBuilder([
          [1, 1],
          [2, 2],
          [3, 3],
          [2, 1, 1, 2],
          [2, 1, 1, 2],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [18],
          [2, 1, 1, 1, 1, 2],
          [1, 1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [26],
          [2, 1, 1, 1, 1, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [14, 14],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [14, 14],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 1, 1, 1, 1, 2],
          [26],
          [1, 1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [2, 1, 1, 1, 1, 2],
          [18],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [2, 1, 1, 2],
          [2, 1, 1, 2],
          [3, 3],
          [2, 2],
          [1, 1],
        ])
        ..rows = ListBuilder([
          [1, 1],
          [2, 2],
          [3, 3],
          [2, 1, 1, 2],
          [2, 1, 1, 2],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [18],
          [2, 1, 1, 1, 1, 2],
          [1, 1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [26],
          [2, 1, 1, 1, 1, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [14, 14],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [14, 14],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 2, 2, 1, 1, 2],
          [2, 1, 1, 1, 1, 1, 1, 2],
          [26],
          [1, 1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [2, 1, 1, 1, 1, 2],
          [18],
          [1, 1, 1, 1],
          [1, 1, 1, 1],
          [2, 1, 1, 2],
          [2, 1, 1, 2],
          [3, 3],
          [2, 2],
          [1, 1],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution((s) => s
        ..type = SolutionType.goal
        // ..solution = "01100011010010101110101001010000110010100101111000"
        ..image = '''|...............X..X...............|
|..............XX..XX..............|
|.............XXX..XXX.............|
|............XX.X..X.XX............|
|...........XX..X..X..XX...........|
|...........X...X..X...X...........|
|...........X...X..X...X...........|
|........XXXXXXXXXXXXXXXXXX........|
|.......XX..X...X..X...X..XX.......|
|.......X...X...X..X...X...X.......|
|.......X...X...X..X...X...X.......|
|....XXXXXXXXXXXXXXXXXXXXXXXXXX....|
|...XX..X...X...X..X...X...X..XX...|
|..XX...X...X..XX..XX..X...X...XX..|
|.XX....X...X.XX....XX.X...X....XX.|
|XXXXXXXXXXXXXX......XXXXXXXXXXXXXX|
|.......X...X..........X...X.......|
|.......X...X..........X...X.......|
|XXXXXXXXXXXXXX......XXXXXXXXXXXXXX|
|.XX....X...X.XX....XX.X...X....XX.|
|..XX...X...X..XX..XX..X...X...XX..|
|...XX..X...X...X..X...X...X..XX...|
|....XXXXXXXXXXXXXXXXXXXXXXXXXX....|
|.......X...X...X..X...X...X.......|
|.......X...X...X..X...X...X.......|
|.......XX..X...X..X...X..XX.......|
|........XXXXXXXXXXXXXXXXXX........|
|...........X...X..X...X...........|
|...........X...X..X...X...........|
|...........XX..X..X..XX...........|
|............XX.X..X.XX............|
|.............XXX..XXX.............|
|..............XX..XX..............|
|...............X..X...............|''')
    ]),
);
