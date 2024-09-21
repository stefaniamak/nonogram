import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/solver_settings.dart';
import 'package:nonogram/backend/models/solution_step.dart';

part 'isolate_input.g.dart';

@JsonSerializable()
class IsolateInput {
  const IsolateInput({
    required this.nonogram,
    required this.solutionSteps,
    this.solverSettings = const SolverSettings(),
  });

  final IsolateNonogram nonogram;
  final List<SolutionStep> solutionSteps;
  final SolverSettings solverSettings;

  factory IsolateInput.fromJson(final Map<String, dynamic> json) => _$IsolateInputFromJson(json);

  Map<String, dynamic> toJson() => _$IsolateInputToJson(this);

  static List<IsolateInput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateInput.fromJson(item)).toList();
}
