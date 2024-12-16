// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clues.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clues _$CluesFromJson(Map<String, dynamic> json) => Clues(
      rows: (json['rows'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      columns: (json['columns'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
    );

Map<String, dynamic> _$CluesToJson(Clues instance) => <String, dynamic>{
      'rows': instance.rows,
      'columns': instance.columns,
    };
