import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nono_clues.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class NonogramGridAndClues extends HookWidget {
  final Nonogram nonogram;
  final NonogramState? nonogramState;
  final EdgeInsets padding;
  final Size? maxSize;

  const NonogramGridAndClues({
    required this.nonogram,
    this.nonogramState,
    this.padding = EdgeInsets.zero,
    this.maxSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var md = MediaQuery.of(context);
    var maxSize = this.maxSize ?? md.size;

    var nonogramState = this.nonogramState;
    var nonogramUi = useNonogramUi(nonogram, maxSize, padding);

    return Container(
      width: nonogramUi.size.width,
      height: nonogramUi.size.height,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CluesUi(
            clues: nonogram.clues!,
            boxSize: nonogramUi.gridItemSide,
            axis: Axis.horizontal,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CluesUi(
                clues: nonogram.clues!,
                boxSize: nonogramUi.gridItemSide,
                axis: Axis.vertical,
              ),
              NonogramGrid(
                nonogram: nonogram,
                nonogramState: nonogramState,
                nonogramUi: nonogramUi,
                size: Size(nonogramUi.gridSize.width, nonogramUi.gridSize.height),
                solution: nonogramState!.solutionSteps.elementAt(nonogramState.stepNumber).currentSolution,
                clues: nonogram.clues!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
