import 'package:json_annotation/json_annotation.dart';

part 'solver_settings.g.dart';

@JsonSerializable()
class SolverSettings {
  const SolverSettings({
    this.groupSteps = true,
    this.keepCacheData = true,
    this.countCheckedBoxes = true,
    this.isolateConcurrent = 1,
  });

  final bool groupSteps;
  final bool keepCacheData;
  final bool countCheckedBoxes;
  final int isolateConcurrent;

  factory SolverSettings.fromJson(final Map<String, dynamic> json) => _$SolverSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SolverSettingsToJson(this);

  static List<SolverSettings> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => SolverSettings.fromJson(item)).toList();

  SolverSettings copyWith({
    final bool? groupSteps,
    final bool? keepCacheData,
    final bool? countCheckedBoxes,
    final int? isolateConcurrent,
  }) {
    return SolverSettings(
      groupSteps: groupSteps ?? this.groupSteps,
      keepCacheData: keepCacheData ?? this.keepCacheData,
      countCheckedBoxes: countCheckedBoxes ?? this.countCheckedBoxes,
      isolateConcurrent: isolateConcurrent ?? this.isolateConcurrent,
    );
  }
}
