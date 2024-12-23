import 'package:json_annotation/json_annotation.dart';

part 'solver_settings.g.dart';

/// A class representing the settings for the nonogram solver.
@JsonSerializable()
class SolverSettings {
  /// Creates a new [SolverSettings].
  const SolverSettings({
    this.keepCacheData = true,
    this.countCheckedBoxes = true,
    this.sortInitialLinesStackViaClues = true,
    this.isolateConcurrent = 1,
    this.highlightNewFilledBoxes = true,
  });

  factory SolverSettings.fromJson(final Map<String, dynamic> json) => _$SolverSettingsFromJson(json);

  /// Whether to keep cache data.
  final bool keepCacheData;

  /// Whether to sort the initial lines stack via clues' lines' sum.
  final bool sortInitialLinesStackViaClues;

  /// Whether to count checked boxes.
  final bool countCheckedBoxes;

  /// The number of concurrent isolates.
  final int isolateConcurrent;

  /// Whether to highlight newly filled boxes.
  final bool highlightNewFilledBoxes;

  Map<String, dynamic> toJson() => _$SolverSettingsToJson(this);

  static List<SolverSettings> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => SolverSettings.fromJson(item)).toList();

  SolverSettings copyWith({
    final bool? groupSteps,
    final bool? keepCacheData,
    final bool? sortInitialLinesStackViaClues,
    final bool? countCheckedBoxes,
    final int? isolateConcurrent,
    final bool? highlightNewFilledBoxes,
  }) {
    return SolverSettings(
      keepCacheData: keepCacheData ?? this.keepCacheData,
      countCheckedBoxes: countCheckedBoxes ?? this.countCheckedBoxes,
      sortInitialLinesStackViaClues: sortInitialLinesStackViaClues ?? this.sortInitialLinesStackViaClues,
      isolateConcurrent: isolateConcurrent ?? this.isolateConcurrent,
      highlightNewFilledBoxes: highlightNewFilledBoxes ?? this.highlightNewFilledBoxes,
    );
  }
}
