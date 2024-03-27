import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kCat = Nonogram(
  (n) => n
    ..id = "2"
    ..info = NonogramInfo((i) => i
      ..title = "Cat"
      ..copyright = "(c) Copyright 2004 by Jan Wolter"
      ..author = "Jan Wolter"
      ..authorId = "jan"
      ..description = "My five year old son was able to tell that this was a dog.").toBuilder()
    ..note = "published,definitely unique,definitely line/color solvable"
    ..clues = Clues(
      (c) => c
        ..columns = ListBuilder([
          [1, 1],
          [5],
          [3],
          [2],
          [2],
          [8],
          [2, 1],
          [1, 1],
        ])
        ..rows = ListBuilder([
          [1],
          [2],
          [1, 3],
          [5],
          [5],
          [2, 2],
          [2, 1, 1],
          [1, 1],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution((s) => s
        ..type = SolutionType.goal
        // ..solution = "01100011010010101110101001010000110010100101111000"
        ..image = '''|.....X..|
|.....XX.|
|X....XXX|
|.XXXXX..|
|.XXXXX..|
|.XX..XX.|
|XX...X.X|
|.X...X..|''')
    ]),
);
