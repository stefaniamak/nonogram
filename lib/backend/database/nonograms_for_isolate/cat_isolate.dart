import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

const IsolateNonogram kCatIsolate = IsolateNonogram(
  id: "2",
  info: IsolateNonogramInfo(
    title: "Cat",
    copyright: "(c) Copyright 2004 by Jan Wolter",
    author: "Jan Wolter",
    authorId: "jan",
    description: "My five year old son was able to tell that this was a dog.",
  ),
  note: "published,definitely unique,definitely line/color solvable",
  clues: IsolateClues(
    columns: [
      [1, 1],
      [5],
      [3],
      [2],
      [2],
      [8],
      [2, 1],
      [1, 1],
    ],
    rows: [
      [1],
      [2],
      [1, 3],
      [5],
      [5],
      [2, 2],
      [2, 1, 1],
      [1, 1],
    ],
  ),
);
