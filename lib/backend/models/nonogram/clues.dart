import 'package:json_annotation/json_annotation.dart';

part 'clues.g.dart';

/// A class representing the clues for a nonogram puzzle.
@JsonSerializable()
class Clues {
  /// Creates a new [Clues].
  const Clues({
    required this.rows,
    required this.columns,
  });

  factory Clues.fromJson(final Map<String, dynamic> json) => _$CluesFromJson(json);

  /// A list of lists containing the row clues.
  final List<List<int>> rows;

  /// A list of lists containing the column clues.
  final List<List<int>> columns;

  /// Gets the number of columns.
  int get columnLength => columns.length;

  /// Gets the number of rows.
  int get rowLength => rows.length;

  Map<String, dynamic> toJson() => _$CluesToJson(this);

  static List<Clues> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => Clues.fromJson(item)).toList();
}
