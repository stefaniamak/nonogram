// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SolutionType _$goal = const SolutionType._('goal');
const SolutionType _$solution = const SolutionType._('solution');
const SolutionType _$saved = const SolutionType._('saved');

SolutionType _$solutionTypeValueOf(String name) {
  switch (name) {
    case 'goal':
      return _$goal;
    case 'solution':
      return _$solution;
    case 'saved':
      return _$saved;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<SolutionType> _$solutionTypeValues =
    new BuiltSet<SolutionType>(const <SolutionType>[
  _$goal,
  _$solution,
  _$saved,
]);

Serializer<SolutionType> _$solutionTypeSerializer =
    new _$SolutionTypeSerializer();

class _$SolutionTypeSerializer implements PrimitiveSerializer<SolutionType> {
  @override
  final Iterable<Type> types = const <Type>[SolutionType];
  @override
  final String wireName = 'SolutionType';

  @override
  Object serialize(Serializers serializers, SolutionType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  SolutionType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SolutionType.valueOf(serialized as String);
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
