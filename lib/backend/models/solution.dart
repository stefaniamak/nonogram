import 'package:built_value/built_value.dart';
import 'package:nonogram/backend/models/solution_type.dart';

part 'solution.g.dart';

abstract class Solution implements Built<Solution, SolutionBuilder> {
  SolutionType get type;
  String? get image;
  String? get solution;

  String? get solutionFromImage => image
      ?.replaceAll('\n', '')
      .replaceAll('|', '')
      .replaceAll('.', '0')
      .replaceAll('X', '1');

  Solution._();
  factory Solution([void Function(SolutionBuilder) updates]) = _$Solution;
}
