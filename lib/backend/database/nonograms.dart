import 'package:nonogram/backend/database/nonograms_for_isolate/cat_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/dancer_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/knot_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/swing_isolate.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

class Nonograms {
  static List<IsolateNonogram> get all => <IsolateNonogram>[
        dancer,
        cat,
        knot,
        // edge,
        swing,
      ];

  static IsolateNonogram get dancer => kDancerIsolate;
  static IsolateNonogram get cat => kCatIsolate;
  static IsolateNonogram get knot => kKnotIsolate;
// IsolateNonogram get edge => kEdgeIsolate;
  static IsolateNonogram get swing => kSwingIsolate;
}
