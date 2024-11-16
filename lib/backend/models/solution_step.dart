import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'solution_step.g.dart';

@JsonSerializable()
class SolutionStep {
  const SolutionStep({
    required this.currentSolution,
    this.lineSolution,
    this.axis,
    this.isNote,
    this.lineIndex,
    required this.explanation,
    required this.newFilledBoxes,
  });

  final String currentSolution;
  final List<List<String>>? lineSolution;
  final NonoAxis? axis;
  final bool? isNote;
  final int? lineIndex;
  final String explanation;
  final List<int> newFilledBoxes;

  String getUpdatedSolution(int index, String value) => currentSolution.replaceRange(index, index + 1, value);

  factory SolutionStep.fromJson(final Map<String, dynamic> json) => _$SolutionStepFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionStepToJson(this);

  static List<SolutionStep> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => SolutionStep.fromJson(item)).toList();
}
