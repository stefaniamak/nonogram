import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/nono_tabs_page.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class HomePage extends HookWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Nonogram draftNono = Nonogram((n) => n
      ..columns = 10
      ..rows = 10);
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
