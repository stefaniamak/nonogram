import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/serializers.dart';

part 'nonogram.g.dart';

abstract class Nonogram implements Built<Nonogram, NonogramBuilder> {
  int get rows;
  int get columns;

  Nonogram._();
  factory Nonogram([void Function(NonogramBuilder) updates]) = _$Nonogram;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Nonogram.serializer, this)
        as Map<String, dynamic>;
  }

  static Nonogram fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Nonogram.serializer, json)!;
  }

  static Serializer<Nonogram> get serializer => _$nonogramSerializer;
}
