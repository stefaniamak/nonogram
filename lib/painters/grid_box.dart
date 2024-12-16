import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/config/enums/point_state.dart';

/// Custom painter for drawing grid boxes in a nonogram puzzle.
class GridBox extends CustomPainter {
  /// Creates a GridBox painter.
  GridBox({
    required this.pointState,
    required this.point,
    super.repaint,
    this.side = 20,
    this.isHighlighted = false,
  });

  /// The state of the point (unknown, filled, or cross).
  final PointState pointState;

  /// The side length of the grid box.
  final double side;

  /// Whether the box is highlighted.
  final bool isHighlighted;

  /// The coordinates of the point.
  final Point<double> point;

  /// The default paint used for drawing the grid box.
  ///
  /// This paint is configured with the appropriate color, stroke width,
  /// stroke cap, and painting style based on whether the box is highlighted.
  late final Paint _defaultPaint = Paint()
    ..color = isHighlighted ? Colors.lightGreen : Colors.black
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    switch (pointState) {
      case PointState.unknown:
        break;
      case PointState.filled:
        drawFilledBox(canvas);
      case PointState.cross:
        drawCrossBox(canvas);
    }
    drawEmptyBox(canvas, color: Colors.black);
  }

  /// Draws an empty box on the canvas.
  ///
  /// - [canvas]: The canvas to draw on.
  /// - [paintingStyle]: The painting style (stroke or fill). Defaults to stroke.
  /// - [color]: The color of the box. Defaults to black.
  void drawEmptyBox(Canvas canvas, {PaintingStyle paintingStyle = PaintingStyle.stroke, Color? color}) {
    final Paint paint = _defaultPaint
      ..style = paintingStyle
      ..color = color ?? _defaultPaint.color;
    final double x = point.x;
    final double y = point.y;

    final Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x + side, y)
      ..lineTo(x + side, y + side)
      ..lineTo(x, y + side)
      ..close();

    canvas.drawPath(path, paint);
  }

  /// Draws a filled box on the canvas.
  ///
  /// - [canvas]: The canvas to draw on.
  void drawFilledBox(Canvas canvas) => drawEmptyBox(canvas, paintingStyle: PaintingStyle.fill);

  /// Draws a cross box on the canvas.
  ///
  /// - [canvas]: The canvas to draw on.
  void drawCrossBox(Canvas canvas) {
    drawEmptyBox(canvas);
    final double x = point.x;
    final double y = point.y;

    final Paint paint = _defaultPaint..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x + side, y + side)
      ..moveTo(x + side, y)
      ..lineTo(x, y + side);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
