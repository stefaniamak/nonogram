import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class GridBox extends CustomPainter {
  final PointState pointState;
  final double side;
  final bool isHighlighted;
  final Point point;

  GridBox({
    super.repaint,
    required this.pointState,
    this.side = 20,
    this.isHighlighted = false,
    required this.point,
  });

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
        break;
      case PointState.cross:
        drawCrossBox(canvas);
        break;
    }
    drawEmptyBox(canvas, color: Colors.black);
  }

  void drawEmptyBox(Canvas canvas, {PaintingStyle paintingStyle = PaintingStyle.stroke, Color? color}) {
    var paint = _defaultPaint
      ..style = paintingStyle
      ..color = color ?? _defaultPaint.color;
    double x = point.x.toDouble();
    double y = point.y.toDouble();

    var path = Path();
    path.moveTo(x, y);
    path.lineTo(x + side, y);
    path.lineTo(x + side, y + side);
    path.lineTo(x, y + side);
    path.lineTo(x, y);

    canvas.drawPath(path, paint);
  }

  void drawFilledBox(Canvas canvas) => drawEmptyBox(canvas, paintingStyle: PaintingStyle.fill);

  void drawCrossBox(Canvas canvas) {
    drawEmptyBox(canvas);
    double x = point.x.toDouble();
    double y = point.y.toDouble();

    var paint = _defaultPaint..style = PaintingStyle.stroke;
    var path = Path();

    path.moveTo(x, y);
    path.lineTo(x + side, y + side);
    path.moveTo(x + side, y);
    path.lineTo(x, y + side);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
    throw UnimplementedError();
  }
}
