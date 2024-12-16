import 'package:nonogram/backend/database/nonograms_for_isolate/cat_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/dancer_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/knot_isolate.dart';
import 'package:nonogram/backend/database/nonograms_for_isolate/swing_isolate.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';

/// A class that provides access to all nonograms.
class Nonograms {
  /// A list of all nonogram.
  static final List<Nonogram> all = <Nonogram>[
    dancer,
    cat,
    knot,
    swing,
  ];

  /// Gets the dancer nonogram.
  static Nonogram get dancer => kDancerIsolate;

  /// Gets the cat nonogram.
  static Nonogram get cat => kCatIsolate;

  /// Gets the knot nonogram.
  static Nonogram get knot => kKnotIsolate;

  /// Gets the swing nonogram.
  static Nonogram get swing => kSwingIsolate;
}
