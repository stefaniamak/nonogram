// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateOutput _$IsolateOutputFromJson(Map<String, dynamic> json) =>
    IsolateOutput(
      stack: (json['stack'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) =>
                    MapEntry(int.parse(k), $enumDecode(_$NonoAxisEnumMap, e)),
              ))
          .toList(),
      solutionSteps: (json['solutionSteps'] as List<dynamic>)
          .map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      cachedBoxSolutions:
          (json['cachedBoxSolutions'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
    );

Map<String, dynamic> _$IsolateOutputToJson(IsolateOutput instance) =>
    <String, dynamic>{
      'stack': instance.stack
          .map((e) =>
              e.map((k, e) => MapEntry(k.toString(), _$NonoAxisEnumMap[e]!)))
          .toList(),
      'solutionSteps': instance.solutionSteps,
      'cachedBoxSolutions': instance.cachedBoxSolutions,
    };

const _$NonoAxisEnumMap = {
  NonoAxis.row: 'row',
  NonoAxis.column: 'column',
};
