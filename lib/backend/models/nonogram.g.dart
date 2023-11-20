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
      serializers.serialize(object.rows, specifiedType: const FullType(int)),
      'columns',
      serializers.serialize(object.columns, specifiedType: const FullType(int)),
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
          result.rows = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'columns':
          result.columns = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Nonogram extends Nonogram {
  @override
  final int rows;
  @override
  final int columns;

  factory _$Nonogram([void Function(NonogramBuilder)? updates]) =>
      (new NonogramBuilder()..update(updates))._build();

  _$Nonogram._({required this.rows, required this.columns}) : super._() {
    BuiltValueNullFieldError.checkNotNull(rows, r'Nonogram', 'rows');
    BuiltValueNullFieldError.checkNotNull(columns, r'Nonogram', 'columns');
  }

  @override
  Nonogram rebuild(void Function(NonogramBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NonogramBuilder toBuilder() => new NonogramBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Nonogram && rows == other.rows && columns == other.columns;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, columns.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Nonogram')
          ..add('rows', rows)
          ..add('columns', columns))
        .toString();
  }
}

class NonogramBuilder implements Builder<Nonogram, NonogramBuilder> {
  _$Nonogram? _$v;

  int? _rows;
  int? get rows => _$this._rows;
  set rows(int? rows) => _$this._rows = rows;

  int? _columns;
  int? get columns => _$this._columns;
  set columns(int? columns) => _$this._columns = columns;

  NonogramBuilder();

  NonogramBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rows = $v.rows;
      _columns = $v.columns;
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
    final _$result = _$v ??
        new _$Nonogram._(
            rows: BuiltValueNullFieldError.checkNotNull(
                rows, r'Nonogram', 'rows'),
            columns: BuiltValueNullFieldError.checkNotNull(
                columns, r'Nonogram', 'columns'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
