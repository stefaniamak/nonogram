import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/serializers.dart';

part 'clues.g.dart';

abstract class Clues implements Built<Clues, CluesBuilder> {
  BuiltList<List<int>> get rows;
  BuiltList<List<int>> get columns;

  int get maxRowNumbs => rows.map((r) => r.length).reduce(max);
  int get maxColNumbs => columns.map((c) => c.length).reduce(max);

  int get columnLength => columns.length;
  int get rowLength => rows.length;

  Clues._();
  factory Clues([void Function(CluesBuilder) updates]) = _$Clues;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Clues.serializer, this) as Map<String, dynamic>;
  }

  static Clues? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Clues.serializer, json);
  }

  static Serializer<Clues> get serializer => _$cluesSerializer;
}
