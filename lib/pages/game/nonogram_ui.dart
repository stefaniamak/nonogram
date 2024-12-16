import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';

/// A class which calculates the final sizes of the clues list and grid size
/// for a Nonogram puzzle.
class NonogramUi {
  /// Creates a NonogramUi.
  const NonogramUi({
    required this.size,
    required this.cluesSize,
    required this.gridSize,
    required this.gridItemSide,
    required this.boxesNumb,
  });

  /// The overall size of both clues and grid.
  final Size size;

  /// The size of the clues area.
  final Size cluesSize;

  /// The size of the grid area.
  final Size gridSize;

  /// The side size of each square grid item.
  final double gridItemSide;

  /// The number of boxes in the Nonogram puzzle.
  final Size boxesNumb;
}

/// Calculates and returns the UI sizes for a Nonogram puzzle.
///
/// The [clues] parameter provides the clues for the Nonogram puzzle.
/// The [maxSize] parameter specifies the maximum size of the Nonogram UI.
/// The [padding] parameter specifies the padding around the Nonogram UI, and is optional.
///
/// Returns an instance of `NonogramUi` containing the calculated UI parameters.
NonogramUi useNonogramUi(Clues clues, Size maxSize, [EdgeInsets padding = EdgeInsets.zero]) {
  final Size boxesNumb = Size(clues.columnLength.toDouble(), clues.rowLength.toDouble());

  double width = maxSize.width - padding.horizontal;
  double height = maxSize.height - padding.vertical;

  final int maxRowNumbs = clues.rows.map((List<int> r) => r.length).reduce(max);
  final int maxColNumbs = clues.columns.map((List<int> c) => c.length).reduce(max);

  double gridItemSide = width / (boxesNumb.width + maxRowNumbs);

  if (gridItemSide * (boxesNumb.height + maxColNumbs) > height) {
    gridItemSide = height / (boxesNumb.height + maxColNumbs);
  }

  final Size cluesSize = Size(maxRowNumbs * gridItemSide, maxColNumbs * gridItemSide);
  final Size gridSize = Size(boxesNumb.width * gridItemSide, boxesNumb.height * gridItemSide);

  width = gridSize.width + cluesSize.width + padding.horizontal;
  height = gridSize.height + cluesSize.height + padding.vertical;

  return NonogramUi(
    size: Size(width, height),
    cluesSize: cluesSize,
    gridSize: gridSize,
    gridItemSide: gridItemSide,
    boxesNumb: boxesNumb,
  );
}
