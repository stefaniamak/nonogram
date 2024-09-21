import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

const IsolateNonogram kDancerIsolate = IsolateNonogram(
  id: "1",
  info: IsolateNonogramInfo(
      title: "Dancer",
      copyright: "(c) Copyright 2004 by Jan Wolter",
      author: "Jan Wolter",
      authorId: "jan",
      description: "A stick figure man, dancing his stickly little heart out."),
  note: "published,definitely unique,definitely line/color solvable",
  clues: IsolateClues(
    columns: [
      [2, 1],
      [2, 1, 3],
      [7],
      [1, 3],
      [2, 1],
    ],
    rows: [
      [2],
      [2, 1],
      [1, 1],
      [3],
      [1, 1],
      [1, 1],
      [2],
      [1, 1],
      [1, 2],
      [2],
    ],
  ),
//     ..solutions = ListBuilder([
//       Solution((s) => s
//         ..type = SolutionType.goal
//         ..solution = "01100011010010101110101001010000110010100101111000"
//         ..image = '''|.XX..|
// |.XX.X|
// |..X.X|
// |.XXX.|
// |X.X..|
// |X.X..|
// |..XX.|
// |.X.X.|
// |.X.XX|
// |XX...|''')
//     ]),
);
