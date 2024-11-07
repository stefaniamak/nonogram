import 'package:nonogram/backend/cubits/create_nonogram/selected_line.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

const int _baseValue = 5;

class CreateNonogramState {
  final int width;
  final int height;
  final List<List<int>> horizontalClues;
  final List<List<int>> verticalClues;
  final String solution;
  final SelectedLine? selectedLine;

  CreateNonogramState({
    this.width = _baseValue,
    this.height = _baseValue,
    List<List<int>>? horizontalClues,
    List<List<int>>? verticalClues,
    String? solution,
    this.selectedLine,
  })  : horizontalClues = horizontalClues ?? List<List<int>>.generate(width, (_) => <int>[0]),
        verticalClues = verticalClues ?? List<List<int>>.generate(height, (_) => <int>[0]),
        solution = solution ?? Iterable.generate(width * height, (_) => '?').join();
  // assert(horizontalClues != null && horizontalClues.length == width),
  // assert(verticalClues != null && verticalClues.length == height),
  // assert(solution != null && solution.length == width * height);

  IsolateNonogram get nonogram => IsolateNonogram(
        id: "-",
        clues: IsolateClues(
          columns: horizontalClues,
          rows: verticalClues,
        ),
        info: const IsolateNonogramInfo(
          title: 'Custom Puzzle',
          author: 'You',
        ),
      );

  CreateNonogramState copyWith({
    final int? width,
    final int? height,
    final List<List<int>>? horizontalClues,
    final List<List<int>>? verticalClues,
    final String? solution,
    final SelectedLine? selectedLine,
  }) {
    return CreateNonogramState(
      width: width ?? this.width,
      height: height ?? this.height,
      horizontalClues: horizontalClues ?? this.horizontalClues,
      verticalClues: verticalClues ?? this.verticalClues,
      solution: solution ?? this.solution,
      selectedLine: selectedLine ?? this.selectedLine,
    );
  }
}
