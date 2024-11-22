import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/pages/game/nono_clues.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class NonogramGridAndClues extends StatelessWidget {

  const NonogramGridAndClues({
    // required this.nonogram,
    required this.clues,
    this.solution,
    this.maxSize,
    this.boxItems,
    this.onLineTap,

    // this.nonogramState,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.onPan,
    this.onPanEnd,
    this.highlightedBoxes = const <int>[],
    super.key,
  });
  // final Nonogram nonogram;
  final IsolateClues clues;
  final String? solution;
  final Size? boxItems;
  // final NonogramState? nonogramState;
  final EdgeInsets padding;
  final Size? maxSize;
  final Function(Axis axis, int index, List<int>)? onLineTap;
  final Function(int)? onTap;
  final Function(int)? onPan;
  final Function(int)? onPanEnd;
  final List<int> highlightedBoxes;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData md = MediaQuery.of(context);
    final Size maxSize = this.maxSize ?? md.size;

    // var nonogramState = this.nonogramState;
    final NonogramUi nonogramUi = useNonogramUi(
        Size(boxItems?.width ?? clues.columnLength + 0, boxItems?.height ?? clues.rowLength + 0), clues, maxSize, padding,);

    return Container(
      width: nonogramUi.size.width,
      height: nonogramUi.size.height,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CluesUi(
            clues: clues,
            boxSize: nonogramUi.gridItemSide,
            axis: Axis.horizontal,
            onEdit: onLineTap,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CluesUi(
                clues: clues,
                boxSize: nonogramUi.gridItemSide,
                axis: Axis.vertical,
                onEdit: onLineTap,
              ),
              // if (solution != null)
              NonogramGrid(
                // nonogram: nonogram,
                // nonogramState: nonogramState,
                gridItemSide: nonogramUi.gridItemSide,
                size: nonogramUi.gridSize, // Size(nonogramUi.gridSize.width, nonogramUi.gridSize.height),
                boxItems: Size(clues.columnLength + 0, clues.rowLength + 0),
                // solution: nonogramState!.solutionSteps.elementAt(nonogramState.stepNumber).currentSolution,
                solution: solution ?? Iterable.generate(clues.columnLength * clues.rowLength, (_) => '?').join(),
                onTap: onTap,
                onPan: onPan,
                onPanEnd: onPanEnd,
                // clues: clues,
                highlightedBoxes: highlightedBoxes,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
