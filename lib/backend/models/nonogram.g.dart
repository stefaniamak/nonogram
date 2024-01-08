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
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.info;
    if (value != null) {
      result
        ..add('info')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(NonogramInfo)));
    }
    value = object.note;
    if (value != null) {
      result
        ..add('note')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.clues;
    if (value != null) {
      result
        ..add('clues')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Clues)));
    }
    value = object.solutions;
    if (value != null) {
      result
        ..add('solutions')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Solution)])));
    }
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
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'info':
          result.info.replace(serializers.deserialize(value,
              specifiedType: const FullType(NonogramInfo))! as NonogramInfo);
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'clues':
          result.clues.replace(serializers.deserialize(value,
              specifiedType: const FullType(Clues))! as Clues);
          break;
        case 'solutions':
          result.solutions.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Solution)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$Nonogram extends Nonogram {
  @override
  final String id;
  @override
  final NonogramInfo? info;
  @override
  final String? note;
  @override
  final Clues? clues;
  @override
  final BuiltList<Solution>? solutions;

  factory _$Nonogram([void Function(NonogramBuilder)? updates]) =>
      (new NonogramBuilder()..update(updates))._build();

  _$Nonogram._(
      {required this.id, this.info, this.note, this.clues, this.solutions})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Nonogram', 'id');
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
        id == other.id &&
        info == other.info &&
        note == other.note &&
        clues == other.clues &&
        solutions == other.solutions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, info.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, clues.hashCode);
    _$hash = $jc(_$hash, solutions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Nonogram')
          ..add('id', id)
          ..add('info', info)
          ..add('note', note)
          ..add('clues', clues)
          ..add('solutions', solutions))
        .toString();
  }
}

class NonogramBuilder implements Builder<Nonogram, NonogramBuilder> {
  _$Nonogram? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  NonogramInfoBuilder? _info;
  NonogramInfoBuilder get info => _$this._info ??= new NonogramInfoBuilder();
  set info(NonogramInfoBuilder? info) => _$this._info = info;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CluesBuilder? _clues;
  CluesBuilder get clues => _$this._clues ??= new CluesBuilder();
  set clues(CluesBuilder? clues) => _$this._clues = clues;

  ListBuilder<Solution>? _solutions;
  ListBuilder<Solution> get solutions =>
      _$this._solutions ??= new ListBuilder<Solution>();
  set solutions(ListBuilder<Solution>? solutions) =>
      _$this._solutions = solutions;

  NonogramBuilder();

  NonogramBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _info = $v.info?.toBuilder();
      _note = $v.note;
      _clues = $v.clues?.toBuilder();
      _solutions = $v.solutions?.toBuilder();
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
              id: BuiltValueNullFieldError.checkNotNull(id, r'Nonogram', 'id'),
              info: _info?.build(),
              note: note,
              clues: _clues?.build(),
              solutions: _solutions?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'info';
        _info?.build();

        _$failedField = 'clues';
        _clues?.build();
        _$failedField = 'solutions';
        _solutions?.build();
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
