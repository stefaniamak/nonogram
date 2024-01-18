import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/solver/solver.dart';

class NonogramPage extends HookWidget {
  final Nonogram nonogram;

  const NonogramPage({
    required this.nonogram,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var nonogramState = useNonogramState(nonogram);

    return Column(
      children: [
        NonogramGridAndClues(
          nonogram: nonogram,
          nonogramState: nonogramState,
          padding: const EdgeInsets.all(32),
        ),
        InkWell(
          onTap: () {
            // todo: build draft/empty solver structure #17 https://github.com/stefaniamak/nonogram/issues/17
            var solution = Solver().solve(nonogramState);
            // int i = 0;
            // for (String s in solution.solution.characters) {
            //   if (s == "0") {
            //     nonogramState.setCross(i);
            //   } else if (s == "1") {
            //     nonogramState.setFilled(i);
            //   }
            //   i++;
            // }
          },
          child: const SizedBox(
            height: 50,
            width: 80,
            child: Center(child: Text('Solve')),
          ),
        )
      ],
    );
  }
}
