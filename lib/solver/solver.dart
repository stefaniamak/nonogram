import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/solver/line_solver.dart';

class Solver {
  Solution? solve(NonogramState state) {
    String solution = state.activeSolution.solution!;
    // solution =
    LineSolver().solve(state);
    // return Solution(
    //   type:,
    //   solution: '01100011010010101110101001010000110010100101111000',
    // );
  }
}
