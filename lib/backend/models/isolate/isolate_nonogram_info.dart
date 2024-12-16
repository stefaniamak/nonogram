import 'package:json_annotation/json_annotation.dart';

part 'isolate_nonogram_info.g.dart';

/// A class representing additional information about a nonogram puzzle.
@JsonSerializable()
class IsolateNonogramInfo {
  /// Creates a new [IsolateNonogramInfo].
  const IsolateNonogramInfo({
    this.title,
    this.author,
    this.authorId,
    this.copyright,
    this.description,
  });

  factory IsolateNonogramInfo.fromJson(final Map<String, dynamic> json) => _$IsolateNonogramInfoFromJson(json);

  /// The title of the nonogram.
  final String? title;

  /// The author of the nonogram.
  final String? author;

  /// The unique identifier of the author.
  final String? authorId;

  /// The copyright information of the nonogram.
  final String? copyright;

  /// A description of the nonogram.
  final String? description;

  Map<String, dynamic> toJson() => _$IsolateNonogramInfoToJson(this);

  static List<IsolateNonogramInfo> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateNonogramInfo.fromJson(item)).toList();
}
