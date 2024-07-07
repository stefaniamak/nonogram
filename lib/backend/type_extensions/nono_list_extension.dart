import 'package:flutter/foundation.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/solver/line_solver.dart';

import 'nono_axis_extension.dart';

extension NonoListExtension on List {
  int get sum => fold<int>(0, (previousValue, element) => previousValue + (element as int));

  bool get everyElementIsZero => every((e) => e.toString() == '0');

  bool isInStack(int charIndex, NonoAxis lineType) {
    return contains({charIndex: lineType});
  }

  void updateStack(int charIndex, NonoAxis lineType, NonogramState state) {
    NonoAxis newAxis = lineType == NonoAxis.row ? NonoAxis.column : NonoAxis.row;
    if (!isInStack(charIndex, newAxis)) {
      state.pushStack({charIndex: newAxis});
    } else {
      // print('bumped');
      // print('stack before ${state.stack}');
      // state.bumpToStack({charIndex: newAxis});
      // print('stack after ${state.stack}');
    }
  }
}
