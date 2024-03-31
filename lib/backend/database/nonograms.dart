import 'package:nonogram/backend/database/nonograms/16_knot.dart';
import 'package:nonogram/backend/database/nonograms/23_edge.dart';
import 'package:nonogram/backend/database/nonograms/2_cat.dart';
import 'package:nonogram/backend/database/nonograms/529_swing.dart';
import 'package:nonogram/backend/models/nonogram.dart';

import 'nonograms/1_dancer.dart';

class Nonograms {
  List<Nonogram> get allNonograms => [
        dancer,
        cat,
        knot,
        edge,
        swing,
      ];

  Nonogram get dancer => kDancer;
  Nonogram get cat => kCat;
  Nonogram get knot => kKnot;
  Nonogram get edge => kEdge;
  Nonogram get swing => kSwing;
}
