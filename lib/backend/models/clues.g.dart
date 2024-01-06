// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clues.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Clues> _$cluesSerializer = new _$CluesSerializer();

class _$CluesSerializer implements StructuredSerializer<Clues> {
  @override
  final Iterable<Type> types = const [Clues, _$Clues];
  @override
  final String wireName = 'Clues';

  @override
  Iterable<Object?> serialize(Serializers serializers, Clues object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'rows',
      serializers.serialize(object.rows,
          specifiedType: const FullType(BuiltList, const [
            const FullType(List, const [const FullType(int)])
          ])),
      'columns',
      serializers.serialize(object.columns,
          specifiedType: const FullType(BuiltList, const [
            const FullType(List, const [const FullType(int)])
          ])),
    ];

    return result;
  }

  @override
  Clues deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CluesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'rows':
          result.rows.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(List, const [const FullType(int)])
              ]))! as BuiltList<Object?>);
          break;
        case 'columns':
          result.columns.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(List, const [const FullType(int)])
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$Clues extends Clues {
  @override
  final BuiltList<List<int>> rows;
  @override
  final BuiltList<List<int>> columns;

  factory _$Clues([void Function(CluesBuilder)? updates]) =>
      (new CluesBuilder()..update(updates))._build();

  _$Clues._({required this.rows, required this.columns}) : super._() {
    BuiltValueNullFieldError.checkNotNull(rows, r'Clues', 'rows');
    BuiltValueNullFieldError.checkNotNull(columns, r'Clues', 'columns');
  }

  @override
  Clues rebuild(void Function(CluesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CluesBuilder toBuilder() => new CluesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Clues && rows == other.rows && columns == other.columns;
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
    return (newBuiltValueToStringHelper(r'Clues')
          ..add('rows', rows)
          ..add('columns', columns))
        .toString();
  }
}

class CluesBuilder implements Builder<Clues, CluesBuilder> {
  _$Clues? _$v;

  ListBuilder<List<int>>? _rows;
  ListBuilder<List<int>> get rows =>
      _$this._rows ??= new ListBuilder<List<int>>();
  set rows(ListBuilder<List<int>>? rows) => _$this._rows = rows;

  ListBuilder<List<int>>? _columns;
  ListBuilder<List<int>> get columns =>
      _$this._columns ??= new ListBuilder<List<int>>();
  set columns(ListBuilder<List<int>>? columns) => _$this._columns = columns;

  CluesBuilder();

  CluesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rows = $v.rows.toBuilder();
      _columns = $v.columns.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Clues other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Clues;
  }

  @override
  void update(void Function(CluesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Clues build() => _build();

  _$Clues _build() {
    _$Clues _$result;
    try {
      _$result =
          _$v ?? new _$Clues._(rows: rows.build(), columns: columns.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
        _$failedField = 'columns';
        columns.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Clues', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
