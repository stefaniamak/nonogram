import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:nonogram/backend/serializers.dart';

part 'nonogram_info.g.dart';

abstract class NonogramInfo
    implements Built<NonogramInfo, NonogramInfoBuilder> {
  factory NonogramInfo([void Function(NonogramInfoBuilder) updates]) =
      _$NonogramInfo;

  NonogramInfo._();
  String? get title;
  String? get author;
  String? get authorId;
  String? get copyright;
  String? get description;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(NonogramInfo.serializer, this)!
        as Map<String, dynamic>;
  }

  static NonogramInfo? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(NonogramInfo.serializer, json);
  }

  static Serializer<NonogramInfo> get serializer => _$nonogramInfoSerializer;
}
