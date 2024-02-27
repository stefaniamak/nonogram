import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

class SolutionStep {
  final String currentSolution;
  final NonoAxis axis;
  final bool isNote;
  final int lineIndex;
  final String explanation;

  SolutionStep({
    required this.currentSolution,
    required this.axis,
    required this.isNote,
    required this.lineIndex,
    required this.explanation,
  });
}
