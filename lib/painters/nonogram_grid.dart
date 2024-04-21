import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/grid_box.dart';

import '../backend/models/nonogram.dart';

class NonogramGrid extends StatelessWidget {
  // final Nonogram nonogram;
  // final NonogramState? nonogramState;
  final double gridItemSide;

  final Size size;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;

  const NonogramGrid({
    // required this.nonogram,
    // this.nonogramState,
    required this.gridItemSide,
    required this.size,
    required this.boxItems,
    this.solution,
    this.onTap,
    super.key,
  });

  PointState getGridBoxState(int index) {
    var char = solution?.characterAt(index);
    switch (char.toString()) {
      case '?':
        return PointState.unknown;
      case '1':
        return PointState.filled;
      case '0':
        return PointState.cross;
      default:
        return PointState.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    // String? solution = nonogramState?.solutionSteps.elementAt(nonogramState!.stepNumber).currentSolution;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: GridView.builder(
        itemCount: solution?.length ?? (boxItems.width * boxItems.height).ceil(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boxItems.width.ceil(),
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: onTap != null
                ? () {
                    onTap!.call(index);
                  }
                : null,

            //   () {
            // switch (getGridBoxState(index)) {
            //   case PointState.unknown:
            //     nonogramState?.setFilled(index);
            //     break;
            //   case PointState.filled:
            //     nonogramState?.setCross(index);
            //     break;
            //   case PointState.cross:
            //     nonogramState?.setUnknown(index);
            //     break;
            // }
            // },
            child: CustomPaint(
              painter: GridBox(
                pointState: getGridBoxState(index),
                side: gridItemSide,
              ),
            ),
          );
        },
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
