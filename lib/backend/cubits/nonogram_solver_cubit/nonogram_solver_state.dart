part of 'nonogram_solver_cubit.dart';

enum SolverStatus { initial, solving, solved, notSolved }

extension SolverStatusExtension on SolverStatus {
  bool get isCompleted => this == SolverStatus.solved || this == SolverStatus.notSolved;
}

class NonogramSolverState {
  const NonogramSolverState({
    this.solverStatus = SolverStatus.initial,
    this.nonogram,
    this.solverSettings = const SolverSettings(),
    this.solutionSteps = const <SolutionStep>[],
    this.stepNumber = 0,
    this.stack = const <Map<int, NonoAxis>>[],
    this.startDateTime,
    this.endingDateTime,
    this.linesChecked = 0,
    this.boxesChecked = 0,
    this.actualBoxesChecked = 0,
    this.otherBoxesChecked = 0,
    this.cachedBoxSolutions = const {},
  });

  // Main variables
  final SolverStatus solverStatus;
  final IsolateNonogram? nonogram;

  // Settings
  final SolverSettings solverSettings;

  // Results
  final List<SolutionStep> solutionSteps;
  final int stepNumber;
  final List<Map<int, NonoAxis>> stack;
  final DateTime? startDateTime;
  final DateTime? endingDateTime; // TODO(stef): change to endDateTime
  final int linesChecked;
  final int boxesChecked;
  final int actualBoxesChecked;
  final int otherBoxesChecked;
  final Map<String, bool> cachedBoxSolutions;

  NonogramSolverState copyWith({
    final SolverStatus? solverStatus,
    final IsolateNonogram? nonogram,
    final SolverSettings? solverSettings,
    final List<SolutionStep>? solutionSteps,
    final int? stepNumber,
    final List<Map<int, NonoAxis>>? stack,
    final DateTime? startDateTime,
    final DateTime? endingDateTime,
    final int? linesChecked,
    final int? boxesChecked,
    final int? actualBoxesChecked,
    final int? otherBoxesChecked,
    final Map<String, bool>? cachedBoxSolutions,
  }) {
    return NonogramSolverState(
      solverStatus: solverStatus ?? this.solverStatus,
      nonogram: nonogram ?? this.nonogram,
      solverSettings: solverSettings ?? this.solverSettings,
      solutionSteps: solutionSteps ?? this.solutionSteps,
      stepNumber: stepNumber ?? this.stepNumber,
      stack: stack ?? this.stack,
      startDateTime: startDateTime ?? this.startDateTime,
      endingDateTime: endingDateTime ?? this.endingDateTime,
      linesChecked: linesChecked ?? this.linesChecked,
      boxesChecked: boxesChecked ?? this.boxesChecked,
      actualBoxesChecked: actualBoxesChecked ?? this.actualBoxesChecked,
      otherBoxesChecked: otherBoxesChecked ?? this.otherBoxesChecked,
      cachedBoxSolutions: cachedBoxSolutions ?? this.cachedBoxSolutions,
    );
  }
}
