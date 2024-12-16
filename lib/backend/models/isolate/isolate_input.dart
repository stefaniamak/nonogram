import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/solver_settings.dart';
import 'package:nonogram/backend/models/solution_step.dart';

part 'isolate_input.g.dart';

/// A class representing the input for an isolate in the nonogram solver.
@JsonSerializable()
class IsolateInput {
  /// Creates a new [IsolateInput].
  const IsolateInput({
    required this.nonogram,
    required this.solutionSteps,
    this.solverSettings = const SolverSettings(),
  });

  factory IsolateInput.fromJson(final Map<String, dynamic> json) => _$IsolateInputFromJson(json);

  /// The nonogram puzzle to be solved.
  final IsolateNonogram nonogram;

  /// A list of steps taken to solve the nonogram.
  final List<SolutionStep> solutionSteps;

  /// Optional settings for the solver.
  final SolverSettings solverSettings;

  Map<String, dynamic> toJson() => _$IsolateInputToJson(this);

  static List<IsolateInput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateInput.fromJson(item)).toList();
}
