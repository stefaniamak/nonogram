import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/serializers.dart';

part 'clues.g.dart';

abstract class Clues implements Built<Clues, CluesBuilder> {
  factory Clues([void Function(CluesBuilder) updates]) = _$Clues;

  Clues._();
  BuiltList<List<int>> get rows;
  BuiltList<List<int>> get columns;

  int get maxRowNumbs => rows.map((List<int> r) => r.length).reduce(max);
  int get maxColNumbs => columns.map((List<int> c) => c.length).reduce(max);

  int get columnLength => columns.length;
  int get rowLength => rows.length;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Clues.serializer, this)! as Map<String, dynamic>;
  }

  static Clues? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Clues.serializer, json);
  }

  static Serializer<Clues> get serializer => _$cluesSerializer;
}
