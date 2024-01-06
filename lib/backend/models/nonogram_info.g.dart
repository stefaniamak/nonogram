// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonogram_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NonogramInfo> _$nonogramInfoSerializer =
    new _$NonogramInfoSerializer();

class _$NonogramInfoSerializer implements StructuredSerializer<NonogramInfo> {
  @override
  final Iterable<Type> types = const [NonogramInfo, _$NonogramInfo];
  @override
  final String wireName = 'NonogramInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, NonogramInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.author;
    if (value != null) {
      result
        ..add('author')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.authorId;
    if (value != null) {
      result
        ..add('authorId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.copyright;
    if (value != null) {
      result
        ..add('copyright')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NonogramInfo deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NonogramInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'authorId':
          result.authorId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'copyright':
          result.copyright = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$NonogramInfo extends NonogramInfo {
  @override
  final String? title;
  @override
  final String? author;
  @override
  final String? authorId;
  @override
  final String? copyright;
  @override
  final String? description;

  factory _$NonogramInfo([void Function(NonogramInfoBuilder)? updates]) =>
      (new NonogramInfoBuilder()..update(updates))._build();

  _$NonogramInfo._(
      {this.title,
      this.author,
      this.authorId,
      this.copyright,
      this.description})
      : super._();

  @override
  NonogramInfo rebuild(void Function(NonogramInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NonogramInfoBuilder toBuilder() => new NonogramInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NonogramInfo &&
        title == other.title &&
        author == other.author &&
        authorId == other.authorId &&
        copyright == other.copyright &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, authorId.hashCode);
    _$hash = $jc(_$hash, copyright.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NonogramInfo')
          ..add('title', title)
          ..add('author', author)
          ..add('authorId', authorId)
          ..add('copyright', copyright)
          ..add('description', description))
        .toString();
  }
}

class NonogramInfoBuilder
    implements Builder<NonogramInfo, NonogramInfoBuilder> {
  _$NonogramInfo? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  String? _authorId;
  String? get authorId => _$this._authorId;
  set authorId(String? authorId) => _$this._authorId = authorId;

  String? _copyright;
  String? get copyright => _$this._copyright;
  set copyright(String? copyright) => _$this._copyright = copyright;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  NonogramInfoBuilder();

  NonogramInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _author = $v.author;
      _authorId = $v.authorId;
      _copyright = $v.copyright;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NonogramInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NonogramInfo;
  }

  @override
  void update(void Function(NonogramInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NonogramInfo build() => _build();

  _$NonogramInfo _build() {
    final _$result = _$v ??
        new _$NonogramInfo._(
            title: title,
            author: author,
            authorId: authorId,
            copyright: copyright,
            description: description);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
