import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class NonogramGrid extends StatelessWidget {
  final NonogramState nonogramState;

  const NonogramGrid({
    required this.nonogramState,
    super.key,
  });

  PointState getGridBoxState(int index) {
    var char = nonogramState.activeSolution.characters.characterAt(index);
    print('char: $char');
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
    final double puzzleWidth = MediaQuery.of(context).size.width * 80 / 100;
    final double gridSize = puzzleWidth / nonogramState.nonogram.width;
    return Center(
      child: Container(
        width: puzzleWidth,
        child: GridView.builder(
          itemCount:
              nonogramState.nonogram.width * nonogramState.nonogram.height,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: nonogramState.nonogram.width,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                nonogramState.setFilled(index, index);
              },
              child: CustomPaint(
                painter: GridBox(
                  pointState: getGridBoxState(index),
                  side: gridSize,
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
