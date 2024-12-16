import 'package:json_annotation/json_annotation.dart';

part 'isolate_clues.g.dart';

/// A class representing the clues for a nonogram puzzle.
@JsonSerializable()
class IsolateClues {
  /// Creates a new [IsolateClues].
  const IsolateClues({
    required this.rows,
    required this.columns,
  });

  factory IsolateClues.fromJson(final Map<String, dynamic> json) => _$IsolateCluesFromJson(json);

  /// A list of lists containing the row clues.
  final List<List<int>> rows;

  /// A list of lists containing the column clues.
  final List<List<int>> columns;

  /// Gets the number of columns.
  int get columnLength => columns.length;

  /// Gets the number of rows.
  int get rowLength => rows.length;

  Map<String, dynamic> toJson() => _$IsolateCluesToJson(this);

  static List<IsolateClues> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateClues.fromJson(item)).toList();
}
