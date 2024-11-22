import 'package:json_annotation/json_annotation.dart';

part 'isolate_nonogram_info.g.dart';

@JsonSerializable()
class IsolateNonogramInfo {
  const IsolateNonogramInfo({
    this.title,
    this.author,
    this.authorId,
    this.copyright,
    this.description,
  });

  factory IsolateNonogramInfo.fromJson(final Map<String, dynamic> json) => _$IsolateNonogramInfoFromJson(json);

  final String? title;
  final String? author;
  final String? authorId;
  final String? copyright;
  final String? description;

  Map<String, dynamic> toJson() => _$IsolateNonogramInfoToJson(this);

  static List<IsolateNonogramInfo> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateNonogramInfo.fromJson(item)).toList();
}
