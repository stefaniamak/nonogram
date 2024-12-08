/// Enum representing the status of the solver.
enum SolverStatus {
  /// Initial state of the solver.
  initial,

  /// Solver is currently solving.
  solving,

  /// Solver has successfully solved the puzzle.
  solved,

  /// Solver has not solved the puzzle.
  notSolved
}

/// Extension on [SolverStatus] to provide additional utility methods.
extension SolverStatusExtension on SolverStatus {
  /// Checks if the solver has completed its task.
  bool get isCompleted => this == SolverStatus.solved || this == SolverStatus.notSolved;

  /// Checks if the solver is in an editable state.
  bool get canEdit => this == SolverStatus.initial;

  /// Checks if the solver is currently solving.
  bool get isSolving => this == SolverStatus.solving;
}
