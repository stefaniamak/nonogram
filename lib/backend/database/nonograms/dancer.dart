import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/backend/models/nonogram/nonogram_info.dart';

/// A constant representing a nonogram puzzle of a dancer.
const Nonogram kDancer = Nonogram(
  id: "1",
  info: NonogramInfo(
    title: "Dancer",
    copyright: "(c) Copyright 2004 by Jan Wolter",
    author: "Jan Wolter",
    authorId: "jan",
    description: "A stick figure man, dancing his stickly little heart out.",
  ),
  note: "published,definitely unique,definitely line/color solvable",
  clues: Clues(
    columns: <List<int>>[
      <int>[2, 1],
      <int>[2, 1, 3],
      <int>[7],
      <int>[1, 3],
      <int>[2, 1],
    ],
    rows: <List<int>>[
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
    ],
  ),
);

/// Solution:
/// 01100011010010101110101001010000110010100101111000
/// |.XX..|
/// |.XX.X|
/// |..X.X|
/// |.XXX.|
/// |X.X..|
/// |X.X..|
/// |..XX.|
/// |.X.X.|
/// |.X.XX|
/// |XX...|
