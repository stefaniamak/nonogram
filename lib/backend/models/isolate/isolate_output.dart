import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/solution_step.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

part 'isolate_output.g.dart';

@JsonSerializable()
class IsolateOutput extends Equatable {
  const IsolateOutput({
    this.stack = const <Map<int, NonoAxis>>[],
    this.solutionSteps = const <SolutionStep>[],
    this.cachedBoxSolutions = const {},
    this.linesCheckedList = const [0], // const {'linesChecked': 0},
    this.boxesChecked = 0,
    this.actualBoxesChecked = 0,
    this.otherBoxesChecked = 0,
  });

  final List<Map<int, NonoAxis>> stack;
  final List<SolutionStep> solutionSteps;
  final Map<String, bool> cachedBoxSolutions;
  final List<int> linesCheckedList;
  final int boxesChecked;
  final int actualBoxesChecked;
  final int otherBoxesChecked;

  int get linesChecked => linesCheckedList.length;

  factory IsolateOutput.fromJson(final Map<String, dynamic> json) => _$IsolateOutputFromJson(json);

  Map<String, dynamic> toJson() => _$IsolateOutputToJson(this);

  static List<IsolateOutput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateOutput.fromJson(item)).toList();

  IsolateOutput copyWith({
    final List<Map<int, NonoAxis>>? stack,
    final List<SolutionStep>? solutionSteps,
    final Map<String, bool>? cachedBoxSolutions,
    final List<int>? linesCheckedList,
    final int? boxesChecked,
    final int? actualBoxesChecked,
    final int? otherBoxesChecked,
  }) {
    return IsolateOutput(
      stack: stack ?? this.stack,
      solutionSteps: solutionSteps ?? this.solutionSteps,
      cachedBoxSolutions: cachedBoxSolutions ?? this.cachedBoxSolutions,
      linesCheckedList: linesCheckedList ??
          this.linesCheckedList, // linesCheckedList != null ? {'linesCheckedList': linesCheckedList} : this.linesCheckedList,
      boxesChecked: boxesChecked ?? this.boxesChecked,
      actualBoxesChecked: actualBoxesChecked ?? this.actualBoxesChecked,
      otherBoxesChecked: otherBoxesChecked ?? this.otherBoxesChecked,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        stack,
        solutionSteps,
        cachedBoxSolutions,
        linesCheckedList,
        linesChecked,
        boxesChecked,
        actualBoxesChecked,
        otherBoxesChecked,
      ];
}
