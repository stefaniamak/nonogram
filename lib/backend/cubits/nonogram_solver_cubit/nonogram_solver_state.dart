part of 'nonogram_solver_cubit.dart';

enum SolverStatus { initial, solving, solved, notSolved }

extension SolverStatusExtension on SolverStatus {
  bool get isCompleted => this == SolverStatus.solved || this == SolverStatus.notSolved;
  bool get canEdit => this == SolverStatus.initial;
  bool get isSolving => this == SolverStatus.solving;
}

class NonogramSolverState extends Equatable {
  const NonogramSolverState({
    this.solverStatus = SolverStatus.initial,
    this.nonogram,
    this.solverSettings = const SolverSettings(),
    this.output = const IsolateOutput(),
    this.startDateTime,
    this.endingDateTime,
    this.stepNumber = 0,
  });

  // Main variables
  final SolverStatus solverStatus;
  final IsolateNonogram? nonogram;

  // Settings
  final SolverSettings solverSettings;

  // Outputs
  final IsolateOutput output;
  final DateTime? startDateTime;
  final DateTime? endingDateTime; // TODO(stef): change to endDateTime

  // UI
  final int stepNumber;

  NonogramSolverState copyWith({
    final SolverStatus? solverStatus,
    final IsolateNonogram? nonogram,
    final SolverSettings? solverSettings,
    final int? stepNumber,
    final IsolateOutput? output,
    final Nullable<DateTime>? startDateTime,
    final Nullable<DateTime>? endingDateTime,
  }) {
    return NonogramSolverState(
      solverStatus: solverStatus ?? this.solverStatus,
      nonogram: nonogram ?? this.nonogram,
      solverSettings: solverSettings ?? this.solverSettings,
      stepNumber: stepNumber ?? this.stepNumber,
      output: output ?? this.output,
      startDateTime: startDateTime == null ? this.startDateTime : startDateTime.value,
      endingDateTime: endingDateTime == null ? this.endingDateTime : endingDateTime.value,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        solverStatus,
        nonogram,
        solverSettings,
        output,
        startDateTime,
        endingDateTime,
        stepNumber,
      ];
}
