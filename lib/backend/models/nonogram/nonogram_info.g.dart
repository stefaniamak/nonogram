// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonogram_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonogramInfo _$NonogramInfoFromJson(Map<String, dynamic> json) => NonogramInfo(
      title: json['title'] as String?,
      author: json['author'] as String?,
      authorId: json['authorId'] as String?,
      copyright: json['copyright'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$NonogramInfoToJson(NonogramInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'authorId': instance.authorId,
      'copyright': instance.copyright,
      'description': instance.description,
    };
