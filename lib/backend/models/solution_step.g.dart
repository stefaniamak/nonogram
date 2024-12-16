// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionStep _$SolutionStepFromJson(Map<String, dynamic> json) => SolutionStep(
      currentSolution: json['currentSolution'] as String,
      explanation: json['explanation'] as String,
      newFilledBoxes: (json['newFilledBoxes'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      axis: $enumDecodeNullable(_$NonoAxisEnumMap, json['axis']),
      lineIndex: (json['lineIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SolutionStepToJson(SolutionStep instance) =>
    <String, dynamic>{
      'currentSolution': instance.currentSolution,
      'explanation': instance.explanation,
      'newFilledBoxes': instance.newFilledBoxes,
      'axis': _$NonoAxisEnumMap[instance.axis],
      'lineIndex': instance.lineIndex,
    };

const _$NonoAxisEnumMap = {
  NonoAxis.row: 'row',
  NonoAxis.column: 'column',
};
