import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';

class NonogramUi {
  final Size size;
  final Size cluesSize;
  final Size gridSize;
  final double gridItemSide;

  const NonogramUi({
    required this.size,
    required this.cluesSize,
    required this.gridSize,
    required this.gridItemSide,
  });
}

NonogramUi useNonogramUi(Size boxesNumb, IsolateClues clues, Size maxSize, [EdgeInsets padding = EdgeInsets.zero]) {
  double width = maxSize.width - padding.horizontal;
  double height = maxSize.height - padding.vertical;

  final maxRowNumbs = clues.rows.map((r) => r.length).reduce(max);
  final maxColNumbs = clues.columns.map((c) => c.length).reduce(max);

  double gridItemSide = width / (boxesNumb.width + maxRowNumbs);

  if (gridItemSide * (boxesNumb.height + maxColNumbs) > height) {
    gridItemSide = height / (boxesNumb.height + maxColNumbs);
  }

  Size cluesSize = Size(
    maxRowNumbs * gridItemSide,
    maxColNumbs * gridItemSide,
  );

  Size gridSize = Size(
    boxesNumb.width * gridItemSide,
    boxesNumb.height * gridItemSide,
  );

  width = gridSize.width + cluesSize.width + padding.horizontal;
  height = gridSize.height + cluesSize.height + padding.vertical;

  return NonogramUi(
    size: Size(width, height),
    cluesSize: cluesSize,
    gridSize: gridSize,
    gridItemSide: gridItemSide,
  );
}
