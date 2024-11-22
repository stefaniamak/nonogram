import 'package:built_collection/built_collection.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/models/solution_type.dart';

final Nonogram kEdge = Nonogram(
  (NonogramBuilder n) => n
    ..id = "5"
    ..info = NonogramInfo(
      (NonogramInfoBuilder i) => i
        ..title = "Edge"
        ..copyright = "(c) Copyright 2004 by Jan Wolter"
        ..author = "Jan Wolter"
        ..authorId = "jan"
        ..description = "Two hats falling from a cloud?  No, just simple example of the usefulness of edges.",
    ).toBuilder()
    ..note = "published,definitely unique,definitely requires moderate lookahead"
    ..clues = Clues(
      (CluesBuilder c) => c
        ..columns = ListBuilder([
          <int>[1],
          <int>[3],
          <int>[1],
          <int>[2, 2],
          <int>[2],
          <int>[4],
          <int>[1],
          <int>[3],
          <int>[3],
          <int>[1],
        ])
        ..rows = ListBuilder([
          <int>[1],
          <int>[3],
          <int>[1],
          <int>[2],
          <int>[1],
          <int>[3],
          <int>[3],
          <int>[1],
          <int>[2],
          <int>[2],
          <int>[4],
        ]),
    ).toBuilder()
    ..solutions = ListBuilder([
      Solution(
        (SolutionBuilder s) => s
          ..type = SolutionType.goal
          // ..solution = "01100011010010101110101001010000110010100101111000"
          ..image = '''
|...X......|
|.XXX......|
|.X........|
|XX........|
|.....X....|
|...XXX....|
|...XXX....|
|.....X....|
|.......XX.|
|.......XX.|
|......XXXX|''',
      ),
    ]),
);
