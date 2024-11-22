import 'package:json_annotation/json_annotation.dart';

part 'isolate_clues.g.dart';

@JsonSerializable()
class IsolateClues {
  const IsolateClues({
    required this.rows,
    required this.columns,
  });

  factory IsolateClues.fromJson(final Map<String, dynamic> json) => _$IsolateCluesFromJson(json);

  final List<List<int>> rows;
  final List<List<int>> columns;

  // int get maxRowNumbs => rows.map((r) => r.length).reduce(max);
  // int get maxColNumbs => columns.map((c) => c.length).reduce(max);

  int get columnLength => columns.length;
  int get rowLength => rows.length;

  Map<String, dynamic> toJson() => _$IsolateCluesToJson(this);

  static List<IsolateClues> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateClues.fromJson(item)).toList();
}
