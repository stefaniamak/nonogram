import 'package:flutter/material.dart';

class SelectedLine {
  const SelectedLine({
    required this.axis,
    required this.index,
    required this.clues,
  });

  final Axis axis;
  final int index;
  final List<int> clues;

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
