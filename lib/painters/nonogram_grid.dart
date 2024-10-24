import 'package:flutter/material.dart';
import 'package:nonogram/painters/grid_painter.dart';

class NonogramGrid extends StatelessWidget {
  final double gridItemSide;
  final Size size;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;
  final List<int> highlightedBoxes;

  const NonogramGrid({
    required this.gridItemSide,
    required this.size,
    required this.boxItems,
    this.solution,
    this.onTap,
    this.highlightedBoxes = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        isComplex: true,
        foregroundPainter: GridPainter(
          boxItems: boxItems,
          side: gridItemSide,
          highlightedBoxes: highlightedBoxes,
          solution: solution,
        ),
      ),
    );
  }
}
