import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'isolate_output.g.dart';

/// A class representing the output of an isolate in the nonogram solver.
@JsonSerializable()
class IsolateOutput {
  /// Creates a new [IsolateOutput].
  const IsolateOutput({
    this.stack = const <Map<int, NonoAxis>>[],
    this.solutionSteps = const <SolutionStep>[],
    this.cachedBoxSolutions = const <String, bool>{},
    this.linesCheckedList = const <int>[0],
    this.boxesCheckedList = const <int>[0],
    this.actualBoxesChecked = 0,
    this.otherBoxesCheckedList = const <int>[0],
    this.linesChecked = 0,
    this.boxesChecked = 0,
    this.otherBoxesChecked = 0,
    this.totalCacheData = 0,
  });

  factory IsolateOutput.fromJson(final Map<String, dynamic> json) => _$IsolateOutputFromJson(json);

  /// A list of maps representing the stack of nonogram axes to be imported
  /// to the solver algorithm.
  final List<Map<int, NonoAxis>> stack;

  /// The list of steps taken to solve the nonogram.
  final List<SolutionStep> solutionSteps;

  /// A map of cached box solutions.
  final Map<String, bool> cachedBoxSolutions;

  /// A list of integers representing the lines checked.
  final List<int> linesCheckedList;

  /// A list of integers representing the boxes checked.
  final List<int> boxesCheckedList;

  /// The actual number of boxes checked.
  final int actualBoxesChecked;

  /// A list of integers representing other boxes checked.
  final List<int> otherBoxesCheckedList;

  /// The number of lines checked.
  final int linesChecked;

  /// The number of boxes checked.
  final int boxesChecked;

  /// The number of other boxes checked.
  final int otherBoxesChecked;

  /// The total cache data.
  final int totalCacheData;

  Map<String, dynamic> toJson() => _$IsolateOutputToJson(this);

  static List<IsolateOutput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateOutput.fromJson(item)).toList();

  /// Creates a copy of the current [IsolateOutput] instance with updated values.
  IsolateOutput copyWith({
    final List<Map<int, NonoAxis>>? stack,
    final List<SolutionStep>? solutionSteps,
    final Map<String, bool>? cachedBoxSolutions,
    final List<int>? linesCheckedList,
    final List<int>? boxesCheckedList,
    final int? actualBoxesChecked,
    final List<int>? otherBoxesCheckedList,
    final int? linesChecked,
    final int? boxesChecked,
    final int? otherBoxesChecked,
    final int? totalCacheData,
  }) {
    return IsolateOutput(
      stack: stack ?? this.stack,
      solutionSteps: solutionSteps ?? this.solutionSteps,
      cachedBoxSolutions: cachedBoxSolutions ?? this.cachedBoxSolutions,
      linesCheckedList: linesCheckedList ?? this.linesCheckedList,
      boxesCheckedList: boxesCheckedList ?? this.boxesCheckedList,
      actualBoxesChecked: actualBoxesChecked ?? this.actualBoxesChecked,
      otherBoxesCheckedList: otherBoxesCheckedList ?? this.otherBoxesCheckedList,
      linesChecked: linesChecked ?? this.linesChecked,
      boxesChecked: boxesChecked ?? this.boxesChecked,
      otherBoxesChecked: otherBoxesChecked ?? this.otherBoxesChecked,
      totalCacheData: totalCacheData ?? this.totalCacheData,
    );
  }
}
