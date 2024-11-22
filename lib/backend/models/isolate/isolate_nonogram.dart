import 'package:json_annotation/json_annotation.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram_info.dart';

part 'isolate_nonogram.g.dart';

@JsonSerializable()
class IsolateNonogram {
  const IsolateNonogram({
    required this.id,
    required this.clues, this.info,
    this.note,
    // this.solutions,
  });

  factory IsolateNonogram.fromJson(final Map<String, dynamic> json) => _$IsolateNonogramFromJson(json);

  final String id;
  final IsolateNonogramInfo? info;
  final String? note;
  final IsolateClues clues;
  // final List<Solution>? solutions;

  int get width => clues.columns.length;
  int get height => clues.rows.length;

  bool? get isPublished => note?.contains('published');
  bool? get isUnique => note?.contains('definitely unique');
  bool? get isLineSolvable => note?.contains('definitely line/color solvable');

  String get emptySolution => Iterable.generate(height * width, (_) => '?').join();

  Map<String, dynamic> toJson() => _$IsolateNonogramToJson(this);

  static List<IsolateNonogram> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateNonogram.fromJson(item)).toList();
}
