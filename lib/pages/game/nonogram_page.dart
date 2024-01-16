import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

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

class Solution {
  final String solution;
  final String? note;

  Solution({required this.solution, this.note});
}

class Solver {
  Solution solve(NonogramState state) {
    String solution = state.activeSolution;
    solution = lineSolver(state);
    return Solution(
      solution: '01100011010010101110101001010000110010100101111000',
      note: 'solver run',
    );
  }

  String lineSolver(NonogramState state) {
    print('I re-run?');
    // left most solution
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      // gets [i] row
      List<int> rowClue = state.nonogram.clues!.rows.elementAt(i);
      String row = state.activeSolution.characters
          .getRange(i * state.nonogram.width, state.nonogram.width * (i + 1))
          .string;
      print('row: $row');
      print('rowClue: $rowClue');

      String n = '';
      String n2 = '';
      // find leftmost solution
      String leftSolution = row;
      for (int a = 0; a < rowClue.length; a++) {
        int clue = rowClue.elementAt(a);
        // print('gen ? : ${Iterable.generate(clue, (_) => '?').join()}');
        // print('gen 1 : ${Iterable.generate(clue, (_) => '1').join()}');
        n = leftSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (a + 1).toString()).join(),
        );
        leftSolution = n.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
        n = leftSolution;
      }
      print('leftSolution:  $n');

      String rightSolution = row;
      for (int b = rowClue.length - 1; b >= 0; b--) {
        int clue = rowClue.elementAt(b);
        // print('gen ? : ${Iterable.generate(clue, (_) => '?').join()}');
        // print('gen 1 : ${Iterable.generate(clue, (_) => '1').join()}');
        n2 = rightSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (b + 1).toString()).join(),
        );
        rightSolution = n2.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
        n2 = rightSolution;
      }
      n2 = n2.split('').reversed.join();
      print('rightSolution: $n2');

      for (int j = 0; j < row.length; j++) {
        print('n: $n');
        print('n.split(' ').elementAt(j): ${n.split('').elementAt(j)}');
        print('n2: $n2');
        print('n2.split(' ').elementAt(j): ${n2.split('').elementAt(j)}');
        print('i * j ${i * state.nonogram.width + j}');

        var leftSolutionElement = n.split('').elementAt(j);
        var rightSolutionElement = n2.split('').elementAt(j);
        if ((leftSolutionElement == rightSolutionElement) &&
            leftSolutionElement != '?' &&
            leftSolutionElement != '0' &&
            rightSolutionElement != '?' &&
            rightSolutionElement != '0') {
          state.setFilled(i * state.nonogram.width + j);
        }
      }

      // for(int r in rs){
      //
      // }
    }

    return state.activeSolution;
  }
}
