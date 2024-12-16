import 'package:flutter/material.dart';

/// Represents a selected line in the Nonogram grid.
class SelectedLine {
  /// Creates a new instance of [SelectedLine].
  const SelectedLine({
    required this.axis,
    required this.index,
    required this.clues,
  });

  /// The axis of the selected line (horizontal or vertical).
  final Axis axis;

  /// The index of the selected line.
  final int index;

  /// The clues associated with the selected line.
  final List<int> clues;

  /// Creates a copy of the current [SelectedLine] with the given parameters.
  ///
  /// Returns a new instance of [SelectedLine] with the updated values.
  SelectedLine copyWith({
    Axis? axis,
    int? index,
    List<int>? clues,
  }) {
    return SelectedLine(
      axis: axis ?? this.axis,
      index: index ?? this.index,
      clues: clues ?? this.clues,
    );
  }
}
