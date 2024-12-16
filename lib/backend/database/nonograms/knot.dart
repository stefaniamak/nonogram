import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/nonogram/nonogram_info.dart';

/// A constant representing a nonogram puzzle of a dancer.
const Nonogram kKnot = Nonogram(
  id: "3",
  info: NonogramInfo(
    title: "Probably Not",
    copyright: "(c) Copyright 2004 by Jan Wolter",
    author: "Jan Wolter",
    authorId: "jan",
    description: "A classic two loop Celtic Knot design.",
  ),
  note: "published,definitely unique,definitely line/color solvable",
  clues: Clues(
    columns: <List<int>>[
      <int>[1, 1],
      <int>[2, 2],
      <int>[3, 3],
      <int>[2, 1, 1, 2],
      <int>[2, 1, 1, 2],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[18],
      <int>[2, 1, 1, 1, 1, 2],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[26],
      <int>[2, 1, 1, 1, 1, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[14, 14],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[14, 14],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 1, 1, 1, 1, 2],
      <int>[26],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[2, 1, 1, 1, 1, 2],
      <int>[18],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[2, 1, 1, 2],
      <int>[2, 1, 1, 2],
      <int>[3, 3],
      <int>[2, 2],
      <int>[1, 1],
    ],
    rows: <List<int>>[
      <int>[1, 1],
      <int>[2, 2],
      <int>[3, 3],
      <int>[2, 1, 1, 2],
      <int>[2, 1, 1, 2],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[18],
      <int>[2, 1, 1, 1, 1, 2],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[26],
      <int>[2, 1, 1, 1, 1, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[14, 14],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[14, 14],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 2, 2, 1, 1, 2],
      <int>[2, 1, 1, 1, 1, 1, 1, 2],
      <int>[26],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[1, 1, 1, 1, 1, 1],
      <int>[2, 1, 1, 1, 1, 2],
      <int>[18],
      <int>[1, 1, 1, 1],
      <int>[1, 1, 1, 1],
      <int>[2, 1, 1, 2],
      <int>[2, 1, 1, 2],
      <int>[3, 3],
      <int>[2, 2],
      <int>[1, 1],
    ],
  ),
);

/// Solution:
/// 01100011010010101110101001010000110010100101111000
/// |...............X..X...............|
/// |..............XX..XX..............|
/// |.............XXX..XXX.............|
/// |............XX.X..X.XX............|
/// |...........XX..X..X..XX...........|
/// |...........X...X..X...X...........|
/// |...........X...X..X...X...........|
/// |........XXXXXXXXXXXXXXXXXX........|
/// |.......XX..X...X..X...X..XX.......|
/// |.......X...X...X..X...X...X.......|
/// |.......X...X...X..X...X...X.......|
/// |....XXXXXXXXXXXXXXXXXXXXXXXXXX....|
/// |...XX..X...X...X..X...X...X..XX...|
/// |..XX...X...X..XX..XX..X...X...XX..|
/// |.XX....X...X.XX....XX.X...X....XX.|
/// |XXXXXXXXXXXXXX......XXXXXXXXXXXXXX|
/// |.......X...X..........X...X.......|
/// |.......X...X..........X...X.......|
/// |XXXXXXXXXXXXXX......XXXXXXXXXXXXXX|
/// |.XX....X...X.XX....XX.X...X....XX.|
/// |..XX...X...X..XX..XX..X...X...XX..|
/// |...XX..X...X...X..X...X...X..XX...|
/// |....XXXXXXXXXXXXXXXXXXXXXXXXXX....|
/// |.......X...X...X..X...X...X.......|
/// |.......X...X...X..X...X...X.......|
/// |.......XX..X...X..X...X..XX.......|
/// |........XXXXXXXXXXXXXXXXXX........|
/// |...........X...X..X...X...........|
/// |...........X...X..X...X...........|
/// |...........XX..X..X..XX...........|
/// |............XX.X..X.XX............|
/// |.............XXX..XXX.............|
/// |..............XX..XX..............|
/// |...............X..X...............|
