import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

class NonogramGrid extends CustomPainter {
  final NonogramState nonogramState;

  NonogramGrid({super.repaint, required this.nonogramState});

  @override
  void paint(Canvas canvas, Size size) {
    var nonogram = nonogramState.nonogram;
    double side = size.width / nonogram.columns;

    print('side: $side');

    for (var r = 0; r < nonogram.rows; r++) {
      for (var c = 0; c < nonogram.columns; c++) {
        switch (nonogramState.activeSolution[Point(r, c)] ?? PointState.empty) {
          case PointState.empty:
            drawEmptyBox(canvas, Size(r * side, c * side), side);
            break;
          case PointState.filled:
            drawFilledBox(canvas, Size(r * side, c * side), side);
            break;
          case PointState.cross:
            drawCrossBox(canvas, Size(r * side, c * side), side);
            break;
        }
      }
    }
  }

  void drawEmptyBox(Canvas canvas, Size s, double side) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(s.width, s.height);
    path.lineTo(s.width + side, s.height);
    path.lineTo(s.width + side, s.height + side);
    path.lineTo(s.width, s.height + side);
    path.lineTo(s.width, s.height);
    canvas.drawPath(path, paint);
  }

  void drawFilledBox(Canvas canvas, Size s, double side) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(s.width, s.height);
    path.lineTo(s.width + side, s.height);
    path.lineTo(s.width + side, s.height + side);
    path.lineTo(s.width, s.height + side);
    path.lineTo(s.width, s.height);
    canvas.drawPath(path, paint);
  }

  void drawCrossBox(Canvas canvas, Size s, double side) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(s.width, s.height);
    path.lineTo(s.width + side, s.height + side);
    path.moveTo(s.width + side, s.height);
    path.lineTo(s.width, s.height + side);

    path.moveTo(s.width, s.height);
    path.lineTo(s.width + side, s.height);
    path.lineTo(s.width + side, s.height + side);
    path.lineTo(s.width, s.height + side);
    path.lineTo(s.width, s.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    throw UnimplementedError();
  }
}
