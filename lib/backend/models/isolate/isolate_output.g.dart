// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsolateOutput _$IsolateOutputFromJson(Map<String, dynamic> json) =>
    IsolateOutput(
      stack: (json['stack'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        int.parse(k), $enumDecode(_$NonoAxisEnumMap, e)),
                  ))
              .toList() ??
          const <Map<int, NonoAxis>>[],
      solutionSteps: (json['solutionSteps'] as List<dynamic>?)
              ?.map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SolutionStep>[],
      cachedBoxSolutions:
          (json['cachedBoxSolutions'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
      linesCheckedList: (json['linesCheckedList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [0],
      boxesCheckedList: (json['boxesCheckedList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [0],
      actualBoxesChecked: (json['actualBoxesChecked'] as num?)?.toInt() ?? 0,
      otherBoxesCheckedList: (json['otherBoxesCheckedList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [0],
    );

Map<String, dynamic> _$IsolateOutputToJson(IsolateOutput instance) =>
    <String, dynamic>{
      'stack': instance.stack
          .map((e) =>
              e.map((k, e) => MapEntry(k.toString(), _$NonoAxisEnumMap[e]!)))
          .toList(),
      'solutionSteps': instance.solutionSteps,
      'cachedBoxSolutions': instance.cachedBoxSolutions,
      'linesCheckedList': instance.linesCheckedList,
      'boxesCheckedList': instance.boxesCheckedList,
      'actualBoxesChecked': instance.actualBoxesChecked,
      'otherBoxesCheckedList': instance.otherBoxesCheckedList,
    };

const _$NonoAxisEnumMap = {
  NonoAxis.row: 'row',
  NonoAxis.column: 'column',
};
