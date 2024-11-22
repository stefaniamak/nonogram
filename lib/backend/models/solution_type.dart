import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/serializers.dart';

part 'solution_type.g.dart';

// enum SolutionType { goal, solution, saved }

class SolutionType extends EnumClass {

  const SolutionType._(super.name);
  static const SolutionType goal = _$goal;
  static const SolutionType solution = _$solution;
  static const SolutionType saved = _$saved;

  static BuiltSet<SolutionType> get values => _$solutionTypeValues;
  static SolutionType valueOf(String name) => _$solutionTypeValueOf(name);

  String serialize() {
    return serializers.serializeWith(SolutionType.serializer, this)! as String;
  }

  static SolutionType? deserialize(String string) {
    return serializers.deserializeWith(SolutionType.serializer, string);
  }

  static Serializer<SolutionType> get serializer => _$solutionTypeSerializer;
}
