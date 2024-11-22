import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kCat = Nonogram(
  (NonogramBuilder n) => n
    ..id = "2"
    ..info = NonogramInfo(
      (NonogramInfoBuilder i) => i
        ..title = "Cat"
        ..copyright = "(c) Copyright 2004 by Jan Wolter"
        ..author = "Jan Wolter"
        ..authorId = "jan"
        ..description = "My five year old son was able to tell that this was a dog.",
    ).toBuilder()
    ..note = "published,definitely unique,definitely line/color solvable"
    ..clues = Clues(
      (CluesBuilder c) => c
        ..columns = ListBuilder([
          <int>[1, 1],
          <int>[5],
          <int>[3],
          <int>[2],
          <int>[2],
          <int>[8],
          <int>[2, 1],
          <int>[1, 1],
        ])
        ..rows = ListBuilder([
          <int>[1],
          <int>[2],
          <int>[1, 3],
          <int>[5],
          <int>[5],
          <int>[2, 2],
          <int>[2, 1, 1],
          <int>[1, 1],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution(
        (SolutionBuilder s) => s
          ..type = SolutionType.goal
          // ..solution = "01100011010010101110101001010000110010100101111000"
          ..image = '''
|.....X..|
|.....XX.|
|X....XXX|
|.XXXXX..|
|.XXXXX..|
|.XX..XX.|
|XX...X.X|
|.X...X..|''',
      ),
    ]),
);
