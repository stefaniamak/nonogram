// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionStep _$SolutionStepFromJson(Map<String, dynamic> json) => SolutionStep(
      currentSolution: json['currentSolution'] as String,
      lineSolution: (json['lineSolution'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      axis: $enumDecodeNullable(_$NonoAxisEnumMap, json['axis']),
      isNote: json['isNote'] as bool?,
      lineIndex: (json['lineIndex'] as num?)?.toInt(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$SolutionStepToJson(SolutionStep instance) =>
    <String, dynamic>{
      'currentSolution': instance.currentSolution,
      'lineSolution': instance.lineSolution,
      'axis': _$NonoAxisEnumMap[instance.axis],
      'isNote': instance.isNote,
      'lineIndex': instance.lineIndex,
      'explanation': instance.explanation,
    };

const _$NonoAxisEnumMap = {
  NonoAxis.row: 'row',
  NonoAxis.column: 'column',
};
