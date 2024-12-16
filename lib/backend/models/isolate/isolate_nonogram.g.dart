// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_nonogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateNonogram _$IsolateNonogramFromJson(Map<String, dynamic> json) =>
    IsolateNonogram(
      id: json['id'] as String,
      clues: IsolateClues.fromJson(json['clues'] as Map<String, dynamic>),
      info: json['info'] == null
          ? null
          : IsolateNonogramInfo.fromJson(json['info'] as Map<String, dynamic>),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$IsolateNonogramToJson(IsolateNonogram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'note': instance.note,
      'clues': instance.clues,
    };
