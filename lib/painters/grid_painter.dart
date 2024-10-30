import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class GridPainter extends CustomPainter {
  final double side;
  final List<int> highlightedBoxes;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;

  GridPainter({
    super.repaint,
    this.side = 20,
    this.highlightedBoxes = const [],
    required this.boxItems,
    required this.solution,
    this.onTap,
  });

  @override
  bool? hitTest(Offset position) {
    onTap?.call((position.dx / side).floor() + (position.dy / side).floor() * boxItems.width.floor());
    return false;
  }

  PointState getGridBoxState(int index) {
    var char = solution?.split('').elementAt(index);
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
    for (var x = 0; x < boxItems.width; x += 1) {
      for (var y = 0; y < boxItems.height; y += 1) {
        int index = (y * boxItems.width).ceil() + x;
        PointState pointState = getGridBoxState(index);

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
