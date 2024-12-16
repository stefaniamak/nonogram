import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

part 'isolate_nonogram.g.dart';

/// A class representing a nonogram puzzle for an isolate.
@JsonSerializable()
class IsolateNonogram {
  /// Creates a new [IsolateNonogram].
  const IsolateNonogram({
    required this.id,
    required this.clues,
    this.info,
    this.note,
  });

  factory IsolateNonogram.fromJson(final Map<String, dynamic> json) => _$IsolateNonogramFromJson(json);

  /// The unique identifier of the nonogram.
  final String id;

  /// Optional additional information about the nonogram.
  final IsolateNonogramInfo? info;

  /// Optional notes about the nonogram.
  final String? note;

  /// The clues for the nonogram.
  final IsolateClues clues;

  /// Gets the width of the nonogram.
  int get width => clues.columns.length;

  /// Gets the height of the nonogram.
  int get height => clues.rows.length;

  /// Checks if the nonogram is published.
  bool? get isPublished => note?.contains('published');

  /// Checks if the nonogram is unique.
  bool? get isUnique => note?.contains('definitely unique');

  /// Checks if the nonogram is line/color solvable.
  bool? get isLineSolvable => note?.contains('definitely line/color solvable');

  /// Generates an empty solution string for the nonogram.
  ///
  /// Returns a string filled with '?' characters representing an empty solution.
  String get emptySolution => List<String>.filled(height * width, '?').join();

  Map<String, dynamic> toJson() => _$IsolateNonogramToJson(this);

  static List<IsolateNonogram> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateNonogram.fromJson(item)).toList();
}
