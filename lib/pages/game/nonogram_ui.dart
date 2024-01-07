import 'package:flutter/cupertino.dart';
import 'package:nonogram/backend/models/nonogram.dart';

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

NonogramUi useNonogramUi(Nonogram nonogram, Size size,
    [EdgeInsets padding = EdgeInsets.zero]) {
  double width = size.width - padding.horizontal;
  double height = size.height - padding.vertical;

  double gridItemSide = width / (nonogram.width + nonogram.clues!.maxRowNumbs);

  if (gridItemSide * (nonogram.height + nonogram.clues!.maxColNumbs) > height) {
    gridItemSide = height / (nonogram.height + nonogram.clues!.maxColNumbs);
  }

  Size cluesSize = Size(
    nonogram.clues!.maxRowNumbs * gridItemSide,
    nonogram.clues!.maxColNumbs * gridItemSide,
  );

  Size gridSize = Size(
    nonogram.width * gridItemSide,
    nonogram.height * gridItemSide,
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
