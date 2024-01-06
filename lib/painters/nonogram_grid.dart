import 'package:flutter/material.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';

enum PointState { empty, filled, cross }

class NonogramGrid extends CustomPainter {
  final NonogramState nonogramState;

  NonogramGrid({super.repaint, required this.nonogramState});

  @override
  void paint(Canvas canvas, Size size) {
    var nonogram = nonogramState.nonogram;
    double side = nonogram.width > nonogram.height
        ? size.width / nonogram.width
        : size.height / nonogram.height;

    print('side: $side');
    // print('nonogram.width: ${nonogram.width}');
    // print('nonogram.height: ${nonogram.height}');

    for (var r = 0; r < nonogram.height; r++) {
      for (var c = 0; c < nonogram.width; c++) {
        switch (PointState.empty) {
          //nonogramState.activeSolution[Point(c, r)] ??
          case PointState.empty:
            drawEmptyBox(canvas, Size(c * side, r * side), side);
            break;
          case PointState.filled:
            drawFilledBox(canvas, Size(c * side, r * side), side);
            break;
          case PointState.cross:
            drawCrossBox(canvas, Size(c * side, r * side), side);
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
