// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateInput _$IsolateInputFromJson(Map<String, dynamic> json) => IsolateInput(
      nonogram:
          IsolateNonogram.fromJson(json['nonogram'] as Map<String, dynamic>),
      solutionSteps: (json['solutionSteps'] as List<dynamic>)
          .map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      solverSettings: json['solverSettings'] == null
          ? const SolverSettings()
          : SolverSettings.fromJson(
              json['solverSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IsolateInputToJson(IsolateInput instance) =>
    <String, dynamic>{
      'nonogram': instance.nonogram,
      'solutionSteps': instance.solutionSteps,
      'solverSettings': instance.solverSettings,
    };
