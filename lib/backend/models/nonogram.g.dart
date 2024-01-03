// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonogram.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Nonogram> _$nonogramSerializer = new _$NonogramSerializer();

class _$NonogramSerializer implements StructuredSerializer<Nonogram> {
  @override
  final Iterable<Type> types = const [Nonogram, _$Nonogram];
  @override
  final String wireName = 'Nonogram';

  @override
  Iterable<Object?> serialize(Serializers serializers, Nonogram object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'rows',
      serializers.serialize(object.rows,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
      'columns',
      serializers.serialize(object.columns,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'author',
      serializers.serialize(object.author,
          specifiedType: const FullType(String)),
      'copyright',
      serializers.serialize(object.copyright,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'isUnique',
      serializers.serialize(object.isUnique,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Nonogram deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NonogramBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'rows':
          result.rows.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'columns':
          result.columns.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'copyright':
          result.copyright = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isUnique':
          result.isUnique = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Nonogram extends Nonogram {
  @override
  final BuiltList<int> rows;
  @override
  final BuiltList<int> columns;
  @override
  final String title;
  @override
  final String author;
  @override
  final String copyright;
  @override
  final String description;
  @override
  final bool isUnique;

  factory _$Nonogram([void Function(NonogramBuilder)? updates]) =>
      (new NonogramBuilder()..update(updates))._build();

  _$Nonogram._(
      {required this.rows,
      required this.columns,
      required this.title,
      required this.author,
      required this.copyright,
      required this.description,
      required this.isUnique})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(rows, r'Nonogram', 'rows');
    BuiltValueNullFieldError.checkNotNull(columns, r'Nonogram', 'columns');
    BuiltValueNullFieldError.checkNotNull(title, r'Nonogram', 'title');
    BuiltValueNullFieldError.checkNotNull(author, r'Nonogram', 'author');
    BuiltValueNullFieldError.checkNotNull(copyright, r'Nonogram', 'copyright');
    BuiltValueNullFieldError.checkNotNull(
        description, r'Nonogram', 'description');
    BuiltValueNullFieldError.checkNotNull(isUnique, r'Nonogram', 'isUnique');
  }

  @override
  Nonogram rebuild(void Function(NonogramBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NonogramBuilder toBuilder() => new NonogramBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Nonogram &&
        rows == other.rows &&
        columns == other.columns &&
        title == other.title &&
        author == other.author &&
        copyright == other.copyright &&
        description == other.description &&
        isUnique == other.isUnique;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, columns.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, copyright.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, isUnique.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Nonogram')
          ..add('rows', rows)
          ..add('columns', columns)
          ..add('title', title)
          ..add('author', author)
          ..add('copyright', copyright)
          ..add('description', description)
          ..add('isUnique', isUnique))
        .toString();
  }
}

class NonogramBuilder implements Builder<Nonogram, NonogramBuilder> {
  _$Nonogram? _$v;

  ListBuilder<int>? _rows;
  ListBuilder<int> get rows => _$this._rows ??= new ListBuilder<int>();
  set rows(ListBuilder<int>? rows) => _$this._rows = rows;

  ListBuilder<int>? _columns;
  ListBuilder<int> get columns => _$this._columns ??= new ListBuilder<int>();
  set columns(ListBuilder<int>? columns) => _$this._columns = columns;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  String? _copyright;
  String? get copyright => _$this._copyright;
  set copyright(String? copyright) => _$this._copyright = copyright;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _isUnique;
  bool? get isUnique => _$this._isUnique;
  set isUnique(bool? isUnique) => _$this._isUnique = isUnique;

  NonogramBuilder();

  NonogramBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rows = $v.rows.toBuilder();
      _columns = $v.columns.toBuilder();
      _title = $v.title;
      _author = $v.author;
      _copyright = $v.copyright;
      _description = $v.description;
      _isUnique = $v.isUnique;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Nonogram other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Nonogram;
  }

  @override
  void update(void Function(NonogramBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Nonogram build() => _build();

  _$Nonogram _build() {
    _$Nonogram _$result;
    try {
      _$result = _$v ??
          new _$Nonogram._(
              rows: rows.build(),
              columns: columns.build(),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'Nonogram', 'title'),
              author: BuiltValueNullFieldError.checkNotNull(
                  author, r'Nonogram', 'author'),
              copyright: BuiltValueNullFieldError.checkNotNull(
                  copyright, r'Nonogram', 'copyright'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'Nonogram', 'description'),
              isUnique: BuiltValueNullFieldError.checkNotNull(
                  isUnique, r'Nonogram', 'isUnique'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
        _$failedField = 'columns';
        columns.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Nonogram', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
