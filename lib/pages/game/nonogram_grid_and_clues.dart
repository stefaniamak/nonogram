import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/pages/game/nono_clues.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/grid_painter.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

/// A stateless widget that represents a Nonogram grid and its clues.
///
/// The `NonogramGridAndClues` widget includes various parameters to configure the grid,
/// such as the clues, solution, maximum size, box items, padding, and callback functions
/// for tap and pan events.
class NonogramGridAndClues extends StatelessWidget {
  /// Creates a Nonogram Grid and Clues based on screen size.
  ///
  /// Provide just the [clues] parameter to display an empty grid with its clues.
  const NonogramGridAndClues({
    required this.clues,
    this.onLineTap,
    this.gridStateParams,
    this.gridGestures,
    this.maxSize,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  /// The clues for the Nonogram puzzle.
  final IsolateClues clues;

  /// The parameters for the grid state.
  final GridStateParams? gridStateParams;

  /// The gestures for the grid.
  final GridGestures? gridGestures;

  /// Callback function to be called when a clue line is tapped.
  final Function(Axis axis, int index, List<int>)? onLineTap;

  /// The maximum size for the grid and clues.
  final Size? maxSize;

  /// The padding for the grid and clues.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData md = MediaQuery.of(context);
    final Size maxSize = this.maxSize ?? md.size;
    final Size puzzleSize = Size(
      clues.columnLength.toDouble(),
      clues.rowLength.toDouble(),
    );
    final NonogramUi nonogramUi = useNonogramUi(puzzleSize, clues, maxSize, padding);

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
              NonogramGrid(
                gestures: gridGestures,
                gridStateParams: gridStateParams,
                gridViewParams: GridViewParams(
                  boxItems: puzzleSize,
                  side: nonogramUi.gridItemSide,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
