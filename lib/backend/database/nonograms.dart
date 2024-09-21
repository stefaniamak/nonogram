import 'package:nonogram/backend/database/nonograms_for_isolate/cat_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/dancer_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/knot_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/swing_isolate.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

class Nonograms {
  List<IsolateNonogram> get allNonograms => [
        dancer,
        cat,
        knot,
        // edge,
        swing,
      ];

  IsolateNonogram get dancer => kDancerIsolate;
  IsolateNonogram get cat => kCatIsolate;
  IsolateNonogram get knot => kKnotIsolate;
// IsolateNonogram get edge => kEdgeIsolate;
  IsolateNonogram get swing => kSwingIsolate;
}
