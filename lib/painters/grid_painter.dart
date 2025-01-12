import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/config/enums/point_state.dart';
import 'package:nonogram/painters/grid_box_painter.dart';

/// A custom painter for drawing a Nonogram grid.
class GridPainter extends CustomPainter {
  /// Creates a custom painter for a Nonogram grid.
  GridPainter({
    required this.gridStateParams,
    required this.gridViewParams,
    super.repaint,
  });

  /// The parameters for the grid state.
  final GridStateParams? gridStateParams;

  /// The parameters for the grid view.
  final GridViewParams gridViewParams;

  @override
  bool? hitTest(Offset position) => true;

  PointState getGridBoxState(int index) {
    final String? char = gridStateParams?.solution?.split('').elementAt(index);
    switch (char) {
      case '1':
        return PointState.filled;
      case '0':
        return PointState.cross;
      case '?':
      default:
        return PointState.unknown;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < gridViewParams.boxItems.width; x += 1) {
      for (int y = 0; y < gridViewParams.boxItems.height; y += 1) {
        final int index = (y * gridViewParams.boxItems.width).ceil() + x;
        GridBoxPainter(
          point: Point<double>(x * gridViewParams.side, y * gridViewParams.side),
          pointState: getGridBoxState(index),
          side: gridViewParams.side,
          isHighlighted: gridStateParams?.highlightedBoxes.contains(index) ?? false,
        ).paint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => this != oldDelegate;
}

/// A class that holds the parameters for the Nonogram grid state.
class GridStateParams {
  /// Creates an instance of `GridStateParams`.
  ///
  /// The [solution] and [highlightedBoxes] parameters are optional.
  GridStateParams({
    this.solution,
    this.highlightedBoxes = const <int>[],
  });

  /// The solution string representing the state of each box in the grid.
  final String? solution;

  /// List of indices of highlighted boxes in the grid.
  final List<int> highlightedBoxes;
}

/// A class that holds the parameters for the Nonogram grid view.
class GridViewParams {
  /// Creates an instance of `GridViewParams`.
  ///
  /// The [boxItems] and [side] parameters are required.
  GridViewParams({
    required this.boxItems,
    required this.side,
  });

  /// The size of the grid in terms of number of boxes.
  final Size boxItems;

  /// The size of each side of a grid box.
  final double side;
}
