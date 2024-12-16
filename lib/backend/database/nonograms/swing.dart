import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/nonogram/nonogram_info.dart';

/// A constant representing a nonogram puzzle of two people dancing.
const Nonogram kSwing = Nonogram(
  id: "6",
  info: NonogramInfo(
    title: "Swing",
    copyright: "(c) Copyright 2004 by Jan Wolter",
    author: "Jan Wolter",
    authorId: "jan",
    description: "A couple of merry dancers.",
  ),
  note: "published,definitely unique,definitely line/color solvable",
  clues: Clues(
    columns: <List<int>>[
      <int>[7, 1, 1, 1, 1, 1],
      <int>[2, 2, 4, 1, 4, 1, 5, 1, 4, 1, 4, 1, 2],
      <int>[3, 1, 4, 1, 4, 1, 14, 4, 1, 2],
      <int>[1, 1, 5, 1, 2, 3, 4, 1],
      <int>[3, 13, 1, 10],
      <int>[1, 9, 4],
      <int>[6, 7, 2, 2],
      <int>[8, 4, 1, 4],
      <int>[2, 8, 3, 2, 5, 3],
      <int>[10, 1, 3, 7, 2],
      <int>[8, 6, 2, 8, 1, 2],
      <int>[1, 1, 2, 2, 8, 1, 1],
      <int>[2, 1, 1, 1, 2, 1, 3, 1, 3, 3, 1],
      <int>[2, 1, 1, 1, 5, 4, 2, 1],
      <int>[2, 1, 1, 1, 1, 7, 2, 1],
      <int>[2, 1, 1, 2, 9, 1, 2, 1],
      <int>[4, 6, 12, 1, 3],
      <int>[16, 13, 3, 2],
      <int>[12, 21, 2],
      <int>[2, 13, 23],
      <int>[2, 14, 19],
      <int>[2, 14, 20, 2],
      <int>[2, 13, 7, 2, 8, 2],
      <int>[12, 8, 1, 7, 2],
      <int>[5, 1, 1, 1, 2, 8, 1, 5, 2],
      <int>[2, 1, 1, 1, 9, 1, 1, 4],
      <int>[2, 1, 1, 1, 6, 1, 3, 5],
      <int>[2, 2, 1, 5, 6, 2],
      <int>[2, 1, 3, 1, 3, 7, 3, 2],
      <int>[2, 3, 2, 1, 1, 2, 4, 4, 2],
      <int>[2, 2, 1, 1, 2, 3, 1, 8, 2],
      <int>[9, 3, 1, 7, 2],
      <int>[12, 4, 1, 6, 2],
      <int>[7, 4, 1, 2, 5],
      <int>[2, 6, 6, 5, 6],
      <int>[8, 8, 6, 3],
      <int>[3, 10, 8, 4, 2],
      <int>[5, 11, 9, 5, 2],
      <int>[3, 1, 12, 16, 2],
      <int>[3, 1, 12, 16],
      <int>[5, 2, 13, 21],
      <int>[6, 1, 3, 3, 1, 1],
      <int>[5, 1, 3, 1, 3, 1, 1, 2, 1, 4, 1, 3, 1, 3],
      <int>[5, 1, 3, 1, 3, 1, 4, 1, 4, 1, 3, 1, 3],
      <int>[1, 1, 1, 1, 1, 1],
    ],
    rows: <List<int>>[
      <int>[7, 1, 1, 1, 1, 1],
      <int>[3, 1, 3, 1, 4, 1, 4, 1, 5, 1, 5, 1, 2],
      <int>[1, 1, 1, 3, 1, 4, 1, 4, 1, 5, 1, 5, 1, 2],
      <int>[2, 1, 2, 1, 1, 1, 1, 6, 2],
      <int>[3, 30, 1, 5],
      <int>[1, 5, 8, 1, 1, 7, 1, 1, 3],
      <int>[3, 4, 8, 1, 5, 1, 2],
      <int>[3, 20, 6, 6],
      <int>[3, 3, 7, 2, 5, 1],
      <int>[3, 3, 1, 1, 9, 1, 1, 5, 6],
      <int>[2, 3, 8, 1, 3, 4, 2],
      <int>[5, 3, 1, 10, 4, 5, 2],
      <int>[1, 2, 3, 8, 4, 6],
      <int>[2, 2, 3, 11, 10],
      <int>[2, 2, 3, 10, 7],
      <int>[2, 3, 1, 7, 12, 2],
      <int>[2, 3, 1, 4, 11, 2],
      <int>[4, 1, 2, 1, 11, 2],
      <int>[9, 1, 2, 9],
      <int>[6, 2, 1, 4, 11],
      <int>[2, 5, 1, 2, 6, 6],
      <int>[6, 2, 4, 8, 4],
      <int>[4, 2, 16, 1],
      <int>[2, 2, 15, 2],
      <int>[3, 2, 15, 4],
      <int>[3, 3, 13, 4],
      <int>[4, 12, 9],
      <int>[1, 9, 10],
      <int>[2, 1, 17, 7, 2],
      <int>[2, 2, 8, 3, 8, 2],
      <int>[2, 3, 6, 3, 8, 2],
      <int>[2, 4, 5, 4, 7, 2],
      <int>[2, 5, 5, 4, 6],
      <int>[4, 4, 5, 4, 9],
      <int>[1, 4, 6, 4, 4],
      <int>[4, 3, 6, 4, 3, 2],
      <int>[2, 1, 2, 7, 4, 4, 2],
      <int>[2, 2, 2, 9, 5, 5, 2],
      <int>[2, 2, 2, 10, 6, 6],
      <int>[3, 2, 1, 9, 18],
      <int>[8, 4, 23],
      <int>[1, 2, 1, 2, 2, 1, 1, 1, 2],
      <int>[2, 1, 4, 2, 1, 4, 1, 5, 1, 3, 1, 2],
      <int>[2, 1, 5, 4, 4, 1, 5, 1, 3, 1, 2],
      <int>[1, 10, 1, 1, 1],
    ],
  ),
);

