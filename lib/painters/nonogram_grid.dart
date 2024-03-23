import 'package:flutter/material.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/grid_box.dart';

class NonogramGrid extends StatelessWidget {
  final NonogramState nonogramState;
  final NonogramUi nonogramUi;

  const NonogramGrid({
    required this.nonogramState,
    required this.nonogramUi,
    super.key,
  });

  PointState getGridBoxState(int index) {
    var char = nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).currentSolution.characterAt(index);
    switch (char.toString()) {
      case '?':
        return PointState.unknown;
      case '1':
        return PointState.filled;
      case '0':
        return PointState.cross;
    }
    return PointState.unknown;
  }

  @override
  Widget build(BuildContext context) {
    String solution = nonogramState.solutionSteps.elementAt(nonogramState.stepNumber).currentSolution;

    return SizedBox(
      width: nonogramUi.gridSize.width,
      height: nonogramUi.gridSize.height,
      child: GridView.builder(
        itemCount: solution.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: nonogramState.nonogram.width,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              switch (getGridBoxState(index)) {
                case PointState.unknown:
                  nonogramState.setFilled(index);
                  break;
                case PointState.filled:
                  nonogramState.setCross(index);
                  break;
                case PointState.cross:
                  nonogramState.setUnknown(index);
                  break;
              }
            },
            child: CustomPaint(
              painter: GridBox(
                pointState: getGridBoxState(index),
                side: nonogramUi.gridItemSide,
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
