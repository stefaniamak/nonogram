import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/nonogram/nonogram_info.dart';

const Nonogram kCat = Nonogram(
  id: "2",
  info: NonogramInfo(
    title: "Cat",
    copyright: "(c) Copyright 2004 by Jan Wolter",
    author: "Jan Wolter",
    authorId: "jan",
    description: "My five year old son was able to tell that this was a dog.",
  ),
  note: "published,definitely unique,definitely line/color solvable",
  clues: Clues(
    columns: <List<int>>[
      <int>[1, 1],
      <int>[5],
      <int>[3],
      <int>[2],
      <int>[2],
      <int>[8],
      <int>[2, 1],
      <int>[1, 1],
    ],
    rows: <List<int>>[
      <int>[1],
      <int>[2],
      <int>[1, 3],
      <int>[5],
      <int>[5],
      <int>[2, 2],
      <int>[2, 1, 1],
      <int>[1, 1],
    ],
  ),
);

// Solution:
// 01100011010010101110101001010000110010100101111000
// |.....X..|
// |.....XX.|
// |X....XXX|
// |.XXXXX..|
// |.XXXXX..|
// |.XX..XX.|
// |XX...X.X|
// |.X...X..|
