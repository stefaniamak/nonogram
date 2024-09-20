// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_nonogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateNonogram _$IsolateNonogramFromJson(Map<String, dynamic> json) =>
    IsolateNonogram(
      id: json['id'] as String,
      note: json['note'] as String?,
      clues: IsolateClues.fromJson(json['clues'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IsolateNonogramToJson(IsolateNonogram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'clues': instance.clues,
    };
