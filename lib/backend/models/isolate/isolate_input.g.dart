// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateInput _$IsolateInputFromJson(Map<String, dynamic> json) => IsolateInput(
      rows: (json['rows'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      columns: (json['columns'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      solutionSteps: (json['solutionSteps'] as List<dynamic>)
          .map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      nonogram:
          IsolateNonogram.fromJson(json['nonogram'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IsolateInputToJson(IsolateInput instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'columns': instance.columns,
      'solutionSteps': instance.solutionSteps,
      'nonogram': instance.nonogram,
    };
