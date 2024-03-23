import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

class SolutionStep {
  final String currentSolution;
  final List<List<String>>? lineSolution;
  final NonoAxis? axis;
  final bool? isNote;
  final int? lineIndex;
  final String explanation;

  String getUpdatedSolution(int index, String value) => currentSolution.replaceRange(index, index + 1, value);

  SolutionStep({
    required this.currentSolution,
    this.lineSolution,
    this.axis,
    this.isNote,
    this.lineIndex,
    required this.explanation,
  });
}
