import 'package:nonogram/backend/database/nonograms_for_isolate/cat_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/dancer_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/knot_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/swing_isolate.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

/// A class that provides access to all nonograms.
class Nonograms {
  /// A list of all nonogram.
  static final List<IsolateNonogram> all = <IsolateNonogram>[
    dancer,
    cat,
    knot,
    swing,
  ];

  /// Gets the dancer nonogram.
  static IsolateNonogram get dancer => kDancerIsolate;

  /// Gets the cat nonogram.
  static IsolateNonogram get cat => kCatIsolate;

  /// Gets the knot nonogram.
  static IsolateNonogram get knot => kKnotIsolate;

  /// Gets the swing nonogram.
  static IsolateNonogram get swing => kSwingIsolate;
}
