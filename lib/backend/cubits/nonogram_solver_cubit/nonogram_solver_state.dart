part of 'nonogram_solver_cubit.dart';

/// Represents the state of the Nonogram solver.
class NonogramSolverState {
  /// Creates an instance of [NonogramSolverState].
  const NonogramSolverState({
    this.solverStatus = SolverStatus.initial,
    this.nonogram,
    this.solverSettings = const SolverSettings(),
    this.output = const IsolateOutput(),
    this.startDateTime,
    this.endDateTime,
    this.stepNumber = 0,
  });

  /// The current status of the solver.
  final SolverStatus solverStatus;

  /// The Nonogram puzzle being solved.
  final IsolateNonogram? nonogram;

  /// The settings for the solver.
  final SolverSettings solverSettings;

  /// The output of the solver.
  final IsolateOutput output;

  /// The start time of the solving process.
  final DateTime? startDateTime;

  /// The end time of the solving process.
  final DateTime? endDateTime;

  /// The current step number in the solving process.
  final int stepNumber;

  /// Returns the difference between the start and end times as a string.
  String get dateTimeDifference =>
      startDateTime != null ? (endDateTime ?? DateTime.now()).difference(startDateTime!).toString() : '-';

  /// Creates a copy of this state with the given fields replaced with new values.
  NonogramSolverState copyWith({
    final SolverStatus? solverStatus,
    final IsolateNonogram? nonogram,
    final SolverSettings? solverSettings,
    final int? stepNumber,
    final IsolateOutput? output,
    final Nullable<DateTime>? startDateTime,
    final Nullable<DateTime>? endDateTime,
  }) {
    return NonogramSolverState(
      solverStatus: solverStatus ?? this.solverStatus,
      nonogram: nonogram ?? this.nonogram,
      solverSettings: solverSettings ?? this.solverSettings,
      stepNumber: stepNumber ?? this.stepNumber,
      output: output ?? this.output,
      startDateTime: startDateTime == null ? this.startDateTime : startDateTime.value,
      endDateTime: endDateTime == null ? this.endDateTime : endDateTime.value,
    );
  }
}
