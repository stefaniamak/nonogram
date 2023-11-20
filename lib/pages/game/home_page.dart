import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/nono_tabs_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
    return NonoTabsPage(
      body: body(context),
    );
  }

  Column body(BuildContext context) {
    Nonogram draftNono = Nonogram((n) => n
      ..columns = 10
      ..rows = 10);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('game home pageeeeeeeeee'),
        Center(
          child: CustomPaint(
            size: Size(400, 400),
            painter: NonogramGrid(nonogram: draftNono),
          ),
        ),
      ],
    );
  }
}

enum PointState { empty, filled, cross }

class NonogramGrid extends CustomPainter {
  final Nonogram nonogram;

  NonogramGrid({super.repaint, required this.nonogram});

  @override
  void paint(Canvas canvas, Size size) {
    double side = size.width / nonogram.columns;

    print('side: $side');

    Map<String, PointState> pS1 = {
      '{0: 0}': PointState.cross,
      '{0: 2}': PointState.cross,
      '{1: 1}': PointState.filled,
      '{2: 2}': PointState.empty,
    };

    for (var r = 0; r < nonogram.rows; r++) {
      for (var c = 0; c < nonogram.columns; c++) {
        // print('pS1: ${pS1}');
        // print('{r: c}: ${{r: c}}');
        // print('pS1[{r: c}]: ${pS1[{r: c}.toString()]}');
        // print('pS1[{0: 0}]: ${pS1[{0: 0}.toString()]}');
        switch (pS1[{r: c}.toString()] ?? PointState.empty) {
          case PointState.empty:
            {
              drawEmptyBox(canvas, Size(r * side, c * side), side);
            }
            break;
          case PointState.filled:
            {
              print('filled');
              drawFilledBox(canvas, Size(r * side, c * side), side);
            }
            break;
          case PointState.cross:
            drawCrossBox(canvas, Size(r * side, c * side), side);
        }

        // drawEmptyBox(canvas, Size(r * side, c * side), side);
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
