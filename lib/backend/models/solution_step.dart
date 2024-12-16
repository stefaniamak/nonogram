import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'solution_step.g.dart';

/// A class representing a step in the solution process of a nonogram.
@JsonSerializable()
class SolutionStep {
  /// Creates a new [SolutionStep].
  const SolutionStep({
    required this.currentSolution,
    required this.explanation,
    required this.newFilledBoxes,
    this.axis,
    this.lineIndex,
  });

  factory SolutionStep.fromJson(final Map<String, dynamic> json) => _$SolutionStepFromJson(json);

  /// The current state of the solution as a string.
  final String currentSolution;

  /// A description or explanation of the step.
  final String explanation;

  /// A list of indices of newly filled boxes.
  final List<int> newFilledBoxes;

  /// An optional axis (row or column) related to the step.
  final NonoAxis? axis;

  /// An optional index of the line related to the step.
  final int? lineIndex;

  /// Updates the current solution by replacing a character at the specified index with a new value.
  ///
  /// * [index]: The index of the character to replace.
  /// * [value]: The new value to insert at the specified index.
  /// Returns the updated solution string.
  String getUpdatedSolution(int index, String value) => currentSolution.replaceRange(index, index + 1, value);

  Map<String, dynamic> toJson() => _$SolutionStepToJson(this);

  static List<SolutionStep> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => SolutionStep.fromJson(item)).toList();
}
