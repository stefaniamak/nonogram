import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class NonogramGridAndClues extends HookWidget {
  const NonogramGridAndClues({super.key});

  @override
  Widget build(BuildContext context) {
    Nonogram draftNono = Nonograms().dancer;
    var nonogramState = useNonogramState(draftNono);

    final gridWidth = MediaQuery.of(context).size.width * 50 / 100;
    return Scaffold(
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('game home pageeeeeeeeee'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('test 1'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('test 2'),
                    NonogramGrid(
                      nonogramState: nonogramState,
                      gridWidth: gridWidth,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
