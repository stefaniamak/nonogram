import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

const IsolateNonogram kCatIsolate = IsolateNonogram(
  id: "2",
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
