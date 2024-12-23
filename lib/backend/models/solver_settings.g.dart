// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solver_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolverSettings _$SolverSettingsFromJson(Map<String, dynamic> json) =>
    SolverSettings(
      keepCacheData: json['keepCacheData'] as bool? ?? true,
      countCheckedBoxes: json['countCheckedBoxes'] as bool? ?? true,
      sortInitialLinesStackViaClues:
          json['sortInitialLinesStackViaClues'] as bool? ?? true,
      isolateConcurrent: (json['isolateConcurrent'] as num?)?.toInt() ?? 1,
      highlightNewFilledBoxes: json['highlightNewFilledBoxes'] as bool? ?? true,
    );

Map<String, dynamic> _$SolverSettingsToJson(SolverSettings instance) =>
    <String, dynamic>{
      'keepCacheData': instance.keepCacheData,
      'sortInitialLinesStackViaClues': instance.sortInitialLinesStackViaClues,
      'countCheckedBoxes': instance.countCheckedBoxes,
      'isolateConcurrent': instance.isolateConcurrent,
      'highlightNewFilledBoxes': instance.highlightNewFilledBoxes,
    };
