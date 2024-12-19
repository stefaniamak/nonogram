import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_output.dart';
import 'package:nonogram/backend/models/solver_settings.dart';
import 'package:nonogram/backend/type_extensions/nono_direction_extension.dart';

part 'isolate_do_other_clues_fit_input.g.dart';

/// A class representing the input for an isolate in the nonogram solver.
@JsonSerializable()
class IsolateDoOtherCluesFitInput {
  /// Creates a new [IsolateDoOtherCluesFitInput].
  const IsolateDoOtherCluesFitInput({
    required this.solutionSide,
    required this.clues,
    required this.clueIndex,
    required this.solution,
    required this.solutionIndex,
    required this.output,
    required this.settings,
    this.printLogs = false,
  });

  factory IsolateDoOtherCluesFitInput.fromJson(final Map<String, dynamic> json) => _$IsolateDoOtherCluesFitInputFromJson(json);

  final NonoDirection solutionSide;
  final List<int> clues;
  final int clueIndex;
  final String solution;
  final int solutionIndex;
  final IsolateOutput output;
  final SolverSettings settings;
  final bool printLogs;

  Map<String, dynamic> toJson() => _$IsolateDoOtherCluesFitInputToJson(this);

  static List<IsolateDoOtherCluesFitInput> fromJsonList(final List<dynamic> json) => List<Map<String, dynamic>>.from(json)
      .map((Map<String, dynamic> item) => IsolateDoOtherCluesFitInput.fromJson(item))
      .toList();
}
