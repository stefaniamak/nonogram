import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/solution_step.dart';

import '../../type_extensions/nono_axis_extension.dart';

part 'isolate_input.g.dart';

@JsonSerializable()
class IsolateInput {
  const IsolateInput({
    required this.rows,
    required this.columns,
    required this.stack,
    required this.solutionSteps,
    required this.nonogram,
  });

  final List<List<int>> rows;
  final List<List<int>> columns;
  final List<Map<int, NonoAxis>> stack;
  final List<SolutionStep> solutionSteps;
  final IsolateNonogram nonogram;

  factory IsolateInput.fromJson(final Map<String, dynamic> json) => _$IsolateInputFromJson(json);

  Map<String, dynamic> toJson() => _$IsolateInputToJson(this);

  static List<IsolateInput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateInput.fromJson(item)).toList();
}
