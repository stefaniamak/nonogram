// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nonogram _$NonogramFromJson(Map<String, dynamic> json) => Nonogram(
      id: json['id'] as String,
      clues: Clues.fromJson(json['clues'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : NonogramInfo.fromJson(json['info'] as Map<String, dynamic>),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$NonogramToJson(Nonogram instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'note': instance.note,
      'clues': instance.clues,
    };
