class Nullable<T> {
  Nullable(this._value);

  final T? _value;

  T? get value {
    return _value;
  }
}
