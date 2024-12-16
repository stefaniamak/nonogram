import 'package:json_annotation/json_annotation.dart';

part 'nonogram_info.g.dart';

/// A class representing additional information about a nonogram puzzle.
@JsonSerializable()
class NonogramInfo {
  /// Creates a new [NonogramInfo].
  const NonogramInfo({
    this.title,
    this.author,
    this.authorId,
    this.copyright,
    this.description,
  });

  factory NonogramInfo.fromJson(final Map<String, dynamic> json) => _$NonogramInfoFromJson(json);

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

  Map<String, dynamic> toJson() => _$NonogramInfoToJson(this);

  static List<NonogramInfo> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => NonogramInfo.fromJson(item)).toList();
}
