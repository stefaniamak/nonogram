import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

class NonogramUi {
  final Size size;
  final Size gridSize;
  final double gridItemSide;

  const NonogramUi({
    required this.size,
    required this.gridSize,
    required this.gridItemSide,
  });
}

NonogramUi useNonogramUi(Nonogram nonogram,
    [EdgeInsets padding = EdgeInsets.zero]) {
  var context = useContext();
  var md = MediaQuery.of(context).size;

  double width = md.width - padding.left - padding.right;
  double height = md.height - padding.top - padding.bottom;

  double gridItemSide = width / (nonogram.width + nonogram.clues!.maxRowNumbs);

  if (gridItemSide * (nonogram.height + nonogram.clues!.maxColNumbs) > height) {
    gridItemSide = height / (nonogram.height + nonogram.clues!.maxColNumbs);
  }

  // double get
  return NonogramUi(
    size: Size(width, height),
    gridSize: Size(
      nonogram.width * gridItemSide,
      nonogram.height * gridItemSide,
    ),
    gridItemSide: gridItemSide,
  );
}
