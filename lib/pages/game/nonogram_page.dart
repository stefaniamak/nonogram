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
    // left most solution

    /// Loop all puzzle rows.
    for (var i = 0; i < state.nonogram.clues!.rows.length; i++) {
      /// Gets [i] row's clues.
      List<int> rowClue = state.nonogram.clues!.rows.elementAt(i);

      /// Gets current active solution of that [i] row.
      String row = state.activeSolution.characters
          .getRange(i * state.nonogram.width, state.nonogram.width * (i + 1))
          .string;

      print('row: $row');
      print('rowClue: $rowClue');

      /// Finds leftmost solution.
      String leftSolution = row;
      for (int a = 0; a < rowClue.length; a++) {
        int clue = rowClue.elementAt(a);

        /// Replaces all next "?" clue times with the clue's index.
        leftSolution = leftSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (a + 1).toString()).join(),
        );

        /// Adds an "0" as the next character after the clue solution.
        leftSolution = leftSolution.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
      }
      print('leftSolution:  $leftSolution');

      /// Finds rightMost solution.
      String rightSolution = row;
      for (int b = rowClue.length - 1; b >= 0; b--) {
        int clue = rowClue.elementAt(b);

        /// Replaces all next "?" clue times with the clue's index.
        rightSolution = rightSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (b + 1).toString()).join(),
        );

        /// Adds an "0" as the next character after the clue solution.
        rightSolution = rightSolution.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
        rightSolution = rightSolution;
      }

      /// Reverses the solution to be accurate.
      rightSolution = rightSolution.split('').reversed.join();
      print('rightSolution: $rightSolution');

      /// Loop [i] row's fields, and find matches in between the leftMost
      /// and rightMost solutions.
      for (int j = 0; j < row.length; j++) {
        print('n: $leftSolution');
        print('n.split('
            ').elementAt(j): ${leftSolution.split('').elementAt(j)}');
        print('n2: $rightSolution');
        print('n2.split('
            ').elementAt(j): ${rightSolution.split('').elementAt(j)}');
        print('i * j ${i * state.nonogram.width + j}');

        var leftSolutionElement = leftSolution.split('').elementAt(j);
        var rightSolutionElement = rightSolution.split('').elementAt(j);
        if ((leftSolutionElement == rightSolutionElement) &&
            leftSolutionElement != '?' &&
            leftSolutionElement != '0' &&
            rightSolutionElement != '?' &&
            rightSolutionElement != '0') {
          state.setFilled(i * state.nonogram.width + j);
        }
      }
    }

    /// Loop all puzzle columns.
    for (var c = 0; c < state.nonogram.clues!.columns.length; c++) {
      /// Gets [i] column's clues.
      List<int> columnClue = state.nonogram.clues!.columns.elementAt(c);

      /// Gets current active solution of that [i] column.
      String columnSol = '';
      for (var solChar = 0;
          solChar < state.nonogram.width * state.nonogram.height;
          solChar = solChar + state.nonogram.width) {
        columnSol =
            '${columnSol}${state.activeSolution.characters.characterAt(solChar)}';
      }

      print('columnSols: $columnSol');
      print('columnClue: $columnClue');

      /// Finds leftmost solution.
      String leftSolution = columnSol;
      for (int a = 0; a < columnClue.length; a++) {
        int clue = columnClue.elementAt(a);

        /// Replaces all next "?" clue times with the clue's index.
        leftSolution = leftSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (a + 1).toString()).join(),
        );

        /// Adds an "0" as the next character after the clue solution.
        leftSolution = leftSolution.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
      }
      print('leftSolution:  $leftSolution');

      /// Finds rightMost solution.
      String rightSolution = columnSol;
      for (int b = columnClue.length - 1; b >= 0; b--) {
        int clue = columnClue.elementAt(b);

        /// Replaces all next "?" clue times with the clue's index.
        rightSolution = rightSolution.replaceFirstMapped(
          Iterable.generate(clue, (_) => '?').join(),
          (m) => Iterable.generate(clue, (_) => (b + 1).toString()).join(),
        );

        /// Adds an "0" as the next character after the clue solution.
        rightSolution = rightSolution.replaceFirstMapped(
          Iterable.generate(1, (_) => '?').join(),
          (m) => Iterable.generate(1, (_) => '0').join(),
        );
        rightSolution = rightSolution;
      }

      /// Reverses the solution to be accurate.
      rightSolution = rightSolution.split('').reversed.join();
      print('rightSolution: $rightSolution');

      /// Loop [i] column's fields, and find matches in between the leftMost
      /// and rightMost solutions.
      for (int j = 0; j < columnSol.length; j++) {
        print('n: $leftSolution');
        print('n.split('
            ').elementAt(j): ${leftSolution.split('').elementAt(j)}');
        print('n2: $rightSolution');
        print('n2.split('
            ').elementAt(j): ${rightSolution.split('').elementAt(j)}');
        print('i * j ${c * state.nonogram.width + j}');

        var leftSolutionElement = leftSolution.split('').elementAt(j);
        var rightSolutionElement = rightSolution.split('').elementAt(j);
        if ((leftSolutionElement == rightSolutionElement) &&
            leftSolutionElement != '?' &&
            leftSolutionElement != '0' &&
            rightSolutionElement != '?' &&
            rightSolutionElement != '0') {
          state.setFilled(c + j * state.nonogram.width);
        }
      }
    }

    return state.activeSolution;
  }
}
