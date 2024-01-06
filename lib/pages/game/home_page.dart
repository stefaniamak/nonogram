import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/nono_tabs_page.dart';

class HomePage extends HookWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Nonogram draftNono = Nonograms().dancer;
    print('image:');
    print('${draftNono.solutions?.first.image}');
    print('${draftNono.solutions?.first.solutionFromImage}');
    var nonogramState = useNonogramState(draftNono);
    return Scaffold(body: body(context, nonogramState));
    return NonoTabsPage(
      body: body(context, nonogramState),
    );
  }

  Column body(BuildContext context, NonogramState nonogramState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('game home pageeeeeeeeee'),
        Center(
          child: CustomPaint(
            size: Size(400, 400),
            painter: NonogramGrid(nonogramState: nonogramState),
          ),
        ),
      ],
    );
  }
}

enum PointState { empty, filled, cross }

class NonogramGrid extends CustomPainter {
  final NonogramState nonogramState;

  NonogramGrid({super.repaint, required this.nonogramState});

  @override
  void paint(Canvas canvas, Size size) {
    var nonogram = nonogramState.nonogram;
    double side = size.width / nonogram.width;

    print('side: $side');

    for (var r = 0; r < nonogram.height; r++) {
      for (var c = 0; c < nonogram.width; c++) {
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
