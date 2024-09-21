import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'isolate_output.g.dart';

@JsonSerializable()
class IsolateOutput {
  const IsolateOutput({
    required this.stack,
    required this.solutionSteps,
  });

  final List<Map<int, NonoAxis>> stack;
  final List<SolutionStep> solutionSteps;

  factory IsolateOutput.fromJson(final Map<String, dynamic> json) => _$IsolateOutputFromJson(json);

  Map<String, dynamic> toJson() => _$IsolateOutputToJson(this);

  static List<IsolateOutput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateOutput.fromJson(item)).toList();
}
