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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('game home pageeeeeeeeee'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('test 1'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('test 2'),
                  NonogramGrid(
                    nonogramState: nonogramState,
                    gridWidth: MediaQuery.of(context).size.width * 70 / 100,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
