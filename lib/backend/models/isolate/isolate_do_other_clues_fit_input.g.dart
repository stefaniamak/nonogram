// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_do_other_clues_fit_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateDoOtherCluesFitInput _$IsolateDoOtherCluesFitInputFromJson(
        Map<String, dynamic> json) =>
    IsolateDoOtherCluesFitInput(
      solutionSide: $enumDecode(_$NonoDirectionEnumMap, json['solutionSide']),
      clues: (json['clues'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      clueIndex: (json['clueIndex'] as num).toInt(),
      solution: json['solution'] as String,
      solutionIndex: (json['solutionIndex'] as num).toInt(),
      output: IsolateOutput.fromJson(json['output'] as Map<String, dynamic>),
      settings:
          SolverSettings.fromJson(json['settings'] as Map<String, dynamic>),
      printLogs: json['printLogs'] as bool? ?? false,
    );

Map<String, dynamic> _$IsolateDoOtherCluesFitInputToJson(
        IsolateDoOtherCluesFitInput instance) =>
    <String, dynamic>{
      'solutionSide': _$NonoDirectionEnumMap[instance.solutionSide]!,
      'clues': instance.clues,
      'clueIndex': instance.clueIndex,
      'solution': instance.solution,
      'solutionIndex': instance.solutionIndex,
      'output': instance.output,
      'settings': instance.settings,
      'printLogs': instance.printLogs,
    };

const _$NonoDirectionEnumMap = {
  NonoDirection.before: 'before',
  NonoDirection.after: 'after',
};
