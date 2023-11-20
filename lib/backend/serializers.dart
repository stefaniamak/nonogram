import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:nonogram/backend/models/nonogram.dart';

part 'serializers.g.dart';

@SerializersFor([
  Nonogram,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
