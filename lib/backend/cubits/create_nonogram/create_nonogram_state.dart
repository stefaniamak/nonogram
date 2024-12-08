import 'package:nonogram/backend/cubits/create_nonogram/editing_settings.dart';
import 'package:nonogram/backend/cubits/create_nonogram/selected_line.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

const int _baseValue = 5;

/// Represents the state of creating a Nonogram.
class CreateNonogramState {
  /// Creates a new instance of [CreateNonogramState].
  CreateNonogramState({
    this.width = _baseValue,
    this.height = _baseValue,
    List<List<int>>? horizontalClues,
    List<List<int>>? verticalClues,
    String? solution,
    this.selectedLine,
    this.editingSettings = const EditingSettings(),
  })  : horizontalClues = horizontalClues ?? List<List<int>>.generate(width, (_) => <int>[0]),
        verticalClues = verticalClues ?? List<List<int>>.generate(height, (_) => <int>[0]),
        solution = solution ?? List<String>.filled(width * height, '?').join();

  /// The width of the Nonogram grid.
  final int width;

  /// The height of the Nonogram grid.
  final int height;

  /// The horizontal clues for the Nonogram.
  final List<List<int>> horizontalClues;

  /// The vertical clues for the Nonogram.
  final List<List<int>> verticalClues;

  /// The solution string for the Nonogram.
  final String solution;

  /// The currently selected line for editing.
  final SelectedLine? selectedLine;

  /// The settings for editing the Nonogram.
  final EditingSettings editingSettings;

  /// Returns an [IsolateNonogram] representation of the current state.
  IsolateNonogram get nonogram => IsolateNonogram(
        id: "-",
        clues: IsolateClues(columns: horizontalClues, rows: verticalClues),
        info: const IsolateNonogramInfo(title: 'Custom Puzzle', author: 'You'),
      );

  /// Creates a copy of the current state with the given parameters.
  ///
  /// Returns a new instance of [CreateNonogramState] with the updated values.
  CreateNonogramState copyWith({
    final int? width,
    final int? height,
    final List<List<int>>? horizontalClues,
    final List<List<int>>? verticalClues,
    final String? solution,
    final SelectedLine? selectedLine,
    final EditingSettings? editingSettings,
  }) {
    return CreateNonogramState(
      width: width ?? this.width,
      height: height ?? this.height,
      horizontalClues: horizontalClues ?? this.horizontalClues,
      verticalClues: verticalClues ?? this.verticalClues,
      solution: solution ?? this.solution,
      selectedLine: selectedLine ?? this.selectedLine,
      editingSettings: editingSettings ?? this.editingSettings,
    );
  }
}
