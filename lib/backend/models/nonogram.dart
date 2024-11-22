import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram_info.dart';
import 'package:nonogram/backend/models/solution.dart';
import 'package:nonogram/backend/serializers.dart';

part 'nonogram.g.dart';

abstract class Nonogram implements Built<Nonogram, NonogramBuilder> {
  factory Nonogram([void Function(NonogramBuilder) updates]) = _$Nonogram;

  Nonogram._();
  String get id;
  NonogramInfo? get info;
  String? get note;
  Clues? get clues;
  BuiltList<Solution>? get solutions;

  int get width => clues?.columns.length ?? 0;
  int get height => clues?.rows.length ?? 0;

  bool? get isPublished => note?.contains('published');
  bool? get isUnique => note?.contains('definitely unique');
  bool? get isLineSolvable => note?.contains('definitely line/color solvable');

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Nonogram.serializer, this)! as Map<String, dynamic>;
  }

  static Nonogram fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Nonogram.serializer, json)!;
  }

  static Serializer<Nonogram> get serializer => _$nonogramSerializer;
}

class NonogramMap {}
