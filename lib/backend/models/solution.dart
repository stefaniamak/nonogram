import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as m;
import 'package:nonogram/backend/models/solution_type.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

import 'nonogram.dart';

part 'solution.g.dart';

abstract class Solution implements Built<Solution, SolutionBuilder> {
  SolutionType get type;
  String? get image;
  String? get solution;

  String? get solutionFromImage =>
      image?.replaceAll('\n', '').replaceAll('|', '').replaceAll('.', '0').replaceAll('X', '1');

  void printSolution() {
    print('Image:');
    print(image ?? 'No Image');
    print(solution ?? 'No Solution');
  }

  String getLine(int index, Nonogram nonogram, NonoAxis lineType) {
    switch (lineType) {
      case NonoAxis.row:
        return getRow(index, nonogram);
      case NonoAxis.column:
        return getColumn(index, nonogram);
    }
  }

  String getRow(int index, Nonogram nonogram) =>
      solution!.characters.getRange(index * nonogram.width, nonogram.width * (index + 1)).string;

  String getColumn(int index, Nonogram nonogram) {
    String columnSol = '';
    for (var solChar = index; solChar < solution!.characters.length; solChar = solChar + nonogram.width) {
      columnSol = '$columnSol${solution!.characters.characterAt(solChar)}';
    }
    return columnSol;
  }

  Solution._();
  factory Solution([void Function(SolutionBuilder) updates]) = _$Solution;
}
