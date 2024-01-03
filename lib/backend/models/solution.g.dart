// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Solution extends Solution {
  @override
  final SolutionType type;
  @override
  final BuiltList<int> solution;

  factory _$Solution([void Function(SolutionBuilder)? updates]) =>
      (new SolutionBuilder()..update(updates))._build();

  _$Solution._({required this.type, required this.solution}) : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'Solution', 'type');
    BuiltValueNullFieldError.checkNotNull(solution, r'Solution', 'solution');
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
        solution == other.solution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, solution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Solution')
          ..add('type', type)
          ..add('solution', solution))
        .toString();
  }
}

class SolutionBuilder implements Builder<Solution, SolutionBuilder> {
  _$Solution? _$v;

  SolutionType? _type;
  SolutionType? get type => _$this._type;
  set type(SolutionType? type) => _$this._type = type;

  ListBuilder<int>? _solution;
  ListBuilder<int> get solution => _$this._solution ??= new ListBuilder<int>();
  set solution(ListBuilder<int>? solution) => _$this._solution = solution;

  SolutionBuilder();

  SolutionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _solution = $v.solution.toBuilder();
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
    _$Solution _$result;
    try {
      _$result = _$v ??
          new _$Solution._(
              type: BuiltValueNullFieldError.checkNotNull(
                  type, r'Solution', 'type'),
              solution: solution.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'solution';
        solution.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Solution', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
