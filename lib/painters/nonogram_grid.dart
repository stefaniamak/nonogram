import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class NonogramGrid extends HookWidget {
  const NonogramGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Nonogram draftNono = Nonograms().dancer;
    var nonogramState = useNonogramState(draftNono);

    final double puzzleWidth = MediaQuery.of(context).size.width;
    final double puzzleHeight = MediaQuery.of(context).size.height;
    final double gridSize = puzzleWidth / nonogramState.nonogram.width;
    return Center(
      child: Container(
        width: puzzleWidth,
        height: gridSize * nonogramState.nonogram.height,
        child: GridView.builder(
          itemCount:
              nonogramState.nonogram.width * nonogramState.nonogram.height,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: nonogramState.nonogram.width,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                nonogramState.setFilled(1, 1);
              },
              child: CustomPaint(
                painter: GridBox(
                  pointState: PointState.unknown,
                  side: gridSize,
                ),
              ),
            );
          },
          padding: EdgeInsets.zero,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
