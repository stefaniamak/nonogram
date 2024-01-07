import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class NonogramGrid extends StatelessWidget {
  final NonogramState nonogramState;
  final double gridWidth;
  final double gridItemWidth;

  const NonogramGrid({
    required this.nonogramState,
    required this.gridWidth,
    required this.gridItemWidth,
    super.key,
  });

  PointState getGridBoxState(int index) {
    var char = nonogramState.activeSolution.characters.characterAt(index);
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
    // todo: find grid height and width #16 https://github.com/stefaniamak/nonogram/issues/16
    final double gridSize = gridWidth / nonogramState.nonogram.width;
    return Center(
      child: Container(
        width: gridWidth,
        child: GridView.builder(
          itemCount: nonogramState.activeSolution.length,
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
                  side: gridItemWidth,
                ),
              ),
            );
          },
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
