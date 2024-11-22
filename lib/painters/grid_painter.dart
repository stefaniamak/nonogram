import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/config/enums/point_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class GridPainter extends CustomPainter {

  GridPainter({
    required this.boxItems, required this.solution, super.repaint,
    this.side = 20,
    this.highlightedBoxes = const <int>[],
    this.onTap,
  });
  final double side;
  final List<int> highlightedBoxes;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;

  @override
  bool? hitTest(Offset position) {
    return true;
  }

  PointState getGridBoxState(int index) {
    final String? char = solution?.split('').elementAt(index);
    switch (char.toString()) {
      case '?':
        return PointState.unknown;
      case '1':
        return PointState.filled;
      case '0':
        return PointState.cross;
      default:
        return PointState.unknown;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < boxItems.width; x += 1) {
      for (int y = 0; y < boxItems.height; y += 1) {
        final int index = (y * boxItems.width).ceil() + x;
        final PointState pointState = getGridBoxState(index);

        GridBox(
          point: Point(x * side, y * side),
          pointState: pointState,
          side: side,
          isHighlighted: highlightedBoxes.contains(index),
        ).paint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
    throw UnimplementedError();
  }
}
