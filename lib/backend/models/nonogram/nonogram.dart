import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram_info.dart';

part 'nonogram.g.dart';

/// A class representing a nonogram puzzle for an isolate.
@JsonSerializable()
class Nonogram {
  /// Creates a new [Nonogram].
  const Nonogram({
    required this.id,
    required this.clues,
    this.info,
    this.note,
  });

  factory Nonogram.fromJson(final Map<String, dynamic> json) => _$NonogramFromJson(json);

  /// The unique identifier of the nonogram.
  final String id;

  /// Optional additional information about the nonogram.
  final NonogramInfo? info;

  /// Optional notes about the nonogram.
  final String? note;

  /// The clues for the nonogram.
  final Clues clues;

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

  Map<String, dynamic> toJson() => _$NonogramToJson(this);

  static List<Nonogram> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => Nonogram.fromJson(item)).toList();
}
