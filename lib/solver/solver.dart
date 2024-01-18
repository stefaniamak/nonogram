import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/solver/line_solver.dart';

class Solution {
  final String solution;
  final String? note;

  Solution({required this.solution, this.note});
}

class Solver {
  Solution solve(NonogramState state) {
    String solution = state.activeSolution;
    solution = LineSolver().lineSolver(state);
    return Solution(
      solution: '01100011010010101110101001010000110010100101111000',
      note: 'solver run',
    );
  }
}