/// Solution:
/// 01100011010010101110101001010000110010100101111000
/// |XXXXXXX...X......X......X.......X.......X....|
/// |XXX.X.XXX.X.XXXX.X.XXXX.X.XXXXX.X.XXXXX.X.XX.|
/// |X.X.X.XXX.X.XXXX.X.XXXX.X.XXXXX.X.XXXXX.X.XX.|
/// |XX.X..XX..X......X......X.......X..XXXXXX.XX.|
/// |XXX...XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.X.XXXXX.|
/// |X.....XXXXX.....XXXXXXXX.X.X.XXXXXXX.X.X.XXX.|
/// |XXX....XXXX.....XXXXXXXX.....X.XXXXX..X.XX...|
/// |.XXX...XXXXXXXXXXXXXXXXXXXX...XXXXXX...XXXXXX|
/// |.XXX...XXX.......XXXXXXX...XX..XXXXX.....X...|
/// |.XXX....XXX.X.X.XXXXXXXXX.X.X.XXXXX...XXXXXX.|
/// |...XX...XXX.....XXXXXXXX....X..XXX...XXXX.XX.|
/// |XXXXX...XXX.X...XXXXXXXXXX...XXXX...XXXXX.XX.|
/// |....X....XX.XXX.XXXXXXXX....XXXX...XXXXXX....|
/// |.XX.XX...XXX...XXXXXXXXXXX.........XXXXXXXXXX|
/// |.XX.XX....XXX..XXXXXXXXXX.........XXXXXXX....|
/// |.XX.XXX......X...XXXXXXX.....XXXXXXXXXXXX.XX.|
/// |.XX.XXX......X.....XXXX.......XXXXXXXXXXX.XX.|
/// |....XXXX.....X......XX...X....XXXXXXXXXXX.XX.|
/// |XXXXXXXXX....X..........XX......XXXXXXXXX....|
/// |....XXXXXX..XX..X......XXXX.......XXXXXXXXXXX|
/// |.XX.XXXXX...X...XX....XXXXXX........XXXXXX...|
/// |.XXXXXX....XX..XXXX..XXXXXXXX...........XXXX.|
/// |.XXXX.....XX..XXXXXXXXXXXXXXXX.............X.|
/// |.XX......XX...XXXXXXXXXXXXXXX.............XX.|
/// |.XXX....XX...XXXXXXXXXXXXXXX............XXXX.|
/// |..XXX..XXX...XXXXXXXXXXXXX............XXXX...|
/// |XXXX........XXXXXXXXXXXX............XXXXXXXXX|
/// |..X..........XXXXXXXXX.........XXXXXXXXXX....|
/// |.XX.....X.....XXXXXXXXXXXXXXXXX...XXXXXXX.XX.|
/// |.XX.....XX.....XXXXXXXX....XXX...XXXXXXXX.XX.|
/// |.XX.....XXX.....XXXXXX....XXX....XXXXXXXX.XX.|
/// |.XX.....XXXX.....XXXXX...XXXX.....XXXXXXX.XX.|
/// |..XX....XXXXX....XXXXX....XXXX.....XXXXXX....|
/// |XXXX.....XXXX.....XXXXX....XXXX.....XXXXXXXXX|
/// |...X.....XXXX.....XXXXXX....XXXX.....XXXX....|
/// |.XXXX....XXX......XXXXXX.....XXXX.....XXX.XX.|
/// |.XX.X.....XX......XXXXXXX.....XXXX...XXXX.XX.|
/// |.XX.XX....XX.....XXXXXXXXX...XXXXX..XXXXX.XX.|
/// |.XX.XX.....XX...XXXXXXXXXX..XXXXXX.XXXXXX....|
/// |....XXX.....XX.X.XXXXXXXXX.XXXXXXXXXXXXXXXXXX|
/// |XXXXXXXX...XXXX...XXXXXXXXXXXXXXXXXXXXXXX....|
/// |....X..XX.X...XX..XX......X.......X.....X.XX.|
/// |.XX.X.XXXX.....XX..X.XXXX.X.XXXXX.X.XXX.X.XX.|
/// |.XX.X.XXXXX.....XXXX.XXXX.X.XXXXX.X.XXX.X.XX.|
/// |....X.....XXXXXXXXXX......X.......X.....X....|
