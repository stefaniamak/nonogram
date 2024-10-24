import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class GridBox extends CustomPainter {
  final PointState pointState;
  final double side;
  final bool isHighlighted;

  GridBox({
    super.repaint,
    required this.pointState,
    this.side = 20,
    this.isHighlighted = false,
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
        drawEmptyBox(canvas);
        break;
      case PointState.filled:
        drawFilledBox(canvas);
        break;
      case PointState.cross:
        drawCrossBox(canvas);
        break;
    }
  }

  void drawEmptyBox(Canvas canvas, [PaintingStyle paintingStyle = PaintingStyle.stroke]) {
    var paint = _defaultPaint..style = paintingStyle;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(side, 0);
    path.lineTo(side, side);
    path.lineTo(0, side);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  void drawFilledBox(Canvas canvas) => drawEmptyBox(canvas, PaintingStyle.fill);

  void drawCrossBox(Canvas canvas) {
    drawEmptyBox(canvas);

    var paint = _defaultPaint..style = PaintingStyle.stroke;
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(side, side);
    path.moveTo(side, 0);
    path.lineTo(0, side);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
    throw UnimplementedError();
  }
}
