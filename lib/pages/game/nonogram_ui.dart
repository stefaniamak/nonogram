import 'package:flutter/cupertino.dart';
import 'package:nonogram/backend/models/clues.dart';
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

NonogramUi useNonogramUi(Size boxesNumb, Clues clues, Size maxSize, [EdgeInsets padding = EdgeInsets.zero]) {
  double width = maxSize.width - padding.horizontal;
  double height = maxSize.height - padding.vertical;

  double gridItemSide = width / (boxesNumb.width + clues.maxRowNumbs);

  if (gridItemSide * (boxesNumb.height + clues.maxColNumbs) > height) {
    gridItemSide = height / (boxesNumb.height + clues.maxColNumbs);
  }

  Size cluesSize = Size(
    clues.maxRowNumbs * gridItemSide,
    clues.maxColNumbs * gridItemSide,
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
