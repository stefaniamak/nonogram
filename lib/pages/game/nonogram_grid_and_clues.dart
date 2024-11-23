import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/pages/game/nono_clues.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
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
    this.solution,
    this.maxSize,
    this.boxItems,
    this.onLineTap,
    this.padding = EdgeInsets.zero,
    this.gridGestures,
    this.highlightedBoxes = const <int>[],
    super.key,
  });

  /// The clues for the Nonogram puzzle.
  final IsolateClues clues;

  /// The solution for the Nonogram puzzle.
  final String? solution;

  /// The size of each grid item.
  final Size? boxItems;

  /// The padding for the grid and clues.
  final EdgeInsets padding;

  /// The maximum size for the grid and clues.
  final Size? maxSize;

  /// Callback function to be called when a clue line is tapped.
  final Function(Axis axis, int index, List<int>)? onLineTap;

  /// The gestures for the grid.
  final GridGestures? gridGestures;

  /// List of indices of highlighted boxes in the grid (usually the last solution step's boxes).
  final List<int> highlightedBoxes;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData md = MediaQuery.of(context);
    final Size maxSize = this.maxSize ?? md.size;
    final Size puzzleSize = Size(boxItems?.width ?? clues.columnLength + 0, boxItems?.height ?? clues.rowLength + 0);
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
                gridItemSide: nonogramUi.gridItemSide,
                size: nonogramUi.gridSize,
                boxItems: Size(clues.columnLength + 0, clues.rowLength + 0),
                solution: solution ?? Iterable<String>.generate(clues.columnLength * clues.rowLength, (_) => '?').join(),
                gestures: gridGestures,
                highlightedBoxes: highlightedBoxes,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
