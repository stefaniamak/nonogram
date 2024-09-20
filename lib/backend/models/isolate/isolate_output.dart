import 'package:json_annotation/json_annotation.dart';

import '../../type_extensions/nono_axis_extension.dart';

part 'isolate_output.g.dart';

@JsonSerializable()
class IsolateOutput {
  const IsolateOutput({
    required this.stack,
  });

  final List<Map<int, NonoAxis>> stack;

  factory IsolateOutput.fromJson(final Map<String, dynamic> json) => _$IsolateOutputFromJson(json);

  Map<String, dynamic> toJson() => _$IsolateOutputToJson(this);

  static List<IsolateOutput> fromJsonList(final List<dynamic> json) =>
      List<Map<String, dynamic>>.from(json).map((Map<String, dynamic> item) => IsolateOutput.fromJson(item)).toList();
}
