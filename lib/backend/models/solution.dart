import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:nonogram/backend/models/solution_type.dart';

part 'solution.g.dart';

abstract class Solution implements Built<Solution, SolutionBuilder> {
  SolutionType get type;
  BuiltList<int> get solution;

  Solution._();
  factory Solution([void Function(SolutionBuilder) updates]) = _$Solution;
}
