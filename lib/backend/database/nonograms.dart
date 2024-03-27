import 'package:nonogram/backend/database/nonograms/2_cat.dart';
import 'package:nonogram/backend/database/nonograms/529_swing.dart';
import 'package:nonogram/backend/models/nonogram.dart';

import 'nonograms/1_dancer.dart';

class Nonograms {
  List<Nonogram> get allNonograms => [
        dancer,
        cat,
        swing,
      ];

  Nonogram get dancer => kDancer;
  Nonogram get cat => kCat;
  Nonogram get swing => kSwing;
}
