import 'package:nonogram/backend/database/nonograms/cat.dart';
import 'package:nonogram/backend/database/nonograms/dancer.dart';
import 'package:nonogram/backend/database/nonograms/knot.dart';
import 'package:nonogram/backend/database/nonograms/swing.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';

import 'nonograms/dev.dart';

/// A class that provides access to all nonograms.
class Nonograms {
  /// A list of all nonogram.
  static final List<Nonogram> all = <Nonogram>[
    dancer,
    cat,
    knot,
    swing,
    dev,
  ];

  /// Gets the dancer nonogram.
  static Nonogram get dancer => kDancer;

  /// Gets the cat nonogram.
  static Nonogram get cat => kCat;

  /// Gets the knot nonogram.
  static Nonogram get knot => kKnot;

  /// Gets the swing nonogram.
  static Nonogram get swing => kSwing;

  /// Gets the swing nonogram.
  static Nonogram get dev => kDev;
}
