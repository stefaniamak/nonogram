// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Solution extends Solution {
  @override
  final SolutionType type;
  @override
  final String? image;
  @override
  final String? solution;

  factory _$Solution([void Function(SolutionBuilder)? updates]) =>
      (new SolutionBuilder()..update(updates))._build();

  _$Solution._({required this.type, this.image, this.solution}) : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'Solution', 'type');
  }

  @override
  Solution rebuild(void Function(SolutionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SolutionBuilder toBuilder() => new SolutionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Solution &&
        type == other.type &&
        image == other.image &&
        solution == other.solution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, solution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Solution')
          ..add('type', type)
          ..add('image', image)
          ..add('solution', solution))
        .toString();
  }
}

class SolutionBuilder implements Builder<Solution, SolutionBuilder> {
  _$Solution? _$v;

  SolutionType? _type;
  SolutionType? get type => _$this._type;
  set type(SolutionType? type) => _$this._type = type;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _solution;
  String? get solution => _$this._solution;
  set solution(String? solution) => _$this._solution = solution;

  SolutionBuilder();

  SolutionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _image = $v.image;
      _solution = $v.solution;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Solution other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Solution;
  }

  @override
  void update(void Function(SolutionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Solution build() => _build();

  _$Solution _build() {
    final _$result = _$v ??
        new _$Solution._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'Solution', 'type'),
            image: image,
            solution: solution);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
