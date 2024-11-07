import 'package:flutter/material.dart';
import 'package:nonogram/painters/grid_painter.dart';

class NonogramGrid extends StatelessWidget {
  final double gridItemSide;
  final Size size;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;
  final Function(int)? onPan;
  final List<int> highlightedBoxes;

  const NonogramGrid({
    required this.gridItemSide,
    required this.size,
    required this.boxItems,
    this.solution,
    this.onTap,
    this.onPan,
    this.highlightedBoxes = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: GestureDetector(
        onPanStart: (details) {
          final Offset position = details.localPosition;
          // print('onPanStart: $position');
          onTap?.call((position.dx / gridItemSide).floor() + (position.dy / gridItemSide).floor() * boxItems.width.floor());
        },
        onPanUpdate: (details) {
          final Offset position = details.localPosition;
          // print('onPanUpdate: $position');
          onPan?.call((position.dx / gridItemSide).floor() + (position.dy / gridItemSide).floor() * boxItems.width.floor());
        },
        child: CustomPaint(
          isComplex: true,
          painter: GridPainter(
            boxItems: boxItems,
            side: gridItemSide,
            highlightedBoxes: highlightedBoxes,
            solution: solution,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
