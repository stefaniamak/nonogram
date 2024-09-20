// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_clues.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateClues _$IsolateCluesFromJson(Map<String, dynamic> json) => IsolateClues(
      rows: (json['rows'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      columns: (json['columns'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
    );

Map<String, dynamic> _$IsolateCluesToJson(IsolateClues instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'columns': instance.columns,
    };
